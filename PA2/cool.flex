/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>
#include <string>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

std::string string_buf{}; /* to assemble string constants */

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */
static int comment_lvl;

%}

%option noyywrap

/*
 * Define names for regular expressions here.
 */

INTEGER         [[:digit:]]+
TYPEID          [[:upper:]][[:alnum:]_]*
OBJECTID        [[:lower:]][[:alnum:]_]*
WHITESPACE      [ \f\r\t\v]
DARROW          =>
LE              <=
ASSIGN          <-

%x              COMMENT
%x              STRING

%%

 /*
  *  Nested comments
  */
"(*" {
    comment_lvl++;
    BEGIN(COMMENT);
}

<COMMENT>"(*" {
    comment_lvl++;
}

<COMMENT>"*)" {
    if (0 == --comment_lvl) {
        BEGIN(INITIAL);
    }
}

<COMMENT>[^*(\n]*       /* Ignore anything that is not a `*`, `(`. */
<COMMENT>"*"+[^*)\n]*   /* Ignore "*" that is not followed by `)`s. */
<COMMENT>"("+[^*(\n]*   /* Ignore "(" that is not followed by `*`s. */
<COMMENT>\n             { curr_lineno++; }

 /*
  * A comment remains open when EOF is encountered.
  */
<COMMENT><<EOF>> {
    yylval.error_msg = "EOF in comment";
    BEGIN(INITIAL);  // Otherwise lexer continues reporting indefinitely.
    return ERROR;
}

 /*
  * Report `*)`s outside a comment.
  */
")*" {
    yylval.error_msg = "Unmatched *)";
    return ERROR;
}

 /*
  *  Inline comments.
  */
"--".*          /* Do nothing. */

 /*
  *  The multiple-character operators.
  */
{DARROW}		{ return DARROW; }
{LE}		    { return LE; }
{ASSIGN}		{ return ASSIGN; }

 /*
  *  The single-character operators.
  */
"."             { return (int) '.'; }
"@"             { return (int) '@'; }
"~"             { return (int) '~'; }
"*"             { return (int) '*'; }
"/"             { return (int) '/'; }
"+"             { return (int) '+'; }
"-"             { return (int) '-'; }
"<"             { return (int) '<'; }
"="             { return (int) '='; }
"("             { return (int) '('; }
")"             { return (int) ')'; }
"{"             { return (int) '{'; }
"}"             { return (int) '}'; }
":"             { return (int) ':'; }
";"             { return (int) ';'; }
","             { return (int) ','; }

 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */
(?i:class)      { return CLASS; }
(?i:else)       { return ELSE; }
(?i:fi)         { return FI; }
(?i:if)         { return IF; }
(?i:in)         { return IN; }
(?i:inherits)   { return INHERITS; }
(?i:let)        { return LET; }
(?i:loop)       { return LOOP; }
(?i:pool)       { return POOL; }
(?i:then)       { return THEN; }
(?i:while)      { return WHILE; }
(?i:case)       { return CASE; }
(?i:esac)       { return ESAC; }
(?i:of)         { return OF; }
(?i:new)        { return NEW; }
(?i:isvoid)     { return ISVOID; }
(?i:not)        { return NOT; }

t(?i:rue) {
    yylval.boolean = 1;
    return BOOL_CONST;
}

f(?i:alse) {
    yylval.boolean = 0;
    return BOOL_CONST;
}

 /*
  *  Identifiers.
  */
{TYPEID} {
    yylval.symbol = idtable.add_string(yytext);
    return TYPEID;
}

{OBJECTID} {
    yylval.symbol = idtable.add_string(yytext);
    return OBJECTID;
}

 /*
  *  Whitespaces.
  */
\n              { curr_lineno++; }
{WHITESPACE}+   /* Do nothing. */

 /*
  *  Integer constants.
  */
{INTEGER} {
    yylval.symbol = inttable.add_string(yytext);
    return INT_CONST;
}

 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */

 /*
  *  Optimization for strings without escaped characters.
  *  NOTE: If a literal EOF exists in a string literal, a trailing `"` cannot exist.
  */
\"[^"\\\n]*\" {
    yylval.symbol = stringtable.add_string(yytext + 1, yyleng - 2);
    return STR_CONST;
}

 /*
  *  Handle escaped characters and errors.
  */
\"[^"\\\n]* {
    string_buf += std::string(yytext + 1, yyleng - 1);
    BEGIN(STRING);
}

<STRING>{
    [^"\\\n]+ { string_buf.append(yytext, yyleng); }
    \\n     { string_buf += '\n'; }
    \\b     { string_buf += '\b'; }
    \\t     { string_buf += '\t'; }
    \\f     { string_buf += '\f'; }
    \\.     { string_buf += yytext[1]; }  // Remove the backslash.

    \" {
        if (MAX_STR_CONST < string_buf.length()) {
            yylval.error_msg = "String constant too long";
            BEGIN(INITIAL);
            return ERROR;
        }

        yylval.symbol = stringtable.add_string((char*) string_buf.c_str(), string_buf.length());
        BEGIN(INITIAL);
        return STR_CONST;
    }

    \n {
        yylval.error_msg = "Unterminated string constant";
        curr_lineno++;
        BEGIN(INITIAL);
        return ERROR;
    }

    <<EOF>> {
        yylval.error_msg = "EOF in string constant";
        BEGIN(INITIAL);
        return ERROR;
    }
}

. {
    yylval.error_msg = yytext;
    return ERROR;
}

%%

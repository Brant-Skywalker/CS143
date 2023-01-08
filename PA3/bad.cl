
(*
 *  execute "coolc bad.cl" to see the error messages that the coolc parser
 *  generates
 *
 *  execute "myparser bad.cl" to see the error messages that your parser
 *  generates
 *)

(* no error *)
class A {
    main(): Int {
        {
            4;
            5;
            6;
            **;
            7;
            test(3, **, 
            4, 6,
            &&, 7, 7);
        }
    };
};

Class F {
    b: String;
    c;
    d: Int;
    e;

    main(): Int {

    let s <- 33, 
    b : Int <- 3,
    c <- "String" in 
    5
    };
};

(* error:  b is not a type identifier *)
Class b inherits A {
};

(* error:  a is not a type identifier *)
Class C inherits a {
};

(* error:  keyword inherits is misspelled *)
Class D inherts A {
};

(* error:  closing brace is missing *)
Class E inherits A {
;


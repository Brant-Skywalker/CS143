(*
 *  CS164 Fall 94
 *
 *  Programming Assignment 1
 *    Implementation of a simple stack machine.
 *
 *  Skeleton file
 *)

class Main inherits IO {

    stack : Stack;

    cmd : String;

    display_stack(s : Stack) : Object {
        if s.isEmpty() then
            out_string("")
        else {
            out_string(s.top());
            out_string("\n");
            display_stack(s.getNext());
        } fi
    };

    prompt() : Bool {
        {
            out_string(">");
            cmd <- in_string();
            if cmd = "x" then
                false
            else
                true
            fi;
        }
    };

    evaluate() : Object {
        if stack.isEmpty() then
            0 -- Do nothing.
        else if stack.top() = "+" then {
            stack <- stack.getNext();
            let z : A2I <- new A2I in
            let t1 : Int <- z.a2i(stack.top()) in {
                stack <- stack.getNext();
                let t2 : Int <- z.a2i(stack.top()) in {
                    stack <- stack.getNext();
                    stack <- stack.push(z.i2a(t1 + t2));
                };
            };
        }
        else if stack.top() = "s" then {
            stack <- stack.getNext();
            let s1 : String <- stack.top() in {
                stack <- stack.getNext();
                let s2 : String <- stack.top() in {
                    stack <- stack.getNext();
                    stack <- stack.push(s1);
                    stack <- stack.push(s2);
                };
            };
        }
        else
            0  -- Do nothing.
        fi fi fi
    };

    main() : Object {
        {
            stack <- new Stack;
            let z : A2I <- new A2I in
            while prompt() loop {
                if cmd = "d" then
                    display_stack(stack)
                else if cmd = "s" then
                    stack <- stack.push("s")
                else if cmd = "+" then
                    stack <- stack.push("+")
                else if cmd = "e" then
                    evaluate()
                else  -- The input is a digit; error checking omitted!
                    stack <- stack.push(cmd)
                fi fi fi fi;
            } pool;
        }
    };


};

class Stack {

    -- Define operations on empty stacks.
    isEmpty() : Bool { true };

    top() : String { { abort(); ""; } };

    getNext() : Stack { { abort(); self; } };

    push(val : String) : Stack {
        (new Cons).init(val, self)
    };
};

class Cons inherits Stack {

    val : String;  -- The element in this stack cell.
    
    next : Stack;  -- The rest of the stack.

    isEmpty() : Bool { false };

    top() : String { val };

    getNext() : Stack { next };

    init(i : String, n : Stack) : Stack {
        {
            val <- i;
            next <- n;
            self;
        }
    };
};

(* lvl 1 [ ((( * * ))) ] (* lvl 2 (* lvl 3 *) lvl 2 *) lvl 1 *)
(* models one-dimensional cellular automaton on a circle of finite radius
   arrays are faked as Strings,
   X's respresent live cells, dots represent dead cells,
   no error checking is done *)
class CellularAutomaton inherits IO {
    population_map : String;
    init(map : String) : SELF_TYPE {
        {
            population_map <- map;
            self;
        }
    };
    print() : SELF_TYPE {
        {
            out_string(population_map.concat("\n"));
            self;
        }
    };
    num_cells() : Int {
        population_map.length()
    };
    cell(position : Int) : String {
        population_map.substr(position, 1)
    };
    cell_left_neighbor(position : Int) : String {
        if position = 0 then
            cell(num_cells() - 1)
        else
            cell(position - 1)
        fi
    };
    cell_right_neighbor(position : Int) : String {
        if position = num_cells() - 1 then
            cell(0)
        else
            cell(position + 1)
        fi
    };
    (* a cell will live if exactly 1 of itself and it's immediate
       neighbors are alive *)
    cell_at_next_evolution(position : Int) : String {
        if (if cell(position) = "X" then 1 else 0 fi
            + if cell_left_neighbor(position) = "X" then 1 else 0 fi
            + if cell_right_neighbor(position) = "X" then 1 else 0 fi
            = 1)
        then  -- Test comment.
            "X"
        else
            '.'
        fi
    };
    evolve() : SELF_TYPE {
        (let position : Int in
        (let num : Int <- num_cells[] in
        (let temp : String in
            {
                while position < num loop
                    {
                        temp <- temp.concat(cell_at_next_evolution(position));
                        position <- position + 1;
                    }
                pool;
                population_map <- temp;
                self;
            }
        ) ) )
    };
class Main {
    cells : CellularAutomaton;
    testBool : Bool;
    main() : SELF_TYPE {
        {
            testBool <- tRuE;
            testBool <- fAlSe;
            testStr1 <- "testtest
            test test
            ";
            testStr2 <- "\ttest\b\btest\ntest\ftest\ctest\
test\0\c\a\s\rtest\1\2\033\3\4\x33\x44";
            testStr3 <- "test \
            ";
            testStr4 <- "test\
            \
test";
            testStr5 <- "test\
            test";
            testStr6 <- "test
test";
            tooLongString <- "c7aQcQGLT8dcok2EBWP1NnPCSb3BQZZaYYWEWKNdVWJLDtXUdqcvhzVrBJVFVkMPUmQwCVT5LfYG4DwL5GI6vtDZNQghrHcrMTd1dhCZE1TZidAnIt44IvbZnXoCZ1gSpPLjuIbBVcx4Ya95ndW48dwDJfBnlm0igTW3MZja7u7GbG1klG3faREGQf7LhCNUkJWYWCpcNnhJeOublQHZZtyZZEFFwptKR53cJ8br8g0hB8aJtq6T3ifeyPXaNHORJKP4aZoO78NbIe2JhBVa4xu7wpuUg4KmOGcDrxM0JZpOxATSMjRVgKmcDSVkrYuskV1WANcfYZa6is1QCLtudq0zZZRVKJ4nQ4m3x8tQIlmdHCWLIyPlV1wCQZpHW4X4d6TKPAiiUX0A53ZByJZldqU6La7vWl4XXeUk75qwO6lcF8aQNPtLqo8OMdxWqbXTi42MyWMcNno99bJei6rpnEW52kjfG3YnsokqSpVYgki3KlygPoSpylO9Gj2ErSfrmidGsmRMfJEuKlr3MPBw8pqshZXLP32bEwZQMf9por3EqhCuRNdHIqI8XegNMVEKO8IOYf92j9YhjM49BK2kdBm9dj3GKkn4vCcVmVlsjArMrO1iBHkGnBkal2G7ZnbiVMo2xS5YJ4srDEfWoh4jMkMZDq8EBqn1ONI2CtlUHGxyyMgVV1Fd7WkRc7FyVUOqOq5q57dQuC2PTQP7YEYtbRm85VQlNIOqMC4robyejYVbubCV8IZEvIEnbNsA3ddG2C2THIQsu9byuiFvnzF1Ve9Jppz5CloQg454HfVGoFEoq3Kjot1wyUsC7fTkpSstntb8vuQxYehzGqkvjY41aEOOHY61jpQe3JACYEqBL3XuHBo5Ht5r532NoHaKsUhrPDl3g7qLO3yy8S2hpbxrhP7FmcbQ3ynuqyrrbpPh5037WQa5CNbzx8eNClz58HRwYaNzaFS5ViuRwakJgrY7b0Vfxqa8KRcIfLVO0P2CQrdmIFS3afPZmlHRN6SySNAzs";
            cells <- (new CellularAutomaton).init("         X         ");
            cells.print();
            (let countdown : Int <- 20 in
                while countdown > 0 loop
                    {
                        cells.evolve();
                        cells.print();
                        countdown <- countdown - 1;

                pool
            );  (* end let countdown
            self;
        }
    };
-- Test comments. (*
does this one work? *)
(* does this one work? -- *)

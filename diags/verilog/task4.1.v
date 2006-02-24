module main;

reg c;

mod_a a( c );
mod_a b( ~c );

initial begin
        $dumpfile( "task4.1.vcd" );
        $dumpvars( 0, main );
	c = 1'b0;
        #10;
        $finish;
end

endmodule


module mod_a( input wire c );

always @(c) foo( c );

task foo;
  input c;
  reg a;
  begin
   a = c;
   #5;
   a = ~c;
  end
endtask

endmodule

/* HEADER
GROUPS task4.1 all iv vcs vcd lxt
SIM    task4.1 all iv vcd  : iverilog task4.1.v; ./a.out                                   : task4.1.vcd
SIM    task4.1 all iv lxt  : iverilog task4.1.v; ./a.out -lxt2; mv task4.1.vcd task4.1.lxt : task4.1.lxt
SIM    task4.1 all vcs vcd : vcs +v2k task4.1.v; ./simv                                    : task4.1.vcd
SCORE  task4.1.vcd     : -t main -vcd task4.1.vcd -o task4.1.cdd -v task4.1.v : task4.1.cdd
SCORE  task4.1.lxt     : -t main -lxt task4.1.lxt -o task4.1.cdd -v task4.1.v : task4.1.cdd
REPORT task4.1.cdd 1   : -d v -o task4.1.rptM task4.1.cdd                         : task4.1.rptM
REPORT task4.1.cdd 2   : -d v -w -o task4.1.rptWM task4.1.cdd                     : task4.1.rptWM
REPORT task4.1.cdd 3   : -d v -i -o task4.1.rptI task4.1.cdd                      : task4.1.rptI
REPORT task4.1.cdd 4   : -d v -w -i -o task4.1.rptWI task4.1.cdd                  : task4.1.rptWI
*/

/* OUTPUT task4.1.cdd
5 1 * 6 0 0 0 0
3 0 main main task4.1.v 1 16
1 c 0 3 30004 1 0 2
3 0 mod_a main.a task4.1.v 19 33
2 1 21 110011 1 1 4 0 0 c
2 2 21 110011 1 47 4 1 0 foo.c
2 3 21 c0014 2 3b 2600a 0 2 1 0 2 foo
2 4 21 90009 1 1 4 0 0 c
2 5 21 90009 0 2a 20000 0 0 2 0 a
2 6 21 90009 3 29 2100a 4 5 1 0 2
1 c 0 19 19 1 0 2
4 3 6 0
4 6 3 0
3 3 mod_a.foo main.a.foo task4.1.v 23 31
2 7 27 70007 1 1 4 0 0 c
2 8 27 30003 0 1 400 0 0 a
2 9 27 30007 1 37 11006 7 8
2 10 28 40004 1 0 20008 0 0 32 64 11 0 0 0 0 0 0 0
2 11 28 40004 1 0 20008 0 0 32 64 55 55 55 55 55 55 55 55
2 12 28 30004 2 2c 2000a 10 11 32 0 aa aa aa aa aa aa aa aa
2 13 29 80008 1 1 4 0 0 c
2 14 29 70007 1 1b 20008 13 0 1 0 2
2 15 29 30003 0 1 400 0 0 a
2 16 29 30008 1 37 a 14 15
1 c 0 24 8 1 16 2
1 a 0 25 30006 1 16 102
4 16 0 0
4 12 16 0
4 9 12 12
3 0 mod_a main.b task4.1.v 19 33
2 17 21 110011 1 1 8 0 0 c
2 18 21 110011 1 47 8 17 0 foo.c
2 19 21 c0014 2 3b 2600a 0 18 1 0 2 foo
2 20 21 90009 1 1 8 0 0 c
2 21 21 90009 0 2a 20000 0 0 2 0 a
2 22 21 90009 3 29 2100a 20 21 1 0 2
1 c 0 19 19 1 0 2
4 19 22 0
4 22 19 0
3 3 mod_a.foo main.b.foo task4.1.v 23 31
2 23 27 70007 1 1 8 0 0 c
2 24 27 30003 0 1 400 0 0 a
2 25 27 30007 1 37 1100a 23 24
2 26 28 40004 1 0 20008 0 0 32 64 11 0 0 0 0 0 0 0
2 27 28 40004 1 0 20008 0 0 32 64 55 55 55 55 55 55 55 55
2 28 28 30004 2 2c 2000a 26 27 32 0 aa aa aa aa aa aa aa aa
2 29 29 80008 1 1 8 0 0 c
2 30 29 70007 1 1b 20004 29 0 1 0 2
2 31 29 30003 0 1 400 0 0 a
2 32 29 30008 1 37 6 30 31
1 c 0 24 8 1 16 2
1 a 0 25 30006 1 16 1002
4 32 0 0
4 28 32 0
4 25 28 28
*/

/* OUTPUT task4.1.rptM
                             ::::::::::::::::::::::::::::::::::::::::::::::::::
                             ::                                              ::
                             ::  Covered -- Verilog Coverage Verbose Report  ::
                             ::                                              ::
                             ::::::::::::::::::::::::::::::::::::::::::::::::::


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   GENERAL INFORMATION   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Report generated from CDD file : task4.1.cdd

* Reported by                    : Module

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   LINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function      Filename                 Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    task4.1.v                  0/    0/    0      100%
  mod_a                   task4.1.v                  2/    0/    2      100%
  mod_a.foo               task4.1.v                  2/    0/    2      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   TOGGLE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function      Filename                         Toggle 0 -> 1                       Toggle 1 -> 0
                                                   Hit/ Miss/Total    Percent hit      Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    task4.1.v                  0/    1/    1        0%             0/    1/    1        0%
  mod_a                   task4.1.v                  0/    1/    1        0%             0/    1/    1        0%
  mod_a.foo               task4.1.v                  1/    1/    2       50%             1/    1/    2       50%
---------------------------------------------------------------------------------------------------------------------

    Module: main, File: task4.1.v
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      c                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...

    Module: mod_a, File: task4.1.v
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      c                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...

    Task: mod_a.foo, File: task4.1.v
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      c                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   COMBINATIONAL LOGIC COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function                Filename                                Logic Combinations
                                                                      Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                              task4.1.v                           0/   0/   0      100%
  mod_a                             task4.1.v                           1/   0/   1      100%
  mod_a.foo                         task4.1.v                           4/   0/   4      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   FINITE STATE MACHINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                               State                             Arc
Module/Task/Function      Filename                Hit/Miss/Total    Percent Hit    Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    task4.1.v                 0/   0/   0      100%            0/   0/   0      100%
  mod_a                   task4.1.v                 0/   0/   0      100%            0/   0/   0      100%
  mod_a.foo               task4.1.v                 0/   0/   0      100%            0/   0/   0      100%


*/

/* OUTPUT task4.1.rptWM
                             ::::::::::::::::::::::::::::::::::::::::::::::::::
                             ::                                              ::
                             ::  Covered -- Verilog Coverage Verbose Report  ::
                             ::                                              ::
                             ::::::::::::::::::::::::::::::::::::::::::::::::::


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   GENERAL INFORMATION   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Report generated from CDD file : task4.1.cdd

* Reported by                    : Module

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   LINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function      Filename                 Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    task4.1.v                  0/    0/    0      100%
  mod_a                   task4.1.v                  2/    0/    2      100%
  mod_a.foo               task4.1.v                  2/    0/    2      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   TOGGLE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function      Filename                         Toggle 0 -> 1                       Toggle 1 -> 0
                                                   Hit/ Miss/Total    Percent hit      Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    task4.1.v                  0/    1/    1        0%             0/    1/    1        0%
  mod_a                   task4.1.v                  0/    1/    1        0%             0/    1/    1        0%
  mod_a.foo               task4.1.v                  1/    1/    2       50%             1/    1/    2       50%
---------------------------------------------------------------------------------------------------------------------

    Module: main, File: task4.1.v
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      c                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...

    Module: mod_a, File: task4.1.v
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      c                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...

    Task: mod_a.foo, File: task4.1.v
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      c                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   COMBINATIONAL LOGIC COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function                Filename                                Logic Combinations
                                                                      Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                              task4.1.v                           0/   0/   0      100%
  mod_a                             task4.1.v                           1/   0/   1      100%
  mod_a.foo                         task4.1.v                           4/   0/   4      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   FINITE STATE MACHINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                               State                             Arc
Module/Task/Function      Filename                Hit/Miss/Total    Percent Hit    Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    task4.1.v                 0/   0/   0      100%            0/   0/   0      100%
  mod_a                   task4.1.v                 0/   0/   0      100%            0/   0/   0      100%
  mod_a.foo               task4.1.v                 0/   0/   0      100%            0/   0/   0      100%


*/

/* OUTPUT task4.1.rptI
                             ::::::::::::::::::::::::::::::::::::::::::::::::::
                             ::                                              ::
                             ::  Covered -- Verilog Coverage Verbose Report  ::
                             ::                                              ::
                             ::::::::::::::::::::::::::::::::::::::::::::::::::


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   GENERAL INFORMATION   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Report generated from CDD file : task4.1.cdd

* Reported by                    : Instance

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   LINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                           Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                          0/    0/    0      100%
  <NA>.main.a                                        2/    0/    2      100%
  <NA>.main.a.foo                                    2/    0/    2      100%
  <NA>.main.b                                        2/    0/    2      100%
  <NA>.main.b.foo                                    2/    0/    2      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   TOGGLE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                                   Toggle 0 -> 1                       Toggle 1 -> 0
                                                   Hit/ Miss/Total    Percent hit      Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                          0/    1/    1        0%             0/    1/    1        0%
  <NA>.main.a                                        0/    1/    1        0%             0/    1/    1        0%
  <NA>.main.a.foo                                    1/    1/    2       50%             0/    2/    2        0%
  <NA>.main.b                                        0/    1/    1        0%             0/    1/    1        0%
  <NA>.main.b.foo                                    0/    2/    2        0%             1/    1/    2       50%
---------------------------------------------------------------------------------------------------------------------

    Module: main, File: task4.1.v, Instance: <NA>.main
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      c                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...

    Module: mod_a, File: task4.1.v, Instance: <NA>.main.a
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      c                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...

    Task: mod_a.foo, File: task4.1.v, Instance: <NA>.main.a.foo
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      c                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...
      a                         0->1: 1'h1
      ......................... 1->0: 1'h0 ...

    Module: mod_a, File: task4.1.v, Instance: <NA>.main.b
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      c                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...

    Task: mod_a.foo, File: task4.1.v, Instance: <NA>.main.b.foo
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      c                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...
      a                         0->1: 1'h0
      ......................... 1->0: 1'h1 ...


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   COMBINATIONAL LOGIC COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                                                    Logic Combinations
                                                                      Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                                             0/   0/   0      100%
  <NA>.main.a                                                           1/   0/   1      100%
  <NA>.main.a.foo                                                       2/   2/   4       50%
  <NA>.main.b                                                           1/   0/   1      100%
  <NA>.main.b.foo                                                       2/   2/   4       50%
---------------------------------------------------------------------------------------------------------------------

    Task: mod_a.foo, File: task4.1.v, Instance: <NA>.main.a.foo
    -------------------------------------------------------------------------------------------------------------
    Missed Combinations  (* = missed value)

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
             27:     a  =  c 
                          |1|

        Expression 1   (1/2)
        ^^^^^^^^^^^^^ - 
         E | E
        =0=|=1=
             *

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
             29:     a  = ~ c 
                          |1-|

        Expression 1   (1/2)
        ^^^^^^^^^^^^^ - ~
         E | E
        =0=|=1=
         *    


    Task: mod_a.foo, File: task4.1.v, Instance: <NA>.main.b.foo
    -------------------------------------------------------------------------------------------------------------
    Missed Combinations  (* = missed value)

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
             27:     a  =  c 
                          |1|

        Expression 1   (1/2)
        ^^^^^^^^^^^^^ - 
         E | E
        =0=|=1=
         *    

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
             29:     a  = ~ c 
                          |1-|

        Expression 1   (1/2)
        ^^^^^^^^^^^^^ - ~
         E | E
        =0=|=1=
             *



~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   FINITE STATE MACHINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                               State                             Arc
Instance                                          Hit/Miss/Total    Percent hit    Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                         0/   0/   0      100%            0/   0/   0      100%
  <NA>.main.a                                       0/   0/   0      100%            0/   0/   0      100%
  <NA>.main.a.foo                                   0/   0/   0      100%            0/   0/   0      100%
  <NA>.main.b                                       0/   0/   0      100%            0/   0/   0      100%
  <NA>.main.b.foo                                   0/   0/   0      100%            0/   0/   0      100%


*/

/* OUTPUT task4.1.rptWI
                             ::::::::::::::::::::::::::::::::::::::::::::::::::
                             ::                                              ::
                             ::  Covered -- Verilog Coverage Verbose Report  ::
                             ::                                              ::
                             ::::::::::::::::::::::::::::::::::::::::::::::::::


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   GENERAL INFORMATION   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Report generated from CDD file : task4.1.cdd

* Reported by                    : Instance

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   LINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                           Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                          0/    0/    0      100%
  <NA>.main.a                                        2/    0/    2      100%
  <NA>.main.a.foo                                    2/    0/    2      100%
  <NA>.main.b                                        2/    0/    2      100%
  <NA>.main.b.foo                                    2/    0/    2      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   TOGGLE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                                   Toggle 0 -> 1                       Toggle 1 -> 0
                                                   Hit/ Miss/Total    Percent hit      Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                          0/    1/    1        0%             0/    1/    1        0%
  <NA>.main.a                                        0/    1/    1        0%             0/    1/    1        0%
  <NA>.main.a.foo                                    1/    1/    2       50%             0/    2/    2        0%
  <NA>.main.b                                        0/    1/    1        0%             0/    1/    1        0%
  <NA>.main.b.foo                                    0/    2/    2        0%             1/    1/    2       50%
---------------------------------------------------------------------------------------------------------------------

    Module: main, File: task4.1.v, Instance: <NA>.main
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      c                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...

    Module: mod_a, File: task4.1.v, Instance: <NA>.main.a
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      c                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...

    Task: mod_a.foo, File: task4.1.v, Instance: <NA>.main.a.foo
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      c                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...
      a                         0->1: 1'h1
      ......................... 1->0: 1'h0 ...

    Module: mod_a, File: task4.1.v, Instance: <NA>.main.b
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      c                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...

    Task: mod_a.foo, File: task4.1.v, Instance: <NA>.main.b.foo
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      c                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...
      a                         0->1: 1'h0
      ......................... 1->0: 1'h1 ...


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   COMBINATIONAL LOGIC COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                                                    Logic Combinations
                                                                      Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                                             0/   0/   0      100%
  <NA>.main.a                                                           1/   0/   1      100%
  <NA>.main.a.foo                                                       2/   2/   4       50%
  <NA>.main.b                                                           1/   0/   1      100%
  <NA>.main.b.foo                                                       2/   2/   4       50%
---------------------------------------------------------------------------------------------------------------------

    Task: mod_a.foo, File: task4.1.v, Instance: <NA>.main.a.foo
    -------------------------------------------------------------------------------------------------------------
    Missed Combinations  (* = missed value)

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
             27:     a  =  c 
                          |1|

        Expression 1   (1/2)
        ^^^^^^^^^^^^^ - 
         E | E
        =0=|=1=
             *

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
             29:     a  = ~ c 
                          |1-|

        Expression 1   (1/2)
        ^^^^^^^^^^^^^ - ~
         E | E
        =0=|=1=
         *    


    Task: mod_a.foo, File: task4.1.v, Instance: <NA>.main.b.foo
    -------------------------------------------------------------------------------------------------------------
    Missed Combinations  (* = missed value)

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
             27:     a  =  c 
                          |1|

        Expression 1   (1/2)
        ^^^^^^^^^^^^^ - 
         E | E
        =0=|=1=
         *    

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
             29:     a  = ~ c 
                          |1-|

        Expression 1   (1/2)
        ^^^^^^^^^^^^^ - ~
         E | E
        =0=|=1=
             *



~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   FINITE STATE MACHINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                               State                             Arc
Instance                                          Hit/Miss/Total    Percent hit    Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                         0/   0/   0      100%            0/   0/   0      100%
  <NA>.main.a                                       0/   0/   0      100%            0/   0/   0      100%
  <NA>.main.a.foo                                   0/   0/   0      100%            0/   0/   0      100%
  <NA>.main.b                                       0/   0/   0      100%            0/   0/   0      100%
  <NA>.main.b.foo                                   0/   0/   0      100%            0/   0/   0      100%


*/

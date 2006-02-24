module main;

supply1       a;
supply1 [1:0] b;
wire    [1:0] c;
reg           d, e;

assign a = d & e;
assign b = {d, e};
assign c = {2{a}} | b;

initial begin
	$dumpfile( "supply1.vcd" );
	$dumpvars( 0, main );
	d = 1'b0;
	e = 1'b1;
	#5;
	d = 1'b1;
	e = 1'b0;
	#5;
	$finish;
end

endmodule 

/* HEADER
GROUPS supply1 all iv vcs vcd lxt
SIM    supply1 all iv vcd  : iverilog supply1.v; ./a.out                             : supply1.vcd
SIM    supply1 all iv lxt  : iverilog supply1.v; ./a.out -lxt2; mv supply1.vcd supply1.lxt : supply1.lxt
SIM    supply1 all vcs vcd : vcs supply1.v; ./simv                                   : supply1.vcd
SCORE  supply1.vcd     : -t main -vcd supply1.vcd -o supply1.cdd -v supply1.v : supply1.cdd
SCORE  supply1.lxt     : -t main -lxt supply1.lxt -o supply1.cdd -v supply1.v : supply1.cdd
REPORT supply1.cdd 1   : -d v -o supply1.rptM supply1.cdd                         : supply1.rptM
REPORT supply1.cdd 2   : -d v -w -o supply1.rptWM supply1.cdd                     : supply1.rptWM
REPORT supply1.cdd 3   : -d v -i -o supply1.rptI supply1.cdd                      : supply1.rptI
REPORT supply1.cdd 4   : -d v -w -i -o supply1.rptWI supply1.cdd                  : supply1.rptWI
*/

/* OUTPUT supply1.cdd
5 1 * 6 0 0 0 0
3 0 main main supply1.v 1 24
2 1 8 f000f 2 1 c 0 0 e
2 2 8 b000b 2 1 c 0 0 d
2 3 8 b000f 2 8 20184 1 2 1 0 2
2 4 8 70007 0 1 400 0 0 a
2 5 8 7000f 1 35 f006 3 4
2 6 9 f000f 2 1 c 0 0 e
2 7 9 c000c 2 1 c 0 0 d
2 8 9 c000f 2 31 20188 6 7 2 0 120a
2 9 9 b0010 2 26 20008 8 0 2 0 120a
2 10 9 70007 0 1 400 0 0 b
2 11 9 70010 2 35 f00a 9 10
2 12 10 140014 1 1 8 0 0 b
2 13 10 e000e 1 1 8 0 0 a
2 14 10 c000c 1 0 20008 0 0 32 64 4 0 0 0 0 0 0 0
2 15 10 b0010 2 25 20208 13 14 2 0 a
2 16 10 b0014 2 9 20208 12 15 2 0 a
2 17 10 70007 0 1 400 0 0 c
2 18 10 70014 2 35 f00a 16 17
1 a 0 3 3000e 1 0 2
1 b 0 4 3000e 2 0 a
1 c 0 5 3000e 2 0 a
1 d 0 6 3000e 1 0 102
1 e 0 6 30011 1 0 1002
4 5 5 5
4 11 11 11
4 18 18 18
*/

/* OUTPUT supply1.rptM
                             ::::::::::::::::::::::::::::::::::::::::::::::::::
                             ::                                              ::
                             ::  Covered -- Verilog Coverage Verbose Report  ::
                             ::                                              ::
                             ::::::::::::::::::::::::::::::::::::::::::::::::::


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   GENERAL INFORMATION   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Report generated from CDD file : supply1.cdd

* Reported by                    : Module

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   LINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function      Filename                 Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    supply1.v                  3/    0/    3      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   TOGGLE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function      Filename                         Toggle 0 -> 1                       Toggle 1 -> 0
                                                   Hit/ Miss/Total    Percent hit      Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    supply1.v                  1/    6/    7       14%             1/    6/    7       14%
---------------------------------------------------------------------------------------------------------------------

    Module: main, File: supply1.v
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      a                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...
      b                         0->1: 2'h0
      ......................... 1->0: 2'h0 ...
      c                         0->1: 2'h0
      ......................... 1->0: 2'h0 ...
      d                         0->1: 1'h1
      ......................... 1->0: 1'h0 ...
      e                         0->1: 1'h0
      ......................... 1->0: 1'h1 ...


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   COMBINATIONAL LOGIC COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function                Filename                                Logic Combinations
                                                                      Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                              supply1.v                           5/   7/  12       42%
---------------------------------------------------------------------------------------------------------------------

    Module: main, File: supply1.v
    -------------------------------------------------------------------------------------------------------------
    Missed Combinations  (* = missed value)

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
              8:    assign  a  = ( d  &  e )
                                 |----1----|

        Expression 1   (2/4)
        ^^^^^^^^^^^^^ - &
         LR | LR | LR | LR 
        =00=|=01=|=10=|=11=
         *              *

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
              9:    assign  b  = { d ,  e }
                                 |---1----|

        Expression 1   (1/2)
        ^^^^^^^^^^^^^ - {}
         E | E
        =0=|=1=
         *    

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
             10:    assign  c  = ({2{ a }} |  b )
                                  |--1---|       
                                 |------2-------|

        Expression 1   (1/2)
        ^^^^^^^^^^^^^ - {{}}
         E | E
        =0=|=1=
         *    

        Expression 2   (1/4)
        ^^^^^^^^^^^^^ - |
         LR | LR | LR | LR 
        =00=|=01=|=10=|=11=
         *    *    *     



~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   FINITE STATE MACHINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                               State                             Arc
Module/Task/Function      Filename                Hit/Miss/Total    Percent Hit    Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    supply1.v                 0/   0/   0      100%            0/   0/   0      100%


*/

/* OUTPUT supply1.rptWM
                             ::::::::::::::::::::::::::::::::::::::::::::::::::
                             ::                                              ::
                             ::  Covered -- Verilog Coverage Verbose Report  ::
                             ::                                              ::
                             ::::::::::::::::::::::::::::::::::::::::::::::::::


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   GENERAL INFORMATION   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Report generated from CDD file : supply1.cdd

* Reported by                    : Module

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   LINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function      Filename                 Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    supply1.v                  3/    0/    3      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   TOGGLE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function      Filename                         Toggle 0 -> 1                       Toggle 1 -> 0
                                                   Hit/ Miss/Total    Percent hit      Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    supply1.v                  1/    6/    7       14%             1/    6/    7       14%
---------------------------------------------------------------------------------------------------------------------

    Module: main, File: supply1.v
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      a                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...
      b                         0->1: 2'h0
      ......................... 1->0: 2'h0 ...
      c                         0->1: 2'h0
      ......................... 1->0: 2'h0 ...
      d                         0->1: 1'h1
      ......................... 1->0: 1'h0 ...
      e                         0->1: 1'h0
      ......................... 1->0: 1'h1 ...


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   COMBINATIONAL LOGIC COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function                Filename                                Logic Combinations
                                                                      Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                              supply1.v                           5/   7/  12       42%
---------------------------------------------------------------------------------------------------------------------

    Module: main, File: supply1.v
    -------------------------------------------------------------------------------------------------------------
    Missed Combinations  (* = missed value)

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
              8:    assign  a  = ( d  &  e )
                                 |----1----|

        Expression 1   (2/4)
        ^^^^^^^^^^^^^ - &
         LR | LR | LR | LR 
        =00=|=01=|=10=|=11=
         *              *

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
              9:    assign  b  = { d ,  e }
                                 |---1----|

        Expression 1   (1/2)
        ^^^^^^^^^^^^^ - {}
         E | E
        =0=|=1=
         *    

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
             10:    assign  c  = ({2{ a }} |  b )
                                  |--1---|       
                                 |------2-------|

        Expression 1   (1/2)
        ^^^^^^^^^^^^^ - {{}}
         E | E
        =0=|=1=
         *    

        Expression 2   (1/4)
        ^^^^^^^^^^^^^ - |
         LR | LR | LR | LR 
        =00=|=01=|=10=|=11=
         *    *    *     



~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   FINITE STATE MACHINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                               State                             Arc
Module/Task/Function      Filename                Hit/Miss/Total    Percent Hit    Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    supply1.v                 0/   0/   0      100%            0/   0/   0      100%


*/

/* OUTPUT supply1.rptI
                             ::::::::::::::::::::::::::::::::::::::::::::::::::
                             ::                                              ::
                             ::  Covered -- Verilog Coverage Verbose Report  ::
                             ::                                              ::
                             ::::::::::::::::::::::::::::::::::::::::::::::::::


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   GENERAL INFORMATION   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Report generated from CDD file : supply1.cdd

* Reported by                    : Instance

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   LINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                           Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                          3/    0/    3      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   TOGGLE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                                   Toggle 0 -> 1                       Toggle 1 -> 0
                                                   Hit/ Miss/Total    Percent hit      Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                          1/    6/    7       14%             1/    6/    7       14%
---------------------------------------------------------------------------------------------------------------------

    Module: main, File: supply1.v, Instance: <NA>.main
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      a                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...
      b                         0->1: 2'h0
      ......................... 1->0: 2'h0 ...
      c                         0->1: 2'h0
      ......................... 1->0: 2'h0 ...
      d                         0->1: 1'h1
      ......................... 1->0: 1'h0 ...
      e                         0->1: 1'h0
      ......................... 1->0: 1'h1 ...


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   COMBINATIONAL LOGIC COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                                                    Logic Combinations
                                                                      Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                                             5/   7/  12       42%
---------------------------------------------------------------------------------------------------------------------

    Module: main, File: supply1.v, Instance: <NA>.main
    -------------------------------------------------------------------------------------------------------------
    Missed Combinations  (* = missed value)

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
              8:    assign  a  = ( d  &  e )
                                 |----1----|

        Expression 1   (2/4)
        ^^^^^^^^^^^^^ - &
         LR | LR | LR | LR 
        =00=|=01=|=10=|=11=
         *              *

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
              9:    assign  b  = { d ,  e }
                                 |---1----|

        Expression 1   (1/2)
        ^^^^^^^^^^^^^ - {}
         E | E
        =0=|=1=
         *    

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
             10:    assign  c  = ({2{ a }} |  b )
                                  |--1---|       
                                 |------2-------|

        Expression 1   (1/2)
        ^^^^^^^^^^^^^ - {{}}
         E | E
        =0=|=1=
         *    

        Expression 2   (1/4)
        ^^^^^^^^^^^^^ - |
         LR | LR | LR | LR 
        =00=|=01=|=10=|=11=
         *    *    *     



~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   FINITE STATE MACHINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                               State                             Arc
Instance                                          Hit/Miss/Total    Percent hit    Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                         0/   0/   0      100%            0/   0/   0      100%


*/

/* OUTPUT supply1.rptWI
                             ::::::::::::::::::::::::::::::::::::::::::::::::::
                             ::                                              ::
                             ::  Covered -- Verilog Coverage Verbose Report  ::
                             ::                                              ::
                             ::::::::::::::::::::::::::::::::::::::::::::::::::


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   GENERAL INFORMATION   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Report generated from CDD file : supply1.cdd

* Reported by                    : Instance

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   LINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                           Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                          3/    0/    3      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   TOGGLE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                                   Toggle 0 -> 1                       Toggle 1 -> 0
                                                   Hit/ Miss/Total    Percent hit      Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                          1/    6/    7       14%             1/    6/    7       14%
---------------------------------------------------------------------------------------------------------------------

    Module: main, File: supply1.v, Instance: <NA>.main
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      a                         0->1: 1'h0
      ......................... 1->0: 1'h0 ...
      b                         0->1: 2'h0
      ......................... 1->0: 2'h0 ...
      c                         0->1: 2'h0
      ......................... 1->0: 2'h0 ...
      d                         0->1: 1'h1
      ......................... 1->0: 1'h0 ...
      e                         0->1: 1'h0
      ......................... 1->0: 1'h1 ...


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   COMBINATIONAL LOGIC COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                                                    Logic Combinations
                                                                      Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                                             5/   7/  12       42%
---------------------------------------------------------------------------------------------------------------------

    Module: main, File: supply1.v, Instance: <NA>.main
    -------------------------------------------------------------------------------------------------------------
    Missed Combinations  (* = missed value)

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
              8:    assign  a  = ( d  &  e )
                                 |----1----|

        Expression 1   (2/4)
        ^^^^^^^^^^^^^ - &
         LR | LR | LR | LR 
        =00=|=01=|=10=|=11=
         *              *

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
              9:    assign  b  = { d ,  e }
                                 |---1----|

        Expression 1   (1/2)
        ^^^^^^^^^^^^^ - {}
         E | E
        =0=|=1=
         *    

      =========================================================================================================
       Line #     Expression
      =========================================================================================================
             10:    assign  c  = ({2{ a }} |  b )
                                  |--1---|       
                                 |------2-------|

        Expression 1   (1/2)
        ^^^^^^^^^^^^^ - {{}}
         E | E
        =0=|=1=
         *    

        Expression 2   (1/4)
        ^^^^^^^^^^^^^ - |
         LR | LR | LR | LR 
        =00=|=01=|=10=|=11=
         *    *    *     



~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   FINITE STATE MACHINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                               State                             Arc
Instance                                          Hit/Miss/Total    Percent hit    Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                         0/   0/   0      100%            0/   0/   0      100%


*/

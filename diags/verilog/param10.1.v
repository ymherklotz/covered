module main;

foo #(3) a();

initial begin
        $dumpfile( "param10.1.vcd" );
        $dumpvars( 0, main );
        #10;
        $finish;
end

endmodule


module foo;

initial begin : foo_begin
	parameter bar = 5;
	reg [(bar-1):0] a;
	a = 1'b0;
end

endmodule

/* HEADER
GROUPS param10.1 all iv vcs vcd lxt
SIM    param10.1 all iv vcd  : iverilog param10.1.v; ./a.out                             : param10.1.vcd
SIM    param10.1 all iv lxt  : iverilog param10.1.v; ./a.out -lxt2; mv param10.1.vcd param10.1.lxt : param10.1.lxt
SIM    param10.1 all vcs vcd : vcs param10.1.v; ./simv                                   : param10.1.vcd
SCORE  param10.1.vcd     : -t main -vcd param10.1.vcd -o param10.1.cdd -v param10.1.v : param10.1.cdd
SCORE  param10.1.lxt     : -t main -lxt param10.1.lxt -o param10.1.cdd -v param10.1.v : param10.1.cdd
REPORT param10.1.cdd 1   : -d v -o param10.1.rptM param10.1.cdd                         : param10.1.rptM
REPORT param10.1.cdd 2   : -d v -w -o param10.1.rptWM param10.1.cdd                     : param10.1.rptWM
REPORT param10.1.cdd 3   : -d v -i -o param10.1.rptI param10.1.cdd                      : param10.1.rptI
REPORT param10.1.cdd 4   : -d v -w -i -o param10.1.rptWI param10.1.cdd                  : param10.1.rptWI
*/

/* OUTPUT param10.1.cdd
5 1 * 6 0 0 0 0
3 0 main main param10.1.v 1 12
3 0 foo main.a param10.1.v 15 23
2 1 17 8000c 2 3d 2100a 0 0 1 0 2 foo_begin
4 1 0 0
3 1 foo.foo_begin main.a.foo_begin param10.1.v 17 21
2 2 20 50008 1 0 20004 0 0 1 1 0
2 3 20 10001 0 1 400 0 0 a
2 4 20 10008 1 37 11006 2 3
1 #bar 0 0 0 32 0 5 0 0 0 0 0 0 0
1 a 0 19 30011 3 16 2a
4 4 0 0
*/

/* OUTPUT param10.1.rptM
                             ::::::::::::::::::::::::::::::::::::::::::::::::::
                             ::                                              ::
                             ::  Covered -- Verilog Coverage Verbose Report  ::
                             ::                                              ::
                             ::::::::::::::::::::::::::::::::::::::::::::::::::


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   GENERAL INFORMATION   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Report generated from CDD file : param10.1.cdd

* Reported by                    : Module

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   LINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function      Filename                 Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    param10.1.v                0/    0/    0      100%
  foo                     param10.1.v                0/    0/    0      100%
  foo.foo_begin           param10.1.v                1/    0/    1      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   TOGGLE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function      Filename                         Toggle 0 -> 1                       Toggle 1 -> 0
                                                   Hit/ Miss/Total    Percent hit      Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    param10.1.v                0/    0/    0      100%             0/    0/    0      100%
  foo                     param10.1.v                0/    0/    0      100%             0/    0/    0      100%
  foo.foo_begin           param10.1.v                0/    3/    3        0%             0/    3/    3        0%
---------------------------------------------------------------------------------------------------------------------

    Named Block: foo.foo_begin, File: param10.1.v
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      a                         0->1: 3'h0
      ......................... 1->0: 3'h0 ...


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   COMBINATIONAL LOGIC COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function                Filename                                Logic Combinations
                                                                      Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                              param10.1.v                         0/   0/   0      100%
  foo                               param10.1.v                         0/   0/   0      100%
  foo.foo_begin                     param10.1.v                         0/   0/   0      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   FINITE STATE MACHINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                               State                             Arc
Module/Task/Function      Filename                Hit/Miss/Total    Percent Hit    Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    param10.1.v               0/   0/   0      100%            0/   0/   0      100%
  foo                     param10.1.v               0/   0/   0      100%            0/   0/   0      100%
  foo.foo_begin           param10.1.v               0/   0/   0      100%            0/   0/   0      100%


*/

/* OUTPUT param10.1.rptWM
                             ::::::::::::::::::::::::::::::::::::::::::::::::::
                             ::                                              ::
                             ::  Covered -- Verilog Coverage Verbose Report  ::
                             ::                                              ::
                             ::::::::::::::::::::::::::::::::::::::::::::::::::


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   GENERAL INFORMATION   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Report generated from CDD file : param10.1.cdd

* Reported by                    : Module

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   LINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function      Filename                 Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    param10.1.v                0/    0/    0      100%
  foo                     param10.1.v                0/    0/    0      100%
  foo.foo_begin           param10.1.v                1/    0/    1      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   TOGGLE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function      Filename                         Toggle 0 -> 1                       Toggle 1 -> 0
                                                   Hit/ Miss/Total    Percent hit      Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    param10.1.v                0/    0/    0      100%             0/    0/    0      100%
  foo                     param10.1.v                0/    0/    0      100%             0/    0/    0      100%
  foo.foo_begin           param10.1.v                0/    3/    3        0%             0/    3/    3        0%
---------------------------------------------------------------------------------------------------------------------

    Named Block: foo.foo_begin, File: param10.1.v
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      a                         0->1: 3'h0
      ......................... 1->0: 3'h0 ...


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   COMBINATIONAL LOGIC COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Module/Task/Function                Filename                                Logic Combinations
                                                                      Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                              param10.1.v                         0/   0/   0      100%
  foo                               param10.1.v                         0/   0/   0      100%
  foo.foo_begin                     param10.1.v                         0/   0/   0      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   FINITE STATE MACHINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                               State                             Arc
Module/Task/Function      Filename                Hit/Miss/Total    Percent Hit    Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  main                    param10.1.v               0/   0/   0      100%            0/   0/   0      100%
  foo                     param10.1.v               0/   0/   0      100%            0/   0/   0      100%
  foo.foo_begin           param10.1.v               0/   0/   0      100%            0/   0/   0      100%


*/

/* OUTPUT param10.1.rptI
                             ::::::::::::::::::::::::::::::::::::::::::::::::::
                             ::                                              ::
                             ::  Covered -- Verilog Coverage Verbose Report  ::
                             ::                                              ::
                             ::::::::::::::::::::::::::::::::::::::::::::::::::


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   GENERAL INFORMATION   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Report generated from CDD file : param10.1.cdd

* Reported by                    : Instance

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   LINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                           Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                          0/    0/    0      100%
  <NA>.main.a                                        0/    0/    0      100%
  <NA>.main.a.foo_begin                              1/    0/    1      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   TOGGLE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                                   Toggle 0 -> 1                       Toggle 1 -> 0
                                                   Hit/ Miss/Total    Percent hit      Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                          0/    0/    0      100%             0/    0/    0      100%
  <NA>.main.a                                        0/    0/    0      100%             0/    0/    0      100%
  <NA>.main.a.foo_begin                              0/    3/    3        0%             0/    3/    3        0%
---------------------------------------------------------------------------------------------------------------------

    Named Block: foo.foo_begin, File: param10.1.v, Instance: <NA>.main.a.foo_begin
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      a                         0->1: 3'h0
      ......................... 1->0: 3'h0 ...


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   COMBINATIONAL LOGIC COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                                                    Logic Combinations
                                                                      Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                                             0/   0/   0      100%
  <NA>.main.a                                                           0/   0/   0      100%
  <NA>.main.a.foo_begin                                                 0/   0/   0      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   FINITE STATE MACHINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                               State                             Arc
Instance                                          Hit/Miss/Total    Percent hit    Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                         0/   0/   0      100%            0/   0/   0      100%
  <NA>.main.a                                       0/   0/   0      100%            0/   0/   0      100%
  <NA>.main.a.foo_begin                             0/   0/   0      100%            0/   0/   0      100%


*/

/* OUTPUT param10.1.rptWI
                             ::::::::::::::::::::::::::::::::::::::::::::::::::
                             ::                                              ::
                             ::  Covered -- Verilog Coverage Verbose Report  ::
                             ::                                              ::
                             ::::::::::::::::::::::::::::::::::::::::::::::::::


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   GENERAL INFORMATION   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Report generated from CDD file : param10.1.cdd

* Reported by                    : Instance

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   LINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                           Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                          0/    0/    0      100%
  <NA>.main.a                                        0/    0/    0      100%
  <NA>.main.a.foo_begin                              1/    0/    1      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   TOGGLE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                                   Toggle 0 -> 1                       Toggle 1 -> 0
                                                   Hit/ Miss/Total    Percent hit      Hit/ Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                          0/    0/    0      100%             0/    0/    0      100%
  <NA>.main.a                                        0/    0/    0      100%             0/    0/    0      100%
  <NA>.main.a.foo_begin                              0/    3/    3        0%             0/    3/    3        0%
---------------------------------------------------------------------------------------------------------------------

    Named Block: foo.foo_begin, File: param10.1.v, Instance: <NA>.main.a.foo_begin
    -------------------------------------------------------------------------------------------------------------
    Signals not getting 100% toggle coverage

      Signal                    Toggle
      ---------------------------------------------------------------------------------------------------------
      a                         0->1: 3'h0
      ......................... 1->0: 3'h0 ...


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   COMBINATIONAL LOGIC COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Instance                                                                    Logic Combinations
                                                                      Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                                             0/   0/   0      100%
  <NA>.main.a                                                           0/   0/   0      100%
  <NA>.main.a.foo_begin                                                 0/   0/   0      100%


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   FINITE STATE MACHINE COVERAGE RESULTS   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                               State                             Arc
Instance                                          Hit/Miss/Total    Percent hit    Hit/Miss/Total    Percent hit
---------------------------------------------------------------------------------------------------------------------
  <NA>.main                                         0/   0/   0      100%            0/   0/   0      100%
  <NA>.main.a                                       0/   0/   0      100%            0/   0/   0      100%
  <NA>.main.a.foo_begin                             0/   0/   0      100%            0/   0/   0      100%


*/

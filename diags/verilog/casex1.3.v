module main;

reg	a, b;

always @( a )
  casex( a )
    1'b0 :  b = 1'b1;
    1'b1 :  b = 1'b0;
    1'bx :  b = 1'b1;
    1'bz :  b = 1'b0;
  endcase

initial begin
`ifdef DUMP
	$dumpfile( "casex1.3.vcd" );
	$dumpvars( 0, main );
`endif
	a = 1'b0;
	#5;
	a = 1'b1;
	#5;
	a = 1'bz;
	#5;
	a = 1'b0;
	#5;
	$finish;
end

endmodule

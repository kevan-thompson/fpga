`timescale 1ns/100ps

/***********************************************************
File Name:	full_adder_tb.v
Author: 	Kevan Thompson
Date:		March 13, 2024
Description: A very simple testbench to test 4 different 
            implementations of a full adder: dataflow,
            behavioral, and two different structural. 

***********************************************************/


module full_adder_tb;

reg a,b,cin;
wire s_st1, s_st2, s_df, s_bh;
wire cout_st1, cout_st2, cout_df, cout_bh;

full_adder_st full_adder_st_dut(
	.a(a),
	.b(b),
	.cin(cin),
	.s(s_st1),
	.cout(cout_st1)
);

full_adder_st2 full_adder_st2_dut(
	.a(a),
	.b(b),
	.cin(cin),
	.s(s_st2),
	.cout(cout_st2)
);

full_adder_df full_adder_df_dut(
	.a(a),
	.b(b),
	.cin(cin),
	.s(s_df),
	.cout(cout_df)
);

full_adder_bh full_adder_bh_dut(
	.a(a),
	.b(b),
	.cin(cin),
	.s(s_bh),
	.cout(cout_bh)
);


initial
begin
	$monitor("time = %d,\t a = %b,\t b = %b,\t cin = %b,\t
				s_st1 = %b,\t cout_st1 = %b,\t s_st2 = %b,\t cout_st2 = %b,\t 
				s_df = %b,\t cout_df = %b,\t s_bh = %b,\t cout_bh = %b ", 
				$time, a,b,cin,s_st1,cout_st1,s_st2,cout_st2,s_df,cout_df,s_bh,cout_bh);

	a = 0;
	b = 0;
	cin = 0;

	#10	a = 1;
	#10 b = 1;
	#10 cin = 1;
	#10 $stop;

end

endmodule
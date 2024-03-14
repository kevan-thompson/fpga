/***********************************************************
File Name:	full_adder_st2.v
Author: 	Kevan Thompson
Date:		March 13, 2024
Description: A structural implementation of a full adder. This
			full adder is constructed from two half adders.
			Operands are a, b, and Cin. s in the sum, and c is
			the carry bit

***********************************************************/

module full_adder_st2(
	input a,
	input b,
	input cin,
	output s,
	output cout
);

wire n1,n2,n3;

half_adder_df hald_adder_df1(
	.s(n1),
	.c(n2),
	.a(a),
	.b(b)
);

half_adder_df hald_adder_df2(
	.s(s),
	.c(n3),
	.a(n1),
	.b(cin)
);

or or1(cout,n2,n3);

endmodule



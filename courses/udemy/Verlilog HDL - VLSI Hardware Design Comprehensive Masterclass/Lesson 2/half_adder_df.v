/***********************************************************
File Name:	half_adder_df.v
Author: 	Kevan Thompson
Date:		March 12, 2024
Description: A data flow implementation of a half adder.
			Operands are a, and b. s in the sum, and c is
			the carry bit

***********************************************************/

module half_adder_df(
	input a,
	input b,
	output s,
	output c
);

assign s = a ^ b;
assign c = a & b;

endmodule
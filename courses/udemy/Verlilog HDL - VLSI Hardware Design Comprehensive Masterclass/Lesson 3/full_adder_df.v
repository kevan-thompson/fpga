/***********************************************************
File Name:	full_adder_df.v
Author: 	Kevan Thompson
Date:		March 13, 2024
Description: A data flow implementation of a full adder. 
			Operands are a, b, and cin. s in the sum, and c is
			the carry bit

***********************************************************/

module full_adder_df(
	input a,
	input b,
	input c_in,
	output s,
	output c_out
);

assign s = a ^ b ^ c_in;
assign c_out = (a & b) | (c_in & (a ^ b));

endmodule



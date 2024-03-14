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
	input cin,
	output s,
	output cout
);

assign s = a ^ b ^ cin;
assign cout = (a & b) | (cin & (a ^ b));

endmodule



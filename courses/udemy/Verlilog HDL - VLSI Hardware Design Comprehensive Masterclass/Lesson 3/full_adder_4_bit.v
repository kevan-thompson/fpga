/***********************************************************
File Name:	full_adder_4_bit.v
Author: 	Kevan Thompson
Date:		March 14, 2024
Description: A simple implementation of a 4 bit full adder

***********************************************************/

module full_adder_4_bit(
	input [3:0] a,
	input [3:0] b,
    input c_in,
	output [3:0] s,
	output c_out
);

assign {c_out,s} = a + b + c_in;

endmodule
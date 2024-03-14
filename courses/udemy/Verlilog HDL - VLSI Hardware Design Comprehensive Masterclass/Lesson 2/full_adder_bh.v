/***********************************************************
File Name:	full_adder_bh.v
Author: 	Kevan Thompson
Date:		March 13, 2024
Description: A behavioral implementation of a full adder. 
			Operands are a, b, and cin. s in the sum, and c is
			the carry bit

***********************************************************/

module full_adder_bh(
	input a,
	input b,
	input cin,
	output reg s,
	output reg cout
);

always@(a,b,cin)
begin
    s = a ^ b ^ cin;
    cout = (a & b) | (cin & (a ^ b));
end
    
endmodule



/***********************************************************
File Name:	half_adder_bh.v
Author: 	Kevan Thompson
Date:		March 12, 2024
Description: A behavioral implementation of a half adder.
			Operands are a, and b. s in the sum, and c is
			the carry bit

***********************************************************/

module half_adder_bh(
	input a,
	input b,
	output reg s,
	output reg c
);


always@(*)
begin
	s = a ^ b;
	c = a & b;
end

endmodule 

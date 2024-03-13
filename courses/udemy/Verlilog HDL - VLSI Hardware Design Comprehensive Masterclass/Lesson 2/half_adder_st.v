/***********************************************************
File Name:  half_adder_st.v	
Author: 	Kevan Thompson
Date:		March 12, 2024
Description: A structural implementation of a half adder.
			Operands are a, and b. s in the sum, and c is
			the carry bit

***********************************************************/

module half_adder_df(
	input a,
	input b,
	output s,
	output c
);

xor xor1 (s,a,b);
and and1 (c,a,b);

endmodule
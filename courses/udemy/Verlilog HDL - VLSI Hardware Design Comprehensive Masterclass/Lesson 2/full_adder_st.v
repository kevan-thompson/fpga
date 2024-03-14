/***********************************************************
File Name:	full_adder_st.v
Author: 	Kevan Thompson
Date:		March 13, 2024
Description: A structural implementation of a full adder.
			Operands are a, b, and Cin. s in the sum, and c is
			the carry bit

***********************************************************/

module full_adder_st(
	input a,
	input b,
	input cin,
	output s,
	output cout
);

wire n1,n2,n3;

//Sum = a xor b xor cin

xor xor1(n1,a,b);
xor xor2(s,n1,cin);

//Cout = (a and b) or (cin and ( a xor b))

and and1(n2, cin, n1);
and and2(n3,a,b);
or or1(cout,n2,n3);

endmodule 
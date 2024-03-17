/***********************************************************
File Name:	full_adder_4_bit_st.v
Author: 	Kevan Thompson
Date:		March 16, 2024
Description: A structural implementation of a 4 bit full adder

***********************************************************/

module full_adder_4_bit_st(
	input [3:0] a,
	input [3:0] b,
    input c_in,
	output [3:0] s,
	output c_out
);

wire c0,c1,c2;

full_adder_df fa_0(
    .s(s[0]),
    .c_out(c0),
    .a(a[0]),
    .b(b[0]),
    .c_in(c_in));

full_adder_df fa_1(
    .s(s[1]),
    .c_out(c1),
    .a(a[1]),
    .b(b[1]),
    .c_in(c0));

full_adder_df fa_2(
    .s(s[2]),
    .c_out(c2),
    .a(a[2]),
    .b(b[2]),
    .c_in(c1));    

full_adder_df fa_3(
    .s(s[3]),
    .c_out(c_out),
    .a(a[3]),
    .b(b[3]),
    .c_in(c2));
    
endmodule
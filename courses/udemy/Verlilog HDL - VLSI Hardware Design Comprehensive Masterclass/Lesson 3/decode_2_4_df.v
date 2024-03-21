/***********************************************************
File Name:	decode_2_4_df.v
Author: 	Kevan Thompson
Date:		March 20, 2024
Description: A 2x4 decoder

It implements the following

En I |Y
0  xx|0000
1  00|0001
1  01|0010
1  10|0100
1  11|1000 

***********************************************************/

module decode_2_4_df(
    input En,   //Enable
    input [1:0] I,
    output [3:0] Y
);    
    
assign Y = {En&I[1]&I[0],En&I[1]&~I[0],En&~I[1]&I[0],En&~I[1]&~I[0]};

endmodule
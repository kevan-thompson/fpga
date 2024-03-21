/***********************************************************
File Name:	encode_4_2_df.v
Author: 	Kevan Thompson
Date:		March 20, 2024
Description: A 4x2 encoder

It implements the following

 I  |Y  Valid
0001|00 1
0010|01 1
0100|10 1
1000|11 1

All other I values Y=00 Valid = 0 

***********************************************************/

module decode_2_4_df(
    input [3:0] I,
    output [1:0] Y,
    output Valid
);    
    
assign Y = {I[3]|I[2],I[3]|I[1]};

assign Valid = |I;

endmodule
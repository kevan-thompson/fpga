/***********************************************************
File Name:	mux_4_1_df3.v
Author: 	Kevan Thompson
Date:		March 18, 2024
Description: A 4 to 1 mux 

***********************************************************/

module mux_4_1_df3(
	input [3:0] I,
    input [1:0] S,
	output  Y
);

//This seems like not the best way to implement this...
assign Y = (S == 2'd0)?I[0]:((S == 2'd1)?I[1]:((S == 2'd2)?I[2]:I[3]));
    
endmodule
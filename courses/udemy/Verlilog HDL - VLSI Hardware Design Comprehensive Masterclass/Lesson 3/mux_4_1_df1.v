/***********************************************************
File Name:	mux_4_1_df1.v
Author: 	Kevan Thompson
Date:		March 18, 2024
Description: A 4 to 1 mux 

***********************************************************/

module mux_4_1_df1(
	input [3:0] I,
    input [1:0] S,
	output  Y
);

assign Y = I[S];
    
endmodule
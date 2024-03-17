/***********************************************************
File Name:	mux_2_1_df.v
Author: 	Kevan Thompson
Date:		March 17, 2024
Description: A 2 to 1 mux using the ternary operator

***********************************************************/

module mux_2_1_df(
	input [1:0] I,
    input S,
	output Y
);

assign Y = S ? I[1] : I[0];
    
endmodule
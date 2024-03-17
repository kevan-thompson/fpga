/***********************************************************
File Name:	mux_2_1_bh.v
Author: 	Kevan Thompson
Date:		March 17, 2024
Description: A 2 to 1 mux using if/else

***********************************************************/

module mux_2_1_bh(
	input [1:0] I,
    input S,
	output reg Y
);

always @(*)
    if(S)
        Y = I[1];
    else
        Y = I[0];
    
endmodule
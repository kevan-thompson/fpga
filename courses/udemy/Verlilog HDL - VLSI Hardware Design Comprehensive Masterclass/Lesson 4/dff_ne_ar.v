/***********************************************************
File Name:	dff_ne_ar.v
Author: 	Kevan Thompson
Date:		March 22, 2024
Description: A d flip flop with negative edge clock and 
            asynchronous reset

***********************************************************/
module dff_ne_ar(
    input clk,
    input rst,
    input d,
    output reg q
);

always@(negedge clk or posedge rst) 
    if(rst) 
        q <= 1'b0;
    else
        q <= d;

endmodule
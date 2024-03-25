/***********************************************************
File Name:	dff_nsr_ss.v
Author: 	Kevan Thompson
Date:		March 24, 2024
Description: A d flip flop with positive edge clock and 
             negative synchronous reset and  positive 
             synchronous set

***********************************************************/
module dff_nsr_ss(
    input clk,
    input rst,
    input set,
    input d,
    output reg q
);

always@(posedge clk) 
    if(!rst) 
        q <= 1'b0;
    else if(set)
        q <= 1'b1;
    else
        q <= d;

endmodule
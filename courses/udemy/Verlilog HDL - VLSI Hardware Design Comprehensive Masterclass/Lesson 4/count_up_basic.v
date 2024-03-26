/***********************************************************
File Name:	count_up_basic.v
Author: 	Kevan Thompson
Date:		March 25, 2024
Description: A basic 8 bit counter

***********************************************************/
module count_up_basic(
    input clk,
    input rst,
    output [7:0] count 
);

reg [7:0] count_temp;

always@(posedge clk) 
    if(rst)
        count_temp <= 8'd0;
    else 
        count_temp <= count_temp + 1;

assign count = count_temp;
    
endmodule
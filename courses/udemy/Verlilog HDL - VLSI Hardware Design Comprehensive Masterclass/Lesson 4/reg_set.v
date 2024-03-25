/***********************************************************
File Name:	reg_set.v
Author: 	Kevan Thompson
Date:		March 24, 2024
Description: A set of 2, 8 bit registers

***********************************************************/
module reg_set(
    input clk,
    input rst,
    input [7:0] d1,
    input [7:0] d2,
    output reg [7:0] q1,
    output reg [7:0] q2
);

always@(posedge clk) 
    if(rst) begin 
        q1 <= 0;
        q2 <= 0;
    end
    else begin
        q1 <= d1;
        q2 <= d2;
    end
endmodule
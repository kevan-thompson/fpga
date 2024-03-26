/***********************************************************
File Name:	count_up_down.v
Author: 	Kevan Thompson
Date:		March 25, 2024
Description: An 8 bit counter that can count up or down
            and has a load option

***********************************************************/
module count_up_down(
    input clk,
    input rst,
    input up_not_down,   //1 count up, 0 count down
    input load,         // load counter with data 
    input [7:0] data,
    output [7:0] count 
);

reg [7:0] count_temp;

always@(posedge clk) 
    if(rst)
        count_temp <= 8'd0;
    else if(load)
        count_temp <= data;
    else if(up_not_down)
        count_temp <= count_temp + 1;
    else    
        count_temp <= count_temp + 1;
        
assign count = count_temp;
    
endmodule
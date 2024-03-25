/***********************************************************
File Name:	sr_lr.v
Author: 	Kevan Thompson
Date:		March 24, 2024
Description: A 4 bit left to right shift register

***********************************************************/
module sr_lr(
    input clk,
    input rst,
    input si,   //Serial In
    output so   //Serial Out
);

reg [4:0] sr;    //shift register

always@(posedge clk) 
    if(rst) begin 
        sr <= 4'd0;
    end
    else begin
        sr <= {sr[3:0],si};
    end
    
assign so = sr[4];
    
endmodule
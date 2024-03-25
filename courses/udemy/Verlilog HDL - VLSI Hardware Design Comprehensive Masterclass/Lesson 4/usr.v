/***********************************************************
File Name:	usr.v
Author: 	Kevan Thompson
Date:		March 24, 2024
Description: A universal shift register with a parallel in
            and parrallel out. Shift direction and loadings
            is controled with the sel input:
                00 - no shift
                01 - shift left
                10 - shift right 
                11 - load parrallel in into shift reg

***********************************************************/
module usr(
    input clk,
    input rst,
    input [1:0] sel,     //Select, 0 - no shift    
                        //        1 - shift left
                        //        2 - shift right
                        //        3 - load pi into register
    input [4:0] pi,     //parrallel in
    input si,           //Serial In
    output so,          //Serial Out
    output reg [4:0] po //parallel out
);

always@(posedge clk) 
    if(rst) begin 
        po <= 5'd0;
    end
    else begin
        case(sel) 
            2'b00: po <= po;
            2'b01: po <= {po[3:0],si};
            2'b10: po <= {si,po[4:1]};
            2'b11: po <= pi;
            default: po <= 5'd0;
        endcase
    end

//if sel = 01 so gets po[4] (left shift)
//else so gets p[0] (right shift)
    
assign so = (sel == 2'b01)?po[4]:po[0];
    
endmodule
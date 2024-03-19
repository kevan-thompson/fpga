/***********************************************************
File Name:	mux_4_1_bh.v
Author: 	Kevan Thompson
Date:		March 18, 2024
Description: A 4 to 1 mux 

***********************************************************/

module mux_4_1_bh(
	input [3:0] I,
    input [1:0] S,
	output reg Y
);

always@(*) begin
    case(S)
        2'd0: Y=I[0];
        2'd1: Y=I[1];
        2'd2: Y=I[2];
        2'd3: Y=I[3];
        default: $display("Error");
    endcase
    end 
endmodule
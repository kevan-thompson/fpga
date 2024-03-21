/***********************************************************
File Name:	decode_2_4_bh.v
Author: 	Kevan Thompson
Date:		March 20, 2024
Description: A 2x4 decoder

It implements the following

En I |Y
0  xx|0000
1  00|0001
1  01|0010
1  10|0100
1  11|1000 

***********************************************************/

module decode_2_4_df(
    input En,   //Enable
    input [1:0] I,
    output reg [3:0] Y
);    
    
always@(*) begin
    case({En,I})
        3'b100: Y=4'b0001;
        3'b101: Y=4'b0010;
        3'b110: Y=4'b0100;
        3'b111: Y=4'b1000;
        3'b000,
        3'b001,
        3'b010,
        3'b011: Y=4'b0000;
        default: $display("Error");
    endcase
end
endmodule
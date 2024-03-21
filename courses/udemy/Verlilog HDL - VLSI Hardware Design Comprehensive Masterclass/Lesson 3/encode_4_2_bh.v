/***********************************************************
File Name:	encode_4_2_bh.v
Author: 	Kevan Thompson
Date:		March 20, 2024
Description: A 4x2 encoder

It implements the following

 I  |Y  Valid
0001|00 1
0010|01 1
0100|10 1
1000|11 1

All other I values Y=00 Valid = 0 

***********************************************************/

module decode_2_4_dh(
    input [3:0] I,
    output reg [1:0] Y,
    output reg Valid
);    
    
always@(*) begin
    case(I)
        4'd1:{Valid,Y} = 3'b100;
        4'd2:{Valid,Y} = 3'b101;
        4'd4:{Valid,Y} = 3'b110;
        4'd8:{Valid,Y} = 3'b111;
        4'd0,4'd3,4'd5,4'd6,4'd7,4'd9,4'd10,4'd11,4'd12,4'd13,
        4'd14,4'd15:{Valid,Y} = 3'b000;
        default: $display("Error");
    endcase
end        
endmodule
/***********************************************************
File Name:	barrel.v
Author: 	Kevan Thompson
Date:		March 21, 2024
Description: An 8 bit barrel shifter

***********************************************************/

module barrel(
    input [7:0] In,
    input [2:0] N,
    input LnR,      //left not right. Determines shift direction
    output reg [7:0] Out
);

always@(*) begin
    if(LnR)
        Out = In << N;
    else
        Out = In >> N;
end //always @

endmodule
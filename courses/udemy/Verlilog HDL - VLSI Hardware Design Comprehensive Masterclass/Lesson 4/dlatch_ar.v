/***********************************************************
File Name:	dlatch_ar.v
Author: 	Kevan Thompson
Date:		March 22, 2024
Description: A simple d-latch with asynchronous reset

***********************************************************/
module dlatch_ar(
    input en,
    input d,
    input rst,
    output reg q
);


always@(en,q,rst) 
    if(rst)
        q = 1'b0;
    else if(en) 
        q = d;

endmodule
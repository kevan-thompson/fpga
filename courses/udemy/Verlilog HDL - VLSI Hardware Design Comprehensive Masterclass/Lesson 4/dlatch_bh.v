/***********************************************************
File Name:	dlatch_bh.v
Author: 	Kevan Thompson
Date:		March 21, 2024
Description: A simple d-latch

***********************************************************/
module dlatch_bh(
    input en,
    input d,
    output reg q
);

//This seems like a bad way of doing things...
always@(en,q) 
    if(en) q = d;

endmodule
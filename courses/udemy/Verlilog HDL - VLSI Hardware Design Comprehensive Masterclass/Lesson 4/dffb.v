/***********************************************************
File Name:	dffb.v
Author: 	Kevan Thompson
Date:		March 22, 2024
Description: A basic d flip flop

***********************************************************/
module dffb(
    input clk,
    input d,
    output reg q
);

//= is a blocking operator
//Ex:
// a = b;
// c = a;
// d = c;
//Is effectively the same as d = b;

//<= is a non blocking assignment operator
// a <= b; a gets the old value of b
// c <= a; c gets the old value of a
// d <= c; d gets the old value of c

//posedge is used detect a change on the rising edge of 
//a signal. Like a clock 

always@(posedge clk) 
    if(clk) 
        q <= d;

endmodule
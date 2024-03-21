`timescale 1ns/100ps

/***********************************************************
File Name:	mux_4_1_tb.v
Author: 	Kevan Thompson
Date:		March 16, 2024
Description: A testbench comparing different 4 to 1 mux. 
             implementations
***********************************************************/

module mux_4_1_tb;

reg [3:0] I;
reg [1:0] S;

wire Y0,Y1,Y2,Y3;

wire compare;


mux_4_1_bh mux_dut_0(
    .I(I),
    .S(S),
    .Y(Y0));

mux_4_1_df1 mux_dut_1(
    .I(I),
    .S(S),
    .Y(Y1));

mux_4_1_df2 mux_dut_2(
    .I(I),
    .S(S),
    .Y(Y2));

mux_4_1_df3 mux_dut_3(
    .I(I),
    .S(S),
    .Y(Y3));    

assign compare = (Y0 == I[S]) & (Y1 == I[S]) & (Y2 == I[S]) & (Y3 == I[S]); 
    
initial
begin 

    $monitor("time = %d, \t comparison = %b ",
            $time, compare);

    I = 0;
    S = 0;

    repeat(16) begin
        #10 I = I + 1;
        repeat(4) begin
            #10 S = S + 1;
        end
    end
end    
    
endmodule
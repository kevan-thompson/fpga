`timescale 1ns/100ps
/***********************************************************
File Name:	dff_tb.v
Author: 	Kevan Thompson
Date:		March 22, 2024
Description: A test bench for d flip flops

***********************************************************/
module dff_tb;

reg clk;
reg rst;
reg d;
wire q_basic;
wire q_ne_ar;
wire q_pe_ar;

//---------------------------------------------------------
//Instantiate DUTS
//---------------------------------------------------------

dffb dffb_dut(
    .clk(clk),
    .d(d),
    .q(q_basic));

dff_ne_ar dff_ne_ar_dut(
    .clk(clk),
    .rst(rst),
    .d(d),
    .q(q_ne_ar));

dff_pe_ar dff_pe_ar_dut(
    .clk(clk),
    .rst(rst),
    .d(d),
    .q(q_pe_ar));    

//---------------------------------------------------------
//Run Tests
//---------------------------------------------------------
    
 initial begin 
        rst = 0; 
        clk = 0;
        d = 0;
        #15 d = 1;
        #25 rst = 1;
        #30 d = 0;
        #45 rst = 0;
        #55 d = 1;
        #65 rst = 1;
   
     end 

always 
   #10 clk = ~clk;
   
endmodule
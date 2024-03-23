`timescale 1ns/100ps

/***********************************************************
File Name:	full_adder_4_bit_tb2.v
Author: 	Kevan Thompson
Date:		March 16, 2024
Description: A testbench comparing a structural and dataflow
            implementation of a 4 bit adder. 

***********************************************************/

module full_adder_4_bit_tb2;

reg [3:0] a;
reg [3:0] b;
reg c_in;
wire [3:0] s;
wire [3:0] s_st;
wire c_out;
wire c_out_st;
wire compare;

//---------------------------------------------------------
//Instantiate DUTS
//---------------------------------------------------------

full_adder_4_bit fa4_dut(
    .s(s),
    .c_out(c_out),
    .a(a),
    .b(b),
    .c_in(c_in));

full_adder_4_bit_st fa4_st_dut(
    .s(s_st),
    .c_out(c_out_st),
    .a(a),
    .b(b),
    .c_in(c_in));    

//---------------------------------------------------------
//Run Tests
//---------------------------------------------------------    
    
assign compare = (s == s_st) & (c_out == c_out_st); 
    
initial
begin 

    $monitor("time = %d, \t comparison = %b ",
            $time, compare);

    a = 0;
    b = 0;
    c_in = 0;

    repeat(16) begin
        #10 a = a + 1;
        repeat(16) begin
            #10 b = b + 1;
            repeat(2)
                #10 c_in = ~c_in;
        end
    end
end    
    
endmodule
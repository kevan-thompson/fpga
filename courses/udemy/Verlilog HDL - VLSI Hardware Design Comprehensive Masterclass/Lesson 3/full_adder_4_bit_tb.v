`timescale 1ns/100ps

/***********************************************************
File Name:	full_adder_4_bit.v
Author: 	Kevan Thompson
Date:		March 14, 2024
Description: A simple implementation of a 4 bit full adder

***********************************************************/

module full_adder_4_bit_tb;

reg [3:0] a;
reg [3:0] b;
reg c_in;
wire [3:0] s;
wire c_out;

//---------------------------------------------------------
//Instantiate DUT
//---------------------------------------------------------

full_adder_4_bit fa4_dut(
    .s(s),
    .c_out(c_out),
    .a(a),
    .b(b),
    .c_in(c_in));

//---------------------------------------------------------
//Run Tests
//---------------------------------------------------------
    
initial
begin 

    $monitor("time = %d, \t a = %b, \t b = %b, \t c_in = %b, \t s = %b, \t c_out = %b",
            $time, a, b, c_in, s, c_out);

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
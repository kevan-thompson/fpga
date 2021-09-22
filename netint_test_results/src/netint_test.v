/*

Filename:	netint_test.v
Author:		Kevan Thompson
Date: 		Sept 14, 2019
Purpose:	Top level file. Instantiates data_buffer and register_b

*/

module netint_test (
	input	clk,
	input	[15:0] valids,
	//Data In
	input	[31:0] data_in_0,
	input	[31:0] data_in_1,
	input	[31:0] data_in_2,
	input	[31:0] data_in_3,
	input	[31:0] data_in_4,
	input	[31:0] data_in_5,
	input	[31:0] data_in_6,
	input	[31:0] data_in_7,
	input	[31:0] data_in_8,
	input	[31:0] data_in_9,
	input	[31:0] data_in_10,
	input	[31:0] data_in_11,
	input	[31:0] data_in_12,
	input	[31:0] data_in_13,
	input	[31:0] data_in_14,
	input	[31:0] data_in_15,
	//Register B
	output	[4:0] b,
	//Data Out
	output	[31:0] data_out_0,
	output	[31:0] data_out_1,
	output	[31:0] data_out_2,
	output	[31:0] data_out_3,
	output	[31:0] data_out_4,
	output	[31:0] data_out_5,
	output	[31:0] data_out_6,
	output	[31:0] data_out_7,
	output	[31:0] data_out_8,
	output	[31:0] data_out_9,
	output	[31:0] data_out_10,
	output	[31:0] data_out_11,
	output	[31:0] data_out_12,
	output	[31:0] data_out_13,
	output	[31:0] data_out_14,
	output	[31:0] data_out_15);
	
	register_b register_b_0(
		clk,
		valids,
		b);
	
	data_buffer data_buffer_0 (
		clk,
		valids,
		data_in_0,
		data_in_1,
		data_in_2,
		data_in_3,
		data_in_4,
		data_in_5,
		data_in_6,
		data_in_7,
		data_in_8,
		data_in_9,
		data_in_10,
		data_in_11,
		data_in_12,
		data_in_13,
		data_in_14,
		data_in_15,
		data_out_0,
		data_out_1,
		data_out_2,
		data_out_3,
		data_out_4,
		data_out_5,
		data_out_6,
		data_out_7,
		data_out_8,
		data_out_9,
		data_out_10,
		data_out_11,
		data_out_12,
		data_out_13,
		data_out_14,
		data_out_15);
	
endmodule
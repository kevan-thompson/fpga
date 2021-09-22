/*

Filename:	data_buffer.v
Author:		Kevan Thompson
Date: 		Sept 14, 2019
Purpose:	Instantiates 16 buffers_and_mux, and a single encoder 

*/

module data_buffer (
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

	wire	[15:0] buffer_0_mux_sel;
	wire	[15:0] buffer_1_mux_sel;
	wire	[15:0] buffer_2_mux_sel;
	wire	[15:0] buffer_3_mux_sel;
	wire	[15:0] buffer_4_mux_sel;
	wire	[15:0] buffer_5_mux_sel;
	wire	[15:0] buffer_6_mux_sel;
	wire	[15:0] buffer_7_mux_sel;
	wire	[15:0] buffer_8_mux_sel;
	wire	[15:0] buffer_9_mux_sel;
	wire	[15:0] buffer_10_mux_sel;
	wire	[15:0] buffer_11_mux_sel;
	wire	[15:0] buffer_12_mux_sel;
	wire	[15:0] buffer_13_mux_sel;
	wire	[15:0] buffer_14_mux_sel;
	wire	[15:0] buffer_15_mux_sel;
	
	buffer_mux_encoding encoder_0 (
		valids,
		buffer_0_mux_sel,
		buffer_1_mux_sel,
		buffer_2_mux_sel,
		buffer_3_mux_sel,
		buffer_4_mux_sel,
		buffer_5_mux_sel,
		buffer_6_mux_sel,
		buffer_7_mux_sel,
		buffer_8_mux_sel,
		buffer_9_mux_sel,
		buffer_10_mux_sel,
		buffer_11_mux_sel,
		buffer_12_mux_sel,
		buffer_13_mux_sel,
		buffer_14_mux_sel,
		buffer_15_mux_sel);

	
	buffer_and_mux buffer_0 (
		clk,
		buffer_0_mux_sel,
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
		data_out_0);
	
	buffer_and_mux buffer_1 (
		clk,
		buffer_1_mux_sel,
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
		data_out_1);

	buffer_and_mux buffer_2 (
		clk,
		buffer_2_mux_sel,
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
		data_out_2);		

	buffer_and_mux buffer_3 (
		clk,
		buffer_3_mux_sel,
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
		data_out_3);	

	buffer_and_mux buffer_4 (
		clk,
		buffer_4_mux_sel,
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
		data_out_4);

	buffer_and_mux buffer_5 (
		clk,
		buffer_5_mux_sel,
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
		data_out_5);

	buffer_and_mux buffer_6 (
		clk,
		buffer_6_mux_sel,
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
		data_out_6);

	buffer_and_mux buffer_7 (
		clk,
		buffer_7_mux_sel,
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
		data_out_7);

	buffer_and_mux buffer_8 (
		clk,
		buffer_8_mux_sel,
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
		data_out_8);

	buffer_and_mux buffer_9 (
		clk,
		buffer_9_mux_sel,
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
		data_out_9);

	buffer_and_mux buffer_10 (
		clk,
		buffer_10_mux_sel,
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
		data_out_10);

	buffer_and_mux buffer_11 (
		clk,
		buffer_11_mux_sel,
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
		data_out_11);

	buffer_and_mux buffer_12 (
		clk,
		buffer_12_mux_sel,
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
		data_out_12);		
		
	buffer_and_mux buffer_13 (
		clk,
		buffer_13_mux_sel,
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
		data_out_13);

	buffer_and_mux buffer_14 (
		clk,
		buffer_14_mux_sel,
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
		data_out_14);

	buffer_and_mux buffer_15 (
		clk,
		buffer_15_mux_sel,
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
		data_out_15);

endmodule
	
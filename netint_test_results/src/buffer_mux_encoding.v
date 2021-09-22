/*

Filename:	buffer_mux_encoding.v
Author:		Kevan Thompson
Date: 		Sept 14, 2019
Purpose:	Creates the mux encoding for buffer_and_mux based off the valids signal. 
			Encoding uses 1 hot selet
			
			Encoding gets first 1 in valids, and then masks that bit off for the next buffer. Repeate for all 16 buffers

*/

module buffer_mux_encoding (
	input	[15:0] valids,
	output	[15:0] buffer_0_mux_sel,
	output	[15:0] buffer_1_mux_sel,
	output	[15:0] buffer_2_mux_sel,
	output	[15:0] buffer_3_mux_sel,
	output	[15:0] buffer_4_mux_sel,
	output	[15:0] buffer_5_mux_sel,
	output	[15:0] buffer_6_mux_sel,
	output	[15:0] buffer_7_mux_sel,
	output	[15:0] buffer_8_mux_sel,
	output	[15:0] buffer_9_mux_sel,
	output	[15:0] buffer_10_mux_sel,
	output	[15:0] buffer_11_mux_sel,
	output	[15:0] buffer_12_mux_sel,
	output	[15:0] buffer_13_mux_sel,
	output	[15:0] buffer_14_mux_sel,
	output	[15:0] buffer_15_mux_sel);

	wire [15:0] valids_temp_1;
	wire [15:0] valids_temp_2;
	wire [15:0] valids_temp_3;
	wire [15:0] valids_temp_4;
	wire [15:0] valids_temp_5;
	wire [15:0] valids_temp_6;
	wire [15:0] valids_temp_7;
	wire [15:0] valids_temp_8;
	wire [15:0] valids_temp_9;
	wire [15:0] valids_temp_10;
	wire [15:0] valids_temp_11;
	wire [15:0] valids_temp_12;
	wire [15:0] valids_temp_13;
	wire [15:0] valids_temp_14;
	wire [15:0] valids_temp_15;
	
	//Mask off previous selection
	assign valids_temp_1 = valids & (~buffer_0_mux_sel);
	assign valids_temp_2 = valids_temp_1 & (~buffer_1_mux_sel);
	assign valids_temp_3 = valids_temp_2 & (~buffer_2_mux_sel);
	assign valids_temp_4 = valids_temp_3 & (~buffer_3_mux_sel);
	assign valids_temp_5 = valids_temp_4 & (~buffer_4_mux_sel);
	assign valids_temp_6 = valids_temp_5 & (~buffer_5_mux_sel);
	assign valids_temp_7 = valids_temp_6 & (~buffer_6_mux_sel);
	assign valids_temp_8 = valids_temp_7 & (~buffer_7_mux_sel);
	assign valids_temp_9 = valids_temp_8 & (~buffer_8_mux_sel);
	assign valids_temp_10 = valids_temp_9 & (~buffer_9_mux_sel);
	assign valids_temp_11 = valids_temp_10 & (~buffer_10_mux_sel);
	assign valids_temp_12 = valids_temp_11 & (~buffer_11_mux_sel);
	assign valids_temp_13 = valids_temp_12 & (~buffer_12_mux_sel);
	assign valids_temp_14 = valids_temp_13 & (~buffer_13_mux_sel);
	assign valids_temp_15 = valids_temp_14 & (~buffer_14_mux_sel);

	//Get first 1 in valids
	first_bit first_bit_0 (
		valids,
		buffer_0_mux_sel
	);

	first_bit first_bit_1 (
		valids_temp_1,
		buffer_1_mux_sel
	);

	first_bit first_bit_2 (
		valids_temp_2,
		buffer_2_mux_sel
	);
	
	first_bit first_bit_3 (
		valids_temp_3,
		buffer_3_mux_sel
	);
	
	first_bit first_bit_4 (
		valids_temp_4,
		buffer_4_mux_sel
	);
	
	first_bit first_bit_5 (
		valids_temp_5,
		buffer_5_mux_sel
	);
	
	first_bit first_bit_6 (
		valids_temp_6,
		buffer_6_mux_sel
	);
	
	first_bit first_bit_7 (
		valids_temp_7,
		buffer_7_mux_sel
	);
	
	first_bit first_bit_8 (
		valids_temp_8,
		buffer_8_mux_sel
	);
	
	first_bit first_bit_9 (
		valids_temp_9,
		buffer_9_mux_sel
	);
	
	first_bit first_bit_10 (
		valids_temp_10,
		buffer_10_mux_sel
	);
	
	first_bit first_bit_11 (
		valids_temp_11,
		buffer_11_mux_sel
	);
	
	first_bit first_bit_12 (
		valids_temp_12,
		buffer_12_mux_sel
	);
	
	first_bit first_bit_13 (
		valids_temp_13,
		buffer_13_mux_sel
	);
	
	first_bit first_bit_14 (
		valids_temp_14,
		buffer_14_mux_sel
	);
	
	first_bit first_bit_15 (
		valids_temp_15,
		buffer_15_mux_sel
	);
	
endmodule
	
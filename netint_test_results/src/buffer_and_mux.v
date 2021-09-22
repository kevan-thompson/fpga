/*

Filename:	buffer_and_mux.v
Author:		Kevan Thompson
Date: 		Sept 14, 2019
Purpose:	32 bit wide buffer with built in 16-1 mux
			mux encoding uses 1 hot select

*/

module buffer_and_mux (
	input	clk,
	input	[15:0] mux_sel,
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
	output	reg [31:0] data_out);

	always @(posedge clk)
	begin
		if(mux_sel == 16'b0000000000000001)
			data_out  = data_in_0;
		else if (mux_sel == 16'b0000000000000010)
			data_out  = data_in_1;
		else if (mux_sel == 16'b0000000000000100)
			data_out  = data_in_2;
		else if (mux_sel == 16'b0000000000001000)
			data_out  = data_in_3;
		else if (mux_sel == 16'b0000000000010000)
			data_out  = data_in_4;
		else if (mux_sel == 16'b0000000000100000)
			data_out  = data_in_5;
		else if (mux_sel == 16'b0000000001000000)
			data_out  = data_in_6;
		else if (mux_sel == 16'b0000000010000000)
			data_out  = data_in_7;
		else if (mux_sel == 16'b0000000100000000)
			data_out  = data_in_8;
		else if (mux_sel == 16'b0000001000000000)
			data_out  = data_in_9;
		else if (mux_sel == 16'b0000010000000000)
			data_out  = data_in_10;
		else if (mux_sel == 16'b0000100000000000)
			data_out  = data_in_11;
		else if (mux_sel == 16'b0001000000000000)
			data_out  = data_in_12;
		else if (mux_sel == 16'b0010000000000000)
			data_out  = data_in_13;
		else if (mux_sel == 16'b0100000000000000)
			data_out  = data_in_14;
		else if (mux_sel == 16'b1000000000000000)
			data_out  = data_in_15;
		else 
			data_out = 16'b0000000000000000;
	end		
		
	
endmodule
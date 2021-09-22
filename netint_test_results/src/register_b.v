/*

Filename:	register_b.v
Author:		Kevan Thompson
Date: 		Sept 13, 2019
Purpose:	Sums all the 1's in valids, and registers them in b

*/


module register_b (
	input	clk,
	input	[15:0] valids,
	output	reg [4:0] b);
	
	reg [4:0] reg_b;
	integer 	i;
	
	//Sums all the 1's in valid
	always @(valids)
	begin
		reg_b = 0;
		for(i=0;i<16;i=i+1)
			reg_b = reg_b + valids[i];
	end
	
	always @(posedge clk)
	begin
		b = reg_b;
	end
		
endmodule
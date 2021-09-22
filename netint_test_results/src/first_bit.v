/*

Filename:	first_bit.v
Author:		Kevan Thompson
Date: 		Sept 14, 2019
Purpose: 	Masks off to 0 all the bits in data except the first 1, and output in single_bit

*/

module first_bit (
	input	[15:0] data,
	output	reg	[15:0] single_bit);

always @(data)
	begin
	
	if (data == 16'b000000000000000)
		single_bit = 16'b0000000000000000;
	else if(data[0] == 1)
		single_bit = 16'b0000000000000001;
	else if (data[1] == 1)
		single_bit = 16'b0000000000000010;
	else if (data[2] == 1)
		single_bit = 16'b0000000000000100;
	else if (data[3] == 1)
		single_bit = 16'b0000000000001000;
	else if (data[4] == 1)
		single_bit = 16'b0000000000010000;
	else if (data[5] == 1)
		single_bit = 16'b0000000000100000;
	else if (data[6] == 1)
		single_bit = 16'b0000000001000000;
	else if (data[7] == 1)
		single_bit = 16'b0000000010000000;
	else if (data[8] == 1)
		single_bit = 16'b0000000100000000;
	else if (data[9] == 1)
		single_bit = 16'b0000001000000000;
	else if (data[10] == 1)
		single_bit = 16'b0000010000000000;
	else if (data[11] == 1)
		single_bit = 16'b0000100000000000;
	else if (data[12] == 1)
		single_bit = 16'b0001000000000000;
	else if (data[13] == 1)
		single_bit = 16'b0010000000000000;
	else if (data[14] == 1)
		single_bit = 16'b0100000000000000;
	else
		single_bit = 16'b1000000000000000;
end

endmodule
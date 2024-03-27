/***********************************************************
File Name:	ram_single_port.v
Author: 	Kevan Thompson
Date:		March 26, 2024
Description: A basic single port ram with a size of 64 bytes

***********************************************************/

module ram_single_port(
    input clk,
    input [7:0] data,
    input [5:0] read_addr,
    input [5:0] write_addr,
    input we,           //Write enable
    output reg [7:0] q
);

reg [7:0] ram [63:0];

always@(posedge clk) begin
    if(we)
        ram[write_addr] <= data;
    //If write_addr = read_addr this
    //will get the old value at read_addr
    q <= ram[read_addr];
end
endmodule
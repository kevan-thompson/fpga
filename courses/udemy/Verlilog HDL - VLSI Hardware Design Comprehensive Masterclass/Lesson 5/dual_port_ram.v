/***********************************************************
File Name:	dual_port_ram.v
Author: 	Kevan Thompson
Date:		March 26, 2024
Description: A dual port ram with a size of 64 bytes

***********************************************************/

module dual_port_ram(
    input clk,
    input [7:0] data_a,
    input [7:0] data_b,
    input [5:0] addr_a,
    input [5:0] addr_b,
    input we_a,           //Write enable a
    input we_b,           //Write enable b  
    output reg [7:0] q_a,
    output reg [7:0] q_b
);

reg [7:0] ram [63:0];

//Port a
always@(posedge clk) begin
    if(we_a) begin
        ram[addr_a] <= data_a;
        q_a <= data_a;
    end
    else
        q_a <= ram[addr_a];
end

//Port b
always@(posedge clk) begin
    if(we_b) begin
        ram[addr_b] <= data_b;
        q_b <= data_b;
    end
    else
        q_b <= ram[addr_b];
end

endmodule
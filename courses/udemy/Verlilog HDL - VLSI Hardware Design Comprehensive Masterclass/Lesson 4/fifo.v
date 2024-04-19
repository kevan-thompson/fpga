/***********************************************************
File Name:	fifo.v
Author: 	Kevan Thompson
Date:		March 25, 2024
Description: An 8 bit fifo with a maximum capacity of 64 
            elements. It supports only a single clock. 
            If has outputs for full, empty, and a counter
            with the number of elements in the fifo.

***********************************************************/
module count_up_down(
    input clk,
    input rst,
    input wr_en,                 //write enable
    input rd_en,                 //read enable
    input [7:0] buf_in,          //input buffer
    output reg buf_empty,        //1 when fifo is empty
    output reg buf_full,         //1 when fifo is full
    output reg [7:0] buf_out,    //output buffer
    output reg [7:0] fifo_counter//elements loaded in fifo
);

//read pointer (aka tail pointer)
reg [3:0] rd_ptr;
//write pointer (aka head pointer)
reg [3:0] wr_ptr;
//circular buffer
reg [7:0] buf_mem[63:0];

//Calculate if the buffer is empty or full
always@(fifo_counter) begin
    buf_empty <= (fifo_counter == 0);
    buf_full <= (fifo_counter == 64);
end

//Increment and decrement fifo counter
always@(posedge clk) begin 
    if(rst) 
        fifo_counter <= 8'd0;
    else if((!buf_full && wr_en) && (!buf_empty && rd_en)) 
        //There's a read and write, so leave counter as is
        fifo_counter <= fifo_counter;
    else if(!buf_full && wr_en)
        fifo_counter <= fifo_counter + 1;
    else if(!buf_empty && rd_en)
        fifo_counter <= fifo_counter - 1;
    else    
        fifo_counter <= fifo_counter;
end

//Read from the fifo
always@(posedge clk) begin 
    if(rst) 
        buf_out <= 8'd0;
    else begin
        if(!buf_empty && rd_en)
            buf_out <= buf_mem[rd_ptr];
        else
            buf_out <= buf_out;
    end
end

//Write into the fifo
always@(posedge clk) begin 
    if(!buf_full && wr_en)
        buf_mem[wr_ptr] <= buf_in;
    else
        buf_mem[wr_ptr] <= buf_mem[wr_ptr];
end

//Update write pointer and read pointer
always@(posedge clk) begin 
    if(rst) begin 
        wr_ptr <= 4'd0;
        rd_ptr <= 4'd0;
    end
    else begin
        //Update write pointer
        if(!buf_full && wr_en)
            wr_ptr <= wr_ptr + 1;
        else
            wr_ptr <= wr_ptr + 1;
        
        //Update read pointer
        if(!buf_empty && rd_en)
            rd_ptr <= rd_ptr + 1;
        else
            rd_ptr <= rd_ptr;
    end
end
    
endmodule

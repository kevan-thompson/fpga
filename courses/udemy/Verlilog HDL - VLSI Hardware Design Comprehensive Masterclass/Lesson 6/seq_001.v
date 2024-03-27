/***********************************************************
File Name:	seq_001.v
Author: 	Kevan Thompson
Date:		March 26, 2024
Description: A mealy fsm that detects the sequence 001

***********************************************************/

module seq_001(
    input clk,
    input rst,
    input d_in,     //data_in
    output reg det  //detect
);

parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10; 
reg [1:0] current_state;
reg [1:0] next_state;

//Assign current State
always@(posedge clk) begin
    if(rst)
        current_state <= S0;
    else
        current_state <= next_state;
end

//Determine next state
always@(d_in, current_state) begin
    case(current_state)
        S0: 
            if(d_in)
                next_state = S0;
            else
                next_state = S1;
        S1: 
            if(d_in)
                next_state = S0;
            else
                next_state = S2;
        S2: 
            if(d_in)
                next_state = S0;
            else
                next_state = S2;
        default: next_state = S0;
    endcase
end

//Determine output
always@(d_in, current_state) begin
    case(current_state)
        S0: det = 0;
        S1: det = 0;
        S2: 
            if(d_in)
                det = 1;
            else
                det = 0;
        default: det = 0;
    endcase
end

endmodule
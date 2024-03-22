/***********************************************************
File Name:	ALU.v
Author: 	Kevan Thompson
Date:		March 21, 2024
Description: A very bad 4 bit ALU

***********************************************************/

module ALU(
    input [3:0] a,
    input [3:0] b,
    input [3:0] opcode,
    output reg [3:0] x,
    output reg [3:0] y
);

//I'm pretty sure this will infer latches
//I think the instructor was either being lazy
//or just saving time. 
//TODO: fix later
always@(*) begin
        case(opcode)
            4'b0000:x[0] = |a; //x[0] = OR of a
            4'b0001:x[0] = &a; //x[0] = AND of a
            4'b0010:x[0] = ^a; //x[0] = xor of a
            4'b0011:x = a&b; //x = a and b
            4'b0100:x = a|b; //x = a or b
            4'b0101:x = a^b; //x = a xor b
            4'b0110:x[0] = a>b; //x[0] = a greater than b
            4'b0111:x[0] = a<b; //x[0] = a less than b
            4'b1000:x[0] = a==b; //x = a equals b  
            4'b1001:x[0] = !a; //x = not a (logical)
            4'b1010:{y[0],x} = a+b; //y,x = a plus b
            4'b1011:{y[0],x} = a-b; //y,x = a minus b
            4'b1100:{y,x} = a*b; // y,x = a muliplied by b
            4'b1101:{y,x} = a<<b; //x = a left shit b
            4'b1110:{y,x} = a>>b; //x = a right shift b
            4'b1111:x = ~a; //x = not a
            default: $display("Error");
        endcase
    end
endmodule    
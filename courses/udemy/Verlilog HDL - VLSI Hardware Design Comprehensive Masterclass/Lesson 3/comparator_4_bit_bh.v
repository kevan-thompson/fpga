/***********************************************************
File Name:	comparator_4_bit_bh.v
Author: 	Kevan Thompson
Date:		March 20, 2024
Description: A 4 bit comparator

***********************************************************/

module comparator_4_bit_bh(
    input [3:0] A,
    input [3:0] B,
    output reg Eq,  //Equal
    output reg Gt,  //Greater Than  
    output reg Lt   //Less than
);    

always@(*) begin
    //A equal B    
    Eq = (A==B); //And all bits of A xnor B
    //A Greater than B
    Gt = (A>B);
    //A less than B            
    Lt = (A<B);            
end

endmodule
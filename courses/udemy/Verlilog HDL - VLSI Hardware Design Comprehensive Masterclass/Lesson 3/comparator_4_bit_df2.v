/***********************************************************
File Name:	comparator_4_bit_df2.v
Author: 	Kevan Thompson
Date:		March 20, 2024
Description: A 4 bit comparator

***********************************************************/

module comparator_4_bit_df2(
    input [3:0] A,
    input [3:0] B,
    output Eq,  //Equal
    output Gt,  //Greater Than  
    output Lt   //Less than
);    

//A equal B    
assign Eq = (A==B); //And all bits of A xnor B

//A Greater than B
assign Gt = (A>B);

//A less than B            
assign Lt = (A<B);            

endmodule
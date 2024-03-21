/***********************************************************
File Name:	comparator_4_bit_df1.v
Author: 	Kevan Thompson
Date:		March 20, 2024
Description: A 4 bit comparator

***********************************************************/

module comparator_4_bit_df1(
    input [3:0] A,
    input [3:0] B,
    output Eq,  //Equal
    output Gt,  //Greater Than  
    output Lt   //Less than
);    

//A equal B    
assign Eq = &(A~^B); //And all bits of A xnor B

//A Greater than B
assign Gt = (A[3] & ~B[3]) | ((A[3]~^B[3]) & (A[2]&~B[2])) | 
            ((A[3]~^B[3])&(A[2]~^B[2])&(A[1]&~B[1])) | 
            ((A[3]~^B[3])&(A[2]~^B[2])&(A[1]~^B[1])&(A[0]&~B[0]));

//A less than B            
assign Lt = ~(Gt|Eq);            

endmodule
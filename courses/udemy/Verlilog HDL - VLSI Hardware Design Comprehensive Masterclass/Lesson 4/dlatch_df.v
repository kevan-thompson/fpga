/***********************************************************
File Name:	dlatch_df.v
Author: 	Kevan Thompson
Date:		March 21, 2024
Description: A simple d-latch

***********************************************************/
module dlatch_df(
    input en,
    input d,
    output q
);

assign q = en?d:q;

endmodule
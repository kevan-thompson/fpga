-------------------------------------------------------------------------------------
--File Name:    full_adder.vhd
--Author:       Kevan Thompson 
--Date:         June 18, 2025
--Description:  This is a an implementation of a full
--              adder. Adds A, B, C_in. Outputs S and C_out
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    port (
        --Inputs
        A           : in std_logic;
        B           : in std_logic;
        C_IN        : in std_logic;
        --OUTPUTS
        S           : out std_logic;
        C_OUT       : out std_logic
    );
end full_adder;

architecture rtl of full_adder is
begin

    S <= A xor B xor C_IN;
    C_OUT <= (A and B) or (C_IN and (A xor B));

end rtl;
-------------------------------------------------------------------------------------
--File Name:    gates.vhd
--Author:       Kevan Thompson 
--Date:         June 18, 2025
--Description:  This is a shows a basic implemtation of 
--              each basic logic gate. (Not, AND, OR, XOR, 
--              NAND, NOR, XNOR)
-------------------------------------------------------------------------------------

--VHDL Library for STD Logic
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--The entity describes the interface to the system. It 
--is similar to a function prototype in C or a class 
--definition in C++. It defines all the inputs and outputs
--and paramaters (generics). 
entity gates is
    --The port describes all the inputs and outputs of the entity
    port (
        --Inputs
        a       : in std_logic;
        b       : in std_logic;
        --OUTPUTS
        not_a       : out std_logic;
        not_b       : out std_logic;
        a_and_b     : out std_logic;
        a_nand_b    : out std_logic;
        a_or_b      : out std_logic;
        a_nor_b     : out std_logic;
        a_xor_b     : out std_logic;
        a_xnor_b    : out std_logic --Note no ; on the last port
    );
end gates;

--The architecture is the implementation of the entity. 
--An architecture can be given any name, but by convention 
--we often use: rtl, behavioral, structural, dataflow, test
--RTL: Register Transfer Level implementation
--Behavioral: a behavioral or algorithmic implementaiton
--Structural: an entity composed of interconnected components
--Test: a simulation testbench

architecture rtl of gates is
begin

    --Inverters
    not_a <= not a;
    not_b <= not b;
    --And Gate
    a_and_b <= a and b;
    --Nand Gate 
    a_nand_b <= a nand b;
    --OR Gate
    a_or_b <= a or b;
    --NOR Gate 
    a_nor_b <= a nor b;
    --Exclusive Or Gate
    a_xor_b <= a xor b;
    --Exclusive NOR Gate 
    a_xnor_b <= a xnor b;

end rtl;
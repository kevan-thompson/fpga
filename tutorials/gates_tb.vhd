-------------------------------------------------------------------------------------
--File Name:    gates.vhd
--Author:       Kevan Thompson 
--Date:         June 18, 2025
--Description:  Basic testbench for gates.vhd
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity gates_tb is
        --No Inputs or outputs for testbenches. They are
        --not sythesizable, and are for simulation only
end gates_tb;

architecture test of gates_tb is

-----------------------------------------------------------
--COMPONENTS
-----------------------------------------------------------
 
component gates is
    --The port describes all the inputs and outputs of the entity
    port (
        a           : in std_logic;
        b           : in std_logic;
        not_a       : out std_logic;
        not_b       : out std_logic;
        a_and_b     : out std_logic;
        a_nand_b    : out std_logic;
        a_or_b      : out std_logic;
        a_nor_b     : out std_logic;
        a_xor_b     : out std_logic;
        a_xnor_b    : out std_logic
    );
end component;

-----------------------------------------------------------
--SIGNALS
-----------------------------------------------------------

signal reset    :   std_logic;
signal a        :   std_logic;
signal b        :   std_logic;
signal not_a    :   std_logic;
signal not_b    :   std_logic;
signal a_and_b  :   std_logic;
signal a_nand_b :   std_logic;
signal a_or_b   :   std_logic;
signal a_nor_b  :   std_logic;
signal a_xor_b  :   std_logic;
signal a_xnor_b :   std_logic;

begin

--Instantiate Unit Under Test
UUT: gates port map (
        a => a,
        b => b,
        not_a => not_a,      
        not_b => not_b,     
        a_and_b => a_and_b,     
        a_nand_b => a_nand_b,    
        a_or_b => a_or_b,     
        a_nor_b => a_nor_b,   
        a_xor_b => a_xor_b,     
        a_xnor_b => a_xnor_b --note no ,    
    );

reset <= '1', '0' after 5ns;

a <= '0' when reset = '1' else
        not a after 20ns;
        
b <= '0' when reset = '1' else
        not b after 40ns;
        
end test;
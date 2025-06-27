-------------------------------------------------------------------------------------
--File Name:    multiplexers_tb.vhd
--Author:       Kevan Thompson 
--Date:         June 18, 2025
--Description:  Basic testbench for gates.vhd
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexers_tb is

end multiplexers_tb;

architecture test of multiplexers_tb is

-----------------------------------------------------------
--COMPONENTS
-----------------------------------------------------------
 
component multiplexers is
    port (
        --Inputs
        a           : in std_logic;
        b           : in std_logic;
        s           : in std_logic;
        --OUTPUTS
        y_gates     : out std_logic;
        y_when      : out std_logic;
        y_with      : out std_logic;
        y_if        : out std_logic;
        y_case      : out std_logic
    );
end component;

-----------------------------------------------------------
--SIGNALS
-----------------------------------------------------------

signal s        :   std_logic;
signal a        :   std_logic := '0';
signal b        :   std_logic := '0';
signal y_gates  :   std_logic;
signal y_when   :   std_logic;
signal y_with   :   std_logic;
signal y_if     :   std_logic;
signal y_case   :   std_logic;


begin

--Instantiate Unit Under Test
UUT: multiplexers port map (
        a => a,
        b => b,
        s => s,      
        y_gates => y_gates,     
        y_when => y_when,     
        y_with => y_with,    
        y_if => y_if,     
        y_case => y_case
    );

 
a <= not a after 5ns;
        
b <= not b after 8ns;

s <= '0', '1' after 50ns;
        
end test;
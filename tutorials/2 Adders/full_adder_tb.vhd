-------------------------------------------------------------------------------------
--File Name:    full_adder_tb.vhd
--Author:       Kevan Thompson 
--Date:         June 18, 2025
--Description:  Testbench for full adder
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_tb is

end full_adder_tb;

architecture rtl of full_adder_tb is

-----------------------------------------------------------
--COMPONENTS
-----------------------------------------------------------
component full_adder is
    port (
        A           : in std_logic;
        B           : in std_logic;
        C_IN        : in std_logic;
        S           : out std_logic;
        C_OUT       : out std_logic
    );
end component;

-----------------------------------------------------------
--SIGNALS
-----------------------------------------------------------

signal reset    :   std_logic;
signal a        :   std_logic;
signal b        :   std_logic;
signal c_in     :   std_logic;
signal s        :   std_logic;
signal c_out    :   std_logic;

begin

--Instantiate Unit Under Test
UUT: full_adder port map (
        a => a,
        b => b,
        C_IN => c_in,      
        S => s,     
        C_OUT => c_out        
    );

reset <= '1', '0' after 5ns;

a <= '0' when reset = '1' else
        not a after 20ns;
        
b <= '0' when reset = '1' else
        not b after 40ns;    
    
c_in <= '0' when reset = '1' else
        not c_in after 80ns;     
    
end rtl;
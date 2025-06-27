-------------------------------------------------------------------------------------
--File Name:    ripple_carry_adder_tb.vhd
--Author:       Kevan Thompson 
--Date:         June 22, 2025
--Description:  This is a testbench of an 8 bit 
--              ripple carry adder. 
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ripple_carry_adder_tb is

end ripple_carry_adder_tb;

architecture test of ripple_carry_adder_tb is

-----------------------------------------------------------
--COMPONENTS
-----------------------------------------------------------
component ripple_carry_adder is
    port (
        A           : in std_logic_vector(7 downto 0);
        B           : in std_logic_vector(7 downto 0);
        C_IN        : in std_logic;
        S           : out std_logic_vector(7 downto 0);
        C_OUT       : out std_logic
    );
end component;

-----------------------------------------------------------
--SIGNALS
-----------------------------------------------------------

signal a            : std_logic_vector(7 downto 0);
signal b            : std_logic_vector(7 downto 0);
signal c_in         : std_logic;
signal s            : std_logic_vector(7 downto 0);
signal c_out        : std_logic;

begin

UUT: ripple_carry_adder port map (
        a => a,
        b => b,
        C_IN => c_in,      
        S => s,     
        C_OUT => c_out        
    );

main_sim_process: process

variable loop_a : integer := 0;    
variable loop_b : integer := 0;
variable loop_c : integer := 0;

begin

    a <= (others => '0');
    b <= (others => '0');
    c_in <= '0';
    
    for loop_c in 0 to 1 loop
        if(loop_c = 0) then 
            c_in <= '0';
        else 
            c_in <= '1';
        end if;
            for loop_b in 0 to 255 loop
                b <= std_logic_vector(to_unsigned(loop_b, b'length));
                    for loop_a in 0 to 255 loop
                        a <= std_logic_vector(to_unsigned(loop_a, a'length));
                        wait for 1 ns;
                    end loop;
                wait for 1 ns;
            end loop;
        wait for 1 ns;
    end loop;
    wait;
end process main_sim_process;
end test;
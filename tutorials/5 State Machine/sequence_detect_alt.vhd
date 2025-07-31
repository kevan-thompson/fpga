-------------------------------------------------------------------------------------
--File Name:    sequence_detect_alt.vhd
--Author:       Kevan Thompson 
--Date:         July 30, 2025
--Description:  This is shift register to detect the sequence 
--              110. It has a synchronous reset
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity sequence_detect_alt is
    port (
        --clk and reset
        clk     : in std_logic;
        rst     : in std_logic;        
        --Inputs
        x       : in std_logic;
        load    : in std_logic;
        pattern : in std_logic_vector(2 downto 0);
        --OUTPUTS
        y       : out std_logic
    );
end sequence_detect_alt;

architecture rtl of sequence_detect_alt is
  
signal shift_reg    : std_logic_vector(2 downto 0);
signal pattern_reg  : std_logic_vector(2 downto 0);

begin

    y <= '1' when shift_reg = pattern_reg else '0';

    S_REG: process(clk) 
    begin        
        if(rising_edge(clk)) then   
            if(rst = '1') then
                shift_reg <= (others => '0');
            else 
                shift_reg(0) <= x;
                shift_reg(1) <= shift_reg(0);
                shift_reg(2) <= shift_reg(1);
            end if;
        else
            shift_reg <= shift_reg;
        end if;
    end process S_REG;

    P_REG: process(clk) 
    begin        
        if(rising_edge(clk)) then   
            if(rst = '1') then
                pattern_reg <= (others => '0');
            else 
                if(load = '1') then
                    pattern_reg <= pattern;
                else
                    pattern_reg <= pattern_reg;
                end if;
            end if;
        else
            pattern_reg <= pattern_reg;
        end if;
    end process P_REG;
 
end rtl;
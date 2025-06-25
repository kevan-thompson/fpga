-------------------------------------------------------------------------------------
--File Name:    multiplexers.vhd
--Author:       Kevan Thompson 
--Date:         June 18, 2025
--Description:  This is a shows a basic implemtation of 
--              each basic logic gate. (Not, AND, OR, XOR, 
--              NAND, NOR, XNOR)
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity multiplexers is
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
end multiplexers;

architecture rtl of multiplexers is
begin

    y_gates <= (a and (not s)) or (b and s);

    --When/Else
    y_when <= a when s = '0' else b; 
    
    --With/Select
    --with/select only support equality condition
    --unlike the when/else which support a variety of 
    -- boolean expressions. (equal, greater, less than etc)
    with s select y_with <= 
            a when '0',
            b when others; --default condition

    if_process: process(a,b)
    begin
        if(s = '0') then
            y_if <= a;
        else 
            y_if <= b;
        end if;
    end process if_process;
    
    case_process: process(a,b) 
    begin
        case s is
            when '0' => y_case <= a;
            when others => y_case <=b;
        end case;
    end process case_process;    
        
end rtl;
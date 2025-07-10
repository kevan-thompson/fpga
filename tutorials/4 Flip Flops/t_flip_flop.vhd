-------------------------------------------------------------------------------------
--File Name:    T_flip_flop.vhd
--Author:       Kevan Thompson 
--Date:         June 26, 2025
--Description:  This is a T Flip Flop with a 
--              synchronous reset
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity t_flip_flop is
    port (
        --clk and reset
        clk     : in std_logic;
        rst     : in std_logic;        
        --Inputs
        t       : in std_logic;
        --OUTPUTS
        q       : out std_logic
    );
end t_flip_flop;

architecture rtl of t_flip_flop is
 
signal q_s      : std_logic;

begin

    q <= q_s;

    TFF: process(clk) 
    begin      
        if(rising_edge(clk)) then    
            if(rst = '1') then
                q_s <= '0';
            else
                if(t = '1') then
                    q_s <= not q_s;
                else
                    q_s <= q_s;
                end if;
            end if;
        else
            q_s <= q_s;
        end if;
    end process TFF;

end rtl;
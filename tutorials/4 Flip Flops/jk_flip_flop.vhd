-------------------------------------------------------------------------------------
--File Name:    jk_flip_flop.vhd
--Author:       Kevan Thompson 
--Date:         June 26, 2025
--Description:  This is a JK Flip Flop with a 
--              synchronous reset
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity jk_flip_flop is
    port (
        --clk and reset
        clk     : in std_logic;
        rst     : in std_logic;        
        --Inputs
        j       : in std_logic;
        k       : in std_logic;
        --OUTPUTS
        q       : out std_logic
    );
end jk_flip_flop;

architecture rtl of jk_flip_flop is
 
signal q_s      : std_logic;

begin

    q <= q_s;

    JKFF: process(clk) 
    begin       
        if(rising_edge(clk)) then   
            if(rst = '1') then
                q_s <= '0';
            else
                if((j = '1') and (k = '1')) then
                    q_s <= not q_s;
                elsif((j = '1') and (k = '0')) then 
                    q_s <= '1';
                elsif((j = '0') and (k = '1')) then
                    q_s <= '0';
                else
                    q_s <= q_s;
                end if;
            end if;
        else
            q_s <= q_s;
        end if;
    end process JKFF;


end rtl;
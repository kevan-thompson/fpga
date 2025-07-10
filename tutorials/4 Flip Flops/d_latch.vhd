-------------------------------------------------------------------------------------
--File Name:    d_latch.vhd
--Author:       Kevan Thompson 
--Date:         June 26, 2025
--Description:  This is a d latch with a 
--              reset

--              REMINDER: Latches are not to be implemented on FPGAs!
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity d_latch is
    port (
        --clk and reset
        en      : in std_logic;
        rst     : in std_logic;        
        --Inputs
        d       : in std_logic;
        --OUTPUTS
        q       : out std_logic
    );
end d_latch;

architecture rtl of d_latch is
 
signal q_s      : std_logic;

begin

    q <= q_s;

    DL: process(en,d) 
    begin      
        if(rst = '1') then
            q_s <= '0';
        else
            if(en = '1') then
                q_s <= d;
            else
                q_s <= q_s;
            end if;
        end if;
    end process DL;

end rtl;
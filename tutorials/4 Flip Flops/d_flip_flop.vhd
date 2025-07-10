-------------------------------------------------------------------------------------
--File Name:    d_flip_flop.vhd
--Author:       Kevan Thompson 
--Date:         June 26, 2025
--Description:  This is a D Flip Flop with a 
--              synchronous reset
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity d_flip_flop is
    port (
        --clk and reset
        clk     : in std_logic;
        rst     : in std_logic;        
        --Inputs
        d       : in std_logic;
        --OUTPUTS
        q       : out std_logic
    );
end d_flip_flop;

architecture rtl of d_flip_flop is

--Intermediate signal...
--Prior to VHDL 2008 an output can't be on the right side
-- of an assignment. You need to use an intermediate signal
-- and then assign the out seperately. If you used VHDL 
-- 2008 this is not needed. But not all tools support 
-- VHDL 2008. (But most do these days)
 
signal q_s      : std_logic;

begin

    q <= q_s;

    DFF: process(clk) 
    begin
        --You can use rising_edge (or falling_edge) or as 
        --an alternative you can use (clk'event) and (clk = '1') 
        --The 'event signifies a change in clk (rising or falling)
        
        --Under no circumstances should you mix rising and
        --falling edges on an FPGA. Pick on and stick with it.
        
        if(rising_edge(clk)) then   
            --This is a synchronous reset. If you 
            --want an asynchonous reset move the reset
            --above the if with the clk. 
            --Synchronous resets are much much better
            --for timing. 
            if(rst = '1') then
                q_s <= '0';
            else 
                q_s <= d;
            end if;
        else
            q_s <= q_s;
        end if;
    end process DFF;


end rtl;
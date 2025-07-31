-------------------------------------------------------------------------------------
--File Name:    sequence_detect.vhd
--Author:       Kevan Thompson 
--Date:         July 30, 2025
--Description:  This is statemachine to detect the sequence 
--              110. It has a synchronous reset
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity sequence_detect is
    port (
        --clk and reset
        clk     : in std_logic;
        rst     : in std_logic;        
        --Inputs
        x       : in std_logic;
        --OUTPUTS
        y       : out std_logic
    );
end sequence_detect;

architecture rtl of sequence_detect is
 
--You can name your states whatever you want. It should 
--match your state diagram. And should where possible
--descibe what is going on. Ie: Initial, Load, Wait, etc

--The type name state is also up to you. It's a best 
--practice to use something descriptive. 
type state is (s0, s1, s2, s3, s4);
signal current_state    : state;
signal next_state       : state;

begin

    --Output logic
    y <= '1' when current_state = s4 else '0';

    --Current State Logic
    CURRENT_S: process(clk) 
    begin        
        if(rising_edge(clk)) then   
            if(rst = '1') then
                current_state <= s0;
            else 
                current_state <= next_state;
            end if;
        else
            current_state <= current_state;
        end if;
    end process CURRENT_S;

    --Next State Logic
    NEXT_S: process(x,current_state)
    begin
        case current_state is
            when s0 => 
                if x = '0' then
                    next_state <= s0;
                else
                    next_state <= s1;    
                end if;
            when s1 => 
                if x = '0' then
                    next_state <= s0;
                else
                    next_state <= s2;    
                end if;
            when s2 => 
                if x = '0' then
                    next_state <= s3;
                else
                    next_state <= s2;    
                end if;
            when s3 => 
                if x = '0' then
                    next_state <= s0;
                else
                    next_state <= s4;    
                end if;
            when s4 => 
                if x = '0' then
                    next_state <= s0;
                else
                    next_state <= s2;    
                end if;
            when others =>
                next_state <= s0;
        end case;
    end process NEXT_S;
end rtl;
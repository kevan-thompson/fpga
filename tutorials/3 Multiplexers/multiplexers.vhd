-------------------------------------------------------------------------------------
--File Name:    multiplexers.vhd
--Author:       Kevan Thompson 
--Date:         June 24, 2025
--Description:  This file shows 5 different implementations
--              of a 2x1 multiplexer
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
    --This is a conditional assignment
    --You MUST cover all conditions or include an else
    --Failure to do so will likely infer a latch! 
    --(Latches are bad on FPGAs!)
    --This is also true for with select, if/else or case
    --see below...
    y_when <= a when s = '0' else b; 
    
    --With/Select
    --with/select only support equality condition
    --unlike the when/else which support a variety of 
    -- boolean expressions. (equal, greater, less than etc)
    with s select y_with <= 
            a when '0',
            b when others; --default condition

    --<label> process: (<sensativity list>)
    -- The sensativity list is a list of all ports, 
    -- and signals that will cause the procss to
    -- "execute" on a change. Generally anything on
    -- the right of an assignment for logic. Or clocks
    -- for anything 
    
    --In VHDL 2008 you can also use process(all)
    
    if_process: process(a,b)
    begin
        --Anything outside of a project is concurrent, but
        --inside a process statements are sequential!
        --But beware the difference between <= and :=
        
        --For each if, you must either cover every case with
        --with an elsif or with an else
        if(s = '0') then
            y_if <= a;
        else 
            y_if <= b;
        end if;
    end process if_process;
    
    case_process: process(a,b) 
    begin
        --for every case you must either cover every case 
        --or include a "when others"
        case s is
            when '0' => y_case <= a;
            when others => y_case <=b; --default case
        end case;
    end process case_process;    
        
end rtl;
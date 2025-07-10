-------------------------------------------------------------------------------------
--File Name:    flip_flops_tb.vhd
--Author:       Kevan Thompson 
--Date:         June 18, 2025
--Description:  Basic testbench for gates.vhd
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity flip_flops_tb is

end flip_flops_tb;

architecture test of flip_flops_tb is

-----------------------------------------------------------
--COMPONENTS
-----------------------------------------------------------
 

component d_flip_flop is
    port (
        --clk and reset
        clk     : in std_logic;
        rst     : in std_logic;        
        --Inputs
        d       : in std_logic;
        --OUTPUTS
        q       : out std_logic
    );
end component;

component jk_flip_flop is
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
end component;

component t_flip_flop is
    port (
        --clk and reset
        clk     : in std_logic;
        rst     : in std_logic;        
        --Inputs
        t       : in std_logic;
        --OUTPUTS
        q       : out std_logic
    );
end component;

component d_latch is
    port (
        --clk and reset
        en     : in std_logic;
        rst     : in std_logic;        
        --Inputs
        d       : in std_logic;
        --OUTPUTS
        q       : out std_logic
    );
end component;

-----------------------------------------------------------
--SIGNALS
-----------------------------------------------------------

signal reset    :   std_logic;
signal clk      :   std_logic := '0';
signal en       :   std_logic := '0';
signal d        :   std_logic := '0';
signal j        :   std_logic := '0';
signal k        :   std_logic := '0';
signal t        :   std_logic := '0';
signal q_d      :   std_logic := '0';
signal q_jk     :   std_logic := '0';
signal q_t      :   std_logic := '0';
signal q_l      :   std_logic := '0';

begin

UUTD: d_flip_flop port map (
        clk => clk,
        rst => reset,       
        d => d,
        q => q_d
    );

UUTJK: jk_flip_flop port map (
        clk => clk,
        rst => reset,        
        k => k,
        j => j,
        q => q_jk
    );

UUTT: t_flip_flop port map (
        clk => clk,
        rst => reset,        
        t => t,
        q => q_t
    );    
 
UUT_L: d_latch port map(
        en => en,
        rst => reset,        
        d => d,
        q => q_l
    ); 

reset <= '1', '0' after 16ns;

clk <= not clk after 5ns;
en <= clk;
--"When/else" is a conditional assignement. We'll cover 
--that in more detail later. 
j <= not j after 20ns;
        
k <= not k after 40ns;

d <= not d after 3ns;

t <= not t after 3ns;        
        
end test;
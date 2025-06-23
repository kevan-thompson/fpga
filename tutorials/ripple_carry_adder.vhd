-------------------------------------------------------------------------------------
--File Name:    ripple_carry_adder.vhd
--Author:       Kevan Thompson 
--Date:         June 22, 2025
--Description:  This is a an implementation of an 8 bit 
--              ripple carry adder. 
--              Adds A, B, C_in. Outputs S and C_out
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ripple_carry_adder is
    port (
        --Inputs
                    --An std_logic vector is the multibit 
                    --version of an std_logic. 
                    --You can do logic vectors N downto 0 
                    --or 0 to N. Depending on the endian
                    --you're using. 
        A           : in std_logic_vector(7 downto 0);
        B           : in std_logic_vector(7 downto 0);
        C_IN        : in std_logic;
        --OUTPUTS
        S           : out std_logic_vector(7 downto 0);
        C_OUT       : out std_logic
    );
end ripple_carry_adder;

architecture rtl of ripple_carry_adder is

-----------------------------------------------------------
--COMPONENTS
-----------------------------------------------------------
component full_adder is
    port (
        A           : in std_logic;
        B           : in std_logic;
        C_IN        : in std_logic;
        S           : out std_logic;
        C_OUT       : out std_logic
    );
end component;

-----------------------------------------------------------
--SIGNALS
-----------------------------------------------------------

--Connects carry out of one full adder to carry in of next 
--full adder
signal carry_s      : std_logic_vector(6 downto 0);

begin

--Instantiate Full Adders
--This is how you can instantiate a component. This allows 
--you to reuse code from exisiting VHDL files. 

-- <label>: <component name> port map(
--      <component port name> => <signal name or port name>,
--          ...
--     <component port name> => <signal name or port name>
-- ); 
FA0: full_adder port map (
        A => A(0), --You can use () to index a single bit in a vector
                   -- or you can use (n downto m) or (m to n) to access multiple bits
        B => B(0),
        C_IN => C_IN,      
        S => S(0),     
        C_OUT => carry_s(0) --note no ,        
    );

FA1: full_adder port map (
        A => A(1),
        B => B(1),
        C_IN => carry_s(0),      
        S => S(1),     
        C_OUT => carry_s(1)        
    );

FA2: full_adder port map (
        A => A(2),
        B => B(2),
        C_IN => carry_s(1),      
        S => S(2),     
        C_OUT => carry_s(2)        
    );

FA3: full_adder port map (
        A => A(3),
        B => B(3),
        C_IN => carry_s(2),      
        S => S(3),     
        C_OUT => carry_s(3)        
    );

FA4: full_adder port map (
        A => A(4),
        B => B(4),
        C_IN => carry_s(3),      
        S => S(4),     
        C_OUT => carry_s(4)        
    );

FA5: full_adder port map (
        A => A(5),
        B => B(5),
        C_IN => carry_s(4),      
        S => S(5),     
        C_OUT => carry_s(5)        
    );

FA6: full_adder port map (
        A => A(6),
        B => B(6),
        C_IN => carry_s(5),      
        S => S(6),     
        C_OUT => carry_s(6)        
    );

FA7: full_adder port map (
        A => A(7),
        B => B(7),
        C_IN => carry_s(6),      
        S => S(7),     
        C_OUT => C_OUT        
    );
    
end rtl;
-------------------------------------------------------------------------------------
--File Name:    reflector.vhd
--Author:       Kevan Thompson 
--Date:         April 5, 2022
--Description: This decoder will decode a 5 bit binary form of the output to a 
--              26 bit one hot output. This is intended to replicate the lamps
--              on an enigma machine. The default generics are for reflector A
-------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY reflector IS
    GENERIC ( 
		rf0 	: STD_LOGIC_VECTOR := "00101"; --E
		rf1 	: STD_LOGIC_VECTOR := "01010"; --J
		rf2		: STD_LOGIC_VECTOR := "01101"; --M
		rf3		: STD_LOGIC_VECTOR := "11010"; --Z
		rf4		: STD_LOGIC_VECTOR := "00001"; --A
		rf5		: STD_LOGIC_VECTOR := "01100"; --L
		rf6		: STD_LOGIC_VECTOR := "11001"; --Y
		rf7		: STD_LOGIC_VECTOR := "11000"; --X
		rf8		: STD_LOGIC_VECTOR := "10110"; --V
		rf9		: STD_LOGIC_VECTOR := "00010"; --B
		rf10	: STD_LOGIC_VECTOR := "10111"; --W
		rf11	: STD_LOGIC_VECTOR := "00110"; --F
		rf12	: STD_LOGIC_VECTOR := "00011"; --C
		rf13	: STD_LOGIC_VECTOR := "10010"; --R
		rf14	: STD_LOGIC_VECTOR := "10001"; --Q
		rf15	: STD_LOGIC_VECTOR := "10101"; --U
		rf16	: STD_LOGIC_VECTOR := "01111"; --O
		rf17	: STD_LOGIC_VECTOR := "01110"; --N 
		rf18	: STD_LOGIC_VECTOR := "10100"; --T
		rf19	: STD_LOGIC_VECTOR := "10011"; --S
		rf20	: STD_LOGIC_VECTOR := "10000"; --P
		rf21	: STD_LOGIC_VECTOR := "01001"; --I
		rf22	: STD_LOGIC_VECTOR := "01011"; --K
		rf23	: STD_LOGIC_VECTOR := "01000"; --H
		rf24	: STD_LOGIC_VECTOR := "00111"; --G
		rf25	: STD_LOGIC_VECTOR := "00100" --D
		);
	PORT (
		--INPUTS
		encoded_ip	: IN	STD_LOGIC_VECTOR(4 downto 0);
		--Outputs
        encoded_op  : OUT   STD_LOGIC_VECTOR(4 downto 0)
		
);
END reflector;

ARCHITECTURE Behavioral OF reflector IS	

---------------------------------------------------------------------
--SIGNALS
---------------------------------------------------------------------

SIGNAL key_concat	: STD_LOGIC_VECTOR(27 downto 0);

-------------------------------------------------------------------------------
--BEGIN
-------------------------------------------------------------------------------

BEGIN

PROCESS ( encoded_ip ) 
	BEGIN			  
		CASE encoded_ip IS
			WHEN "00000" =>
				encoded_op <= "00000"; --No button pressed
			WHEN "00001" =>
				encoded_op <= rf0; 
			WHEN "00010" =>
				encoded_op <= rf1;
			WHEN "00011" => 
				encoded_op <=rf2;
			WHEN "00100" =>
				encoded_op <= rf3;
			WHEN "00101" =>
				encoded_op <= rf4;
			WHEN "00110" =>
				encoded_op <= rf5;
			WHEN "00111" =>
				encoded_op <= rf6;
			WHEN "01000" =>
				encoded_op <= rf7;
			WHEN "01001" =>
				encoded_op <= rf8;
			WHEN "01010" =>
				encoded_op <= rf9;
			WHEN "01011" =>
				encoded_op <= rf10;
			WHEN "01100" =>
				encoded_op <= rf11;
			WHEN "01101" =>
				encoded_op <= rf12;
			WHEN "01110" =>
				encoded_op <= rf13;
			WHEN "01111" =>
				encoded_op <= rf14;
			WHEN "10000" =>
				encoded_op <= rf15;
			WHEN "10001" =>
				encoded_op <= rf16;
			WHEN "10010" =>
				encoded_op <= rf17;
			WHEN "10011" =>
				encoded_op <= rf18;
			WHEN "10100" =>
				encoded_op <= rf19;
			WHEN "10101" =>
				encoded_op <= rf20;
			WHEN "10110" =>
				encoded_op <= rf21;
			WHEN "10111" =>
				encoded_op <= rf22;
			WHEN "11000" =>
				encoded_op <= rf23;
			WHEN "11001" =>
				encoded_op <= rf24;
			WHEN "11010"  =>
				encoded_op <= rf25;
			WHEN others =>
				encoded_op <= "00000";
		END CASE; 
END PROCESS;

END Behavioral;
-------------------------------------------------------------------------------------
--
--
--
-------------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY rotor_mux IS
	PORT (                                       
		-- Inputs to Mux
		mux_in1		: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in2		: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in3		: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in4		: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in5		: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in6		: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in7		: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in8		: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in9		: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in10	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in11	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in12	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in13	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in14	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in15	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in16	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in17	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in18	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in19	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in20	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in21	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in22	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in23	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in24	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in25	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		mux_in26	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		--Mux Select
		mux_select	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		
		-- Outputs of Mux
		mux_out		: OUT	STD_LOGIC_VECTOR (4 DOWNTO 0)
	);
END rotor_mux;
	
ARCHITECTURE Behavioral OF rotor_mux IS	
	
BEGIN

	mux_out <= mux_in1 WHEN (mux_select = "00001") ELSE
				mux_in2 WHEN (mux_select = "00010") ELSE
				mux_in3 WHEN (mux_select = "00011") ELSE
				mux_in4 WHEN (mux_select = "00100") ELSE
				mux_in5 WHEN (mux_select = "00101") ELSE
				mux_in6 WHEN (mux_select = "00110") ELSE
				mux_in7 WHEN (mux_select = "00111") ELSE
				mux_in8 WHEN (mux_select = "01000") ELSE
				mux_in9 WHEN (mux_select = "01001") ELSE
				mux_in10 WHEN (mux_select = "01010") ELSE
				mux_in11 WHEN (mux_select = "01011") ELSE
				mux_in12 WHEN (mux_select = "01100") ELSE
				mux_in13 WHEN (mux_select = "01101") ELSE
				mux_in14 WHEN (mux_select = "01110") ELSE
				mux_in15 WHEN (mux_select = "01111") ELSE
				mux_in16 WHEN (mux_select = "10000") ELSE
				mux_in17 WHEN (mux_select = "10001") ELSE
				mux_in18 WHEN (mux_select = "10010") ELSE
				mux_in19 WHEN (mux_select = "10011") ELSE
				mux_in20 WHEN (mux_select = "10100") ELSE
				mux_in21 WHEN (mux_select = "10101") ELSE
				mux_in22 WHEN (mux_select = "10110") ELSE
				mux_in23 WHEN (mux_select = "10111") ELSE
				mux_in24 WHEN (mux_select = "11000") ELSE
				mux_in25 WHEN (mux_select = "11001") ELSE
				mux_in26 WHEN (mux_select = "11010") ELSE
				"00000";
	
END Behavioral;
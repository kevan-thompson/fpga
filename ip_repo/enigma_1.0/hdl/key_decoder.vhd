-------------------------------------------------------------------------------------
--File Name:    rotor-shift_reg.vhd
--Author:       Kevan Thompson 
--Date:         April 5, 2022
--Description: This decoder will decode a 5 bit binary form of the output to a 
--              26 bit one hot output. This is intended to replicate the lamps
--              on an enigma machine. 
-------------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY key_decoder IS
	PORT (
		--INPUTS
		encoded_ip	: IN	STD_LOGIC_VECTOR(4 downto 0);
		--Outputs
		a_out		: OUT	STD_LOGIC;
		b_out		: OUT	STD_LOGIC;
		c_out		: OUT	STD_LOGIC;
		d_out		: OUT	STD_LOGIC;
		e_out		: OUT	STD_LOGIC;
		f_out		: OUT	STD_LOGIC;
		g_out		: OUT	STD_LOGIC;
		h_out		: OUT	STD_LOGIC;
		i_out		: OUT	STD_LOGIC;
		j_out		: OUT	STD_LOGIC;
		k_out		: OUT	STD_LOGIC;
		l_out		: OUT	STD_LOGIC;
		m_out		: OUT	STD_LOGIC;
		n_out		: OUT	STD_LOGIC;
		o_out		: OUT	STD_LOGIC;
		p_out		: OUT	STD_LOGIC;
		q_out		: OUT	STD_LOGIC;
		r_out		: OUT	STD_LOGIC;
		s_out		: OUT	STD_LOGIC;
		t_out		: OUT	STD_LOGIC;
		u_out		: OUT	STD_LOGIC;
		v_out		: OUT	STD_LOGIC;
		w_out		: OUT	STD_LOGIC;
		x_out		: OUT	STD_LOGIC;
		y_out		: OUT	STD_LOGIC;
		z_out		: OUT	STD_LOGIC
		
);
END key_decoder;

ARCHITECTURE Behavioral OF key_decoder IS	

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
				key_concat <= x"0000000"; --No button pressed
			WHEN "00001" =>
				key_concat <= x"0000001"; --A
			WHEN "00010" =>
				key_concat <= x"0000002"; --B
			WHEN "00011" => 
				key_concat <= x"0000004"; --C
			WHEN "00100" =>
				key_concat <= x"0000008"; --D
			WHEN "00101" =>
				key_concat <= x"0000010"; --E
			WHEN "00110" =>
				key_concat <= x"0000020"; --F
			WHEN "00111" =>
				key_concat <= x"0000040"; --G
			WHEN "01000" =>
				key_concat <= x"0000080"; --H
			WHEN "01001" =>
				key_concat <= x"0000100"; --I
			WHEN "01010" =>
				key_concat <= x"0000200"; --J
			WHEN "01011" =>
				key_concat <= x"0000400"; --K
			WHEN "01100" =>
				key_concat <= x"0000800"; --L
			WHEN "01101" =>
				key_concat <= x"0001000"; --M
			WHEN "01110" =>
				key_concat <= x"0002000"; --N
			WHEN "01111" =>
				key_concat <= x"0004000"; --O
			WHEN "10000" =>
				key_concat <= x"0008000"; --P
			WHEN "10001" =>
				key_concat <= x"0010000"; --Q
			WHEN "10010" =>
				key_concat <= x"0020000"; --R
			WHEN "10011" =>
				key_concat <= x"0040000"; --S
			WHEN "10100" =>
				key_concat <= x"0080000"; --T
			WHEN "10101" =>
				key_concat <= x"0100000"; --U
			WHEN "10110" =>
				key_concat <= x"0200000"; --V
			WHEN "10111" =>
				key_concat <= x"0400000"; --W
			WHEN "11000" =>
				key_concat <= x"0800000"; --X
			WHEN "11001" =>
				key_concat <= x"1000000"; --Y
			WHEN "11010"  =>
				key_concat <= x"2000000"; --Z
			WHEN others =>
				key_concat <= x"0000000";
		END CASE; 
END PROCESS;

a_out <= key_concat(0);
b_out <= key_concat(1);
c_out <= key_concat(2);
d_out <= key_concat(3);
e_out <= key_concat(4);
f_out <= key_concat(5);
g_out <= key_concat(6);
h_out <= key_concat(7);
i_out <= key_concat(8);
j_out <= key_concat(9);
k_out <= key_concat(10);
l_out <= key_concat(11);
m_out <= key_concat(12);
n_out <= key_concat(13);
o_out <= key_concat(14);
p_out <= key_concat(15);
q_out <= key_concat(16);
r_out <= key_concat(17);
s_out <= key_concat(18);
t_out <= key_concat(19);
u_out <= key_concat(20);
v_out <= key_concat(21);
w_out <= key_concat(22);
x_out <= key_concat(23);
y_out <= key_concat(24);
z_out <= key_concat(25);

END Behavioral;
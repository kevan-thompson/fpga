-------------------------------------------------------------------------------------
--
--
--
-------------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY key_encoder IS
	PORT (
		--INPUTS
		a_in		: IN	STD_LOGIC;
		b_in		: IN	STD_LOGIC;
		c_in		: IN	STD_LOGIC;
		d_in		: IN	STD_LOGIC;
		e_in		: IN	STD_LOGIC;
		f_in		: IN	STD_LOGIC;
		g_in		: IN	STD_LOGIC;
		h_in		: IN	STD_LOGIC;
		i_in		: IN	STD_LOGIC;
		j_in		: IN	STD_LOGIC;
		k_in		: IN	STD_LOGIC;
		l_in		: IN	STD_LOGIC;
		m_in		: IN	STD_LOGIC;
		n_in		: IN	STD_LOGIC;
		o_in		: IN	STD_LOGIC;
		p_in		: IN	STD_LOGIC;
		q_in		: IN	STD_LOGIC;
		r_in		: IN	STD_LOGIC;
		s_in		: IN	STD_LOGIC;
		t_in		: IN	STD_LOGIC;
		u_in		: IN	STD_LOGIC;
		v_in		: IN	STD_LOGIC;
		w_in		: IN	STD_LOGIC;
		x_in		: IN	STD_LOGIC;
		y_in		: IN	STD_LOGIC;
		z_in		: IN	STD_LOGIC;
		encoded_op	: OUT	STD_LOGIC_VECTOR(4 downto 0)
);
END key_encoder;

ARCHITECTURE Behavioral OF key_encoder IS	

---------------------------------------------------------------------
--SIGNALS
---------------------------------------------------------------------

SIGNAL key_concat	: STD_LOGIC_VECTOR(27 downto 0);

BEGIN

key_concat <= "00" & z_in & y_in & x_in & w_in & v_in & u_in & t_in & s_in & r_in
			  & q_in & p_in & o_in & n_in & m_in & l_in & k_in & j_in & i_in
			  & h_in & g_in & f_in & e_in & d_in & c_in& b_in & a_in; 
			  
PROCESS ( key_concat ) 
	BEGIN			  
		CASE key_concat IS
			WHEN x"0000000" =>
				encoded_op <= "00000"; --No button pressed
			WHEN x"0000001" =>
				encoded_op <= "00001"; --A
			WHEN x"0000002" =>
				encoded_op <= "00010"; --B
			WHEN x"0000004" => 
				encoded_op <= "00011"; --C
			WHEN x"0000008" =>
				encoded_op <= "00100"; --D
			WHEN x"0000010" =>
				encoded_op <= "00101"; --E
			WHEN x"0000020" =>
				encoded_op <= "00110"; --F
			WHEN x"0000040" =>
				encoded_op <= "00111"; --G
			WHEN x"0000080" =>
				encoded_op <= "01000"; --H
			WHEN x"0000100" =>
				encoded_op <= "01001"; --I
			WHEN x"0000200" =>
				encoded_op <= "01010"; --J
			WHEN x"0000400" =>
				encoded_op <= "01011"; --K
			WHEN x"0000800" =>
				encoded_op <= "01100"; --L
			WHEN x"0001000" =>
				encoded_op <= "01101"; --M
			WHEN x"0002000" =>
				encoded_op <= "01110"; --N
			WHEN x"0004000" =>
				encoded_op <= "01111"; --O
			WHEN x"0008000" =>
				encoded_op <= "10000"; --P
			WHEN x"0010000" =>
				encoded_op <= "10001"; --Q
			WHEN x"0020000" =>
				encoded_op <= "10010"; --R
			WHEN x"0040000" =>
				encoded_op <= "10011"; --S
			WHEN x"0080000" =>
				encoded_op <= "10100"; --T
			WHEN x"0100000" =>
				encoded_op <= "10101"; --U
			WHEN x"0200000" =>
				encoded_op <= "10110"; --V
			WHEN x"0400000" =>
				encoded_op <= "10111"; --W
			WHEN x"0800000" =>
				encoded_op <= "11000"; --X
			WHEN x"1000000" =>
				encoded_op <= "11001"; --Y
			WHEN x"2000000" =>
				encoded_op <= "11010"; --Z
			WHEN others =>
				encoded_op <= "00000";
		END CASE; 
END PROCESS;
END Behavioral;
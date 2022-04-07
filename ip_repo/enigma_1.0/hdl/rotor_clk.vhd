-------------------------------------------------------------------------------------
--File Name:    rotor_clk.vhd
--Author:       Kevan Thompson 
--Date:         April 5, 2022
--Descrption:   This is generated the clock for the first rotor. This clock is 
--              1 every time a button is pressed, and returns to 0 when the 
--              button is released
-------------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY rotor_clk IS
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
		clk_out		: OUT	STD_LOGIC
);
END rotor_clk;

ARCHITECTURE Behavioral OF rotor_clk IS

BEGIN

clk_out <= z_in OR y_in OR x_in OR w_in OR v_in OR u_in OR t_in OR s_in OR r_in
			OR q_in OR p_in OR o_in OR n_in OR m_in OR l_in OR k_in OR j_in OR 
			i_in OR h_in OR g_in OR f_in OR e_in OR d_in OR c_in OR b_in OR a_in; 

END Behavioral;
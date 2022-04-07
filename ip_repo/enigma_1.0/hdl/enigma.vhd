-------------------------------------------------------------------------------------
--File Name:    enigma.vhd
--Author:       Kevan Thompson 
--Date:         April 5, 2022
--Description:  This is a model of a4 rotor eigma machine from WW2. Generics can be  
--              used to select the rotor order at compile time. There are 26 inputs
--              and 26 outputs. Each input corresponds to a letter of the alphabet.
--              This is analogous to input keys on an enigma machine. The outputs
--              are analogous to the lights on an enigma machine one for each letter
--              of the alphabet. It's assumed that only 1 key is pressed at a time. 
-------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY enigma IS
	GENERIC (
	    --Selects which type of rotor is used
	    --Valid values are 1-8 
		rotor1_type       : integer := 1;
		rotor2_type       : integer := 2;
		rotor3_type       : integer := 3;
		rotor4_type       : integer := 4;
		reflector_type    : integer := 1
		);
	PORT (
		--INPUTS
		--These inputs represent the 26 keys (A to Z) on an enigma keyboard
		--It's assumed that only 1 key is pressed at a time
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
		--OUTPUTS
		--These outputs represent the lights for each letter (A to Z) 
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
END enigma;

ARCHITECTURE Behavioral OF enigma IS	

-------------------------------------------------------------------------------------
--Components
-------------------------------------------------------------------------------------

COMPONENT rotor_clk IS
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
END COMPONENT;

COMPONENT key_encoder IS
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
END COMPONENT;

component rotor IS
	GENERIC ( 
        rotor_type : integer := 1
		);
	PORT ( 
		clk			: IN	STD_LOGIC;
		key_in		: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		clk_out		: OUT 	STD_LOGIC;
		key_out		: OUT	STD_LOGIC_VECTOR (4 DOWNTO 0)
	);
END COMPONENT;

COMPONENT key_decoder IS
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
END COMPONENT;

COMPONENT reflector IS
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
END COMPONENT;

-------------------------------------------------------------------------------------
--Signals
-------------------------------------------------------------------------------------
--Rotor Clocks
signal rotor1_clk	        : STD_LOGIC; --Pulses every key press
signal rotor2_clk	        : STD_LOGIC; --Pulses every 26 key presses 
signal rotor3_clk	        : STD_LOGIC; --Pulses ever 26^2 key presses
signal rotor4_clk	        : STD_LOGIC; --Pulses ever 26^3 key presses
signal rotor5_clk	        : STD_LOGIC; --Not used. Remove later
--Encodes keys from 1 hot to binary 
signal encoded_op	        : STD_LOGIC_VECTOR(4 downto 0);
--Ouputs of previous rotor to the next rotor
signal rotor1_key           : STD_LOGIC_VECTOR(4 downto 0);
signal rotor2_key           : STD_LOGIC_VECTOR(4 downto 0);
signal rotor3_key	        : STD_LOGIC_VECTOR(4 downto 0);
signal rotor4_key           : STD_LOGIC_VECTOR(4 downto 0);
signal reflector_out        : STD_LOGIC_VECTOR(4 downto 0);
signal return_rotor1_key    : STD_LOGIC_VECTOR(4 downto 0);
signal return_rotor2_key    : STD_LOGIC_VECTOR(4 downto 0);
signal return_rotor3_key	: STD_LOGIC_VECTOR(4 downto 0);
signal return_rotor4_key    : STD_LOGIC_VECTOR(4 downto 0);

-------------------------------------------------------------------------------------
--BEGIN
-------------------------------------------------------------------------------------
BEGIN

rotor_clk_inst: rotor_clk 
	PORT MAP (
		a_in => a_in,
		b_in => b_in,
		c_in => c_in,
		d_in => d_in,
		e_in => e_in,
		f_in => f_in,
		g_in => g_in,
		h_in => h_in,
		i_in => i_in,
		j_in => j_in,
		k_in => k_in,
		l_in => l_in,
		m_in => m_in,
		n_in => n_in,
		o_in => o_in,
		p_in => p_in,
		q_in => q_in,
		r_in => r_in,
		s_in => s_in,
		t_in => t_in,
		u_in => u_in,
		v_in => v_in,
		w_in => w_in,
		x_in => x_in,
		y_in => y_in,
		z_in => z_in,
		clk_out => rotor1_clk
);

-------------------------------------------------------------------------------------
--Key Encoder
-------------------------------------------------------------------------------------

key_encoder_inst: key_encoder 
	PORT MAP (
		a_in => a_in,
		b_in => b_in,
		c_in => c_in,
		d_in => d_in,
		e_in => e_in,
		f_in => f_in,
		g_in => g_in,
		h_in => h_in,
		i_in => i_in,
		j_in => j_in,
		k_in => k_in,
		l_in => l_in,
		m_in => m_in,
		n_in => n_in,
		o_in => o_in,
		p_in => p_in,
		q_in => q_in,
		r_in => r_in,
		s_in => s_in,
		t_in => t_in,
		u_in => u_in,
		v_in => v_in,
		w_in => w_in,
		x_in => x_in,
		y_in => y_in,
		z_in => z_in,
		encoded_op => encoded_op
);

-------------------------------------------------------------------------------------
--First rotor
-------------------------------------------------------------------------------------

rotor_1_inst: rotor
	GENERIC MAP ( 
		rotor_type 	=> rotor1_type
	)
	PORT MAP ( 
		clk			=> rotor1_clk,
		key_in		=> encoded_op,
		clk_out		=> rotor2_clk,
		key_out		=> rotor1_key
	);

-------------------------------------------------------------------------------------
--Second rotor
-------------------------------------------------------------------------------------

rotor_2_inst: rotor
	GENERIC MAP ( 
		rotor_type 	=> rotor2_type
	)
	PORT MAP ( 
		clk			=> rotor2_clk,
		key_in		=> rotor1_key,
		clk_out		=> rotor3_clk,
		key_out		=> rotor2_key
	);

-------------------------------------------------------------------------------------
--Third rotor
-------------------------------------------------------------------------------------
 	
rotor_3_inst: rotor
	GENERIC MAP ( 
		rotor_type 	=> rotor3_type
	)
	PORT MAP ( 
		clk			=> rotor3_clk,
		key_in		=> rotor2_key,
		clk_out		=> rotor4_clk,
		key_out		=> rotor3_key
	);

-------------------------------------------------------------------------------------
--Forth rotor
-------------------------------------------------------------------------------------
	
rotor_4_inst: rotor
	GENERIC MAP ( 
		rotor_type 	=> rotor4_type
	)
	PORT MAP ( 
		clk			=> rotor4_clk,
		key_in		=> rotor3_key,
		clk_out		=> rotor5_clk,
		key_out		=> rotor4_key
	);

-------------------------------------------------------------------------------------
--Determine the reflector type
-------------------------------------------------------------------------------------

reflector_type1: IF reflector_type = 1 GENERATE 	
	reflector_type1_inst: reflector
		GENERIC MAP (  
            rf0 => "00101", --E
            rf1 => "01010", --J
            rf2 => "01101", --M
            rf3 => "11010", --Z
            rf4	=> "00001", --A
            rf5 => "01100", --L
            rf6	=> "11001", --Y
            rf7 => "11000", --X
            rf8	=> "10110", --V
            rf9 => "00010", --B
            rf10 => "10111", --W
            rf11 => "00110", --F
            rf12 => "00011", --C
            rf13 => "10010", --R
            rf14 => "10001", --Q
            rf15 => "10101", --U
            rf16 => "01111", --O
            rf17 => "01110", --N 
            rf18 => "10100", --T
            rf19 => "10011", --S
            rf20 => "10000", --P
            rf21 => "01001", --I
            rf22 => "01011", --K
            rf23 => "01000", --H
            rf24 => "00111", --G
            rf25 => "00100" --D
            )
	PORT MAP (
		encoded_ip => rotor4_key,
        encoded_op => reflector_out
    );
END GENERATE reflector_type1;    

-------------------------------------------------------------------------------------
-- Return path through rotors
--
-- Create another instance of each rotor in reverse order
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
--Forth return rotor
-------------------------------------------------------------------------------------
	
return_rotor_4_inst: rotor
	GENERIC MAP ( 
		rotor_type 	=> rotor4_type
	)
	PORT MAP ( 
		clk			=> rotor4_clk,
		key_in		=> reflector_out,
		clk_out		=> open,
		key_out		=> return_rotor4_key
	);

-------------------------------------------------------------------------------------
--Third return rotor
-------------------------------------------------------------------------------------

return_rotor_3_inst: rotor
	GENERIC MAP ( 
		rotor_type 	=> rotor3_type
	)
	PORT MAP ( 
		clk			=> rotor3_clk,
		key_in		=> return_rotor4_key,
		clk_out		=> open,
		key_out		=> return_rotor3_key
	);
	
-------------------------------------------------------------------------------------
--Second return rotor
-------------------------------------------------------------------------------------

return_rotor_2_inst: rotor
	GENERIC MAP ( 
		rotor_type 	=> rotor2_type
	)
	PORT MAP ( 
		clk			=> rotor2_clk,
		key_in		=> return_rotor3_key,
		clk_out		=> open,
		key_out		=> return_rotor2_key
	);

-------------------------------------------------------------------------------------
--First return rotor
-------------------------------------------------------------------------------------

return_rotor_1_inst: rotor
	GENERIC MAP ( 
		rotor_type 	=> rotor1_type
	)
	PORT MAP ( 
		clk			=> rotor1_clk,
		key_in		=> return_rotor2_key,
		clk_out		=> open,
		key_out		=> return_rotor1_key
	);		
-------------------------------------------------------------------------------------
--Key Decoder
-------------------------------------------------------------------------------------

key_decoder_inst: key_decoder 
	PORT MAP (
		encoded_ip	=> return_rotor1_key,
		a_out		=> a_out,
		b_out		=> b_out,
		c_out		=> c_out,
		d_out		=> d_out,
		e_out		=> e_out,
		f_out		=> f_out,
		g_out		=> g_out,
		h_out		=> h_out,
		i_out		=> i_out,
		j_out		=> j_out,
		k_out		=> k_out,
		l_out		=> l_out,
		m_out		=> m_out,
		n_out		=> n_out,
		o_out		=> o_out,
		p_out		=> p_out,
		q_out		=> q_out,
		r_out		=> r_out,
		s_out		=> s_out,
		t_out		=> t_out,
		u_out		=> u_out,
		v_out		=> v_out,
		w_out		=> w_out,
		x_out		=> x_out,
		y_out		=> y_out,
		z_out 		=> z_out
);

END Behavioral;
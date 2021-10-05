-------------------------------------------------------------------------------------
--
--
--
-------------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY enigma IS
	GENERIC ( 
		rotor1_type : integer := 1;
		rotor2_type : integer := 2;
		rotor3_type : integer := 3;
		rotor4_type : integer := 4
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
		r0_init 	: STD_LOGIC_VECTOR( 4 downto 0 ) := "00101";
		r1_init 	: STD_LOGIC_VECTOR( 4 downto 0 ) := "01011";
		r2_init		: STD_LOGIC_VECTOR( 4 downto 0 ) := "01101";
		r3_init		: STD_LOGIC_VECTOR( 4 downto 0 ) := "00110";
		r4_init		: STD_LOGIC_VECTOR( 4 downto 0 ) := "01100";
		r5_init		: STD_LOGIC_VECTOR( 4 downto 0 ) := "00111";
		r6_init		: STD_LOGIC_VECTOR( 4 downto 0 ) := "00100";
		r7_init		: STD_LOGIC_VECTOR( 4 downto 0 ) := "10001";
		r8_init		: STD_LOGIC_VECTOR( 4 downto 0 ) := "10110";
		r9_init		: STD_LOGIC_VECTOR( 4 downto 0 ) := "11010";
		r10_init	: STD_LOGIC_VECTOR( 4 downto 0 ) := "01110";
		r11_init	: STD_LOGIC_VECTOR( 4 downto 0 ) := "10100";
		r12_init	: STD_LOGIC_VECTOR( 4 downto 0 ) := "01111";
		r13_init	: STD_LOGIC_VECTOR( 4 downto 0 ) := "10111";
		r14_init	: STD_LOGIC_VECTOR( 4 downto 0 ) := "11001";
		r15_init	: STD_LOGIC_VECTOR( 4 downto 0 ) := "01000";
		r16_init	: STD_LOGIC_VECTOR( 4 downto 0 ) := "11000";
		r17_init	: STD_LOGIC_VECTOR( 4 downto 0 ) := "10101";
		r18_init	: STD_LOGIC_VECTOR( 4 downto 0 ) := "10011";
		r19_init	: STD_LOGIC_VECTOR( 4 downto 0 ) := "10000";
		r20_init	: STD_LOGIC_VECTOR( 4 downto 0 ) := "00001";
		r21_init	: STD_LOGIC_VECTOR( 4 downto 0 ) := "01001";
		r22_init	: STD_LOGIC_VECTOR( 4 downto 0 ) := "00010";
		r23_init	: STD_LOGIC_VECTOR( 4 downto 0 ) := "10010";
		r24_init	: STD_LOGIC_VECTOR( 4 downto 0 ) := "00011";
		r25_init	: STD_LOGIC_VECTOR( 4 downto 0 ) := "01010"
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


-------------------------------------------------------------------------------------
--Signals
-------------------------------------------------------------------------------------

signal rotor1_clk	: STD_LOGIC;
signal rotor2_clk	: STD_LOGIC;
signal rotor3_clk	: STD_LOGIC;
signal rotor4_clk	: STD_LOGIC;
signal encoded_op	: STD_LOGIC_VECTOR(4 downto 0);
signal rotor1_key	: STD_LOGIC_VECTOR(4 downto 0);
signal rotor2_key	: STD_LOGIC_VECTOR(4 downto 0);
signal rotor3_key	: STD_LOGIC_VECTOR(4 downto 0);

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
--Determine the first rotors type
-------------------------------------------------------------------------------------

rotor1_type1: IF rotor1_type = 1 GENERATE 	
	rotor1_type1_inst: rotor
		GENERIC MAP ( 
			r0_init 	=> "00101", --E
			r1_init 	=> "01011", --K
			r2_init 	=> "01101", --M
			r3_init 	=> "00110", --F
			r4_init 	=> "01100", --L
			r5_init		=> "00111", --G
			r6_init		=> "00100", --D
			r7_init 	=> "10001", --Q
			r8_init 	=> "10110", --V
			r9_init		=> "11010", --Z
			r10_init	=> "01110", --N
			r11_init	=> "10100", --T
			r12_init	=> "01111", --O
			r13_init	=> "10111", --W
			r14_init	=> "11001", --Y
			r15_init	=> "01000", --H
			r16_init	=> "11000", --X
			r17_init	=> "10101", --U
			r18_init	=> "10011", --S
			r19_init	=> "10000", --P
			r20_init	=> "00001", --A
			r21_init	=> "01001", --I
			r22_init	=> "00010", --B
			r23_init	=> "10010", --R
			r24_init	=> "00011", --C
			r25_init	=> "01010"  --J
		)
		PORT MAP ( 
			clk			=> rotor1_clk,
			key_in		=> encoded_op,
			clk_out		=> rotor2_clk,
			key_out		=> rotor1_key
		);
END GENERATE rotor1_type1;

rotor1_type2: IF rotor1_type = 2 GENERATE 	
	rotor1_type2_inst: rotor
		GENERIC MAP ( 
			r0_init 	=> "00001", --A
			r1_init 	=> "01010", --J
			r2_init 	=> "00100", --D
			r3_init 	=> "01011", --K
			r4_init 	=> "10011", --S
			r5_init		=> "01001", --I
			r6_init		=> "10010", --R
			r7_init 	=> "10101", --U
			r8_init 	=> "11000", --X
			r9_init		=> "00010", --B
			r10_init	=> "01100", --L
			r11_init	=> "01000", --H
			r12_init	=> "10111", --W
			r13_init	=> "10100", --T
			r14_init	=> "01101", --M
			r15_init	=> "00011", --C
			r16_init	=> "10001", --Q
			r17_init	=> "00111", --G
			r18_init	=> "11010", --Z
			r19_init	=> "01110", --N
			r20_init	=> "10000", --P
			r21_init	=> "11001", --Y
			r22_init	=> "00110", --F
			r23_init	=> "10110", --V
			r24_init	=> "01111", --O
			r25_init	=> "00101"  --E
		)
		PORT MAP ( 
			clk			=> rotor1_clk,
			key_in		=> encoded_op,
			clk_out		=> rotor2_clk,
			key_out		=> rotor1_key
		);
END GENERATE rotor1_type2;

rotor1_type3: IF rotor1_type = 3 GENERATE 	
	rotor1_type3_inst: rotor
		GENERIC MAP ( 
			r0_init 	=> "00010", --B
			r1_init 	=> "00100", --D
			r2_init 	=> "00110", --F
			r3_init 	=> "01000", --H
			r4_init 	=> "01010", --J
			r5_init		=> "01100", --L
			r6_init		=> "00011", --C
			r7_init 	=> "10000", --P
			r8_init 	=> "10010", --R
			r9_init		=> "10100", --T
			r10_init	=> "11000", --X
			r11_init	=> "10110", --V
			r12_init	=> "11010", --Z
			r13_init	=> "01110", --N
			r14_init	=> "11001", --Y
			r15_init	=> "00101", --E
			r16_init	=> "01001", --I
			r17_init	=> "10111", --W
			r18_init	=> "00111", --G
			r19_init	=> "00001", --A
			r20_init	=> "01011", --K
			r21_init	=> "01101", --M
			r22_init	=> "10101", --U
			r23_init	=> "10011", --S
			r24_init	=> "10001", --Q
			r25_init	=> "01111"  --O
		)
		PORT MAP ( 
			clk			=> rotor1_clk,
			key_in		=> encoded_op,
			clk_out		=> rotor2_clk,
			key_out		=> rotor1_key
		);
END GENERATE rotor1_type3;

rotor1_type4: IF rotor1_type = 4 GENERATE 	
	rotor1_type4_inst: rotor
		GENERIC MAP ( 
			r0_init 	=> "00101", --E
			r1_init 	=> "10011", --S
			r2_init 	=> "01111", --O
			r3_init 	=> "10110", --V
			r4_init 	=> "10000", --P
			r5_init		=> "11010", --Z
			r6_init		=> "01010", --J
			r7_init 	=> "00001", --A
			r8_init 	=> "11001", --Y
			r9_init		=> "10001", --Q
			r10_init	=> "10101", --U
			r11_init	=> "01001", --I
			r12_init	=> "10010", --R
			r13_init	=> "01000", --H
			r14_init	=> "11000", --X
			r15_init	=> "01100", --L
			r16_init	=> "01110", --N
			r17_init	=> "00110", --F
			r18_init	=> "10100", --T
			r19_init	=> "00111", --G
			r20_init	=> "01011", --K
			r21_init	=> "00100", --D
			r22_init	=> "00011", --C
			r23_init	=> "01101", --M
			r24_init	=> "10111", --W
			r25_init	=> "00010"  --B
		)
		PORT MAP ( 
			clk			=> rotor1_clk,
			key_in		=> encoded_op,
			clk_out		=> rotor2_clk,
			key_out		=> rotor1_key
		);
END GENERATE rotor1_type4;

-------------------------------------------------------------------------------------
--Determine the Second rotors type
-------------------------------------------------------------------------------------

rotor2_type1: IF rotor2_type = 1 GENERATE 	
	rotor2_type1_inst: rotor
		GENERIC MAP ( 
			r0_init 	=> "00101", --E
			r1_init 	=> "01011", --K
			r2_init 	=> "01101", --M
			r3_init 	=> "00110", --F
			r4_init 	=> "01100", --L
			r5_init		=> "00111", --G
			r6_init		=> "00100", --D
			r7_init 	=> "10001", --Q
			r8_init 	=> "10110", --V
			r9_init		=> "11010", --Z
			r10_init	=> "01110", --N
			r11_init	=> "10100", --T
			r12_init	=> "01111", --O
			r13_init	=> "10111", --W
			r14_init	=> "11001", --Y
			r15_init	=> "01000", --H
			r16_init	=> "11000", --X
			r17_init	=> "10101", --U
			r18_init	=> "10011", --S
			r19_init	=> "10000", --P
			r20_init	=> "00001", --A
			r21_init	=> "01001", --I
			r22_init	=> "00010", --B
			r23_init	=> "10010", --R
			r24_init	=> "00011", --C
			r25_init	=> "01010"  --J
		)
		PORT MAP ( 
			clk			=> rotor2_clk,
			key_in		=> rotor1_key,
			clk_out		=> rotor3_clk,
			key_out		=> rotor2_key
		);
END GENERATE rotor2_type1;

rotor2_type2: IF rotor2_type = 2 GENERATE 	
	rotor2_type2_inst: rotor
		GENERIC MAP ( 
			r0_init 	=> "00001", --A
			r1_init 	=> "01010", --J
			r2_init 	=> "00100", --D
			r3_init 	=> "01011", --K
			r4_init 	=> "10011", --S
			r5_init		=> "01001", --I
			r6_init		=> "10010", --R
			r7_init 	=> "10101", --U
			r8_init 	=> "11000", --X
			r9_init		=> "00010", --B
			r10_init	=> "01100", --L
			r11_init	=> "01000", --H
			r12_init	=> "10111", --W
			r13_init	=> "10100", --T
			r14_init	=> "01101", --M
			r15_init	=> "00011", --C
			r16_init	=> "10001", --Q
			r17_init	=> "00111", --G
			r18_init	=> "11010", --Z
			r19_init	=> "01110", --N
			r20_init	=> "10000", --P
			r21_init	=> "11001", --Y
			r22_init	=> "00110", --F
			r23_init	=> "10110", --V
			r24_init	=> "01111", --O
			r25_init	=> "00101"  --E
		)
		PORT MAP ( 
			clk			=> rotor2_clk,
			key_in		=> rotor1_key,
			clk_out		=> rotor3_clk,
			key_out		=> rotor2_key
		);
END GENERATE rotor2_type2;

rotor2_type3: IF rotor2_type = 3 GENERATE 	
	rotor2_type3_inst: rotor
		GENERIC MAP ( 
			r0_init 	=> "00010", --B
			r1_init 	=> "00100", --D
			r2_init 	=> "00110", --F
			r3_init 	=> "01000", --H
			r4_init 	=> "01010", --J
			r5_init		=> "01100", --L
			r6_init		=> "00011", --C
			r7_init 	=> "10000", --P
			r8_init 	=> "10010", --R
			r9_init		=> "10100", --T
			r10_init	=> "11000", --X
			r11_init	=> "10110", --V
			r12_init	=> "11010", --Z
			r13_init	=> "01110", --N
			r14_init	=> "11001", --Y
			r15_init	=> "00101", --E
			r16_init	=> "01001", --I
			r17_init	=> "10111", --W
			r18_init	=> "00111", --G
			r19_init	=> "00001", --A
			r20_init	=> "01011", --K
			r21_init	=> "01101", --M
			r22_init	=> "10101", --U
			r23_init	=> "10011", --S
			r24_init	=> "10001", --Q
			r25_init	=> "01111"  --O
		)
		PORT MAP ( 
			clk			=> rotor2_clk,
			key_in		=> rotor1_key,
			clk_out		=> rotor3_clk,
			key_out		=> rotor2_key
		);
END GENERATE rotor2_type3;

rotor2_type4: IF rotor2_type = 4 GENERATE 	
	rotor2_type4_inst: rotor
		GENERIC MAP ( 
			r0_init 	=> "00101", --E
			r1_init 	=> "10011", --S
			r2_init 	=> "01111", --O
			r3_init 	=> "10110", --V
			r4_init 	=> "10000", --P
			r5_init		=> "11010", --Z
			r6_init		=> "01010", --J
			r7_init 	=> "00001", --A
			r8_init 	=> "11001", --Y
			r9_init		=> "10001", --Q
			r10_init	=> "10101", --U
			r11_init	=> "01001", --I
			r12_init	=> "10010", --R
			r13_init	=> "01000", --H
			r14_init	=> "11000", --X
			r15_init	=> "01100", --L
			r16_init	=> "01110", --N
			r17_init	=> "00110", --F
			r18_init	=> "10100", --T
			r19_init	=> "00111", --G
			r20_init	=> "01011", --K
			r21_init	=> "00100", --D
			r22_init	=> "00011", --C
			r23_init	=> "01101", --M
			r24_init	=> "10111", --W
			r25_init	=> "00010"  --B
		)
		PORT MAP ( 
			clk			=> rotor2_clk,
			key_in		=> rotor1_key,
			clk_out		=> rotor3_clk,
			key_out		=> rotor2_key
		);
END GENERATE rotor2_type4;

-------------------------------------------------------------------------------------
--Determine the Third rotors type
-------------------------------------------------------------------------------------

rotor3_type1: IF rotor3_type = 1 GENERATE 	
	rotor3_type1_inst: rotor
		GENERIC MAP ( 
			r0_init 	=> "00101", --E
			r1_init 	=> "01011", --K
			r2_init 	=> "01101", --M
			r3_init 	=> "00110", --F
			r4_init 	=> "01100", --L
			r5_init		=> "00111", --G
			r6_init		=> "00100", --D
			r7_init 	=> "10001", --Q
			r8_init 	=> "10110", --V
			r9_init		=> "11010", --Z
			r10_init	=> "01110", --N
			r11_init	=> "10100", --T
			r12_init	=> "01111", --O
			r13_init	=> "10111", --W
			r14_init	=> "11001", --Y
			r15_init	=> "01000", --H
			r16_init	=> "11000", --X
			r17_init	=> "10101", --U
			r18_init	=> "10011", --S
			r19_init	=> "10000", --P
			r20_init	=> "00001", --A
			r21_init	=> "01001", --I
			r22_init	=> "00010", --B
			r23_init	=> "10010", --R
			r24_init	=> "00011", --C
			r25_init	=> "01010"  --J
		)
		PORT MAP ( 
			clk			=> rotor3_clk,
			key_in		=> rotor2_key,
			clk_out		=> rotor4_clk,
			key_out		=> rotor3_key
		);
END GENERATE rotor3_type1;

rotor3_type2: IF rotor3_type = 2 GENERATE 	
	rotor3_type2_inst: rotor
		GENERIC MAP ( 
			r0_init 	=> "00001", --A
			r1_init 	=> "01010", --J
			r2_init 	=> "00100", --D
			r3_init 	=> "01011", --K
			r4_init 	=> "10011", --S
			r5_init		=> "01001", --I
			r6_init		=> "10010", --R
			r7_init 	=> "10101", --U
			r8_init 	=> "11000", --X
			r9_init		=> "00010", --B
			r10_init	=> "01100", --L
			r11_init	=> "01000", --H
			r12_init	=> "10111", --W
			r13_init	=> "10100", --T
			r14_init	=> "01101", --M
			r15_init	=> "00011", --C
			r16_init	=> "10001", --Q
			r17_init	=> "00111", --G
			r18_init	=> "11010", --Z
			r19_init	=> "01110", --N
			r20_init	=> "10000", --P
			r21_init	=> "11001", --Y
			r22_init	=> "00110", --F
			r23_init	=> "10110", --V
			r24_init	=> "01111", --O
			r25_init	=> "00101"  --E
		)
		PORT MAP ( 
			clk			=> rotor3_clk,
			key_in		=> rotor2_key,
			clk_out		=> rotor4_clk,
			key_out		=> rotor3_key
		);
END GENERATE rotor3_type2;

rotor3_type3: IF rotor3_type = 3 GENERATE 	
	rotor3_type3_inst: rotor
		GENERIC MAP ( 
			r0_init 	=> "00010", --B
			r1_init 	=> "00100", --D
			r2_init 	=> "00110", --F
			r3_init 	=> "01000", --H
			r4_init 	=> "01010", --J
			r5_init		=> "01100", --L
			r6_init		=> "00011", --C
			r7_init 	=> "10000", --P
			r8_init 	=> "10010", --R
			r9_init		=> "10100", --T
			r10_init	=> "11000", --X
			r11_init	=> "10110", --V
			r12_init	=> "11010", --Z
			r13_init	=> "01110", --N
			r14_init	=> "11001", --Y
			r15_init	=> "00101", --E
			r16_init	=> "01001", --I
			r17_init	=> "10111", --W
			r18_init	=> "00111", --G
			r19_init	=> "00001", --A
			r20_init	=> "01011", --K
			r21_init	=> "01101", --M
			r22_init	=> "10101", --U
			r23_init	=> "10011", --S
			r24_init	=> "10001", --Q
			r25_init	=> "01111"  --O
		)
		PORT MAP ( 
			clk			=> rotor3_clk,
			key_in		=> rotor2_key,
			clk_out		=> rotor4_clk,
			key_out		=> rotor3_key
		);
END GENERATE rotor3_type3;

rotor3_type4: IF rotor3_type = 4 GENERATE 	
	rotor3_type4_inst: rotor
		GENERIC MAP ( 
			r0_init 	=> "00101", --E
			r1_init 	=> "10011", --S
			r2_init 	=> "01111", --O
			r3_init 	=> "10110", --V
			r4_init 	=> "10000", --P
			r5_init		=> "11010", --Z
			r6_init		=> "01010", --J
			r7_init 	=> "00001", --A
			r8_init 	=> "11001", --Y
			r9_init		=> "10001", --Q
			r10_init	=> "10101", --U
			r11_init	=> "01001", --I
			r12_init	=> "10010", --R
			r13_init	=> "01000", --H
			r14_init	=> "11000", --X
			r15_init	=> "01100", --L
			r16_init	=> "01110", --N
			r17_init	=> "00110", --F
			r18_init	=> "10100", --T
			r19_init	=> "00111", --G
			r20_init	=> "01011", --K
			r21_init	=> "00100", --D
			r22_init	=> "00011", --C
			r23_init	=> "01101", --M
			r24_init	=> "10111", --W
			r25_init	=> "00010"  --B
		)
		PORT MAP ( 
			clk			=> rotor3_clk,
			key_in		=> rotor2_key,
			clk_out		=> rotor4_clk,
			key_out		=> rotor3_key
		);
END GENERATE rotor3_type4;

-------------------------------------------------------------------------------------
--Key Decoder
-------------------------------------------------------------------------------------

key_decoder_inst: key_decoder 
	PORT MAP (
		encoded_ip	=> rotor3_key,
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
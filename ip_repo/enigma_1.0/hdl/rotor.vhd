-------------------------------------------------------------------------------------
--File Name:    rotor.vhd
--Author:       Kevan Thompson 
--Date:         April 5, 2022
--Descrption:   This is a model of an enigma rotor. The encoded value is stored in a
--              shifted register and is rotated every clock cycle. The correct output
--              is selected using a multiplexor. The clock for the next rotor is 
--              generated by using a counter. (Pulses very 26 cycles) 
--
--              The type of rotor is determined through generics. Each of the 26 
--              registers in the shift register can be initialized through the 
--              generics. The default generics correspond to rotor #1 
-------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY rotor IS
	GENERIC ( 
	    rotor_type : integer := 1
		);
	PORT ( 
		clk			: IN	STD_LOGIC;
		key_in		: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		clk_out		: OUT 	STD_LOGIC;
		key_out		: OUT	STD_LOGIC_VECTOR (4 DOWNTO 0)
	);
END rotor;

ARCHITECTURE Behavioral OF rotor IS	

---------------------------------------------------------------------
--Components
---------------------------------------------------------------------

COMPONENT rotor_shift_reg IS
	GENERIC ( 
		r0_init 	: STD_LOGIC_VECTOR := "00101";
		r1_init 	: STD_LOGIC_VECTOR := "01011";
		r2_init		: STD_LOGIC_VECTOR := "01101";
		r3_init		: STD_LOGIC_VECTOR := "00110";
		r4_init		: STD_LOGIC_VECTOR := "01100";
		r5_init		: STD_LOGIC_VECTOR := "00111";
		r6_init		: STD_LOGIC_VECTOR := "00100";
		r7_init		: STD_LOGIC_VECTOR := "10001";
		r8_init		: STD_LOGIC_VECTOR := "10110";
		r9_init		: STD_LOGIC_VECTOR := "11010";
		r10_init	: STD_LOGIC_VECTOR := "01110";
		r11_init	: STD_LOGIC_VECTOR := "10100";
		r12_init	: STD_LOGIC_VECTOR := "01111";
		r13_init	: STD_LOGIC_VECTOR := "10111";
		r14_init	: STD_LOGIC_VECTOR := "11001";
		r15_init	: STD_LOGIC_VECTOR := "01000";
		r16_init	: STD_LOGIC_VECTOR := "11000";
		r17_init	: STD_LOGIC_VECTOR := "10101";
		r18_init	: STD_LOGIC_VECTOR := "10011";
		r19_init	: STD_LOGIC_VECTOR := "10000";
		r20_init	: STD_LOGIC_VECTOR := "00001";
		r21_init	: STD_LOGIC_VECTOR := "01001";
		r22_init	: STD_LOGIC_VECTOR := "00010";
		r23_init	: STD_LOGIC_VECTOR := "10010";
		r24_init	: STD_LOGIC_VECTOR := "00011";
		r25_init	: STD_LOGIC_VECTOR := "01010"
		);
	PORT ( 
		clk			: IN	STD_LOGIC;
		r0			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r1			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r2			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r3			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r4			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r5			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r6			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r7			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r8			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r9			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r10			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r11			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r12			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r13			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r14			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r15			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r16			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r17			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r18			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r19			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r20			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r21			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r22			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r23			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r24			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0);
		r25			: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END COMPONENT;

COMPONENT rotor_mux IS
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
END COMPONENT;

---------------------------------------------------------------------
--SIGNALS
---------------------------------------------------------------------

	signal r0_s		: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r1_s		: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r2_s		: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r3_s		: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r4_s		: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r5_s		: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r6_s		: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r7_s		: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r8_s		: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r9_s		: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r10_s	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r11_s	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r12_s	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r13_s	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r14_s	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r15_s	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r16_s	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r17_s	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r18_s	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r19_s	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r20_s	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r21_s	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r22_s	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r23_s	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r24_s	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal r25_s	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	
	signal clk_count : INTEGER RANGE 0 to 26 := 0;
	signal clk_out_s : STD_LOGIC;
---------------------------------------------------------------------
--BEGIN
---------------------------------------------------------------------	
BEGIN

rotor_type1: IF rotor_type = 1 GENERATE 	
	rotor_type1_inst: rotor_shift_reg
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
            clk => clk,
            r0 => r0_s,
            r1 => r1_s,
            r2 => r2_s,
            r3 => r3_s,
            r4 => r4_s,
            r5 => r5_s,
            r6 => r6_s,
            r7 => r7_s,
            r8 => r8_s,
            r9 => r9_s,
            r10 => r10_s,
            r11 => r11_s,
            r12 => r12_s,
            r13 => r13_s,
            r14 => r14_s,
            r15 => r15_s,
            r16 => r16_s,
            r17 => r17_s,
            r18 => r18_s,
            r19 => r19_s,
            r20 => r20_s,
            r21 => r21_s,
            r22 => r22_s,
            r23 => r23_s,
            r24 => r24_s,
            r25 => r25_s
		);
END GENERATE rotor_type1;

rotor_type2: IF rotor_type = 2 GENERATE 	
	rotor_type2_inst: rotor_shift_reg
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
            clk => clk,
            r0 => r0_s,
            r1 => r1_s,
            r2 => r2_s,
            r3 => r3_s,
            r4 => r4_s,
            r5 => r5_s,
            r6 => r6_s,
            r7 => r7_s,
            r8 => r8_s,
            r9 => r9_s,
            r10 => r10_s,
            r11 => r11_s,
            r12 => r12_s,
            r13 => r13_s,
            r14 => r14_s,
            r15 => r15_s,
            r16 => r16_s,
            r17 => r17_s,
            r18 => r18_s,
            r19 => r19_s,
            r20 => r20_s,
            r21 => r21_s,
            r22 => r22_s,
            r23 => r23_s,
            r24 => r24_s,
            r25 => r25_s
		);
END GENERATE rotor_type2;

rotor_type3: IF rotor_type = 3 GENERATE 	
	rotor_type3_inst: rotor_shift_reg
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
            clk => clk,
            r0 => r0_s,
            r1 => r1_s,
            r2 => r2_s,
            r3 => r3_s,
            r4 => r4_s,
            r5 => r5_s,
            r6 => r6_s,
            r7 => r7_s,
            r8 => r8_s,
            r9 => r9_s,
            r10 => r10_s,
            r11 => r11_s,
            r12 => r12_s,
            r13 => r13_s,
            r14 => r14_s,
            r15 => r15_s,
            r16 => r16_s,
            r17 => r17_s,
            r18 => r18_s,
            r19 => r19_s,
            r20 => r20_s,
            r21 => r21_s,
            r22 => r22_s,
            r23 => r23_s,
            r24 => r24_s,
            r25 => r25_s
		);
END GENERATE rotor_type3;

rotor_type4: IF rotor_type = 4 GENERATE 	
	rotor_type4_inst: rotor_shift_reg
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
            clk => clk,
            r0 => r0_s,
            r1 => r1_s,
            r2 => r2_s,
            r3 => r3_s,
            r4 => r4_s,
            r5 => r5_s,
            r6 => r6_s,
            r7 => r7_s,
            r8 => r8_s,
            r9 => r9_s,
            r10 => r10_s,
            r11 => r11_s,
            r12 => r12_s,
            r13 => r13_s,
            r14 => r14_s,
            r15 => r15_s,
            r16 => r16_s,
            r17 => r17_s,
            r18 => r18_s,
            r19 => r19_s,
            r20 => r20_s,
            r21 => r21_s,
            r22 => r22_s,
            r23 => r23_s,
            r24 => r24_s,
            r25 => r25_s
		);
END GENERATE rotor_type4;

rotor_mux_i: rotor_mux	
	PORT MAP(
		mux_in1 => r0_s,
		mux_in2 => r1_s,
		mux_in3 => r2_s,
		mux_in4 => r3_s,
		mux_in5 => r4_s,
		mux_in6 => r5_s,
		mux_in7 => r6_s,
		mux_in8 => r7_s,
		mux_in9 => r8_s,
		mux_in10 => r9_s,
		mux_in11 => r10_s,
		mux_in12 => r11_s,
		mux_in13 => r12_s,
		mux_in14 => r13_s,
		mux_in15 => r14_s,
		mux_in16 => r15_s,
		mux_in17 => r16_s,
		mux_in18 => r17_s,
		mux_in19 => r18_s,
		mux_in20 => r19_s,
		mux_in21 => r20_s,
		mux_in22 => r21_s,
		mux_in23 => r22_s,
		mux_in24 => r23_s,
		mux_in25 => r24_s,
		mux_in26 => r25_s,
		mux_select => key_in,
		mux_out => key_out
	);
		
	--Generate the clock for the next rotor.
	PROCESS(clk)
	BEGIN
		IF(rising_edge(clk)) THEN 
			IF (clk_count /= 25) THEN
				clk_count <= clk_count + 1;
				clk_out_s <= '0';
			ELSE
				clk_count <= 0;
				clk_out_s <= '1';
			END IF;
		ELSE
			clk_count <= clk_count;
			clk_out_s <= clk_out_s;
		END IF;
	END PROCESS;
	
	clk_out <= clk_out_s;

END Behavioral;
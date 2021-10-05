-------------------------------------------------------------------------------------
--
--
--
-------------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY rotor_shift_reg IS
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
END rotor_shift_reg;

ARCHITECTURE Behavioral OF rotor_shift_reg IS	

---------------------------------------------------------------------
--SIGNALS
---------------------------------------------------------------------
	--123456789 0123456789 0123456
	--abcdefghi jklmnopqrs tuvwxyz
	--5 11 13 6 12 7 4 17 22 26   14 20 15 23 25 8 24 21 19 16 1 9 2 18 3 10
	--E K  M  F L  G D Q  V  Z    N  T  O  W  Y  H X  U  S  P  A I B R  C J
	signal r0_s		: STD_LOGIC_VECTOR(4 DOWNTO 0) := r0_init;
	signal r1_s		: STD_LOGIC_VECTOR(4 DOWNTO 0) := r1_init;
	signal r2_s		: STD_LOGIC_VECTOR(4 DOWNTO 0) := r2_init;
	signal r3_s		: STD_LOGIC_VECTOR(4 DOWNTO 0) := r3_init;
	signal r4_s		: STD_LOGIC_VECTOR(4 DOWNTO 0) := r4_init;
	signal r5_s		: STD_LOGIC_VECTOR(4 DOWNTO 0) := r5_init;
	signal r6_s		: STD_LOGIC_VECTOR(4 DOWNTO 0) := r6_init;
	signal r7_s		: STD_LOGIC_VECTOR(4 DOWNTO 0) := r7_init;
	signal r8_s		: STD_LOGIC_VECTOR(4 DOWNTO 0) := r8_init;
	signal r9_s		: STD_LOGIC_VECTOR(4 DOWNTO 0) := r9_init;
	signal r10_s	: STD_LOGIC_VECTOR(4 DOWNTO 0) := r10_init;
	signal r11_s	: STD_LOGIC_VECTOR(4 DOWNTO 0) := r11_init;
	signal r12_s	: STD_LOGIC_VECTOR(4 DOWNTO 0) := r12_init;
	signal r13_s	: STD_LOGIC_VECTOR(4 DOWNTO 0) := r13_init;
	signal r14_s	: STD_LOGIC_VECTOR(4 DOWNTO 0) := r14_init;
	signal r15_s	: STD_LOGIC_VECTOR(4 DOWNTO 0) := r15_init;
	signal r16_s	: STD_LOGIC_VECTOR(4 DOWNTO 0) := r16_init;
	signal r17_s	: STD_LOGIC_VECTOR(4 DOWNTO 0) := r17_init;
	signal r18_s	: STD_LOGIC_VECTOR(4 DOWNTO 0) := r18_init;
	signal r19_s	: STD_LOGIC_VECTOR(4 DOWNTO 0) := r19_init;
	signal r20_s	: STD_LOGIC_VECTOR(4 DOWNTO 0) := r20_init;
	signal r21_s	: STD_LOGIC_VECTOR(4 DOWNTO 0) := r21_init;
	signal r22_s	: STD_LOGIC_VECTOR(4 DOWNTO 0) := r22_init;
	signal r23_s	: STD_LOGIC_VECTOR(4 DOWNTO 0) := r23_init;
	signal r24_s	: STD_LOGIC_VECTOR(4 DOWNTO 0) := r24_init;
	signal r25_s	: STD_LOGIC_VECTOR(4 DOWNTO 0) := r25_init;
	
BEGIN

	PROCESS(clk)
	BEGIN
		IF rising_edge(clk) THEN
			r0_s <= r25_s;
			r1_s <= r0_s;
			r2_s <= r1_s;
			r3_s <= r2_s;
			r4_s <= r3_s;
			r5_s <= r4_s;
			r6_s <= r5_s;
			r7_s <= r6_s;
			r8_s <= r7_s;
			r9_s <= r8_s;
			r10_s <= r9_s;
			r11_s <= r10_s;
			r12_s <= r11_s;
			r13_s <= r12_s;
			r14_s <= r13_s;
			r15_s <= r14_s;
			r16_s <= r15_s;
			r17_s <= r16_s;
			r18_s <= r17_s;
			r19_s <= r18_s;
			r20_s <= r19_s;
			r21_s <= r20_s;
			r22_s <= r21_s;
			r23_s <= r22_s;
			r24_s <= r23_s;
			r25_s <= r24_s;
		ELSE
			r0_s <= r0_s;
			r1_s <= r1_s;
			r2_s <= r2_s;
			r3_s <= r3_s;
			r4_s <= r4_s;
			r5_s <= r5_s;
			r6_s <= r6_s;
			r7_s <= r7_s;
			r8_s <= r8_s;
			r9_s <= r9_s;
			r10_s <= r10_s;
			r11_s <= r11_s;
			r12_s <= r12_s;
			r13_s <= r13_s;
			r14_s <= r14_s;
			r15_s <= r15_s;
			r16_s <= r16_s;
			r17_s <= r17_s;
			r18_s <= r18_s;
			r19_s <= r19_s;
			r20_s <= r20_s;
			r21_s <= r21_s;
			r22_s <= r22_s;
			r23_s <= r23_s;
			r24_s <= r24_s;
			r25_s <= r25_s;
		END IF;
	END PROCESS;
	
	r0 <= r0_s;
	r1 <= r1_s;
	r2 <= r2_s;
	r3 <= r3_s;
	r4 <= r4_s;
	r5 <= r5_s;
	r6 <= r6_s;
	r7 <= r7_s;
	r8 <= r8_s;
	r9 <= r9_s;
	r10 <= r10_s;
	r11 <= r11_s;
	r12 <= r12_s;
	r13 <= r13_s;
	r14 <= r14_s;
	r15 <= r15_s;
	r16 <= r16_s;
	r17 <= r17_s;
	r18 <= r18_s;
	r19 <= r19_s;
	r20 <= r20_s;
	r21 <= r21_s;
	r22 <= r22_s;
	r23 <= r23_s;
	r24 <= r24_s;
	r25 <= r25_s;	
	
END Behavioral;
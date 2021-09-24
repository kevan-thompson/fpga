LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

USE ieee.math_real.log2;
USE ieee.math_real.ceil;

library work;
use work.L2_cfg.all;


ENTITY data_bank IS
	GENERIC ( WAYS : integer := NUMBER_OF_WAYS);
	PORT (
	
			CLK            :	IN STD_LOGIC;
			RESET          :	IN	STD_LOGIC;
			Line_addr		:	IN	STD_LOGIC_VECTOR(ADDR_WIDTH downto 0);
			Word_addr		:	IN STD_LOGIC_VECTOR(WORD_WIDTH-1 downto 0);
			Way_number		:	IN  INTEGER RANGE 0 TO NUMBER_OF_WAYS-1;
			LINE_IN      	:	IN  STD_LOGIC_VECTOR (127 downto 0);
			LOAD_LINE    	:	IN  STD_LOGIC;
			LINE_OUT			:	OUT STD_LOGIC_VECTOR (127 downto 0);
			READ_LINE		:	IN STD_LOGIC;
			DONE				:	OUT STD_LOGIC;
			LOAD_WORD		:	IN STD_LOGIC;
			
	
			--SRAM Controller
					
			debug				: out std_logic_vector(31 downto 0)
			
					 );
END data_bank;

ARCHITECTURE structural OF data_bank IS




---------------------------------------------------------------------
--SIGNALS
--------------------------------------------------------------------

	component dual_port_byte_enable_RAM is
		generic (
				C_DATA_SIZE		: INTEGER	:= 32;
				C_PB_BE_WIDTH	: INTEGER	:= 4;
				ADDR_WIDTH		: integer	:= 8
		);
		port (
				CLK				: in   STD_LOGIC;
				ADDR_A			: in   STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
				ADDR_B			: in   STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
				-- WRITE_BE_A is the byte enable in each write operation.
				-- '0' : Do not write on this byte.
				-- '1' : Write on this byte.
				WRITE_BE_A		: in   STD_LOGIC_VECTOR (C_PB_BE_WIDTH - 1 downto 0);
				WRITE_BE_B		: in   STD_LOGIC_VECTOR (C_PB_BE_WIDTH - 1 downto 0);
				-- EN_A is enable signal for the write operation.
				-- '0' : Do not write in the RAM.
				-- '1' : Write in the RAM.
				EN_A				: in   STD_LOGIC;
				-- READ_EN prevants unwanted changes of the output.
				EN_B				: in   STD_LOGIC;
				DATA_IN_A		: in   STD_LOGIC_VECTOR (C_DATA_SIZE - 1 downto 0);
				DATA_IN_B		: in   STD_LOGIC_VECTOR (C_DATA_SIZE - 1 downto 0);
				DATA_OUT_A		: out  STD_LOGIC_VECTOR (C_DATA_SIZE - 1 downto 0);
				DATA_OUT_B		: out  STD_LOGIC_VECTOR (C_DATA_SIZE - 1 downto 0)
		);
	end component;


type STATE_TYPE is (Idle, half_line, full_line, word, transfer_complete, --);
							wait1, wait2, wait3);

signal state        : STATE_TYPE;

SIGNAL ADDR_A			: STD_LOGIC_VECTOR (31 downto 0);
SIGNAL ADDR_B			: STD_LOGIC_VECTOR (31 downto 0);
SIGNAL WRITE_BE_A		: STD_LOGIC_VECTOR (3downto 0);
SIGNAL WRITE_BE_B		: STD_LOGIC_VECTOR (3 downto 0);
SIGNAL EN_A				: STD_LOGIC_vector (3 downto 0);
SIGNAL EN_B				: STD_LOGIC_vector (3 downto 0);
SIGNAL DATA_IN_A		: STD_LOGIC_VECTOR (31 downto 0);
SIGNAL DATA_IN_B		: STD_LOGIC_VECTOR (31 downto 0);
SIGNAL DATA_OUT_A		: STD_LOGIC_VECTOR (31 downto 0);
SIGNAL DATA_OUT_B		: STD_LOGIC_VECTOR (31 downto 0)
SIGNAL line_out_s		: STD_LOGIC_vector (127 downto 0);
---------------------------------------------------------------------
--BEGIN
---------------------------------------------------------------------

	BEGIN
	

	
	brams: for i in 0 to 3 GENERATE

		bram_i: dual_port_byte_enable_RAM 
		generic map (
				C_DATA_SIZE		=> 32;
				C_PB_BE_WIDTH	=> 4;
				ADDR_WIDTH		= >8
		);
		port (
				CLK => CLK,				
				ADDR_A => ADDR_A,			
				ADDR_B => ADDR_B,
				WRITE_BE_A => WRITE_BE_A,	
				WRITE_BE_B => WRITE_BE_B,		
				EN_A => EN_A(i),			
				EN_B => EN_B(i),			
				DATA_IN_A => DATA_IN_A,		
				DATA_IN_B => DATA_IN_B,		
				DATA_OUT_A => DATA_OUT_A,	
				DATA_OUT_B => DATA_OUT_B		
		);
	end component;

	
	END GENERATE;

	EN_A(0) <= '1' when (((state = half_line) or (state = full_line) or (state = word)) and (STD_LOGIC_VECTOR(TO_UNSIGNED(Way_number_sig,2) = "00"))) else
				'0';
	EN_A(1) <= '1' when (((state = half_line) or (state = full_line) or (state = word)) and (STD_LOGIC_VECTOR(TO_UNSIGNED(Way_number_sig,2) = "01"))) else
				'0';
	EN_A(2) <= '1' when (((state = half_line) or (state = full_line) or (state = word)) and (STD_LOGIC_VECTOR(TO_UNSIGNED(Way_number_sig,2) = "10"))) else
				'0';
	EN_A(3) <= '1' when (((state = half_line) or (state = full_line) or (state = word)) and (STD_LOGIC_VECTOR(TO_UNSIGNED(Way_number_sig,2) = "11"))) else
				'0';


	EN_B(0) <= '1' when (((state = half_line) or (state = full_line)) and (STD_LOGIC_VECTOR(TO_UNSIGNED(Way_number_sig,2) = "00"))) else
				'0';
	EN_B(1) <= '1' when (((state = half_line) or (state = full_line)) and (STD_LOGIC_VECTOR(TO_UNSIGNED(Way_number_sig,2) = "01"))) else
				'0';
	EN_B(2) <= '1' when (((state = half_line) or (state = full_line)) and (STD_LOGIC_VECTOR(TO_UNSIGNED(Way_number_sig,2) = "10"))) else
				'0';
	EN_B(3) <= '1' when (((state = half_line) or (state = full_line)) and (STD_LOGIC_VECTOR(TO_UNSIGNED(Way_number_sig,2) = "11"))) else
				'0';

	DATA_IN_A <= LINE_IN(31 downto 0) when ((state = half_line) or (state = word)) else
					 LINE_IN(95 downto 64);

	DATA_IN_B <= LINE_IN(63 downto 32) when ((state = half_line) or (state = word)) else
					 LINE_IN(127 downto 96);
	
	WRITE_BE_A <= "1111" when LOAD_LINE = '1' or LOAD_WORD = '1' else
						"0000";
	WRITE_BE_B <= "1111" when LOAD_LINE = '1' else
						"0000";		
	
	--------------------------------
	--SRAM Controller Port Map		
	--------------------------------
	ADDR_A(15 downto 0) <= Line_addr_sig & 00 when state = word or state = half_line else
									Line_addr_sig & 10 when state = full_line;
	
	ADDR_A(15 downto 0) <= Line_addr_sig & 01 when state = word or state = half_line else
									Line_addr_sig & 11 when state = full_line;								
	--------------------------------
	--Control State Machine		
	--------------------------------
	PROCESS(CLK)
	BEGIN
		if(rising_edge(clk)) then 
			if(reset = '1') then 
				state <= idle
			else
				case state is
					when idle =>
						if((load_line = '1') or (read_line = '1')) then
							state <= half_line;
						elsif(LOAD_WORD = '1') then
							state <= word;
						else
							state <= idle;
						end if;
					when half_line =>
						state <= full_line;
					when full_line =>
						state <= transfer_complete;
					when word =>
						state <= transfer_complete
					when others =>
						state <= idle;
				end case;
			end if;
		else
			state <= state
	end process;
						

	--------------------------------
	-- Register Output	
	--------------------------------
	
	PROCESS(CLK)
	BEGIN
		IF(rising_edge(clk)) then
			If(state = half_Line) then
				line_out_s(31 downto 0) <= DATA_OUT_A;
				line_out_s(63 downto 32) <= DATA_OUT_B;
				line_out_s(127 downto 64) <= line_out_s(127 downto 64);
			elsif(state = full_Line) then
				line_out_s(95 downto 94) <= DATA_OUT_A;
				line_out_s(127 downto 96) <= DATA_OUT_B;
				line_out_s(63 downto 0) <= line_out_s(63 downto 0);
			else
				line_out_s <= line_out_s;
			end if;
		else
			line_out_s <= line_out_s;
		end if;
	end process;
	
	--------------------------------
	--Register Input Signals
	--------------------------------
	
	
	--Assign output signal
	done <= '1' WHEN (state = transfer_complete) ELSE '0';
	
	--done <= '1' when (((state = W2) AND (done_sig = '1')) OR ((state = R2) AND (done_sig = '1'))) ELSE
	--			'0';

	--Select correct word to access
	word_select <= Word_addr WHEN (LOAD_WORD_sig = '1') ELSE
						"00" WHEN (((STATE = write_word1) AND (load_line_sig = '1')) OR (STATE = read_word1)) ELSE
						"01" WHEN ((STATE = write_word2) OR (STATE = read_word2)) ELSE
						"10" WHEN ((STATE = write_word3) OR (STATE = write_word3)) ELSE
						"11" ;

	--debug signals
	debug(0) <= write_sig;
	debug(1) <= read_select;
	debug(2) <= done_sig;
	
	
	
	
	LINE_OUT <= line_out_s;
	
	--DATA_OUT <= data_out_s;

	

END structural;
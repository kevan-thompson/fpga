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
			byte_en			:	in std_logic_vector(3 downto 0);
	
			--SRAM Controller
			
			CE_not			:	OUT STD_LOGIC; --Synchronous Chip Enable
			CE2				:	OUT STD_LOGIC; --Synchronous Chip Enable
			CE2_not			:	OUT STD_LOGIC; --Synchronous Chip Enable
			ADV				:	OUT STD_LOGIC; --Address Advance
			WE_not			:	OUT STD_LOGIC; --Synchronous Read/Write Control Input 
			BWa_not			:	OUT STD_LOGIC; --Synchronous Byte Write Inputs
			BWb_not			:	OUT STD_LOGIC; --Synchronous Byte Write Inputs
			BWc_not			:	OUT STD_LOGIC; --Synchronous Byte Write Inputs
			BWd_not			:	OUT STD_LOGIC; --Synchronous Byte Write Inputs
			OE_not			:	OUT STD_LOGIC; --Output Enable 
			CKE_not			:	OUT STD_LOGIC; --Clock Enable
			SRAM_CLK			:	OUT STD_LOGIC;	
		
			A					:	OUT STD_LOGIC_VECTOR(17 DOWNTO 0); --Address
			Data				:	INOUT STD_LOGIC_VECTOR(35 DOWNTO 0); --Data written into SRAM
			Data_I 			:	IN STD_LOGIC_VECTOR(35 DOWNTO 0);
			Data_O 			:	OUT STD_LOGIC_VECTOR(35 DOWNTO 0);
			Data_T 			:	OUT STD_LOGIC_VECTOR(35 DOWNTO 0);
			
			debug				: out std_logic_vector(63 downto 0)
			
					 );
END data_bank;

ARCHITECTURE structural OF data_bank IS


---------------------------------------------------------------------
--COMPONENTS
---------------------------------------------------------------------

	COMPONENT sram_cntlr IS

	PORT (
		CLK				: IN  STD_LOGIC;
		--RESET			: IN  STD_LOGIC;
		
		--Inputs
		address			:	IN STD_LOGIC_VECTOR(17 DOWNTO 0);
		data_in			:	IN STD_LOGIC_VECTOR(31 DOWNTO 0);	
		read_select		:	IN STD_LOGIC;
		write_select	:	IN STD_LOGIC;
		byte_en			:	in std_logic_vector(3 downto 0);
		--Outputs
		data_out			:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		done				:	OUT STD_LOGIC;
		 
		--SRAM inputs 
		CE_not			:	OUT STD_LOGIC; --Synchronous Chip Enable
		CE2				:	OUT STD_LOGIC; --Synchronous Chip Enable
		CE2_not			:	OUT STD_LOGIC; --Synchronous Chip Enable
		ADV				:	OUT STD_LOGIC; --Address Advance
		WE_not			:	OUT STD_LOGIC; --Synchronous Read/Write Control Input 
		BWa_not			:	OUT STD_LOGIC; --Synchronous Byte Write Inputs
		BWb_not			:	OUT STD_LOGIC; --Synchronous Byte Write Inputs
		BWc_not			:	OUT STD_LOGIC; --Synchronous Byte Write Inputs
		BWd_not			:	OUT STD_LOGIC; --Synchronous Byte Write Inputs
		OE_not			:	OUT STD_LOGIC; --Output Enable 
		CKE_not			:	OUT STD_LOGIC; --Clock Enable
		SRAM_CLK			:	OUT STD_LOGIC;	
		A					:	OUT STD_LOGIC_VECTOR(17 DOWNTO 0); --Address
		Data				:	INOUT STD_LOGIC_VECTOR(35 DOWNTO 0); --Data written into SRAM
		Data_I 			:	IN STD_LOGIC_VECTOR(35 DOWNTO 0);
		Data_O 			:	OUT STD_LOGIC_VECTOR(35 DOWNTO 0);
		Data_T 			:	OUT STD_LOGIC_VECTOR(35 DOWNTO 0)	
		 );
END COMPONENT;

---------------------------------------------------------------------
--SIGNALS
--------------------------------------------------------------------

type STATE_TYPE is (Idle, read_word1,read_word2,read_word3,read_word4,
							write_word1,write_word2,write_word3,write_word4, transfer_complete, --);
							wait1, wait2, wait3);

signal state        : STATE_TYPE;

SIGNAL data_in_sig	: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL SRAM_ADDR		: STD_LOGIC_VECTOR(17 downto 0);
SIGNAL temp				: STD_LOGIC_VECTOR(2 downto 0);
SIGNAL done_sig 		: STD_logic;
SIGNAL done_temp 		: STD_logic;
SIGNAL read_select	: STD_LOGIC;
SIGNAL read_sig		: STD_LOGIC;
SIGNAL write_select	: STD_LOGIC;
SIGNAL write_sig		: STD_LOGIC;
SIGNAL data_out_s		: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL line_out_sig		: STD_LOGIC_VECTOR(127 downto 0);
SIGNAL word_select	: STD_LOGIC_VECTOR(1 downto 0);

SIGNAL load_line_sig : STD_LOGIC; 
SIGNAL load_word_sig : STD_LOGIC;
SIGNAL Line_addr_sig	: STD_LOGIC_VECTOR(ADDR_WIDTH downto 0);
SIGNAL LINE_IN_sig   : STD_LOGIC_VECTOR (127 downto 0);
signal Way_number_sig : INTEGER RANGE 0 TO NUMBER_OF_WAYS-1;
signal Data_I_s 			:	STD_LOGIC_VECTOR(35 DOWNTO 0);
signal Data_O_s			:	STD_LOGIC_VECTOR(35 DOWNTO 0);

---------------------------------------------------------------------
--BEGIN
---------------------------------------------------------------------

	BEGIN
	
	--------------------------------
	--Set Address for Correct Way		
	--------------------------------
	--hack job fix for now....
--	G1:IF(WAYS = 1) GENERATE
--	
--		SRAM_ADDR <= Line_addr_sig;
--	
--	END GENERATE;
--	
--	G2:IF(WAYS = 2) GENERATE
--		temp <= STD_LOGIC_VECTOR(TO_UNSIGNED(Way_number,2));
--		SRAM_ADDR(17) <= temp(1);
--		SRAM_ADDR(16 downto 0) <= Line_addr_sig & word_select;
--	
--	END GENERATE;
	
	G3:IF(WAYS = 4) GENERATE
	
		SRAM_ADDR(17 downto 16) <= STD_LOGIC_VECTOR(TO_UNSIGNED(Way_number_sig,2));
		SRAM_ADDR(15 downto 0) <= Line_addr_sig & word_select;
	
	END GENERATE;
	--fix for now...
--	G4:IF(WAYS = 8) GENERATE
--	
--		SRAM_ADDR(17 downto 15) <= STD_LOGIC_VECTOR(TO_UNSIGNED(Way_number,3));
--		SRAM_ADDR(14 downto 0) <= Line_addr_sig &  word_select;
--	
--	END GENERATE;
--	
--	G5:IF(WAYS = 16) GENERATE
--	
--		SRAM_ADDR(17 downto 14) <= STD_LOGIC_VECTOR(TO_UNSIGNED(Way_number,3));
--		SRAM_ADDR(13 downto 0) <= Line_addr_sig & word_select;
--	
--	END GENERATE;

	--------------------------------
	--SRAM Controller Port Map		
	--------------------------------

	SRAM_CONTROLER:  sram_cntlr
	Port map (
		CLK => Clk,
		address => SRAM_ADDR,
		data_in => data_in_sig,				
		read_select => READ_SELECT,		
		write_select => WRITE_SELECT,
		byte_en => byte_en,
		data_out => data_out_s,			
		done => done_sig,				
		CE_not => CE_not,			
		CE2 => CE2,				
		CE2_not => CE2_not,			
		ADV => ADV,				
		WE_not => WE_not,			 
		BWa_not => BWa_not,
		BWb_not => BWb_not,
		BWc_not => BWc_not,
		BWd_not => BWd_not,		
		OE_not => OE_not,			 
		CKE_not => CKE_not,
		SRAM_CLK => SRAM_CLK,
		A => A,					
		Data => Data,
		Data_I => Data_I_s,  		
		Data_O => Data_O_s,			
		Data_T =>Data_T						
	);

		Data_I_S <= Data_I;  		
		Data_O <= Data_O_s;

	--------------------------------
	--Control State Machine		
	--------------------------------

	Process(clk)
		BEGIN
		IF(rising_edge(clk)) THEN
			--------------------------------
			--RESET 		
			--------------------------------
			IF(reset = '1') THEN
				state <= Idle;
			ELSE
				CASE state IS
				--------------------------------
				--IDLE		
				--------------------------------
				WHEN Idle =>
						IF((load_line = '1')or (load_word  = '1'))THEN
							state <= write_word1;
						ELSIF(read_line = '1') THEN
							state <= read_word1;
						ELSE
							state <= Idle;
						END IF;
						--debug(7 downto 4) <= "0000";
				--------------------------------
				--WRITE 		
				--------------------------------
				WHEN write_word1 =>
					IF(done_sig = '1') THEN
						--Write a single word? Or Write a Line?
						IF(load_line_sig = '1') THEN
							state <= write_word2;
							--state <= wait1;
						ELSE
							state <= transfer_complete;
						END IF;
					ELSE
						state <=write_word1;
					END IF;
					--debug(7 downto 4) <= "0001";
				WHEN wait1 =>
					state <= write_word2;
					--debug(7 downto 4) <= "1010";
				--Turns out it's write a line
				WHEN write_word2 =>
					IF(done_sig = '1') THEN
						--state <= wait2;
						state <= write_word3;
					ELSE
						state <= write_word2;
					END IF;
					--debug(7 downto 4) <= "0010";
				WHEN wait2 =>
					state <= write_word3;
					--debug(7 downto 4) <= "1011";
				WHEN write_word3=>
					IF(done_sig = '1') THEN
						--state <= wait3;
						state <= write_word4;
					ELSE
						state <= write_word3;
					END IF;
					--debug(7 downto 4) <= "0011";
				WHEN wait3 =>
					state <= write_word4;
					--debug(7 downto 4) <= "1100";
				WHEN write_word4 =>
					IF(done_sig = '1') THEN
						state <= transfer_complete;
					ELSE
						state <= write_word4;
					END IF;
					--debug(7 downto 4) <= "0100";
				--------------------------------
				--READ
				--------------------------------
				WHEN read_word1 =>
					IF(done_sig = '1') THEN
							state <= read_word2;
					ELSE
						state <= read_word1;
					END IF;
					--debug(7 downto 4) <= "0101";
				WHEN read_word2 =>
					IF(done_sig = '1') THEN
						state <= read_word3;
					ELSE
						state <=read_word2;
					END IF;	
					--debug(7 downto 4) <= "0110";
				WHEN read_word3 =>
					IF(done_sig = '1') THEN
						state <= read_word4;
					ELSE
						state <= read_word3;
					END IF;
					--debug(7 downto 4) <= "0111";
				WHEN read_word4 =>
					IF(done_sig = '1') THEN
						state <= transfer_complete;
					ELSE
						state <= read_word4;
					END IF;
					--debug(7 downto 4) <= "1000";
				--------------------------------
				--TRANSFER COMPLETE
				--------------------------------
				WHEN transfer_complete =>
					state <= idle;
					--debug(7 downto 4) <= "1001";
				WHEN others =>
					state <= idle;
					--debug(7 downto 4) <= "1111";
				END CASE;
			END IF;
		ELSE
			state <= state;
		END IF;
	END PROCESS;

	--PROCESS(clk)
	--	BEGIN
	--	IF(rising_edge(clk)) THEN
	--		IF(Reset = '1') THEN
	--			done_temp <= '0';
	--		ELSE
	--			IF((state = W2) AND (done_sig = '1')) THEN
	--				done_temp <= '1';
	--			ELSIF((state = R2) AND (done_sig = '1')) THEN
	--				done_temp <= '1';
	--			ELSE
	--				done_temp <= '0';
	--			END IF;
	--		END IF;
	--	ELSE
	--		done_temp <= done_temp;
	--	END IF;
	--END PROCESS;
	
	--------------------------------
	--Register Input Signals
	--------------------------------
	
	PROCESS(clk)
	BEGIN
		IF(rising_edge(clk)) THEN
			IF(state = idle) THEN
				load_line_sig <= load_line;
				load_word_sig <= load_word;
				Line_addr_sig <= Line_addr;
				LINE_IN_sig <= LINE_IN;
				Way_number_sig <= Way_number;
			ELSE
				load_line_sig <= load_line_sig;
				load_word_sig <= load_word_sig;
				Line_addr_sig <= Line_addr_sig;
				LINE_IN_sig <= LINE_IN_sig;
				Way_number_sig <= Way_number_sig;
			END IF;
		ELSE
				load_line_sig <= load_line_sig;
				load_word_sig <= load_word_sig;
				Line_addr_sig <= Line_addr_sig;
				LINE_IN_sig <= LINE_IN_sig;
				Way_number_sig <= Way_number_sig;
		END IF;
	END PROCESS;
	
	--Assign output signal
	done <= '1' WHEN (state = transfer_complete) ELSE '0';
	
	--done <= '1' when (((state = W2) AND (done_sig = '1')) OR ((state = R2) AND (done_sig = '1'))) ELSE
	--			'0';

	--Select correct word to access
	word_select <= Word_addr WHEN (LOAD_WORD_sig = '1') ELSE
						"00" WHEN (((STATE = write_word1) AND (load_line_sig = '1')) OR (STATE = read_word1)) ELSE
						"01" WHEN ((STATE = write_word2) OR (STATE = read_word2)) ELSE
						"10" WHEN ((STATE = write_word3) OR (STATE = read_word3)) ELSE
						"11" ;

	--Enable SRAM write signal
	write_sig <= '1' WHEN ((state = write_word1) OR (state = write_word2) OR (state = write_word3) OR (state = write_word4)) ELSE
						'0';
	write_select <= write_sig;
	
	--Enable SRAM read Signal
	read_select <= '1' WHEN ((state = read_word1) OR (state = read_word2) OR (state = read_word3) OR (state = read_word4)) ELSE
						'0';
	
	--Write correct word to SRAM
	data_in_sig <= Line_in_sig(31 downto 0) WHEN (State = write_word1) ELSE
						Line_in_sig(63 downto 32) WHEN (State = write_word2) ELSE
						Line_in_sig(95 downto 64) WHEN (State = write_word3) ELSE
						Line_in_sig(127 downto 96);
	
	
	--debug signals
	debug(31 downto 0) <= Data_I_s(31 DOWNTO 0);
	debug(63 downto 32) <= Data_O_s(31 DOWNTO 0);
--	debug(0) <= write_sig;
--	debug(1) <= read_select;
--	debug(2) <= done_sig;
--	debug(9 downto 8) <= word_select;
--	debug(11 downto 10) <= STD_LOGIC_VECTOR(TO_UNSIGNED(Way_number,2));
--	debug(14 downto 12) <=  "000" WHEN (LOAD_WORD_sig = '1') ELSE
--						"001" WHEN (((STATE = write_word1) AND (load_line_sig = '1')) OR (STATE = read_word1)) ELSE
--						"010" WHEN ((STATE = write_word2) OR (STATE = read_word2)) ELSE
--						"011" WHEN ((STATE = write_word3) OR (STATE = read_word3)) ELSE
--						"100" ;
	--debug(31 downto 8) <= Line_in_sig(31 downto 8);
	--------------------------------
	--Assign Output
	--------------------------------
				
	PROCESS(clk)
	BEGIN
		IF(rising_edge(clk)) THEN
			CASE(STATE) is
				WHEN read_word1 =>
					if(done_sig = '1') then
						line_out_sig(31 downto 0) <= data_out_s;
						line_out_sig(127 downto 32) <= line_out_sig(127 downto 32);
					else
						line_out_sig <= line_out_sig;
					end if;
				WHEN read_word2 =>
					if(done_sig = '1') then
						line_out_sig(31 downto 0) <= line_out_sig(31 downto 0);
						line_out_sig(63 downto 32) <= data_out_s;
						line_out_sig(127 downto 64) <= line_out_sig(127 downto 64);
					else
						line_out_sig <= line_out_sig;
					end if;
				WHEN read_word3 =>
					if(done_sig = '1') then
						line_out_sig(63 downto 0) <= line_out_sig(63 downto 0);
						line_out_sig(95 downto 64) <= data_out_s;
						line_out_sig(127 downto 96) <= line_out_sig(127 downto 96);
					else
						line_out_sig <= line_out_sig;
					end if;
				WHEN read_word4 =>
					if(done_sig = '1') then
						line_out_sig(95 downto 0) <= line_out_sig(95 downto 0);
						line_out_sig(127 downto 96) <= data_out_s;
					else
						line_out_sig <= line_out_sig;
					end if;
				WHEN OTHERS =>
					line_out_sig <= line_out_sig;
				END CASE;
			ELSE
				line_out_sig <= line_out_sig;
			END IF;
	END PROCESS;
	
	LINE_OUT <= line_out_sig;
	
	--DATA_OUT <= data_out_s;

	

END structural;
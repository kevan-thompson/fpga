library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

USE ieee.math_real.log2;
USE ieee.math_real.ceil;

--library work;
--use work.L1_cfg.all;


ENTITY sram_cntlr IS
	PORT (
		CLK						: in  std_logic;
		--RESET						: in  std_logic;
		
		--Inputs
		address			:	in std_logic_vector(17 downto 0);
		data_in			:	in std_logic_vector(31 downto 0);	
		read_select		:	in std_logic;
		write_select	:	in std_logic;
		byte_en			:	in std_logic_vector(3 downto 0);
		--first				:  in std_logic;
		
		--Outputs
		data_out			:	out std_logic_vector(31 downto 0);
		done				:	out std_logic;
		 
		--SRAM inputs 
		CE_not			:	out std_logic; --Synchronous Chip Enable
		CE2				:	out std_logic; --Synchronous Chip Enable
		CE2_not			:	out std_logic; --Synchronous Chip Enable
		ADV				:	out std_logic; --Address Advance
		WE_not			:	out std_logic; --Synchronous Read/Write Control Input 
		BWa_not			:	out std_logic; --Synchronous Byte Write Inputs
		BWb_not			:	out std_logic; --Synchronous Byte Write Inputs
		BWc_not			:	out std_logic; --Synchronous Byte Write Inputs
		BWd_not			:	out std_logic; --Synchronous Byte Write Inputs
		OE_not			:	out std_logic; --Output Enable 
		CKE_not			:	out std_logic; --Clock Enable
		SRAM_CLK			:	out std_logic;	
		
		A					:	out std_logic_vector(17 downto 0); --Address
		Data				: inout std_logic_vector(35 downto 0); --Data written into SRAM
		Data_I 			: in std_logic_vector(35 downto 0);
      Data_O 			: out std_logic_vector(35 downto 0);
      Data_T 			: out std_logic_vector(35 downto 0)
		

		--
		--temp signals for testbench
	
		--temp!!
		--SRAM_Data_In	:	out std_logic_vector(35 downto 0); --Data written into SRAM
		--SRAM_Data_Out	:	in	std_logic_vector (35 downto 0) --Data read from SRAM		 
		 );
end sram_cntlr;

architecture structural of sram_cntlr is

---------------------------------------------------------------------
--COMPONENTS
---------------------------------------------------------------------

component IOBUF
   port (O : out STD_ULOGIC;
         IO : inout STD_ULOGIC;
         I : in STD_ULOGIC;
         T : in STD_ULOGIC);
end component; 

---------------------------------------------------------------------
--SIGNAL
---------------------------------------------------------------------

TYPE		state_machine	is (start, write_state0, write_state1, write_state2, write_state3, read_state1, read_state2, read_state3, read_state4,
										wait_s);
SIGNAL	state					: state_machine; 
SIGNAL	enable_output_not	: std_logic := '1';
SIGNAL 	address_s			: std_logic_vector(17 downto 0);
SIGNAL	data_in_s			: std_logic_vector(31 downto 0);
SIGNAL	not_used				: std_logic_vector(3 downto 0);
signal 	data_out_s			: std_logic_vector(31 downto 0);
signal	s_clk					: std_logic;
---------------------------------------------------------------------
--BEGIN
---------------------------------------------------------------------

BEGIN

	--Instantiate IO Buffer
--	data_0_31: for i in 0 to 31 generate
--		IOBUF_INSTANCE_NAME : IOBUF
--			port map (O => data_out(i),
--						IO => Data(i),
--						I => data_in(i),
--						T => enable_output_not); 
--	end generate;
	
	Data_O (31 downto 0) <= data_in_s;
	Data_O (35 downto 32) <= (others => '0');
   data_out <= Data_I(31 downto 0);	
   Data_T <= (others => enable_output_not);	
	
	
--	data_32_35: for i in 32 to 35 generate
--		IOBUF_INSTANCE_NAME : IOBUF
--			port map (O => not_used(i-32),
--						IO => Data(i),
--						I => '0',
--						T => enable_output_not); 
--	end generate;
	
	--Control state machine
	PROCESS(clk)
		BEGIN
		IF(rising_edge(clk)) THEN
			IF(state = start) THEN
				IF(read_select = '1') THEN
					state <= read_state1;
				ELSIF(write_select = '1') THEN
				----	if(first = '1') then 
					--	state <= write_state0;
				--	else
						state <= write_state1;
				--	end if;
				ELSE
					state <= start;
				END IF;
			ELSIF(state = write_state0) THEN
				state <= write_state1;
			ELSIF(state = write_state1) THEN
				state <= write_state2;
				--state <= start;
			ELSIF(state = write_state2) THEN
				state <= write_state3;
				--state <= start;
			ELSIF(state = write_state3) THEN
				state <= wait_s;
				--state <= start;
			ELSIF(state = read_state1) THEN
				state <= read_state2;
			ELSIF(state = read_state2) THEN
				state <= read_state3;
				--state <= start;
			ELSIF(state = read_state3) THEN
				state <= wait_s;
				--state <= start;
			ELSIF(state = wait_s) THEN
				state <= start;
			ELSE 
				state <= start;	
			END IF;
		ELSE
			state <= state;
		END IF;
	END PROCESS;


	--Register data_in and address
	PROCESS(clk)
		BEGIN
		IF(rising_edge(clk)) THEN
			IF(state = start) THEN
				IF(read_select = '1') THEN
					address_s <= address;
					data_in_s <= data_in_s;
				ELSIF(write_select = '1') THEN
					address_s <= address;
					data_in_s <= data_in;
				ELSE
					address_s <= address_s;
					data_in_s <= data_in_s;
				END IF;
			ELSE
				address_s <= address_s;
				data_in_s <= data_in_s;
			END IF;
		ELSE
			address_s <= address_s;
			data_in_s <= data_in_s;
		END IF;
	END PROCESS;
		
		
			
		SRAM_CLK <= s_CLK;
		CE_not <=  '0' when ((state = read_state1) OR (state = read_state2) OR (state = read_state3)) ELSE
						'0' when ((state = write_state1) OR (state = write_state2) OR (state = write_state3)) ELSE
						'1';
		CE2 <= '1' when ((state = read_state1) OR (state = read_state2) OR (state = read_state3)) ELSE
					'1' when ((state = write_state1) OR (state = write_state2) OR (state = write_state3)) ELSE
					'0';
		OE_not <= '0' when ((state = read_state1) OR (state = read_state2) OR (state = read_state3)) ELSE
						--'0' when ((state = write_state1) OR (state = write_state2) OR (state = write_state3)) ELSE
						'1';		
					
		CE2_not <= '0';
		ADV <= '0';
		WE_not <= '0' when ((state = write_state1) OR (state = write_state2) OR (state = write_state3)) ELSE
					 '1';
		BWa_not <= not byte_en(0) when ((state = write_state1) OR (state = write_state2) OR (state = write_state3)) ELSE
					 '1';
		BWb_not <= not byte_en(1) when ((state = write_state1) OR (state = write_state2) OR (state = write_state3)) ELSE
					 '1';
		BWc_not <= not byte_en(2) when ((state = write_state1) OR (state = write_state2) OR (state = write_state3)) ELSE
					 '1';
		BWd_not <= not byte_en(3) when ((state = write_state1) OR (state = write_state2) OR (state = write_state3)) ELSE
					 '1';
		OE_not <= '0' when ((state = read_state1) OR (state = read_state2) OR (state = read_state3)) ELSE
						'1';
		CKE_not <= '1' when ((state = start) and (write_select = '0') and (read_select = '0')) ELSE
					  '0'; 

		A <= address_s;
		--SRAM_Data_In(31 downto 0) <= data_in;
		--SRAM_Data_In(35 downto 32) <= (others => '0');
		
		--Data (31 downto 0) <= data_in WHEN ((state = start) and (write_select = '1')) ELSE
											 --(others => 'z');
		--Data (35 downto 32) <= (others => '0') WHEN ((state = start) and (write_select = '1')) ELSE
											   --(others => 'z');
		
		--data_out <= Data (31 downto 0) WHEN (state = read_state) ELSE
							--(others => '0');
		
		enable_output_not <= '0' WHEN ((state = write_state1)OR(state = write_state2)OR(state = write_state3)) ELSE
									'1';
		--debug_enable_not <= enable_output_not; 
		
		--done <= '1' WHEN (((state = write_state3) or (state = read_state3))) ELSE
		done <= '1' WHEN (((state = write_state3) or (state = read_state3))) ELSE
					'0';

		process(clk)
		begin
			if(rising_edge(clk)) then
				if(state = read_state4) then
					data_out_s <= Data_I(31 downto 0); 
				else
					data_out_s <= data_out_s;
				end if;
			else
				data_out_s <= data_out_s;
			end if;
		end process;

		process(clk)
		begin
			if(rising_edge(clk)) then
				s_clk <= not s_clk;
			else
				s_clk <= s_clk;
			end if;
		end process;

END structural;
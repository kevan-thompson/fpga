----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:01:39 11/11/2009 
-- Design Name: 
-- Module Name:    NPI_wrapper - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NPI2 is
	generic(	
		C_PI_ADDR_WIDTH : integer := 32;
		C_PI_DATA_WIDTH : integer := 32;
		C_PI_BE_WIDTH : integer := 4;
		C_PI_RDWDADDR_WIDTH : integer := 4;
		--INTERFACE_DATA_WIDTH : integer := 128;
		WRITE_SUPPORT : integer := 1
	);
	port (
		--wrapper interface
		CLK                   : in  std_logic;
		--CLK2                   : in  std_logic;
		RST                   : in  std_logic;
		ADDR                  : in  std_logic_vector(C_PI_ADDR_WIDTH-1 downto 0);
		RQST                  : in  std_logic;
		Word_nBurst				 : in  std_logic;
		RNW                   : in  std_logic;
		DATA_IN               : in  std_logic_vector(31 downto 0);
		DATA_OUT              : out std_logic_vector(255 downto 0);
		DATA_VALID_IN         : in  std_logic;
		NPI_BE         		 : in std_logic_vector(3 downto 0);
		DATA_VALID_OUT        : out std_logic;
		return_ready			 : out std_logic;
		TRANSFER_COMPLETE     : out std_logic;

		--NPI interface
		NPI_Addr              : out std_logic_vector(C_PI_ADDR_WIDTH-1 downto 0);
		NPI_AddrReq           : out std_logic;
		NPI_AddrAck           : in  std_logic;
		NPI_RNW               : out std_logic;
		NPI_Size              : out std_logic_vector(3 downto 0);
		NPI_WrFIFO_Data       : out std_logic_vector(C_PI_DATA_WIDTH-1 downto 0);
		NPI_WrFIFO_BE         : out std_logic_vector(C_PI_BE_WIDTH-1 downto 0);
		NPI_WrFIFO_Push       : out std_logic;
		NPI_RdFIFO_Data       : in  std_logic_vector(C_PI_DATA_WIDTH-1 downto 0);
		NPI_RdFIFO_Pop        : out std_logic;
		NPI_RdFIFO_RdWdAddr   : in  std_logic_vector(C_PI_RDWDADDR_WIDTH-1 downto 0);
		NPI_WrFIFO_Empty      : in  std_logic;
		NPI_WrFIFO_AlmostFull : in  std_logic;
		NPI_WrFIFO_Flush      : out std_logic;
		NPI_RdFIFO_Empty      : in  std_logic;
		NPI_RdFIFO_Flush      : out std_logic;
		NPI_RdFIFO_Latency    : in  std_logic_vector(1 downto 0);
		NPI_RdModWr           : out std_logic;
		NPI_InitDone          : in  std_logic;
		debug						 : out std_logic_vector(127 downto 0)
	);
end NPI2;

architecture Behavioral of NPI2 is

	--SM
	type STATE_TYPE is (Idle, Read1, Read2, Read3, Read4, Read5, read6, read7, read8, read9,read10, Write1, Write2, Write3,Write4, Write5);

	signal state	: STATE_TYPE;
	signal debug_state	: std_logic_vector(2 downto 0);
	

	--NPI
	constant BURST_SIZE : integer := 32;
	
	signal not_empty, not_empty_d1, not_empty_d2 : std_logic := '0';
	signal data_valid : std_logic := '0';
	signal NPI_reset  : std_logic := '0';
	signal AddrReq  	: std_logic := '0';
	
	signal done, read_done, write_done : std_logic;
	signal addr_rqst : std_logic := '0';

	signal data1	: std_logic_vector(31 downto 0);
	signal data2	: std_logic_vector(31 downto 0);
	signal data3	: std_logic_vector(31 downto 0);
	signal data4	: std_logic_vector(31 downto 0);
	signal data5	: std_logic_vector(31 downto 0);
	signal data6	: std_logic_vector(31 downto 0);
	signal data7	: std_logic_vector(31 downto 0);
	signal data8	: std_logic_vector(31 downto 0);

	signal data_r	: std_logic_vector(31 downto 0);

begin

	NPI_reset <= RST or not NPI_InitDone;

	----Constants----
	NPI_Size    <= "0000" when (Word_nBurst = '1') else "0010"; 
	NPI_RNW     <= RNW;   
	NPI_RdModWr <=  '1'  when ((state = write4) or (state = write5)) else
			'0';
	  --No data aborting
	NPI_RdFIFO_Flush  <= '0';
	  --Full byte enable
	NPI_WrFIFO_BE(3)     <= NPI_BE(0);--(Others => '1');
	NPI_WrFIFO_BE(2)     <= NPI_BE(1);
	NPI_WrFIFO_BE(1)     <= NPI_BE(2);
	NPI_WrFIFO_BE(0)     <= NPI_BE(3);
	
	  --Unused tying to zero
	NPI_WrFIFO_Flush  <= '0';
	------------------

	NPI_Addr <= ADDR;

	process (CLK)
	begin
		if (rising_edge(CLK)) then
			if (NPI_reset = '1') then
				addr_rqst <= '0';
			elsif (NPI_AddrAck = '0' and RQST = '1' and done = '1') then
				addr_rqst <= '1';
			else
				addr_rqst <= '0';
			end if;
		end if;	
	end process;

	--NPI_AddrReq <= addr_rqst;
	--AddrReq <=  '1'  when ((state = write4) or (state = write5) or (state = read1)) else
	AddrReq <=  '1'  when ((state = write4) or (state = read1)) else
			'0';	
	NPI_AddrReq <= AddrReq;

	
	--process (CLK)
	--begin
	--	if (rising_edge(CLK)) then
	--		if (NPI_reset = '1') then
	--			read_done <= '0';
	--		elsif (NPI_AddrAck = '1') then
	--			read_done <= '0';
	--		--elsif (not_empty_d2 = '1' and not_empty_d1 = '0') then
	--		elsif(state = read3) then
	--			read_done <= '1';
	--		else
	--			read_done <= '0';
	--		end if;
	--	end if;	
	--end process;
	
	read_done <= '1' when(state = read10) else '0';

	process (CLK)
	begin
		if (rising_edge(CLK)) then
			if (NPI_reset = '1') then
				write_done <= '0';
			elsif ((NPI_AddrAck = '1') AND ((state = Write4) or (state = Write5))) then
			--elsif ((NPI_AddrAck = '1') AND ((state = Write5))) then
				write_done <= '1';
			else --if ((write_done = '0') and (NPI_AddrAck = '1')) then
				write_done <= '0';
			--else
			--	write_done <= '0';
			end if;
		end if;	
	end process;
	
	done <= read_done when RNW = '1' else write_done;
		
	--TRANSFER_COMPLETE <= done when WRITE_SUPPORT = 1 else read_done;
	TRANSFER_COMPLETE <= done;
	--Stream data from read FIFO to write FIFIO
	NPI_RdFIFO_Pop  <= not NPI_RdFIFO_Empty;
	
	not_empty <= not NPI_RdFIFO_Empty;
	process (CLK)
	begin
		if (rising_edge(CLK)) then
			if (NPI_reset = '1') then
				not_empty_d1 <= '0';
				not_empty_d2 <= '0';
			else
				not_empty_d1 <= not_empty;
				not_empty_d2 <= not_empty_d1;
			end if;
		end if;	
	end process;

	data_valid <= not_empty    when NPI_RdFIFO_Latency = 0 else
	              not_empty_d1 when NPI_RdFIFO_Latency = 1 else
					  not_empty_d2 when NPI_RdFIFO_Latency = 2 else '0';
	
	--NPI_WrFIFO_Data <= DATA_IN;
	
	--Fix me for writes
	
--	NPI_WrFIFO_Data <= data_r(63 downto 0) when  (state = write1) else
--							data_r(127 downto 64) when  (state = write2) else
--							data_r(191 downto 128) when  (state = write3) else
--							data_r(255 downto 192);
	--NPI_WrFIFO_Push <= DATA_VALID_IN;
	NPI_WrFIFO_Data <= data_r;
	NPI_WrFIFO_Push <= '1' when (state = write5) else --or (state = write2)or (state = write3)or (state = write4)) else
				'0';


	--DATA_OUT(255 downto 192) <= data4 ;
	--DATA_OUT(191 downto 128) <= data3 ;
	--DATA_OUT(127 downto 64) <= data2 ;
	DATA_OUT(31 downto 0) <= data1 ;
	DATA_OUT(63 downto 32) <= data2 ;
	DATA_OUT(95 downto 64) <= data3 ;
	DATA_OUT(127 downto 96) <= data4 ;
	DATA_OUT(159 downto 128) <= data5 ;
	DATA_OUT(191 downto 160) <= data6 ;
	DATA_OUT(223 downto 192) <= data7 ;
	DATA_OUT(255 downto 224) <= data8 ;
	--DATA_VALID_OUT <= data_valid;
	DATA_VALID_OUT <= '1' when (state = Read9) else
				'0';
	
	process(clk) 
	begin
		if(rising_edge(clk)) then 
			if((state = idle) and (DATA_VALID_IN = '1')) then
				data_r(31 downto 24) <= DATA_IN(7 downto 0);
				data_r(23 downto 16) <= DATA_IN(15 downto 8);
				data_r(15 downto 8) <= DATA_IN(23 downto 16);
				data_r(7 downto 0) <= DATA_IN(31 downto 24);	
			else
				data_r <= data_r;
			end if;
		else
			data_r <= data_r;
		end if;
	end process;

	--register first data block
	process(clk)
	begin
		if(rising_edge(clk)) then
			if((state = Read2) and (data_valid = '1')) then --note change
				data1(31 downto 24) <= NPI_RdFIFO_Data(7 downto 0);
				data1(23 downto 16) <= NPI_RdFIFO_Data(15 downto 8);
				data1(15 downto 8) <= NPI_RdFIFO_Data(23 downto 16);
				data1(7 downto 0) <= NPI_RdFIFO_Data(31 downto 24);						
			else
				data1 <= data1;
			end if;
		else
			data1 <= data1;
		end if;
	end process;

	--register second data block
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(state = Read3) then --note change
				data2(31 downto 24) <= NPI_RdFIFO_Data(7 downto 0);
				data2(23 downto 16) <= NPI_RdFIFO_Data(15 downto 8);
				data2(15 downto 8) <= NPI_RdFIFO_Data(23 downto 16);
				data2(7 downto 0) <= NPI_RdFIFO_Data(31 downto 24);
			else
				data2 <= data2;
			end if;
		else
			data2 <= data2;
		end if;
	end process;
	
		--register third data block
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(state = Read4) then --note change
				data3(31 downto 24) <= NPI_RdFIFO_Data(7 downto 0);
				data3(23 downto 16) <= NPI_RdFIFO_Data(15 downto 8);
				data3(15 downto 8) <= NPI_RdFIFO_Data(23 downto 16);
				data3(7 downto 0) <= NPI_RdFIFO_Data(31 downto 24);
			else
				data3 <= data3;
			end if;
		else
			data3 <= data3;
		end if;
	end process;
	
		--register forth data block
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(state = Read5) then --note change
				data4(31 downto 24) <= NPI_RdFIFO_Data(7 downto 0);
				data4(23 downto 16) <= NPI_RdFIFO_Data(15 downto 8);
				data4(15 downto 8) <= NPI_RdFIFO_Data(23 downto 16);
				data4(7 downto 0) <= NPI_RdFIFO_Data(31 downto 24); 
			else
				data4 <= data4;
			end if;
		else
			data4 <= data4;
		end if;
	end process;

	process(clk)
	begin
		if(rising_edge(clk)) then
			if(state = Read6) then --note change
				data5(31 downto 24) <= NPI_RdFIFO_Data(7 downto 0);
				data5(23 downto 16) <= NPI_RdFIFO_Data(15 downto 8);
				data5(15 downto 8) <= NPI_RdFIFO_Data(23 downto 16);
				data5(7 downto 0) <= NPI_RdFIFO_Data(31 downto 24); 
			else
				data5 <= data5;
			end if;
		else
			data5 <= data5;
		end if;
	end process;
	
		process(clk)
	begin
		if(rising_edge(clk)) then
			if(state = Read7) then --note change
				data6(31 downto 24) <= NPI_RdFIFO_Data(7 downto 0);
				data6(23 downto 16) <= NPI_RdFIFO_Data(15 downto 8);
				data6(15 downto 8) <= NPI_RdFIFO_Data(23 downto 16);
				data6(7 downto 0) <= NPI_RdFIFO_Data(31 downto 24); 
			else
				data6 <= data6;
			end if;
		else
			data6 <= data6;
		end if;
	end process;
	
		process(clk)
	begin
		if(rising_edge(clk)) then
			if(state = Read8) then --note change
				data7(31 downto 24) <= NPI_RdFIFO_Data(7 downto 0);
				data7(23 downto 16) <= NPI_RdFIFO_Data(15 downto 8);
				data7(15 downto 8) <= NPI_RdFIFO_Data(23 downto 16);
				data7(7 downto 0) <= NPI_RdFIFO_Data(31 downto 24); 
			else
				data7 <= data7;
			end if;
		else
			data7 <= data7;
		end if;
	end process;
	
		process(clk)
	begin
		if(rising_edge(clk)) then
			if(state = Read9) then --note change
				data8(31 downto 24) <= NPI_RdFIFO_Data(7 downto 0);
				data8(23 downto 16) <= NPI_RdFIFO_Data(15 downto 8);
				data8(15 downto 8) <= NPI_RdFIFO_Data(23 downto 16);
				data8(7 downto 0) <= NPI_RdFIFO_Data(31 downto 24); 
			else
				data8 <= data8;
			end if;
		else
			data8 <= data8;
		end if;
	end process;

	--sm

	process(clk)
	begin
		if(rising_edge(clk)) then
			if(NPI_reset = '1') then
				state <= idle;
			else
				case state is
				when idle =>
					if(RQST = '1') then
						if(RNW = '1') then
							state <= Read1;
						else
							state <= Write1;
						end if;
					else
						state <= idle;
					end if;
					debug_state <= "000";
				when Read1 =>
					if(NPI_AddrAck = '1')  then
						state <= Read2;
					else
						state <= Read1;
					end if;
					debug_state <= "001";	
				when Read2 =>
					if(data_valid = '1') then
						if(Word_nBurst = '1') then
							state <= Read9;
						else
							state <= Read3;
						end if;
					else
						state <= Read2;
					end if;
					debug_state <= "010";
				when Read3 =>
					state <= Read4;
					debug_state <= "011";
				when Read4 =>
					state <= Read5;
					debug_state <= "100";
				when Read5 =>
					state <= Read6;
					debug_state <= "100";
				when Read6 =>
					state <= Read7;
					debug_state <= "100";
				when Read7 =>
					state <= Read8;
					debug_state <= "100";
				when Read8 =>
					state <= Read9;
					debug_state <= "100";
				when Read9 =>
					state <= Read10;
					debug_state <= "101";
				when Read10 =>
					state <= idle;
					debug_state <= "101";
				when Write1 =>
					--state <= Write2;
					state <= Write4;
					debug_state <= "110";
				when Write2 =>
					state <= Write3;
					debug_state <= "110";
				when Write3 =>
					state <= Write4;
					debug_state <= "110";
				when Write4 =>
					if(NPI_AddrAck = '1')  then
						state <= Write5;
					else
						state <= Write4;
					end if;
					debug_state <= "110";
				when Write5 =>
--					if(NPI_AddrAck = '1')  then
--						state <= idle;
--					else
--						state <= Write3;
--					end if;
					state <= idle;
					debug_state <= "111";
				when others =>
					state <= idle;
					debug_state <= "111";
				end case;
			end if;
		else
			state <= state;
			debug_state <= debug_state;
		end if;
	end process;


	debug(31 downto 0) <= data_r;--data1;
	debug(63 downto 32) <= data2;
	debug(95 downto 64) <= data8;
	debug(98 downto 96) <= debug_state; 
	debug(102 downto 99) <= NPI_BE;


--	--debug(0) <= addr_rqst; --NPI_AddrReq
--	--debug(0) <=	'1' when ((state = write2) or (state = read1)) else --ADDR_REQ
--	--		'0';	
--	debug(0)	<= NPI_reset;
--	debug(1) <= NPI_AddrAck; --ADDRACK
--	debug(2) <= RNW;
--	debug(3) <= NPI_WrFIFO_Empty;
--	--debug(4) <=	'1'  when ((state = write2) or (state = write3) or (state = read1)) else
--	--				'0';	 --ADDR_REQ
--	debug(4)	<= AddrReq;
--	debug(5) <=	'1' when ((state = write1) or (state = write2)or (state = write3)or (state = write4)) else--wr fifo push
--				'0';
--	debug(6) <=	NPI_RdFIFO_Empty;
--	debug(7) <= done;
--	debug(8) <= not_empty_d1;
--	debug(9) <= not_empty_d2;
--	debug(10) <= data_valid;
--	debug(13 downto 11) <= debug_state;
--	debug(31 downto 14) <= data1(17 downto 0);
--
----	debug (127 downto 64) <= data2;
----	debug (63 downto 0) <= data1;
	
end Behavioral;

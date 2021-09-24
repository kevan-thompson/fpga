----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:36:36 03/21/2011 
-- Design Name: 
-- Module Name:    npi_main - Behavioral 
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



entity ring_buffer is

	Generic (
		DATA_WIDTH		: integer := 71;
		BUFFER_DEPTH	: integer := 4
	);
	
	Port ( 
		-- Common signals
		clk				: in std_logic;
		rst				: in std_logic;
		data_in			: in std_logic_vector(DATA_WIDTH -1 downto 0);
		load_data		: in std_logic;
		read_data		: in std_logic;
		
		data_out			: out std_logic_vector(DATA_WIDTH -1 downto 0);
		buffer_full		: out std_logic;
		empty				: out std_logic;
		done				: out std_logic;
		Valids			: out std_logic_vector(BUFFER_DEPTH downto 1);
		matchs			: out std_logic_vector(BUFFER_DEPTH downto 1);
		compare			: in std_logic;
		address			: in std_logic_vector(31 downto 0);
		match 			: out std_logic
		
	);
end ring_buffer;

architecture Structural of ring_buffer is

	type buff is array (1 to BUFFER_DEPTH) of std_logic_vector(DATA_WIDTH -1 downto 0) ;
	
	signal DATA			: buff := (others => (others => '0'));
	signal Valid		: std_logic_vector(BUFFER_DEPTH downto 1) := (others => '0');
	signal match_s		: std_logic_vector(BUFFER_DEPTH downto 1) := (others => '0');
	signal load_s		: std_logic;
	signal read_s		: std_logic;
	signal empty_s		: std_logic;
	signal full_s		: std_logic;
	signal head			: integer range 1 to BUFFER_DEPTH;
	signal tail			: integer range 1 to BUFFER_DEPTH;
	signal count		: integer range 0 to BUFFER_DEPTH;
	signal data_out_s	: std_logic_vector(DATA_WIDTH -1 downto 0);
	signal done_s		: std_logic;

begin

--full_s <= '1' when((head = (tail - 1)) or ((head = BUFFER_DEPTH) and (tail = 1))) else
--				'0';

matchs <= match_s;

Valids <= Valid;

--full_s <= '1' when (count = 4) else
full_s <= '1' when (count = 3) else
			 '0';

buffer_full <= full_s;

empty_s <= '1' when ((tail = head) and (count /= BUFFER_DEPTH)) else
			'0';		
empty <= empty_s;

load_s <= load_data when (full_s /= '1') else
				'0';	
				
read_s <= read_data when (empty_s /= '1') else
				'0';	
				
-----------------------------------------------
--Register O/P Data
-----------------------------------------------

process(clk)
begin
	if(rising_edge(clk)) then
		if(read_s = '1') then
			data_out_s <= data(tail);
		else
			data_out_s <= data_out_s;
		end if;
	else
		data_out_s <= data_out_s;
	end if;
end process;
				
data_out <= data_out_s ;

-----------------------------------------------
--Data Registers
-----------------------------------------------

registers: for i in 1 to BUFFER_DEPTH generate
		process(clk)
		begin
			if(rising_edge(clk)) then
				if((head = (i)) and (load_s = '1')) then
					data(i) <= data_in;
				else
					data(i) <= data(i);
				end if;
			else
				data(i) <= data(i);
			end if;
		end process;
END GENERATE;	

matching: for i in 1 to BUFFER_DEPTH generate
		process(data, address)
		begin
				if((address(17 downto 5) = data(i)(17 downto 5)) and (data(i)(288) = '1')) then
					match_s(i) <= '1';
				elsif((address(17 downto 5) = data(i)(273 downto 261)) and (data(i)(288) = '0')) then
					match_s(i) <= '1';
				else
					match_s (i) <= '0';
				end if;
		end process;
END GENERATE;	


-----------------------------------------------
--Match Detection
-----------------------------------------------

valid_registers: for i in 1 to BUFFER_DEPTH generate
		process(clk)
		begin
			if(rising_edge(clk)) then
				if((head = (i)) and (load_s = '1')) then
					valid(i) <= '1';
				elsif((tail= (i)) and (read_s = '1')) then
					valid(i) <= '0';
				end if;
			else
				valid(i) <= valid(i);
			end if;
		end process;
END GENERATE;	

process (data, address, compare)
	variable new_match : std_logic := '0';
begin
	for i in 1 to BUFFER_DEPTH loop
			if ((match_s(i) = '1') and (valid(i) = '1')) then
				new_match := '1';
			end if;
	end loop;
	
	if(compare = '1') then
		match <= new_match;
	else
		match <= '0';
	end if;
end process;

--process (data, address, compare)
--	variable new_match : std_logic := '0';
--begin
--	for i in 1 to BUFFER_DEPTH loop
--			if ((address(31 downto 5) = data(i)(31 downto 5)) and (valid(i) = '1') and (data(i)(288) = '1')) then
--				new_match := '1';
--			elsif((address(31 downto 5) = data(i)(287 downto 261)) and (valid(i) = '1') and (data(i)(288) = '0')) then
--				new_match := '1';
--			end if;
--	end loop;
--	
--	if(compare = '1') then
--		match <= new_match;
--	else
--		match <= '0';
--	end if;
--end process;

-----------------------------------------------
--Head and Tail Pointers
-----------------------------------------------

process (clk)
begin
	if(rising_edge(clk)) then 
		if(rst = '1') then
			head <= 1;
		elsif(load_s = '1' ) then
			if((head+1) > BUFFER_DEPTH) then
				head <= 1;
			else
				head <= head + 1;
			end if;
		else
			head <= head;
		end if;
	else
		head <= head;
	end if;
end process;

process (clk)
begin
	if(rising_edge(clk)) then 
		if(rst = '1') then
			count <= 0;
		elsif(load_s = '1' ) then
				count <= count + 1;
		elsif(read_s = '1') then
				count <= count - 1;
		else
			count <= count;
		end if;
	else
		count <= count;
	end if;
end process;


process (clk)
begin
	if(rising_edge(clk)) then 
		if(rst = '1') then
			tail <= 1;
		elsif(read_s = '1' ) then
			if((tail+1) > BUFFER_DEPTH) then
				tail <= 1;
			else
				tail <= tail + 1;
			end if;
		else
			tail <= tail;
		end if;
	else
		tail <= tail;
	end if;
end process;
						

done <= done_s;

process(clk) 
begin
	if(rising_edge(clk)) then
		if((load_data = '1') and (full_s = '0')) then
			done_s <= '1';
		elsif((read_data = '1') and (empty_s = '0')) then
			done_s <= '1';
		else
			done_s <= '0';
		end if;
	else
		done_s <= done_s;
	end if;
end process;
	
end Structural;

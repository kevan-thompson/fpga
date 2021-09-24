library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.math_real.log2;
USE ieee.math_real.ceil;

library work;
use work.L2_cfg.all;

entity tag_bank is
	GENERIC(	
		BANK_NUMBER 		: INTEGER := 0
	);
	Port (
		CLK              : in   STD_LOGIC;
		WRITE_EN         : in   STD_LOGIC;
                                          
		-- TAG_ADDRESS is the reading address from uB/bus.
		TAG_ADDRESS        : in   STD_LOGIC_VECTOR (12 downto 0);--(SET_W - 1 downto 0); -- SET_W = 8
		-- NEW_TAG is the tag value that should replace the old one during the replacement process.
		NEW_TAG          : in   STD_LOGIC_VECTOR (TAG_WIDTH -1  downto 0); -- TAG_W = 17 bits. Bit 16 is valid 
		Old_TAG			  : out  STD_LOGIC_VECTOR (TAG_WIDTH -1  downto 0);
		-- SET_VALID  
		SET_VALID        : in   STD_LOGIC;

		-- TAG_IN
		TAG_IN           : in   STD_LOGIC_VECTOR (TAG_WIDTH - 1 downto 0); -- TAG_W = 20         
		-- VALID determines the validity of the data availbale in the data bank.
		VALID            : out  STD_LOGIC;  
		-- MATCH determines the hit/miss.
		-- 0 : miss
		-- 1 : hit
		MATCH            : out  STD_LOGIC
	);
end tag_bank;

architecture Behavioral of tag_bank is
                                                                                                   
	-- NUM_LINES = 256
	-- SET_BIT_W + TAG_W = 2 + 20 = 22
	-- ram_type is an array with 256 entries each 23 bits wide.
	-- bits #22 to #21 represent the set value
	-- bit #20 is the VALID bits
	-- bits #19 to #0 represent the tag value
	--type ram_type is array (ADDR_WIDTH-1 downto 0) of STD_LOGIC_VECTOR (SET_BIT_WIDTH + TAG_WIDTH downto 0);
	type ram_type is array (8191 downto 0) of STD_LOGIC_VECTOR (SET_BIT_WIDTH + TAG_WIDTH downto 0);
	
	function init_mem return ram_type is

    variable temp_mem : ram_type;
begin
    --for i in 0 to ADDR_WIDTH -1 loop
	 for i in 0 to 8191 loop
		  --initialize LRU stack
        temp_mem(i)(SET_BIT_WIDTH + TAG_WIDTH downto SET_BIT_WIDTH + TAG_WIDTH -1) := STD_LOGIC_VECTOR(TO_UNSIGNED(BANK_NUMBER,2));
		  --Clear tag and valid bits		  
		  temp_mem(i)(SET_BIT_WIDTH + TAG_WIDTH -2 downto 0) := (others => '0');
    end loop;
    return temp_mem;
end;

	
	
	
	--shared variable ram: ram_type := (ADDR_WIDTH downto 0 => (Others => '0'));
	shared variable ram: ram_type := init_mem;
	signal LRU_tag_and_valid : std_logic_vector(SET_BIT_WIDTH + TAG_WIDTH downto 0);
	constant TAG : integer := TAG_WIDTH; -- TAG = 20
begin

	process (CLK)
	begin
		if (rising_edge(CLK)) then
			-- If writing to the cache/memory, we will keep the value of the tag,
			if (WRITE_EN = '1') then
				ram(to_integer(unsigned(TAG_ADDRESS))) := "00" & SET_VALID & NEW_TAG;
				-- LRU_tag_and_valid will have the tag and valid for the reading address
				--LRU_tag_and_valid <= "00" & SET_VALID & NEW_TAG;
				LRU_tag_and_valid <= ram(to_integer(unsigned(TAG_ADDRESS)));
			else
				-- LRU_tag_and_valid will have the tag and valid for the reading address
				LRU_tag_and_valid <= ram(to_integer(unsigned(TAG_ADDRESS)));
			end if; 
		end if;
	end process;

	-- VALID will extract the valid bit from the tag memory
--	VALID <= LRU_tag_and_valid(TAG);
--	-- MATCH will be '1' if the tag input value matches to one of the tags we have stored.
--	MATCH <= '1' when (TAG_IN = LRU_tag_and_valid(TAG_WIDTH-1 downto 0))  else 
--				'0';
	Old_TAG <= LRU_tag_and_valid(TAG_WIDTH-1 downto 0);


	-- VALID will extract the valid bit from the tag memory
	VALID <= SET_VALID WHEN (WRITE_EN = '1') ELSE
				LRU_tag_and_valid(TAG);
	-- MATCH will be '1' if the tag input value matches to one of the tags we have stored.
	MATCH <= '1' when TAG_IN = LRU_tag_and_valid(TAG_WIDTH-1 downto 0)  else 
				'1' when ((TAG_IN = NEW_TAG) AND (WRITE_EN = '1'))  else 
				'0';
--	Old_TAG <= LRU_tag_and_valid(TAG_WIDTH-1 downto 0);
	
end Behavioral;
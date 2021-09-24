library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.math_real.log2;
USE ieee.math_real.ceil;

library work;
use work.L2_cfg.all;

entity reuse_bank is
	GENERIC(	
		BANK_NUMBER 		: INTEGER := 0
	);
	Port (
		CLK              : in   STD_LOGIC;
		WRITE_EN         : in   STD_LOGIC;
                                          
		-- TAG_ADDRESS is the reading address from uB/bus.
		TAG_ADDRESS        : in   STD_LOGIC_VECTOR (12 downto 0);--(SET_W - 1 downto 0); -- SET_W = 8
		-- RPOLICY_BIT_IN determines
		RPOLICY_BITS_IN  : in   STD_LOGIC_VECTOR (LRU_STACK_W - 1 downto 0); -- SET_BIT_W = 2
		-- RPOLICY_BIT_OUT determines
		RPOLICY_BITS_OUT : out  STD_LOGIC_VECTOR (LRU_STACK_W - 1 downto 0) -- SET_BIT_W = 2      

	);
end reuse_bank;

architecture Behavioral of reuse_bank is
                                                                                                   
	-- NUM_LINES = 256
	-- SET_BIT_W + TAG_W = 2 + 20 = 22
	-- ram_type is an array with 256 entries each 23 bits wide.
	-- bits #22 to #21 represent the set value
	-- bit #20 is the VALID bits
	-- bits #19 to #0 represent the tag value
	--type ram_type is array (ADDR_WIDTH-1 downto 0) of STD_LOGIC_VECTOR (SET_BIT_WIDTH + TAG_WIDTH downto 0);
	type ram_type is array (8191 downto 0) of STD_LOGIC_VECTOR (LRU_STACK_W-1 downto 0);
	
	function init_mem return ram_type is

    variable temp_mem : ram_type;
begin
    --for i in 0 to ADDR_WIDTH -1 loop
	 for i in 0 to 8191 loop
		  --initialize LRU stack
        temp_mem(i)(LRU_STACK_W-1 downto 0) := "00011011";
    end loop;
    return temp_mem;
end;

	
	
	
	--shared variable ram: ram_type := (ADDR_WIDTH downto 0 => (Others => '0'));
	shared variable ram		: ram_type := init_mem;
	signal RPOLICY_BITS 		:  STD_LOGIC_VECTOR (LRU_STACK_W - 1 downto 0);
	signal ram_out		 		:  STD_LOGIC_VECTOR (LRU_STACK_W - 1 downto 0);
	constant TAG : integer 	:= TAG_WIDTH; -- TAG = 20
begin

	process (CLK,WRITE_EN,TAG_ADDRESS,RPOLICY_BITS_IN)
	begin
		if (rising_edge(CLK)) then
			-- If writing to the cache/memory, we will keep the value of the tag,
			if (WRITE_EN = '1') then
				ram(to_integer(unsigned(TAG_ADDRESS))) := RPOLICY_BITS_IN;
				ram_out <= ram(to_integer(unsigned(TAG_ADDRESS)));
				-- LRU_tag_and_valid will have the tag and valid for the reading address
			else
				-- LRU_tag_and_valid will have the tag and valid for the reading address
				ram_out <= ram(to_integer(unsigned(TAG_ADDRESS)));
			end if; 
		end if;
	end process;

	RPOLICY_BITS <= RPOLICY_BITS_IN when (WRITE_EN = '1') else
							ram_out;

	RPOLICY_BITS_OUT <= RPOLICY_BITS;
	
end Behavioral;
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:22:27 02/26/2011 
-- Design Name: 
-- Module Name:    LRU_policy - Behavioral 
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
USE ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.math_real.log2;
USE ieee.math_real.ceil;

library work;
use work.L2_cfg.all;

entity LRU_policy is
    Port (
		stack_pos     : in integer range 0 to NUMBER_OF_WAYS-1;
		LRU_STACK_IN  : in  std_logic_vector(LRU_STACK_WIDTH - 1 downto 0);
	 	LRU_STACK_OUT : out std_logic_vector(LRU_STACK_WIDTH - 1 downto 0)
	 );
end LRU_policy;

architecture Behavioral of LRU_policy is
	signal new_MRU : integer range 0 to NUMBER_OF_WAYS-1;

begin
	
	--find position of most recently used line in Stack
	process (stack_pos, LRU_STACK_IN)
		variable new_MRU_temp : integer range 0 to NUMBER_OF_WAYS-1 := 0;
	begin
		for i in 0 to NUM_WAYS-1 loop
			if (stack_pos = i) then
				new_MRU_temp := i;
			end if;
		end loop;
		new_MRU <= new_MRU_temp;
	end process;
	
	--Place new MRU on top of the stack
	LRU_STACK_OUT(LRU_STACK_WIDTH - 1 downto LRU_STACK_WIDTH - SET_BIT_WIDTH) <=
		LRU_STACK_IN (LRU_STACK_WIDTH - 1 - new_MRU*SET_BIT_WIDTH downto LRU_STACK_WIDTH - SET_BIT_WIDTH - new_MRU*SET_BIT_WIDTH);
	
	--Reorder the rest of the stack
	process (new_MRU, LRU_STACK_IN)
	begin
		for j in 1 to NUM_ways-1 loop
			if(new_MRU >= j) then
				LRU_STACK_OUT(LRU_STACK_W_WIDTH - 1 - j*SET_BIT_WIDTH downto LRU_STACK_WIDTH - SET_BIT_WIDTH - j*SET_BIT_WIDTH) <=
				LRU_STACK_IN(LRU_STACK_WIDTH - 1 - (j-1)*SET_BIT_WIDTH downto LRU_STACK_WIDTH - SET_BIT_WIDTH - (j-1)*SET_BIT_WIDTH);
			else
				LRU_STACK_OUT(LRU_STACK_WIDTH - 1 - j*SET_BIT_WIDTH downto LRU_STACK_WIDTH - SET_BIT_WIDTH - j*SET_BIT_WIDTH) <=
				LRU_STACK_IN(LRU_STACK_WIDTH - 1 - j*SET_BIT_WIDTH downto LRU_STACK_WIDTH - SET_BIT_WIDTH - j*SET_BIT_WIDTH);
			end if;
		end loop;
	end process;

end Behavioral;


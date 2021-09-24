--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

USE ieee.math_real.all;
USE ieee.math_real.ceil;

package L2_cfg is

	constant ADDR_W  : integer := 32;
	constant DATA_W  : integer := 32;

	constant NUM_WAYS    : integer := 4;
	constant NUM_LINES   : integer := 256;
	constant LINE_WIDTH  : integer := 16;
	constant REUSE_WIDTH : integer := integer(ceil(log2(real(NUM_WAYS+1))));
	
	constant TAG_L         : integer := integer(ceil(log2(real(LINE_WIDTH)))) + integer(ceil(log2(real(NUM_LINES))));
	constant TAG_W         : integer := 11;--ADDR_W - TAG_L;
	constant SET_W         : integer := integer(ceil(log2(real(NUM_LINES))));
	constant SET_L         : integer := integer(ceil(log2(real(LINE_WIDTH))));

	constant SET_BIT_W     : integer := integer(ceil(log2(real(NUM_WAYS))));

	constant DATA_ADDR_W   : integer := SET_W + integer(ceil(log2(real(LINE_WIDTH/8))));
	
	constant LRU_STACK_W   : integer := SET_BIT_W*NUM_WAYS;

	--FIX ME
	constant LRU_STACK_W_WIDTH   : integer := SET_BIT_W*NUM_WAYS;
	--
	
	
	constant SRAM_ADDR_WIDTH	: integer := 18; --Address lines to SRAM
	constant LINE_WIDTH_n		: integer := 32; --32 or 64 Bytes in a cache line
	constant LINE_LENGTH			: integer := integer(LINE_WIDTH_n*8); --
	constant NUMBER_OF_WAYS 	: integer := 4; --1-16 in powers of 2
	constant NUMBER_OF_WORDS	: integer := integer(ceil(real(LINE_WIDTH_n/4))); --either 8 or 16
	constant WORD_WIDTH			: integer := 2; --integer(ceil(log2(real(NUMBER_OF_WORDS))));
	constant WAY_WIDTH			: integer := integer(ceil(log2(real(NUMBER_OF_WAYS))));
	constant ADDR_WIDTH			: integer := 13; --integer(SRAM_ADDR_WIDTH-WORD_WIDTH-WAY_WIDTH-1);
	constant TAG_WIDTH			: integer := 14; --16 or ....
	constant SET_BIT_WIDTH     : integer := integer(ceil(log2(real(NUMBER_OF_WAYS)))); -- SET_BIT_W = 2
	constant LRU_STACK_WIDTH   : integer := SET_BIT_WIDTH*NUMBER_OF_WAYS; --8

	--L2 FSL Values
	constant FSL_ADDR				: integer := 32; --Address is bits 31 downto 0
	constant FSL_D_Slave			: integer := 64; --Data is bits 63 downto 32
	constant FSL_BE				: integer := 68; --Byte Enables is bits 67 downto 64
	constant FSL_RnW				: integer := 68; --Read/not Write is bit 68
	constant	FSL_Pid				: integer := 70; --Processor ID is bits 70-69
	constant NUM_BYTES			: integer := FSL_BE - FSL_D_SLAVE;
	constant CPU_WIDTH			: integer := 2; --log2(Number of CPUs)

end L2_cfg;
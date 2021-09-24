-------------------------------------------------------------------------------------
--L2.vhd
--Kevan Thompson
--
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
--L2 Arb Bus protocol
-- FSL Slave 0 -> contains protocol data
--		41-12 Address
--		11-8	Byte Enable
--		7		RnW
--		2-1	CPU ID
--		0		Instrustion/not Data

-- FSL Slave 1 -> Data in
--		31-0	Data in

--FSL Master 0 -> Writes Data Back to L2 Arb
--		35-4	Data out
--		2-1	CPU ID
--		0		Instrustion/not Data

--FSL Master 1 -> Just write to when a transaction is complete. Either Read or Write

-------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

USE ieee.math_real.log2;
USE ieee.math_real.ceil;

library work;
use work.L2_cfg.all;

-------------------------------------------------------------------------------------
-- FSL Definition of Ports

-- FSL_Clk         : Synchronous clock
-- FSL_Rst         : System reset, should always come from FSL bus
-- FSL_S_Clk       : Slave asynchronous clock
-- FSL_S_Read      : Read signal, requiring next available input to be read
-- FSL_S_Data      : Input data
-- FSL_S_CONTROL   : Control Bit, indicating the input data are control word
-- FSL_S_Exists    : Data Exist Bit, indicating data existINthe input FSL bus
-- FSL_M_Clk       : Master asynchronous clock
-- FSL_M_Write     : Write signal, enabling writing to output FSL bus
-- FSL_M_Data      : Output data
-- FSL_M_Control   : Control Bit, indicating the output data are contol word
-- FSL_M_Full      : Full Bit, indicating output FSL bus is full
--
-------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Entity Definition
------------------------------------------------------------------------------

ENTITY L2 IS
	PORT 
	(
		
		
		CLK				: IN	STD_LOGIC;
		
		----------------------------------------------------
		--FSL Slave 0
		--Contains protocol info from L2 Arb   
		----------------------------------------------------
		
		FSL_Clk				: IN	STD_LOGIC;
		FSL_Rst				: IN	STD_LOGIC;
		FSL_S_Clk_0			: OUT	STD_LOGIC;
		FSL_S_Read_0		: OUT	STD_LOGIC;
--		FSL_S_Data_0		: IN	STD_LOGIC_VECTOR(0 to 70);
		FSL_S_Data_0		: IN	STD_LOGIC_VECTOR(41 downto 0);
		FSL_S_Control_0	: IN	STD_LOGIC;
		FSL_S_Exists_0		: IN	STD_LOGIC;
		
		----------------------------------------------------
		--FSL Slave 1
		--Contains Write Data from L2 Arb
		----------------------------------------------------
		
		FSL_S_Clk_1			: OUT	STD_LOGIC;
		FSL_S_Read_1		: OUT	STD_LOGIC;
--		FSL_S_Data_0		: IN	STD_LOGIC_VECTOR(0 to 70);
		FSL_S_Data_1		: IN	STD_LOGIC_VECTOR(31 downto 0);
		FSL_S_Control_1	: IN	STD_LOGIC;
		FSL_S_Exists_1		: IN	STD_LOGIC;
		
		----------------------------------------------------
		--FSL Master 0
		--Writes Data, CPU ID, and InD to L2 Arb
		----------------------------------------------------
		
		FSL_M_Clk_0			: OUT	STD_LOGIC;
		FSL_M_Write_0		: OUT	STD_LOGIC;
--		FSL_M_Data_0		: OUT	STD_LOGIC_VECTOR(0 to 70);
		FSL_M_Data_0		: OUT	STD_LOGIC_VECTOR(35 downto 0);
		FSL_M_Control_0	: OUT	STD_LOGIC;
		FSL_M_Full_0		: IN	STD_LOGIC;
		
		----------------------------------------------------
		--FSL Master 1
		--Writes back to L2 Arb on completed transaction 
		----------------------------------------------------
		
		FSL_M_Clk_1			: OUT	STD_LOGIC;
		FSL_M_Write_1		: OUT	STD_LOGIC;
--		FSL_M_Data_0		: OUT	STD_LOGIC_VECTOR(0 to 70);
		FSL_M_Data_1		: OUT	STD_LOGIC;
		FSL_M_Control_1	: OUT	STD_LOGIC;
		FSL_M_Full_1		: IN	STD_LOGIC;
		
		---------------------------------------------------------------
		--Control Signals for NPI Wrapper
		---------------------------------------------------------------
		
		NPI_Addr              : out std_logic_vector(31 downto 0);
		NPI_AddrReq           : out std_logic;
		NPI_AddrAck           : in  std_logic;
		NPI_RNW	             : out std_logic;
		NPI_Size              : out std_logic_vector(3 downto 0);
		NPI_WrFIFO_Data       : out std_logic_vector(63 downto 0);
		NPI_WrFIFO_BE         : out std_logic_vector(7 downto 0);
		NPI_WrFIFO_Push       : out std_logic;
		NPI_RdFIFO_Data       : in  std_logic_vector(63 downto 0);
		NPI_RdFIFO_Pop        : out std_logic;
		NPI_RdFIFO_RdWdAddr   : in  std_logic_vector(3 downto 0);
		NPI_WrFIFO_Empty      : in  std_logic;
		NPI_WrFIFO_AlmostFull : in  std_logic;
		NPI_WrFIFO_Flush      : out std_logic;
		NPI_RdFIFO_Empty      : in  std_logic;
		NPI_RdFIFO_Flush      : out std_logic;
		NPI_RdFIFO_Latency    : in  std_logic_vector(1 downto 0);
		NPI_RdModWr           : out std_logic;
		NPI_InitDone          : in  std_logic;
	
		NPI_Addr2              : out std_logic_vector(31 downto 0);
		NPI_AddrReq2           : out std_logic;
		NPI_AddrAck2           : in  std_logic;
		NPI_RNW2	             : out std_logic;
		NPI_Size2             : out std_logic_vector(3 downto 0);
		NPI_WrFIFO_Data2       : out std_logic_vector(31 downto 0);
		NPI_WrFIFO_BE2         : out std_logic_vector(3 downto 0);
		NPI_WrFIFO_Push2       : out std_logic;
		NPI_RdFIFO_Data2       : in  std_logic_vector(31 downto 0);
		NPI_RdFIFO_Pop2        : out std_logic;
		NPI_RdFIFO_RdWdAddr2   : in  std_logic_vector(3 downto 0);
		NPI_WrFIFO_Empty2      : in  std_logic;
		NPI_WrFIFO_AlmostFull2 : in  std_logic;
		NPI_WrFIFO_Flush2      : out std_logic;
		NPI_RdFIFO_Empty2      : in  std_logic;
		NPI_RdFIFO_Flush2      : out std_logic;
		NPI_RdFIFO_Latency2    : in  std_logic_vector(1 downto 0);
		NPI_RdModWr2           : out std_logic;
		NPI_InitDone2          : in  std_logic;
	
	
		----------------------------------------------------
		--SRAM I/O
		----------------------------------------------------
			
		CE_not			:	OUT STD_LOGIC; --Synchronous Chip Enable
		CE2				:	OUT STD_LOGIC; --Synchronous Chip Enable
		CE2_not			:	OUT STD_LOGIC; --Synchronous Chip Enable
		ADV				:	OUT STD_LOGIC; --Address Advance
		WE_not			:	OUT STD_LOGIC; --Synchronous Read/Write Control Input 
		BWa_not			:	OUT STD_LOGIC; --Synchronous Byte Write Inputs
		BWb_not			:	OUT STD_LOGIC; --Synchronous Byte Write Inputs
		BWc_not			:	OUT STD_LOGIC; --Synchronous Byte Write Inputs
		BWd_not			:	OUT STD_LOGIC; --Synchronous Byte Write Inputs
		OE_not			:	OUT STD_LOGIC; --OUTput Enable 
		CKE_not			:	OUT STD_LOGIC; --Clock Enable
		SRAM_CLK			:	OUT STD_LOGIC;	
		A					:	OUT STD_LOGIC_VECTOR(17 DOWNTO 0); --Address
		Data				:	INOUT STD_LOGIC_VECTOR(35 DOWNTO 0); --Data written into SRAM
		Data_I 			:	IN	STD_LOGIC_VECTOR(35 DOWNTO 0);
		Data_O 			:	OUT STD_LOGIC_VECTOR(35 DOWNTO 0);
		Data_T 			:	OUT STD_LOGIC_VECTOR(35 DOWNTO 0);
		
		disable_cache	:	IN STD_LOGIC;
		
		debug				:	OUT STD_LOGIC_VECTOR(127 downto 0);
		debug_data		:	OUT STD_LOGIC_VECTOR(127 downto 0);
		db_addr			:	OUT STD_LOGIC_VECTOR(31 downto 0);
		db_rnw			:	OUT STD_LOGIC;
		debug_s			:	OUT STD_LOGIC_VECTOR(3 downto 0)
	);
		
attribute SIGIS : STRING; 
attribute SIGIS OF FSL_Clk			: SIGNAL IS "Clk"; 
attribute SIGIS OF FSL_S_Clk_0	: SIGNAL IS "Clk"; 
attribute SIGIS OF FSL_M_Clk_0	: SIGNAL IS "Clk"; 

END L2;

------------------------------------------------------------------------------
-- Architecture Section
------------------------------------------------------------------------------


ARCHITECTURE Behavioral OF L2 IS

---------------------------------------------------------------------
--COMPONENTS
---------------------------------------------------------------------

--DATA BANK
component data_bank 
	GENERIC ( WAYS : integer := NUMBER_OF_WAYS);
	PORT (
	
			CLK         :	IN  STD_LOGIC;
			RESET			:	IN	 STD_LOGIC;
			Line_addr	:	IN	 STD_LOGIC_VECTOR(ADDR_WIDTH DOWNTO 0);
			Word_addr	:	IN  STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0);
			Way_number	:	IN  INTEGER RANGE 0 TO NUMBER_OF_WAYS-1;
			LINE_IN     :	IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
			LOAD_LINE   :	IN  STD_LOGIC;
			LINE_OUT		:	OUT STD_LOGIC_VECTOR (127 downto 0);
			READ_LINE	:	IN  STD_LOGIC;
			Done			:	OUT STD_LOGIC;
			LOAD_WORD	:	IN STD_LOGIC;
			byte_en			:	in std_logic_vector(3 downto 0);
			CE_not		:	OUT STD_LOGIC; 
			CE2			:	OUT STD_LOGIC;
			CE2_not		:	OUT STD_LOGIC; 
			ADV			:	OUT STD_LOGIC; 
			WE_not		:	OUT STD_LOGIC; 
			BWa_not		:	OUT STD_LOGIC; 
			BWb_not		:	OUT STD_LOGIC; 
			BWc_not		:	OUT STD_LOGIC; 
			BWd_not		:	OUT STD_LOGIC; 
			OE_not		:	OUT STD_LOGIC; 
			CKE_not		:	OUT STD_LOGIC;
			SRAM_CLK		:	OUT STD_LOGIC;	
			A				:	OUT STD_LOGIC_VECTOR(17 DOWNTO 0); 
			Data			:	INOUT STD_LOGIC_VECTOR(35 DOWNTO 0); 
			Data_I 		:	IN  STD_LOGIC_VECTOR(35 DOWNTO 0);
			Data_O 		:	OUT STD_LOGIC_VECTOR(35 DOWNTO 0);
			Data_T 		:	OUT STD_LOGIC_VECTOR(35 DOWNTO 0);
			debug 		:	OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
					 );
END COMPONENT;

--TAG BANK
COMPONENT tag_bank IS
	GENERIC(	
		BANK_NUMBER 		: INTEGER := 0
	);
	Port (
		CLK              : IN   STD_LOGIC;
		WRITE_EN         : IN   STD_LOGIC;
		TAG_ADDRESS      : IN   STD_LOGIC_VECTOR (12 downto 0);--(SET_W - 1 DOWNTO 0); 
		NEW_TAG          : IN   STD_LOGIC_VECTOR (TAG_WIDTH - 1 DOWNTO 0); --NEED TO BE FIXED?????  
		Old_TAG          : out   STD_LOGIC_VECTOR (TAG_WIDTH - 1 DOWNTO 0); --NEED TO BE FIXED?????  			
		SET_VALID        : IN   STD_LOGIC;    
		TAG_IN           : IN   STD_LOGIC_VECTOR (TAG_WIDTH - 1 DOWNTO 0);        
		VALID            : OUT  STD_LOGIC;  
		MATCH            : OUT  STD_LOGIC
	);
END COMPONENT;

COMPONENT reuse_bank is
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
end COMPONENT;

COMPONENT LRU_policy is
    Port (
		stack_pos     : in integer range 0 to NUMBER_OF_WAYS-1;
		debug		     : out integer range 0 to NUMBER_OF_WAYS-1;
		LRU_STACK_IN  : in  std_logic_vector(LRU_STACK_WIDTH - 1 downto 0);
	 	LRU_STACK_OUT : out std_logic_vector(LRU_STACK_WIDTH - 1 downto 0)
	 );
end COMPONENT;

--Ring Buffer 
COMPONENT ring_buffer IS
	Generic (
		DATA_WIDTH		: INTEGER := 71;
		BUFFER_DEPTH	: INTEGER := 4
	);
	Port ( 
		clk				: IN  STD_LOGIC;
		rst				: IN  STD_LOGIC;
		data_in			: IN  STD_LOGIC_VECTOR(DATA_WIDTH -1 downto 0);
		load_data		: IN  STD_LOGIC;
		read_data		: IN  STD_LOGIC;
		data_out			: OUT STD_LOGIC_VECTOR(DATA_WIDTH -1 downto 0);
		buffer_full		: OUT STD_LOGIC;
		empty				: OUT STD_LOGIC;
		done				: OUT STD_LOGIC;
		Valids			: out std_logic_vector(BUFFER_DEPTH downto 1);
		matchs			: out std_logic_vector(BUFFER_DEPTH downto 1);
		compare			: IN  STD_LOGIC;
		address			: IN  std_logic_vector(31 downto 0);
		match 			: OUT STD_LOGIC	
	);
END COMPONENT;

COMPONENT ring_buffer_returned IS
	Generic (
		DATA_WIDTH		: INTEGER := 71;
		BUFFER_DEPTH	: INTEGER := 4
	);
	Port ( 
		clk				: IN  STD_LOGIC;
		rst				: IN  STD_LOGIC;
		data_in			: IN  STD_LOGIC_VECTOR(DATA_WIDTH -1 downto 0);
		load_data		: IN  STD_LOGIC;
		read_data		: IN  STD_LOGIC;
		data_out			: OUT STD_LOGIC_VECTOR(DATA_WIDTH -1 downto 0);
		buffer_full		: OUT STD_LOGIC;
		empty				: OUT STD_LOGIC;
		done				: OUT STD_LOGIC;
		compare			: IN  STD_LOGIC;
		address			: IN  std_logic_vector(31 downto 0);
		match 			: OUT STD_LOGIC	
	);
END COMPONENT;

--NPI Interface
COMPONENT NPI IS
	GENERIC(	
		C_PI_ADDR_WIDTH 		: INTEGER := 32;
		C_PI_DATA_WIDTH		: INTEGER := 64;
		C_PI_BE_WIDTH			: INTEGER := 8;
		C_PI_RDWDADDR_WIDTH	: INTEGER := 4;
		--INTERFACE_DATA_WIDTH : integer := 128;
		WRITE_SUPPORT 			: INTEGER := 1
	);
	PORT (
		--wrapper interface
		CLK                   : IN  STD_LOGIC;
		RST                   : IN  STD_LOGIC;
		ADDR                  : IN  STD_LOGIC_VECTOR(C_PI_ADDR_WIDTH-1 downto 0);
		RQST                  : IN  STD_LOGIC;
		RNW                   : IN  STD_LOGIC;
		DATA_IN               : IN  STD_LOGIC_VECTOR(255 downto 0);
		DATA_OUT              : OUT STD_LOGIC_VECTOR(255 downto 0);
		DATA_VALID_IN         : IN  STD_LOGIC;
		DATA_VALID_OUT        : OUT STD_LOGIC;
		TRANSFER_COMPLETE     : OUT STD_LOGIC;

		--NPI interface
		NPI_Addr              : OUT STD_LOGIC_VECTOR(C_PI_ADDR_WIDTH-1 downto 0);
		NPI_AddrReq           : OUT STD_LOGIC;
		NPI_AddrAck           : IN  STD_LOGIC;
		NPI_RNW               : OUT STD_LOGIC;
		NPI_Size              : OUT STD_LOGIC_VECTOR(3 downto 0);
		NPI_WrFIFO_Data       : OUT STD_LOGIC_VECTOR(C_PI_DATA_WIDTH-1 downto 0);
		NPI_WrFIFO_BE         : OUT STD_LOGIC_VECTOR(C_PI_BE_WIDTH-1 downto 0);
		NPI_WrFIFO_Push       : OUT STD_LOGIC;
		NPI_RdFIFO_Data       : IN  STD_LOGIC_VECTOR(C_PI_DATA_WIDTH-1 downto 0);
		NPI_RdFIFO_Pop        : OUT STD_LOGIC;
		NPI_RdFIFO_RdWdAddr   : IN  STD_LOGIC_VECTOR(C_PI_RDWDADDR_WIDTH-1 downto 0);
		NPI_WrFIFO_Empty      : IN  STD_LOGIC;
		NPI_WrFIFO_AlmostFull : IN  STD_LOGIC;
		NPI_WrFIFO_Flush      : OUT STD_LOGIC;
		NPI_RdFIFO_Empty      : IN  STD_LOGIC;
		NPI_RdFIFO_Flush      : OUT STD_LOGIC;
		NPI_RdFIFO_Latency    : IN  STD_LOGIC_VECTOR(1 downto 0);
		NPI_RdModWr           : OUT STD_LOGIC;
		NPI_InitDone          : IN  STD_LOGIC;
		debug						 : OUT STD_LOGIC_VECTOR(127 downto 0)
	);
END COMPONENT;

COMPONENT NPI2 is
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
end COMPONENT;


---------------------------------------------------------------------
--SIGNALS
---------------------------------------------------------------------
	constant LRU_SET : integer := NUMBER_OF_WAYS-1;

	-- Total number of input data.
   CONSTANT NUMBER_OF_INPUT_WORDS  : NATURAL := 1;

   -- Total number of output data
   CONSTANT NUMBER_OF_OUTPUT_WORDS : NATURAL := 1;
	
	----------------------------------------
	--State Machines
	----------------------------------------
	
	--Control unit State Machine
	--Deals with hits, and evictions. 
   TYPE state_type IS (Init,Idle,Ready, Check_Tag, Check_Tag_Wait, Read_Hit, read2, read3, read4, Write_Hit, Evict_Line1, Evict_Line2, Write_Back, Get_Line,
								Invalidate, RU_Invalidate,cache_disabled, disabled_write, disabled_read,disabled_wait, disabled_rb1, disabled_rb2, disabled_rb3, disabled_rb4,write_wait );
   SIGNAL state						: state_type;
	
	--NPI Unit State Machine
	--Controls all writing to/reading from DDR
   TYPE NPI_SM IS (Idle, Transfer,Get_data, wait_1);
   SIGNAL npi_state					: NPI_SM;
	
	--Returned Unit State Machine
	--Deals with missed data read from NPI
   TYPE Returned_SM IS (Idle, Write1, Write2, Read_Returned, Read_Returned2, Read_Returned3, Read_Returned4,Invalidate,Get_Data);
   SIGNAL returned_state 			: Returned_SM;

	----------------------------------------
	--Registered FSL DATA 
	----------------------------------------
	
	SIGNAL address						: STD_LOGIC_VECTOR(ADDR_W-1 DOWNTO 0);
	SIGNAL data_in						: STD_LOGIC_VECTOR(DATA_W-1 DOWNTO 0);
	SIGNAL byte_en						: STD_LOGIC_VECTOR(NUM_BYTES-1 DOWNTO 0);
	SIGNAL RnW_s						: STD_LOGIC;
	SIGNAL cpu_id						: STD_LOGIC_VECTOR(CPU_WIDTH -1 downto 0);
	SIGNAL InD							: STD_LOGIC; --Instruction notData
	
	----------------------------------------
	--Data Bank Signals
	----------------------------------------
	
	SIGNAL data_bank_address		: STD_LOGIC_VECTOR(ADDR_W-1 DOWNTO 0);
	SIGNAL db_Way_number				: INTEGER RANGE 0 TO NUMBER_OF_WAYS-1;
	SIGNAL Way_number					: INTEGER RANGE 0 TO NUMBER_OF_WAYS-1;
	SIGNAL stack_position   		: INTEGER RANGE 0 to NUMBER_OF_WAYS-1;
	SIGNAL debug_lru		   		: INTEGER RANGE 0 to NUMBER_OF_WAYS-1;
	SIGNAL LINE_IN     				: STD_LOGIC_VECTOR (127 DOWNTO 0);
	SIGNAL LOAD_LINE   				: STD_LOGIC;
	SIGNAL LINE_OUT					: STD_LOGIC_VECTOR (127 downto 0);
	SIGNAL READ_LINE					: STD_LOGIC;
	SIGNAL WRITE_EN    				: STD_LOGIC_VECTOR (NUMBER_OF_WAYS -1 downto 0);
	SIGNAL RU_WRITE_EN    			: STD_LOGIC;
	SIGNAL READ_EN     				: STD_LOGIC;
	--SIGNAL DATA_IN     			: STD_LOGIC_VECTOR (DATA_W - 1 DOWNTO 0);
	SIGNAL DATA_OUT    				: STD_LOGIC_VECTOR (DATA_W - 1 DOWNTO 0);	
	SIGNAL db_byte_en							: std_logic_vector(3 downto 0);

	----------------------------------------
	--Valid and Match Signals
	----------------------------------------
	
	SIGNAL valid_bank 				: STD_LOGIC_VECTOR(NUMBER_OF_WAYS - 1 DOWNTO 0);
	SIGNAL match_bank					: STD_LOGIC_VECTOR(NUMBER_OF_WAYS - 1 DOWNTO 0);
	SIGNAL update_tags				: STD_LOGIC_VECTOR(NUMBER_OF_WAYS - 1 DOWNTO 0);
	SIGNAL hit_i						: STD_LOGIC;
	SIGNAL valid_i						: STD_LOGIC;
	SIGNAL selected_set				: INTEGER RANGE 0 TO NUMBER_OF_WAYS-1;
	SIGNAL selected_invalid			: INTEGER RANGE 0 TO NUMBER_OF_WAYS-1;
	----------------------------------------
	--Reuse Signals
	----------------------------------------
	
	SIGNAL rpolicy_bits_from_RAM	: std_logic_vector(LRU_STACK_W - 1 downto 0);
	SIGNAL rpolicy_bits_to_RAM		: std_logic_vector(LRU_STACK_W - 1 downto 0);
	SIGNAL rpolicy_bits_hit			: std_logic_vector(LRU_STACK_W - 1 downto 0);
	SIGNAL rpolicy_bits_returned	: std_logic_vector(LRU_STACK_W - 1 downto 0);
	SIGNAL rpolicy_bits				: std_logic_vector(LRU_STACK_W - 1 downto 0);
	SIGNAL stack_pos					: INTEGER RANGE 0 TO NUMBER_OF_WAYS-1;
	
	----------------------------------------
	--Tag Bank Signals
	----------------------------------------
	
	--SIGNAL tag							: STD_LOGIC_VECTOR(TAG_WIDTH -1 downto 0);
	SIGNAL tag_s						: STD_LOGIC_VECTOR(TAG_WIDTH -1 downto 0);
	SIGNAL tag							: STD_LOGIC_VECTOR(TAG_WIDTH*NUMBER_OF_WAYS -1 downto 0);
	SIGNAL Old_TAG_s					: STD_LOGIC_VECTOR(TAG_WIDTH*NUMBER_OF_WAYS -1 downto 0);
	SIGNAL Old_TAG_ss					: STD_LOGIC_VECTOR(TAG_WIDTH*NUMBER_OF_WAYS -1 downto 0);
	SIGNAL match_tag					: STD_LOGIC_VECTOR(TAG_WIDTH -1 downto 0);
	SIGNAL Data_Bank_Done			: std_logic;
	SIGNAL LOAD_WORD					: STD_LOGIC;
	SIGNAL requested_data 			: std_logic_vector(127 downto 0);
	SIGNAL TAG_ADDRESS				: STD_LOGIC_VECTOR(12 downto 0);
	--SIGNAL valid_s						: std_logic;
	SIGNAL valid_s						: STD_LOGIC_VECTOR (NUMBER_OF_WAYS -1 downto 0);
	

	----------------------------------------
	--NPI Ring Buffer
	----------------------------------------
	
	SIGNAL ring_buffer_data_in		: STD_LOGIC_VECTOR(292 downto 0);
	SIGNAL ring_buffer_load_data	: STD_LOGIC;
	SIGNAL ring_buffer_read_data	: STD_LOGIC;
	SIGNAL ring_buffer_data_out	: STD_LOGIC_VECTOR(292 downto 0);
	SIGNAL ring_buffer_full			: STD_LOGIC;
	SIGNAL ring_buffer_empty		: STD_LOGIC;
	SIGNAL ring_buffer_compare		: STD_LOGIC;
	SIGNAL ring_buffer_address		: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL ring_buffer_match 		: STD_LOGIC;
	SIGNAL ring_buffer_matchs 		: STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL ring_buffer_valids 		: STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL ring_buffer_nu	 		: STD_LOGIC;
	SIGNAL ring_buffer_done				: STD_Logic;

	----------------------------------------
	--Returned Ring Buffer 
	----------------------------------------
	
	--SIGNAL returned_data_in			: STD_LOGIC_VECTOR(294 downto 0);
	SIGNAL returned_load_data		: STD_LOGIC;
	SIGNAL returned_read_data		: STD_LOGIC;
	SIGNAL returned_data_in			: STD_LOGIC_VECTOR(32 downto 0);
	SIGNAL returned_data_out		: STD_LOGIC_VECTOR(298 downto 0);
	SIGNAL returned_full				: STD_LOGIC;
	SIGNAL returned_empty			: STD_LOGIC;
	SIGNAL returned_compare			: STD_LOGIC;
	SIGNAL returned_done				: STD_Logic;
	--SIGNAL returned_address			: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL returned_match 			: STD_LOGIC;
	--SIGNAL returned_load_data
	----------------------------------------
	--NPI Signals
	----------------------------------------
	
	SIGNAL NPI_ADDR_s             : STD_LOGIC_VECTOR(31 downto 0);	
	SIGNAL NPI_RQST               : STD_LOGIC;	
	SIGNAL NPI_RNW_s              : STD_LOGIC;	
	SIGNAL NPI_DATA_IN            : STD_LOGIC_VECTOR(255 downto 0);
	SIGNAL NPI_DATA_OUT           : STD_LOGIC_VECTOR(255 downto 0);
	SIGNAL NPI_DATA_VALID_IN      : STD_LOGIC;
	SIGNAL NPI_DATA_VALID_OUT     : STD_LOGIC;
	SIGNAL NPI_TRANSFER_COMPLETE  : STD_LOGIC;
	SIGNAL RETURN_LINE_IN			: STD_LOGIC_VECTOR(255 downto 0);
	signal NPI_WrFIFO_Data_s		: STD_LOGIC_VECTOR(63 downto 0);

	SIGNAL	NPI_ADDR_s2             : std_logic_vector(31 downto 0);
	SIGNAL	NPI_RQST_2              : std_logic;
	SIGNAL	Word_nBurst				 	: std_logic;
	SIGNAL	NPI_RNW_s2              : std_logic;
	SIGNAL	NPI_DATA_IN_2           : std_logic_vector(31 downto 0);
	SIGNAL	NPI_DATA_OUT_2    : std_logic_vector(255 downto 0);
	SIGNAL	NPI_DATA_VALID_IN_2     : std_logic;
	SIGNAL	NPI_DATA_VALID_OUT_2    : std_logic;
	SIGNAL	NPI_return_ready			: std_logic;
	SIGNAL	NPI_TRANSFER_COMPLETE_2 : std_logic;


	--CU Signals
	SIGNAL Evicted_Data				: STD_LOGIC_vector(292 downto 0);
	SIGNAL Missed_Request			: STD_LOGIC_vector(292 downto 0);
	--signal evict_addr					: std_logic_vector(31 downto 0);
	


	SIGNAL NPI_ADDR_ss            : STD_LOGIC_VECTOR(31 downto 0);	
	SIGNAL NPI_WrFIFO_Data_SS     : STD_LOGIC_VECTOR(63 downto 0);	
	----------------------------------------
	--Returned Request
	----------------------------------------
	SIGNAL returned_request       : STD_LOGIC_VECTOR(255 downto 0);
	SIGNAL returned_way				: INTEGER RANGE 0 TO NUMBER_OF_WAYS-1; 
	SIGNAL returned_RnW 				: STD_LOGIC; 
	SIGNAL returned_CpuID 			: STD_LOGIC_VECTOR(CPU_WIDTH -1 downto 0);
	SIGNAL returned_InD 				: STD_LOGIC;
	SIGNAL returned_Address 		: STD_LOGIC_VECTOR(ADDR_W-1 DOWNTO 0);
	
	----------------------------------------
	--Arbitation Signals
	----------------------------------------
	
	SIGNAL RU_Wanted 					: STD_LOGIC; 
	SIGNAL CU_Wanted 					: STD_LOGIC; 
	SIGNAL RU_Granted					: STD_LOGIC; 
	SIGNAL CU_Granted					: STD_LOGIC;
	


	
	----------------------------------------
	--Debug Signals
	----------------------------------------
	--debug
	SIGNAL debug_state				: STD_logic_VECTOR(3 downto 0);
	SIGNAL debug_s1					: STD_LOGIC_VECTOR(127 downto 0);
	SIGNAL debug_ss					: STD_LOGIC_VECTOR(127 downto 0);
	signal db_debug		: std_logic_vector(63 downto 0);
	signal db_fsl						:std_logic;
	signal db_stall					: std_logic_vector(3 downto 0);
	signal NPI2_debug	 	: std_logic_vector(127 downto 0);
	
	signal BWa_not_s		:	STD_LOGIC; 
	signal BWb_not_s		:	STD_LOGIC; 
	signal BWc_not_s		:	STD_LOGIC; 
	signal BWd_not_s		:	STD_LOGIC;
	signal Data_O_s			:	 STD_LOGIC_VECTOR(35 DOWNTO 0);
	signal Data_I_s			:	 STD_LOGIC_VECTOR(35 DOWNTO 0);
	signal A_s				: STD_LOGIC_VECTOR(17 DOWNTO 0); --Address
	
	signal CE_not_s			: STD_LOGIC; --Synchronous Chip Enable
	signal CE2_s				: STD_LOGIC; --Synchronous Chip Enable
	signal OE_not_s			: STD_LOGIC; --OUTput Enable 
	signal WE_not_S			: STD_LOGIC; --Synchronous Read/Write Control Input 		
	signal s_clk				: std_logic;
	signal way_db				: std_logic_vector(1 downto 0);
	
	signal stall				: std_logic;
	signal stall_s				: std_logic;
	signal FSL_M_Read_s		: STD_LOGIC;
	signal FSL_M_Write_s		: STD_LOGIC;
	signal FSL_M_Data_s		: STD_LOGIC_VECTOR(35 downto 0);
	signal FSL_M_Write_reg	: STD_LOGIC;
	signal FSL_M_Data_reg	: STD_LOGIC_VECTOR(35 downto 0);
	signal FSL_S_READ_reg	: STD_LOGIC;
	
---------------------------------------------------------------------
--BEGIN
---------------------------------------------------------------------

BEGIN

---------------------------------------------------------------------
--FSL Control Signals
---------------------------------------------------------------------
	--FSL SLAVE CLK
	FSL_S_Clk_0 <= CLK;
	FSL_S_Clk_1 <= CLK;
	
	--FSL MASTER CLK
	FSL_M_Clk_0 <= CLK;
	FSL_M_Clk_1 <= CLK;
	
	--FSL READ SIGNAL
	FSL_S_Read_0  <= FSL_S_Exists_0   WHEN ((state = Idle) and (CU_Granted = '1'))ELSE 
							--FSL_S_Exists_0   WHEN ((state = Ready) and (CU_Granted = '1')) ELSE 
						'0';
						
	db_fsl	<= FSL_S_Exists_0   WHEN ((state = Idle) and (CU_Granted = '1'))ELSE 
						'0';
--	process(clk)
--	begin
--		if(rising_edge(clk)) then
--			if((state = Idle) and (CU_Granted = '1')) then
--				FSL_S_READ_reg <= FSL_S_Exists_0;
--			else
--				FSL_S_READ_reg <= '0';
--			end if;
--		else
--			FSL_S_READ_reg <= FSL_S_READ_reg;
--		end if;
--	end process;
	
--		FSL_S_Read_1  <= FSL_S_Exists_1   WHEN (((state = check_tag) and (RnW_s = '0')and (stall = '0'))) ELSE 
--						'0';	
	--change made march 19
	--FSL_S_Read_1  <= FSL_S_Exists_1   WHEN (((state = check_tag) and (RnW_s = '0')and (stall = '0'))) ELSE 
	FSL_S_Read_1  <= FSL_S_Exists_1   WHEN (((state = check_tag) and (RnW_s = '0') AND(RU_Granted /= '1'))) ELSE 
						  FSL_S_Exists_1 WHEN (state = cache_disabled) and (RnW_s = '0') ELSE
					'0';					
					
	FSL_M_Read_s <= FSL_S_Exists_1   WHEN (((state = check_tag) and (RnW_s = '0') AND(RU_Granted /= '1'))) ELSE 
						  FSL_S_Exists_1 WHEN (state = cache_disabled) and (RnW_s = '0') ELSE
					'0';							
					
	--FSL_S_Read_1  <= FSL_S_Exists_1   WHEN (((state = check_tag) and (RnW_s = '0')and (stall = '0')and (CU_Granted = '1'))) ELSE 
	--					'0';	

	--Prepare Read CACHE LINE
	--Data
	FSL_M_Data_s(35 downto 4) <= LINE_OUT(31 downto 0) WHEN ((state = Read_Hit) AND (Data_Bank_Done = '1')) ELSE
											LINE_OUT(63 downto 32) WHEN ((state = Read2)) ELSE
											LINE_OUT(95 downto 64) WHEN ((state = Read3)) ELSE
											LINE_OUT(127 downto 96) WHEN ((state = Read4)) ELSE
											NPI_DATA_OUT_2(31 downto 0) WHEN ((state = disabled_rb1)) ELSE
											NPI_DATA_OUT_2(63 downto 32) WHEN ((state = disabled_rb2)) ELSE
											NPI_DATA_OUT_2(95 downto 64) WHEN ((state = disabled_rb3)) ELSE
											NPI_DATA_OUT_2(127 downto 96) WHEN ((state = disabled_rb4)) ELSE
											--Check addr bit 4 to see if request is top or bottom of line.(bit 4 = 0 return bytes 0-3)
											returned_data_out(31 downto 0) WHEN((returned_state = Read_Returned) AND (returned_data_out(260) = '0')) ELSE
											returned_data_out(63 downto 32) WHEN((returned_state = Read_Returned2) AND (returned_data_out(260) = '0')) ELSE
											returned_data_out(95 downto 64) WHEN((returned_state = Read_Returned3) AND (returned_data_out(260) = '0')) ELSE
											returned_data_out(127 downto 96) WHEN((returned_state = Read_Returned4) AND (returned_data_out(260) = '0')) ELSE
											--Check addr bit 4 to see if request is top or bottom of line.(bit 4 = 1 return bytes 4-7)
											returned_data_out(159 downto 128) WHEN((returned_state = Read_Returned) AND (returned_data_out(260) = '1')) ELSE
											returned_data_out(191 downto 160) WHEN((returned_state = Read_Returned2) AND (returned_data_out(260) = '1')) ELSE
											returned_data_out(223 downto 192) WHEN((returned_state = Read_Returned3) AND (returned_data_out(260) = '1')) ELSE
											returned_data_out(255 downto 224);
											--(OTHERS => '0');
	
											
	--CPU ID
	FSL_M_Data_s(2 downto 1) <= cpu_id WHEN ((state = Read_Hit) AND (Data_Bank_Done = '1')) ELSE --Add more later
												cpu_id WHEN ((state = Read2) ) ELSE 
												cpu_id WHEN ((state = Read3)) ELSE 
												cpu_id WHEN ((state = Read4) ) ELSE 
												cpu_id WHEN ((state = disabled_rb1) ) ELSE 
												cpu_id WHEN ((state = disabled_rb2) ) ELSE 
												cpu_id WHEN ((state = disabled_rb3) ) ELSE 
												cpu_id WHEN ((state = disabled_rb4) ) ELSE 
												returned_data_out(292 downto 291); --WHEN(returned_state = Read_Returned) ELSE
											--(OTHERS => '0');
	--Only used if >4 CPUs										
	FSL_M_Data_s(3) <= '0';
	
	--Instruction/Not Data
	FSL_M_Data_s(0)  <= InD WHEN ((state = Read_Hit) AND (Data_Bank_Done = '1')) ELSE --Add more later
								InD WHEN ((state = Read2) ) ELSE
								InD WHEN ((state = Read3)) ELSE 
								InD WHEN ((state = Read4) ) ELSE 
								InD WHEN ((state = disabled_rb1) ) ELSE 
								InD WHEN ((state = disabled_rb2) ) ELSE 
								InD WHEN ((state = disabled_rb3) ) ELSE 
								InD WHEN ((state = disabled_rb4) ) ELSE 
							 returned_data_out(293);

	--FSL Write Signals

	FSL_M_Write_s <= '1' WHEN	(((state = Read_Hit) AND (Data_Bank_Done = '1')) OR
											(state = Read2) OR (state = Read3) OR (state = Read4) OR
										 (returned_state = Read_Returned) OR (returned_state = Read_Returned2) OR
										 (returned_state = Read_Returned3) OR (returned_state = Read_Returned4)) ELSE
							'1' WHEN ((state = disabled_rb1) OR (state = disabled_rb2) OR (state = disabled_rb3) OR (state = disabled_rb4) ) ELSE
										'0';
										
	Process(clk)
		begin
		if(rising_edge(clk)) then
			FSL_M_Write_reg <= FSL_M_Write_s;
			FSL_M_Data_reg <= FSL_M_Data_s;
		else
			FSL_M_Write_reg <= FSL_M_Write_reg;
			FSL_M_Data_reg <= FSL_M_Data_reg;
		end if;
	end process;
	
	FSL_M_Write_0 <= FSL_M_Write_s; --FSL_M_Write_reg;
	FSL_M_Data_0 <= FSL_M_Data_s; --FSL_M_Data_reg;
										
	FSL_M_Write_1 <= '1' WHEN (((state = write_hit) and (Data_Bank_Done = '1')) OR (state = Read4) OR (returned_state = Read_Returned4)
								OR ((returned_state = WRITE2) AND (returned_data_out(288) = '0') and (Data_Bank_Done = '1'))) ELSE '0';
	
---------------------------------------------------------------------
--Control Unit State Machine
---------------------------------------------------------------------

   Control_Unit: PROCESS (CLK) IS
		BEGIN  
		IF rising_edge(CLK) THEN
			-- Synchronous reset (active high)
			IF FSL_Rst = '1' THEN  
				state        <= Init;
				debug_state <= "1110";
			ELSE
				CASE state IS
					----------------------------------------
					--Init
					----------------------------------------
					--Wait for MPMC to be ready
					WHEN Init =>
						IF(NPI_InitDone = '1') THEN
							state <= Idle;
						ELSE
							state <= Init;
						END IF;
						debug_state <= "0000";
					----------------------------------------
					--Cache IDLE
					----------------------------------------
					WHEN Idle =>
						--IF ((FSL_S_Exists_0 = '1')) THEN --AND (CU_Granted = '1')) THEN
						 IF ((CU_Granted = '1')) THEN
								 state <=  Ready;--Check_Tag;
						 ELSE
							 state <= Idle;--Ready;
						 END IF;
						--ELSE
						--	state <= Idle;
						--End if;
						debug_state <= "0001";
					----------------------------------------
					--CU waiting for RU to finish
					----------------------------------------
					WHEN Ready =>
					--	IF ((FSL_S_Exists_0 = '1') AND (CU_Granted = '1')) THEN
						IF(disable_cache = '1') THEN
							state <= cache_disabled;
						ELSE
							IF ((CU_Granted = '1')AND(ring_buffer_full /= '1')) THEN
									state <= Check_Tag;
							ELSE
								state <= Ready;
							END IF;
						END IF;
						debug_state <= "0001";
					----------------------------------------
					--disable_cache
					----------------------------------------	
					WHEN cache_disabled =>
						IF(RnW_s = '1') THEN
						--read
							state <= disabled_read;
						ELSE
						--write
							state <= disabled_write;
						END IF;
						debug_state <= "1001";
					----------------------------------------
					--disabled_read
					----------------------------------------	
					WHEN disabled_write =>
						state <= write_wait;
						debug_state <= "1010";

					WHEN write_wait =>
						IF(NPI_TRANSFER_COMPLETE_2 = '1') THEN
							state <= idle;
						ELSE
							state <= write_wait;
						END IF;					
						debug_state <= "1011";
					----------------------------------------
					--disabled_read
					----------------------------------------	
					WHEN disabled_read =>
						state <= disabled_wait;
						debug_state <= "1100";
					----------------------------------------
					--disabled_wait
					----------------------------------------	
					WHEN disabled_wait =>
						IF(NPI_TRANSFER_COMPLETE_2 = '1') THEN
							state <= disabled_rb1;
						ELSE
							state <= disabled_wait;
						END IF;
						debug_state <= "1101";
					----------------------------------------
					--disabled_rb1
					----------------------------------------	
					WHEN disabled_rb1 =>
						state <= disabled_rb2;
						debug_state <= "1110";
				
					----------------------------------------
					--disabled_rb2
					----------------------------------------	
					WHEN disabled_rb2 =>
						state <= disabled_rb3;
						debug_state <= "1110";
					----------------------------------------
					--disabled_rb3
					----------------------------------------	
					WHEN disabled_rb3 =>
						state <= disabled_rb4;
						debug_state <= "1110";
					----------------------------------------
					--Check TAG 
					----------------------------------------
					--Check to see if it's a Cache Hit
					WHEN Check_Tag => 
						IF((stall /= '1') AND(RU_Granted /= '1')) THEN
							IF(hit_i = '1') THEN
								--It's a Cache HIT!! Hurrah!!
								--Check to see if it's a Read or a Write
								IF((RnW_s = '1') AND (data_in = x"00000000")) THEN --Data(0) = 1 then Read
									--Data Read
									state <= Read_Hit;
								ELSIF((RnW_s = '1') AND (data_in(0) = '1')) THEN --Data(1) = 1 then Invalidate
									--Invalidate Data
									IF((ring_buffer_match= '1') OR (returned_match = '1')
										OR (NPI_ADDR_s = address)) THEN
										-- Let return unit deal with it, because there's a 
										-- request in flight
										state <= RU_Invalidate;
									ELSE
										--CU will deal with invalidation, no request in flight
										state <= Invalidate;
									END IF;
								
								ELSE
									--Data Write
									state <= Write_Hit;
								END IF;
						ELSIF(valid_i /= '1') THEN
							--It's a miss, but there's an way with
							-- invalid data. So we don't need to evict
							IF((RnW_s = '1') AND (data_in(0) = '1')) THEN
								--It's an invalidate so no worries
								state <= Idle;
							else					
								state <= Get_Line;
							end if;
						ELSE
							IF((RnW_s = '1') AND (data_in(0) = '1')) THEN
								--It's an invalidate 
								IF((ring_buffer_match= '1') OR (returned_match = '1')
									OR (NPI_ADDR_s = address)) THEN
									--Request in flight, let RU deal with it
									state <= RU_Invalidate;
								ELSE
									--Not a big deal, nothing to invalidate
									state <= Idle;
								END IF;
							ELSE
								--It's Cache MISS! Bugger!
								--Now we need to:
								--1)EVICT a Line
								--2)REQUEST a new Line
								state <= Evict_Line1;
							END IF;
						END IF;
					ELSE
						state <= Check_Tag_Wait;
					END IF;
						debug_state <= "0010";
					----------------------------------------
					--Check TAG_Wait
					----------------------------------------
					--Check to see if it's a Cache Hit
					WHEN Check_Tag_Wait => 
						--IF((stall /= '1')) THEN --AND(CU_Granted = '1')) THEN
						--IF((stall /= '1') AND(CU_Granted = '1')) THEN
						IF((stall /= '1') AND(RU_Granted /= '1')) THEN
							IF(hit_i = '1') THEN
								--It's a Cache HIT!! Hurrah!!
								--Check to see if it's a Read or a Write
								IF((RnW_s = '1') AND (data_in = x"00000000")) THEN --Data(0) = 1 then Read
									--Data Read
									state <= Read_Hit;
								ELSIF((RnW_s = '1') AND (data_in(0) = '1')) THEN --Data(1) = 1 then Invalidate
									--Invalidate Data
									IF((ring_buffer_match= '1') OR (returned_match = '1')
										OR (NPI_ADDR_s = address)) THEN
										-- Let return unit deal with it, because there's a 
										-- request in flight
										state <= RU_Invalidate;
									ELSE
										--CU will deal with invalidation, no request in flight
										state <= Invalidate;
									END IF;
								
								ELSE
									--Data Write
									state <= Write_Hit;
								END IF;
						ELSIF(valid_i /= '1') THEN
							--It's a miss, but there's an way with
							-- invalid data. So we don't need to evict
							IF((RnW_s = '1') AND (data_in(0) = '1')) THEN
								--It's an invalidate so no worries
								state <= Idle;
							else					
								state <= Get_Line;
							end if;
						ELSE
							IF((RnW_s = '1') AND (data_in(0) = '1')) THEN
								--It's an invalidate 
								IF((ring_buffer_match= '1') OR (returned_match = '1')
									OR (NPI_ADDR_s = address)) THEN
									--Request in flight, let RU deal with it
									state <= RU_Invalidate;
								ELSE
									--Not a big deal, nothing to invalidate
									state <= Idle;
								END IF;
							ELSE
								--It's Cache MISS! Bugger!
								--Now we need to:
								--1)EVICT a Line
								--2)REQUEST a new Line
								state <= Evict_Line1;
							END IF;
						END IF;
					ELSE
						state <= Check_Tag_Wait;
					END IF;
						debug_state <= "0010";
					----------------------------------------
					--READ and Cache HIT
					----------------------------------------
					WHEN Read_Hit=>
						IF(Data_Bank_Done = '1') THEN
							--Read Complete
							--state <= Idle;
							state <= Read2;
						ELSE
							--Read Not Complete
							state <= Read_Hit;
						END IF;
						debug_state <= "0011";
					----------------------------------------
					--WRITE and Cache HIT
					----------------------------------------
					WHEN Write_Hit =>
						IF(Data_Bank_Done = '1') THEN
							--Write Complete
							state <= Idle;
						ELSE
							state <= Write_Hit;
						END IF;
						debug_state <= "0100";
					----------------------------------------
					--Evict a Line on a Miss
					----------------------------------------
					--Evict first 16 Bytes of the Line
					WHEN Evict_Line1=>
						IF(Data_Bank_Done = '1') THEN
							--Write Complete
							state <= Evict_Line2;
						ELSE
							state <= Evict_Line1;
						END IF;
						debug_state <= "0101";
					--Read second 16 Bytes of the Line	
					WHEN Evict_Line2=>
						IF(Data_Bank_Done = '1') THEN
							--Write Complete
							state <= Write_Back;
						ELSE
							state <= Evict_Line2;
						END IF;
						debug_state <= "0110";
					----------------------------------------
					--Write Back Line
					----------------------------------------
					--Add Write Back Data to Queue
					WHEN Write_back=>
							state <= Get_Line;
							debug_state <= "0111";
					----------------------------------------
					--Get next Line
					----------------------------------------
					--Request new Line 
					WHEN Get_Line=>
							state <= Idle;
							debug_state <= "1000";
					WHEN Read2=>
							state <= Read3;
							debug_state <= "1000";
					WHEN Read3 =>
							state <= Read4;
							debug_state <= "1000";
					----------------------------------------
					--Others...
					----------------------------------------
					WHEN OTHERS =>
						state <= Idle;
						debug_state <= "1111";
				END CASE;
			END IF;
		ELSE
			debug_state <= debug_state;
			state <= state;
		END IF;
	END PROCESS;



------------------------------------------------------------------
--Register Request
------------------------------------------------------------------
	--Register Control signals
	PROCESS(CLK)
		BEGIN
		IF(rising_edge(Clk)) THEN
			--IF((state = Idle) AND (FSL_S_Exists_0 = '1') AND (STALL = '0')) THEN
			IF((state = Idle) AND (FSL_S_Exists_0 = '1') ) THEN
				address(31 downto 2) <= FSL_S_Data_0(41 downto 12);
				address(1 downto 0) <= "00";
				--data_in <= FSL_S_Data_0(FSL_D_SLAVE-1 downto FSL_ADDR);
				byte_en <= FSL_S_DATA_0(11 downto 8);
				RnW_s <= FSL_S_DATA_0(7);
				cpu_id <= FSL_S_DATA_0(2 downto 1);
				InD <= FSL_S_DATA_0(0);
			END IF;
		ELSE
			address <= address;
			--data_in <= data_in;
			byte_en <= byte_en;
			RnW_s <= RnW_s;
			cpu_id <= cpu_id;
			InD <= InD;
		END IF;
	END PROCESS;
	
	--Register Data
	PROCESS(CLK)
		BEGIN
		IF(rising_edge(Clk)) THEN
			IF((state = Idle)) THEN --AND (FSL_S_Exists_0 = '1') AND (STALL = '0')) THEN
				data_in <= (others => '0');
			--ELSIF((state = check_tag) and (RnW_s = '0')AND (FSL_S_Exists_1 = '1')) THEN
			ELSIF((state = check_tag) and (RnW_s = '0') AND(RU_Granted /= '1')) THEN
				data_in <= FSL_S_Data_1(31 downto 0);
			ELSIF(state = cache_disabled) and (RnW_s = '0') THEN
				data_in <= FSL_S_Data_1(31 downto 0);
			ELSE
				data_in <= data_in;
			END IF;
		ELSE
			data_in <= data_in;
		END IF;
	END PROCESS;



---------------------------------------------------------------------
--Detect a match
---------------------------------------------------------------------

	process (match_bank, valid_bank, hit_i)
		variable match_temp   : std_logic := '0';
		variable valid_temp   : std_logic := '0';
		variable selected_set_temp : integer := 0;
		variable stack_temp : integer := 0;
		variable selected_invalid_temp : integer := 0;
	begin
		--stack_temp := LRU_SET;
		selected_set_temp := LRU_SET;
		selected_invalid_temp := 0;
		match_temp        := '0';
		valid_temp        := '1';
		for i in 0 to NUMBER_OF_WAYS-1 loop
			match_temp := match_temp or (match_bank(i) and valid_bank(i));
			--valid_temp := valid_temp and valid_bank(i);
			
			--Check to see if it's a match, and the data is valid
			if (match_bank(i) = '1' and valid_bank(i) = '1') then
				--Keep track of which way has a hit
				selected_set_temp := i;
			end if;
			--Find an invalid way incase there's not a hit
			--Commented for testing!
			if ((valid_bank(i) = '0') or (valid_temp = '0')) then
			--if ((valid_bank(3) = '0') or (valid_temp = '0')) then
				--Keep track of invalid ways
				if(valid_bank(i) = '0') then
					selected_invalid_temp := i;
				else
					selected_invalid_temp := selected_invalid_temp;
				end if;
				valid_temp := '0';
			end if;
		end loop;
		
		--Assign variables to signals 
		valid_i <= valid_temp;
		hit_i  <= match_temp; --and valid_temp;
		selected_set <= selected_set_temp;
		
		--commented for testing
		selected_invalid <= selected_invalid_temp;
		--selected_invalid <= 3;
		
	end process;
	
	--Select Way
	Process(Clk)
		BEGIN
		IF(rising_edge(Clk)) THEN
			IF((state = Check_Tag) OR (state = Check_Tag_Wait)) THEN
				IF(hit_i = '1') THEN
					--There was a hit. Get data from that way
					Way_number <= selected_set;
					way_db <= "00";
				ELSIF(valid_i = '0') THEN
					--Except it's actually a miss. Maybe one of the
					--ways is invalid...
					Way_number <= selected_invalid;
					way_db <= "01";
				ELSE
					--Nope. Better evict a way 
					--Way_number <= to_integer(unsigned(rpolicy_bits_to_RAM(1 downto 0)));
					Way_number <= to_integer(unsigned(rpolicy_bits_from_RAM(1 downto 0)));
					way_db <= "10";
				END IF;
			ELSE
				Way_number <= Way_number;
				way_db <= way_db;
			END IF;
		ELSE
			Way_number <= Way_number;
			way_db <= way_db;
		END IF;
	END PROCESS;

	
---------------------------------------------------------------------
-- Data Bank
---------------------------------------------------------------------

	data_bank_i: data_bank
		GENERIC MAP (GENERIC MAP (
			WAYS => 4
		)
		PORT MAP(
			--Control signals
			CLK => CLK,           
			RESET => FSL_Rst,         
			Line_addr => data_bank_address(17 downto 4),			
			--Word_addr => data_bank_address(Word_WIDTH-1 downto 0),
			Word_addr => data_bank_address(3 downto 2),			
			Way_number => db_Way_number,			
			LINE_IN => LINE_IN,     	
			LOAD_LINE => LOAD_LINE,
			LINE_OUT => LINE_OUT,
			READ_LINE => READ_LINE,
			done => Data_Bank_Done,
			LOAD_WORD => LOAD_WORD,
			byte_en => db_byte_en,
			CE_not => CE_not_s,			
			CE2 => CE2_s,			
			CE2_not =>CE2_not,	
			ADV => ADV,				
			WE_not => WE_not_s,		 
			BWa_not => BWa_not_s,		
			BWb_not => BWb_not_s,	
			BWc_not => BWc_not_s,		
			BWd_not => BWd_not_s,	
			OE_not => OE_not_s,		
			CKE_not => CKE_not,
			SRAM_CLK	=> SRAM_CLK,	
			A => A_s,			
			Data => Data,			
			Data_I => Data_I_S,		
			Data_O => Data_O_s,			
			Data_T => Data_T,
			debug => db_debug
	 );
	 
	 --Debug signals 
	Data_O <= Data_O_s;
	Data_I_s <= Data_I;
	A <= A_s;
	BWa_not 	<= BWa_not_s; 
	BWb_not	<= BWb_not_s; 
	BWc_not	<= BWc_not_s; 
	BWd_not	<= BWd_not_s;
	CE_not <= CE_not_s;			
	CE2 <= CE2_s;			
	OE_not <= OE_not_s;		
	WE_not <= WE_not_S;			
	
	--Select Address for Data bank	
	data_bank_address <= address WHEN ((state = Read_Hit) or (state = Write_Hit)) ELSE  --Read hit
								address(31 downto 5) & "00000" WHEN (state = Evict_Line1) ELSE --Evict first half of line
								address(31 downto 5) & "10000" WHEN (state = Evict_Line2) ELSE --Evict second half of line
								returned_data_out(287 downto 261) & "00000" WHEN (returned_state = Write1) ELSE --Write first half of line
								returned_data_out(287 downto 261) & "10000" WHEN (returned_state = Write2) ELSE --Write second half of line
								(others => '0');
	--Data into Data Bank
	--Use for Write hits, and misses
	LINE_IN(31 downto 0) <= data_in WHEN (state = Write_Hit) ELSE
									returned_data_out(31 downto 0) WHEN (returned_state = Write1) ELSE
									returned_data_out(159 downto 128);
	--Line into Data Bank
	--Only used on misses
	LINE_IN(127 downto 32) <= returned_data_out(127 downto 32) WHEN (returned_state = Write1)  ELSE
										returned_data_out(255 downto 160);
	--Used on Misses
	LOAD_LINE <= '1' WHEN (((returned_state = Write1) OR (returned_state = Write2)) AND (Data_Bank_Done /= '1')) ELSE '0';
	
	--Used on Read Hits, and Evictions
	READ_LINE <= '1' WHEN (((state = Read_Hit) OR (state = Evict_Line1) OR (state = Evict_Line2)) AND (Data_Bank_Done /= '1')) ELSE
						'0';
	--Used on Write Hits					
	LOAD_WORD <= '1' WHEN ((state = Write_Hit) and (Data_Bank_Done /= '1')) ELSE
						'0';
	--Byte enables					
	db_byte_en <= byte_en WHEN (state = Write_Hit) ELSE "1111";--returned_data_out(298 downto 295);
	
	--change made 3 2014
	--Way Number for Data Bank
	db_Way_number <= to_integer(unsigned(returned_data_out(290 downto 289))) WHEN (returned_state /= idle) ELSE
							Way_Number;
	
	
	--Register Evicted Data
	Process(CLK)
	BEGIN
		IF(rising_edge(CLK)) THEN
			IF((state = Evict_Line1) AND (Data_Bank_Done = '1'))THEN
				--Evicted Data
				--Bytes 3 downto 0
				Evicted_data(127 downto 0) <= LINE_OUT;
				--Bytes 7 downto 4
				Evicted_data(255 downto 128) <= Evicted_data(255 downto 128);
				--############################################################
				--Need to check this section when testing!!!  (change made may 8 2012)
				--############################################################
				
				--Evicted Address
				--Word and byte Address
				Evicted_data(260 downto 256) <= "00000"; --when state = evict_line1 else
															--"10000";
				--Line 											
				Evicted_data(273 downto 261) <= TAG_ADDRESS; 
				--Tag
				IF(Way_Number = 0) THEN
					Evicted_data(287 downto 274) <= Old_Tag_ss(13 downto 0);
				ELSIF(Way_Number = 1) THEN
					Evicted_data(287 downto 274) <= Old_Tag_ss(27 downto 14);
				ELSIF(Way_Number = 2) THEN
					Evicted_data(287 downto 274) <= Old_Tag_ss(41 downto 28);
				ELSE
					Evicted_data(287 downto 274) <= Old_Tag_ss(55 downto 42);
				END IF;
				
				--############################################################

				
				Evicted_data(288) <= '0'; --New Request/Not Evict
				Evicted_data(292) <= '0'; 
			ELSIF((state = Evict_Line2) AND (Data_Bank_Done = '1'))THEN
				Evicted_data(127 downto 0) <= Evicted_data(127 downto 0);
				Evicted_data(255 downto 128) <= LINE_OUT;
				Evicted_data(288 downto 256) <= Evicted_data(288 downto 256);
				Evicted_data(292) <= '0';
			ELSE
				Evicted_data <= Evicted_data;
			END IF;
		ELSE
			Evicted_data <= Evicted_data;
		END IF;
	END PROCESS;
	
---------------------------------------------------------------------	
--TAG BANK
---------------------------------------------------------------------

	tags: FOR i IN 0 TO NUMBER_OF_WAYS -1 GENERATE
		tag_bank_i: tag_bank
			Generic MAP (
			BANK_NUMBER => i
			)
			PORT MAP (
				CLK => Clk, 
				WRITE_EN => Write_EN(i),     
				TAG_ADDRESS => TAG_ADDRESS,    
				NEW_TAG => tag(TAG_WIDTH*(i+1)-1 downto TAG_WIDTH*i),
				Old_Tag => Old_Tag_s(TAG_WIDTH*(i+1)-1 downto TAG_WIDTH*i),
				SET_VALID => valid_s(i),        
				TAG_IN => match_tag,                  
				VALID => valid_bank(i),              
				MATCH => match_bank(i)          
		);	
	END GENERATE;

	--Register Old tag. Only used for writing back evicted Data
	--Registered to help with timing. 
	process(clk)
	begin
		if(rising_edge(clk)) then
			Old_Tag_ss <= Old_Tag_s;
		else
			Old_Tag_ss <= Old_Tag_ss;
		end if;
	end process;

	Enables: FOR i IN 0 TO NUMBER_OF_WAYS -1 GENERATE
		
		
--		WRITE_EN(i) <= '1' WHEN (((state = Write_Hit) OR (state = Read_Hit) OR (state = Invalidate) Or (state = Evict_Line2)) AND (i = Way_number))  ELSE
--							'1' WHEN (((returned_state = Write1) OR (returned_state = Write2) OR (returned_state = Invalidate)) 
--								AND (i = to_integer(unsigned(returned_data_out(290 downto 289)))))  ELSE
--						'0';
--change made feb 4 2014

		--Write on evictions, invalidations, and missed returns 
		
		--WRITE_EN(i) <= '1' WHEN (((state = Invalidate) Or (state = Evict_Line2)) AND (i = Way_number))  ELSE
		WRITE_EN(i) <= '1' WHEN ((state = Invalidate) AND (i = Way_number))  ELSE --Or (state = Write_Back)) AND (i = Way_number))  ELSE
							--'1' WHEN (((returned_state = Write1) OR (returned_state = Write2) OR (returned_state = Invalidate)))  ELSE
							--'1' WHEN(((returned_state = Read_Returned)OR (returned_state = Invalidate))
								--'1' WHEN((((returned_state = WRITE2))  OR (returned_state = Invalidate))
								'1' WHEN((((returned_state = WRITE1))  OR (returned_state = Invalidate))
							 AND (i = to_integer(unsigned(returned_data_out(290 downto 289)))))  ELSE
						'0';
						
				
						
						
		tag(TAG_WIDTH*(i+1)-1 downto TAG_WIDTH*i) <= returned_data_out(287 downto 274) WHEN 
																	((returned_state /= IDLE) AND (i = to_integer(unsigned(returned_data_out(290 downto 289)))))  ELSE
																	--Write tag on return data, otherwise it's invalid so tag doesn't matter
				 --address(31 downto 18) when (i = Way_number) ELSE
				 --Old_Tag_s(TAG_WIDTH*(i+1)-1 downto TAG_WIDTH*i);	
				(others => '0'); --should never get here

		valid_s(i) <= 	'1' WHEN (((returned_state /= IDLE))AND (i = to_integer(unsigned(returned_data_out(290 downto 289))))) ELSE 
							'0';	
	
	END GENERATE;
					
	--change made feb 4
	
	match_tag <= address(31 downto 18);
	
	--Line = 16 bits = #lines in SRAM/4 for 4 way cache
--	TAG_ADDRESS <= address(17 downto 5) WHEN ((state = Write_Hit) OR (state = Read_Hit) OR (state = Check_Tag) OR 
--							(state = Invalidate) OR (state = Write_Back) Or (state = Evict_Line2))  ELSE
--						 returned_data_out(273 downto 261);
						
	--TAG_ADDRESS <= returned_data_out(273 downto 261) WHEN (returned_state /= IDLE) ELSE
	TAG_ADDRESS <= returned_data_out(273 downto 261) WHEN (returned_state = Write1) ELSE
						 address(17 downto 5);					

	
---------------------------------------------------------------------
--LRU POLICY 
---------------------------------------------------------------------
reuse_bank_i: reuse_bank
	PORT MAP (
		CLK => Clk, 
		WRITE_EN => RU_Write_EN,     
		TAG_ADDRESS => TAG_ADDRESS,       
		RPOLICY_BITS_IN => rpolicy_bits,--rpolicy_bits_to_RAM,
		RPOLICY_BITS_OUT => rpolicy_bits_from_RAM                     
	);	

--		RU_WRITE_EN <= '1' WHEN ((state = Write_Hit) OR (state = Read_Hit)) ELSE
--							'1' WHEN((returned_state = Read_Returned)) ELSE-- OR (returned_state = Invalidate)) ELSE
--						'0';
		--Only update LRU on hits, and returns
	--COMENTED OUT FOR TESTING PURPOSES	
		RU_WRITE_EN <= '1' WHEN (((state = Write_Hit) OR (state = Read_Hit)) AND (Data_Bank_Done = '1')) ELSE
							--'1' WHEN((returned_state = Read_Returned)) ELSE-- OR (returned_state = Invalidate)) ELSE
							'1' WHEN(((returned_state = WRITE1))) ELSE-- OR (returned_state = Invalidate)) ELSE
					'0';
						
	--Register LRU stack. Helps with timing
	process(clk)
	begin
		if(rising_edge(clk)) then
			--if(((state = Write_Hit) OR (state = Read_Hit))) then
				rpolicy_bits_hit <= rpolicy_bits_to_RAM;
			--else
			--	rpolicy_bits_hit <= rpolicy_bits_hit;
			--end if;
		else
			rpolicy_bits_hit <= rpolicy_bits_hit;
		end if;
	end process;

	
	process(clk)
	begin
		if(rising_edge(clk)) then
			if((returned_state = Write2)) then
				rpolicy_bits_returned <= rpolicy_bits_to_RAM;
			else
				rpolicy_bits_returned <= rpolicy_bits_returned;
			end if;
		else
			rpolicy_bits_returned <= rpolicy_bits_returned;
		end if;
	end process;
	
	--rpolicy_bits <= rpolicy_bits_returned  WHEN((returned_state = Read_Returned)) ELSE --OR (returned_state = Invalidate)) else
	rpolicy_bits <= rpolicy_bits_hit; --rpolicy_bits_returned  WHEN(((returned_state = WRITE2))) ELSE --OR (returned_state = Invalidate)) else
							--rpolicy_bits_hit;
	

	 Replacement_policy: LRU_policy
		PORT MAP (
			stack_pos => stack_pos,
			debug => debug_lru,
			LRU_STACK_IN => rpolicy_bits_from_RAM, --rpolicy_bits,
			LRU_STACK_OUT => rpolicy_bits_to_RAM
		);

	--ADDED FEB 4
	stack_pos <= to_integer(unsigned(returned_data_out(290 downto 289))) when (returned_state /= idle) ELSE

					selected_set;	
					
---------------------------------------------------------------------
--Ouput to MPMC
---------------------------------------------------------------------

	--Ring Buffer
	--Holds a queue of missed requests

	output_buffer: ring_buffer
		Generic MAP (
			DATA_WIDTH => 293,
			BUFFER_DEPTH => 5
		)
		Port MAP ( 
			clk => Clk,
			rst => FSL_Rst,
			data_in => ring_buffer_data_in,
			load_data => ring_buffer_load_data,
			read_data => ring_buffer_read_data,
			data_out => ring_buffer_data_out,
			buffer_full => ring_buffer_full,
			empty => ring_buffer_empty,
			done => ring_buffer_done,
			valids => ring_buffer_valids,
			matchs => ring_buffer_matchs,
			compare => ring_buffer_compare,
			address => address,
			match => ring_buffer_nu	
		);

	--Check to see if a request is inflight for same address.
	ring_buffer_match <= '1' when ((ring_buffer_valids(0) = '1') and (ring_buffer_matchs(0) = '1')) else
								'1' when ((ring_buffer_valids(1) = '1') and (ring_buffer_matchs(1) = '1')) else
								'1' when ((ring_buffer_valids(2) = '1') and (ring_buffer_matchs(2) = '1')) else
								'1' when ((ring_buffer_valids(3) = '1') and (ring_buffer_matchs(3) = '1')) else
								'1' when ((ring_buffer_valids(4) = '1') and (ring_buffer_matchs(4) = '1')) else
								'0';
	
	--Always check. Because... why not?
	returned_compare <= '1'; --when State = check_tag else '0';
	
	--Load Buffer with either Evicted Data or a Missed Request
	ring_buffer_data_in(291 downto 0) <= Evicted_Data (291 downto 0) WHEN (State = Write_Back) ELSE
					Missed_Request (291 downto 0);
	--Tells return unit that it's an invalidation and it needs to deal with it
	ring_buffer_data_in(292) <= '1' WHEN (state = RU_Invalidate) ELSE
											'0';
					
	ring_buffer_load_data <= '1' WHEN (((State = Write_Back) OR (State = Get_Line) OR (state = RU_Invalidate)) AND (ring_buffer_full /= '1')) ELSE
										'0';
	---------------------------------                        --OR
	ring_buffer_read_data <= '1' WHEN (((State /= Write_Back) AND (State /= Get_Line)) 
									AND (npi_state = Idle) AND (ring_buffer_empty /= '1')) ELSE
									'0';
	--	ring_buffer_read_data <= '1' WHEN (((State /= Write_Back) OR (State /= Get_Line)) 
	--								AND (npi_state = Transfer)) ELSE --AND (ring_buffer_empty /= '1')) ELSE
	--								'0';
	--Add missed request to Buffer 
	---needs to make sure first half of line
	Missed_Request(31 downto 0) <= address; --when address(4) = '0' ELSE  address(31 downto 5) & "0" & address(3 downto 0);
	Missed_Request(63 downto 32) <= Data_In;
	Missed_Request(67 downto 64) <= Byte_en;
	Missed_Request(68) <= RnW_s;
	Missed_Request(70 downto 69) <= CPU_ID;
	Missed_Request(71) <= InD;
	Missed_Request(287 downto 72) <= (others => '0'); 
	Missed_Request(288) <= '1'; --New Request/Not Evict
	Missed_Request(290 downto 289) <= STD_LOGIC_VECTOR(TO_UNSIGNED(Way_number,2));
	Missed_Request(292) <= '0'; --Invalidate

	

------------------------------------------------------------------
--NPI INTERFACE
------------------------------------------------------------------

------------------------------------------------------------------
--Instantiate NPI Interface
------------------------------------------------------------------

NPI_interface: NPI
	PORT MAP (
		CLK => Clk,
		RST => FSL_Rst,
		ADDR => NPI_ADDR_s,
		RQST => NPI_RQST,        
		RNW => NPI_RNW_s,                 
		DATA_IN => NPI_Data_in,         
		DATA_OUT => NPI_DATA_Out,            
		DATA_VALID_IN => NPI_DATA_Valid_In,      
		DATA_VALID_OUT => NPI_DATA_Valid_Out,     
		TRANSFER_COMPLETE => NPI_Transfer_Complete,
		--		
		NPI_Addr => NPI_Addr_ss,        
		NPI_AddrReq => NPI_AddrReq,         
		NPI_AddrAck => NPI_AddrAck,          
		NPI_RNW => NPI_RNW,              
		NPI_Size => NPI_Size,            
		NPI_WrFIFO_Data => NPI_WrFIFO_Data_s,		
		NPI_WrFIFO_BE => NPI_WrFIFO_BE,      
		NPI_WrFIFO_Push => NPI_WrFIFO_Push,   
		NPI_RdFIFO_Data => NPI_RdFIFO_Data,      
		NPI_RdFIFO_Pop => NPI_RdFIFO_Pop,       
		NPI_RdFIFO_RdWdAddr => NPI_RdFIFO_RdWdAddr,    
		NPI_WrFIFO_Empty => NPI_WrFIFO_Empty,     
		NPI_WrFIFO_AlmostFull => NPI_WrFIFO_AlmostFull,
		NPI_WrFIFO_Flush => NPI_WrFIFO_Flush,     
		NPI_RdFIFO_Empty => NPI_RdFIFO_Empty,      
		NPI_RdFIFO_Flush => NPI_RdFIFO_Flush,    
		NPI_RdFIFO_Latency => NPI_RdFIFO_Latency,   
		NPI_RdModWr => NPI_RdModWr,         
		NPI_InitDone => NPI_InitDone,          
		debug => debug_s1						 
	);
	NPI_Addr <= NPI_Addr_ss;
	--NPI_WrFIFO_Data_s <= NPI_WrFIFO_Data_ss;
	NPI_WrFIFO_Data <= NPI_WrFIFO_Data_s;
	
	
NPI_interface2: NPI2
port map (
		--wrapper interface
		CLK => CLK,
		RST => FSL_Rst,
		ADDR => NPI_ADDR_s2,               
		RQST => NPI_RQST_2,          
		Word_nBurst => Word_nBurst,			
		RNW => NPI_RNW_s2,            
		DATA_IN => NPI_DATA_IN_2,  
		NPI_BE => byte_en,
		DATA_OUT => NPI_DATA_OUT_2,            
		DATA_VALID_IN => NPI_DATA_VALID_IN_2,        
		DATA_VALID_OUT => NPI_DATA_VALID_OUT_2,    
		return_ready => NPI_return_ready	,		 
		TRANSFER_COMPLETE => NPI_TRANSFER_COMPLETE_2,     

		--NPI interface
		NPI_Addr => NPI_Addr2,
		NPI_AddrReq => NPI_AddrReq2,         
		NPI_AddrAck  => NPI_AddrAck2,         
		NPI_RNW => NPI_RNW2,            
		NPI_Size => NPI_Size2,             
		NPI_WrFIFO_Data => NPI_WrFIFO_Data2,       
		NPI_WrFIFO_BE => NPI_WrFIFO_BE2,        
		NPI_WrFIFO_Push => NPI_WrFIFO_Push2,       
		NPI_RdFIFO_Data => NPI_RdFIFO_Data2,   
		NPI_RdFIFO_Pop => NPI_RdFIFO_Pop2,       
		NPI_RdFIFO_RdWdAddr => NPI_RdFIFO_RdWdAddr2,   
		NPI_WrFIFO_Empty => NPI_WrFIFO_Empty2,    
		NPI_WrFIFO_AlmostFull => NPI_WrFIFO_AlmostFull2, 
		NPI_WrFIFO_Flush => NPI_WrFIFO_Flush2,      
		NPI_RdFIFO_Empty => NPI_RdFIFO_Empty2,     
		NPI_RdFIFO_Flush => NPI_RdFIFO_Flush2,     
		NPI_RdFIFO_Latency => NPI_RdFIFO_Latency2,   
		NPI_RdModWr => NPI_RdModWr2,           
		NPI_InitDone => NPI_InitDone2,          
		debug	=> NPI2_debug					 
	);	
	
	NPI_ADDR_s2 <= address;
	NPI_RQST_2 <= '1' when (state = disabled_write) else
						'1' when (state = disabled_read) else
						'0';
	NPI_RNW_s2 <= '1' when (state = disabled_read) else 
						'1' when (state = disabled_wait) else 
						'0';
	Word_nBurst <= '1' when (state = disabled_write) else
						'1' when (state = write_wait) else
						'0';
	NPI_DATA_IN_2 <= data_in;
	NPI_DATA_VALID_IN_2 <= '1' when (state = disabled_write) else 
						'0';
	
------------------------------------------------------------------
--Assign NPI Signals
------------------------------------------------------------------
	
	--NPI State Machine
	
	PROCESS(CLK)
		BEGIN
		IF(rising_edge(clk)) THEN
			IF(npi_state = IDLE) THEN
				IF((ring_buffer_empty /= '1') AND ((State /= Write_Back) AND (State /= Get_Line)))
				THEN
					npi_state <= Get_data;
				ELSE
					npi_state <= Idle;
				END IF;
				--debug(122 downto 121) <= "00";
			ELSIF(npi_state = Get_data) THEN
				IF(ring_buffer_data_out(292) = '0') THEN
					npi_state <= Transfer;
				ELSE
					npi_state <= IDLE;
				END IF;
				--debug(122 downto 121) <= "01";
			ELSIF(npi_state = Transfer) THEN
				IF(NPI_Transfer_Complete = '1') THEN
					if(NPI_RNW_s = '1') THEN
						npi_state <= Idle;
					ELSE
						npi_state <= Wait_1;
					end if;
				ELSE
					npi_state <= Transfer;
				END IF;
				--debug(122 downto 121) <= "10";
			ELSE
				npi_state <= IDLE;
				--debug(122 downto 121) <= "11";
			END IF;
		ELSE
			npi_state <= npi_state;
		END IF;
	END PROCESS;
	
	--Process(Clk)
	--Begin
	--	IF(rising_edge(clk)) Then
	--		IF(returned_read_data = '1') THEN
				NPI_ADDR_s <= ring_buffer_data_out(287 downto 256) WHEN (ring_buffer_data_out(288) = '0') ELSE--(Missed_Request(288) = '0') ELSE
									ring_buffer_data_out(31 downto 0)	;
	--		ELSE
	NPI_RQST <= '1' WHEN (npi_state = Transfer) AND (NPI_Transfer_Complete = '0') ELSE '0';	
	NPI_RNW_s <= ring_buffer_data_out(288);             
	NPI_Data_in <=ring_buffer_data_out (255 downto 0);                    
	NPI_DATA_Valid_In <= '1' WHEN (npi_state = Transfer) ELSE '0';	



	--Assign returned data
		--Also check Byte Enables. 
	RETURN_LINE_IN(7 downto 0) <= ring_buffer_data_out(39 downto 32) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "000") AND (ring_buffer_data_out(64) = '1') ) else
											 NPI_DATA_Out(7 downto 0);
	RETURN_LINE_IN(15 downto 8) <= ring_buffer_data_out(47 downto 40) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "000") AND (ring_buffer_data_out(65) = '1') ) else
											NPI_DATA_Out(15 downto 8);
	RETURN_LINE_IN(23 downto 16) <= ring_buffer_data_out(55 downto 48) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "000") AND (ring_buffer_data_out(66) = '1') ) else
											NPI_DATA_Out(23 downto 16);
	RETURN_LINE_IN(31 downto 24) <= ring_buffer_data_out(63 downto 56) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "000") AND (ring_buffer_data_out(67) = '1') ) else
											NPI_DATA_Out(31 downto 24);
											
											
	RETURN_LINE_IN(39 downto 32) <= ring_buffer_data_out(39 downto 32) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "001") AND (ring_buffer_data_out(64) = '1') ) else
											 NPI_DATA_Out(39 downto 32);
	RETURN_LINE_IN(47 downto 40) <= ring_buffer_data_out(47 downto 40) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "001") AND (ring_buffer_data_out(65) = '1') ) else
											NPI_DATA_Out(47 downto 40);
	RETURN_LINE_IN(55 downto 48) <= ring_buffer_data_out(55 downto 48) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "001") AND (ring_buffer_data_out(66) = '1') ) else
											NPI_DATA_Out(55 downto 48);
	RETURN_LINE_IN(63 downto 56) <= ring_buffer_data_out(63 downto 56) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "001") AND (ring_buffer_data_out(67) = '1') ) else
											NPI_DATA_Out(63 downto 56);										
	
	
	RETURN_LINE_IN(71 downto 64) <= ring_buffer_data_out(39 downto 32) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "010") AND (ring_buffer_data_out(64) = '1') ) else
											 NPI_DATA_Out(71 downto 64);
	RETURN_LINE_IN(79 downto 72) <= ring_buffer_data_out(47 downto 40) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "010") AND (ring_buffer_data_out(65) = '1') ) else
											NPI_DATA_Out(79 downto 72);
	RETURN_LINE_IN(87 downto 80) <= ring_buffer_data_out(55 downto 48) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "010") AND (ring_buffer_data_out(66) = '1') ) else
											NPI_DATA_Out(87 downto 80);
	RETURN_LINE_IN(95 downto 88) <= ring_buffer_data_out(63 downto 56) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "010") AND (ring_buffer_data_out(67) = '1') ) else
											NPI_DATA_Out(95 downto 88);
	
	
	RETURN_LINE_IN(103 downto 96) <= ring_buffer_data_out(39 downto 32) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "011") AND (ring_buffer_data_out(64) = '1') ) else
											 NPI_DATA_Out(103 downto 96);
	RETURN_LINE_IN(111 downto 104) <= ring_buffer_data_out(47 downto 40) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "011") AND (ring_buffer_data_out(65) = '1') ) else
											NPI_DATA_Out(111 downto 104);
	RETURN_LINE_IN(119 downto 112) <= ring_buffer_data_out(55 downto 48) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "011") AND (ring_buffer_data_out(66) = '1') ) else
											NPI_DATA_Out(119 downto 112);
	RETURN_LINE_IN(127 downto 120) <= ring_buffer_data_out(63 downto 56) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "011") AND (ring_buffer_data_out(67) = '1') ) else
											NPI_DATA_Out(127 downto 120);
	
	
	RETURN_LINE_IN(135 downto 128) <= ring_buffer_data_out(39 downto 32) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "100") AND (ring_buffer_data_out(64) = '1') ) else
											 NPI_DATA_Out(135 downto 128);
	RETURN_LINE_IN(143 downto 136) <= ring_buffer_data_out(47 downto 40) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "100") AND (ring_buffer_data_out(65) = '1') ) else
											NPI_DATA_Out(143 downto 136);
	RETURN_LINE_IN(151 downto 144) <= ring_buffer_data_out(55 downto 48) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "100") AND (ring_buffer_data_out(66) = '1') ) else
											NPI_DATA_Out(151 downto 144);
	RETURN_LINE_IN(159 downto 152) <= ring_buffer_data_out(63 downto 56) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "100") AND (ring_buffer_data_out(67) = '1') ) else
											NPI_DATA_Out(159 downto 152);
	

	RETURN_LINE_IN(167 downto 160) <= ring_buffer_data_out(39 downto 32) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "101") AND (ring_buffer_data_out(64) = '1') ) else
											 NPI_DATA_Out(167 downto 160);
	RETURN_LINE_IN(175 downto 168) <= ring_buffer_data_out(47 downto 40) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "101") AND (ring_buffer_data_out(65) = '1') ) else
											NPI_DATA_Out(175 downto 168);
	RETURN_LINE_IN(183 downto 176) <= ring_buffer_data_out(55 downto 48) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "101") AND (ring_buffer_data_out(66) = '1') ) else
											NPI_DATA_Out(183 downto 176);
	RETURN_LINE_IN(191 downto 184) <= ring_buffer_data_out(63 downto 56) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "101") AND (ring_buffer_data_out(67) = '1') ) else
											NPI_DATA_Out(191 downto 184);	


	RETURN_LINE_IN(199 downto 192) <= ring_buffer_data_out(39 downto 32) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "110") AND (ring_buffer_data_out(64) = '1') ) else
											 NPI_DATA_Out(199 downto 192);
	RETURN_LINE_IN(207 downto 200) <= ring_buffer_data_out(47 downto 40) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "110") AND (ring_buffer_data_out(65) = '1') ) else
											NPI_DATA_Out(207 downto 200);
	RETURN_LINE_IN(215 downto 208) <= ring_buffer_data_out(55 downto 48) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "110") AND (ring_buffer_data_out(66) = '1') ) else
											NPI_DATA_Out(215 downto 208);
	RETURN_LINE_IN(223 downto 216) <= ring_buffer_data_out(63 downto 56) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "110") AND (ring_buffer_data_out(67) = '1') ) else
											NPI_DATA_Out(223 downto 216);	
											
	RETURN_LINE_IN(231 downto 224) <= ring_buffer_data_out(39 downto 32) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "111") AND (ring_buffer_data_out(64) = '1') ) else
											 NPI_DATA_Out(231 downto 224);
	RETURN_LINE_IN(239 downto 232) <= ring_buffer_data_out(47 downto 40) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "111") AND (ring_buffer_data_out(65) = '1') ) else
											NPI_DATA_Out(239 downto 232);
	RETURN_LINE_IN(247 downto 240) <= ring_buffer_data_out(55 downto 48) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "111") AND (ring_buffer_data_out(66) = '1') ) else
											NPI_DATA_Out(247 downto 240);
	RETURN_LINE_IN(255 downto 248) <= ring_buffer_data_out(63 downto 56) when ((ring_buffer_data_out(68) = '0') AND 
											(ring_buffer_data_out(4 downto 2) = "111") AND (ring_buffer_data_out(67) = '1') ) else
											NPI_DATA_Out(255 downto 248);												 

------------------------------------------------------------------
--Returned Request Buffer
------------------------------------------------------------------

		returned_buffer: ring_buffer_returned
		Generic MAP (
			DATA_WIDTH => 299,
			BUFFER_DEPTH => 4
		)
		Port MAP ( 
			clk => Clk,
			rst => FSL_Rst,
			--Data
			data_in(255 downto 0) => RETURN_LINE_IN,
			--Address
			data_in(287 downto 256) => returned_data_in(31 downto 0),
			--RnW
			--data_in(288) => ring_buffer_data_out(288),
			data_in(288) => ring_buffer_data_out(68),--request_RnW,
			--Way Number
			data_in(290 downto 289) => ring_buffer_data_out(290 downto 289),--request_way_number,
			--CPU ID
			data_in(292 downto 291) => ring_buffer_data_out(70 downto 69),--request_CPU,
			--Instruction Cache/Not Data Cache
			data_in(293) => ring_buffer_data_out(71),--request_InD,
			data_in(294) => returned_data_in(32),
			--Byte Enables
			data_in(298 downto 295) => ring_buffer_data_out(67 downto 64),
			load_data =>  returned_load_data,
			read_data => returned_read_data,
			data_out => returned_data_out,
			buffer_full => returned_full,
			done => returned_done,
			empty => returned_empty,
			compare => returned_compare,
			address => address,
			match => returned_match	
		);


		

		returned_compare <= '1'; --when state = check_tag else '0';

		returned_data_in(31 downto 0) <= ring_buffer_data_out(31 downto 0); --WHEN ((npi_state = Get_data) AND (ring_buffer_data_out(292) = '1')) ELSE
													--request_address;
		returned_data_in(32) <= ring_buffer_data_out(292) WHEN ((npi_state = Get_data) AND (ring_buffer_data_out(292) = '1')) ELSE
										'0';

		returned_read_data <= '1' WHEN ((returned_state = Idle) AND (RU_Granted = '1')) ELSE
										'0';
		--Returned_load_data <=  (NPI_DATA_Valid_Out AND NPI_Transfer_Complete AND ring_buffer_data_out(288));
		--Returned_load_data <=  (NPI_Transfer_Complete AND ring_buffer_data_out(288));  --was 292!!!!!!!
		Returned_load_data <= '1' WHEN ((npi_state = Get_data) AND (ring_buffer_data_out(292) = '1')) ELSE --used to be ring_buffer_data_out(292) -- Ithink it should be 292 not 288
											(NPI_Transfer_Complete AND ring_buffer_data_out(288));--AND request);

		
---------------------------------------------------------------------	
--Returned Unit State Machine
---------------------------------------------------------------------
		
	PROCESS(CLK)
		BEGIN
		IF(rising_edge(CLK)) THEN
			IF(FSL_Rst = '1') THEN   
				returned_state <= Idle;
			ELSE
				CASE returned_state IS
					WHEN Idle =>
						IF((RU_Granted = '1') AND  (returned_empty = '0')) THEN
							--returned_state <= Write1;
							returned_state <= Get_data;
						ELSE
							returned_state <= Idle;
						END IF;
							--debug(120 downto 118) <= "000";
					WHEN Get_Data =>
						IF(returned_data_out(294) = '0') THEN
							returned_state <= Write1;
						ELSE
							returned_state <= Invalidate;
						END IF;
						--debug(120 downto 118) <= "100";
					WHEN Invalidate =>
						returned_state <= Idle;
						--debug(120 downto 118) <= "101";
					WHEN WRITE1 =>
						IF(Data_Bank_Done = '1') THEN
							returned_state <= Write2;
						ELSE
							returned_state <= Write1;
						END IF;
						--debug(120 downto 118) <= "001";						
					WHEN WRITE2 =>
						IF(Data_Bank_Done = '1') THEN
							IF(returned_data_out(288) = '1') THEN
								returned_state <= Read_Returned;
							ELSE
								returned_state <= Idle;
							END IF;
						ELSE
							returned_state <= Write2;
						END IF;
						--debug(120 downto 118) <= "010";	
					WHEN Read_Returned =>
						--returned_state <= Idle;
						returned_state <= Read_Returned2;
					--debug(120 downto 118) <= "011";
					WHEN Read_Returned2 =>
						--returned_state <= Idle;
						returned_state <= Read_Returned3;
					--debug(120 downto 118) <= "011";
					WHEN Read_Returned3 =>
						--returned_state <= Idle;
						returned_state <= Read_Returned4;
					--debug(120 downto 118) <= "011";
					WHEN Read_Returned4 =>
						returned_state <= Idle;
						--returned_state <= returned_state2;
					--debug(120 downto 118) <= "011";					
					WHEN others =>
						returned_state <= Idle;
					--	debug(120 downto 118) <= "111";
				END CASE;
			END IF;
		ELSE
				returned_state <= returned_state;
		END IF;
	END PROCESS; 
					
	
------------------------------------------------------------------
--Arbitration For Data and Tag Bank
------------------------------------------------------------------
	
	--This signal determines if a request for the same address is already
	--in flight. In this case we need to stall the CU
	
	stall_s <= '1' WHEN (((returned_match = '1') AND (returned_empty = '0')) OR ((ring_buffer_match = '1') AND (ring_buffer_empty = '0')) OR 
							((address(17 downto 5) = returned_data_out(273 downto 261)) and ((returned_state /= idle))) OR 
							((NPI_ADDR_s(17 downto 5) = address(17 downto 5)) and (npi_state /= idle))) ELSE
				'0';
	

	db_stall(0) <= '1' WHEN ((address(31 downto 5) = returned_data_out(287 downto 261)) and ((returned_state /= idle))) else '0';

	db_stall(1) <= '1' WHEN ((NPI_ADDR_s(31 downto 5) = address(31 downto 5)) and (npi_state /= idle)) else '0';
	
	process(clk)
		begin
		if(rising_edge(clk)) then
			stall <= stall_s;
		else
			stall <= stall;
		end if;
	end process;
	
	
	RU_Wanted <= '1' when ((returned_empty = '0') OR  (returned_state /= Idle)) else '0';
	
	--#####################################################################
	--NEED TO CHECK STALL (change made may 10 2012)
	--#####################################################################
	
	CU_Wanted <= '1' WHEN ((state = Idle) AND (FSL_S_Exists_0 = '1')) ELSE
					 '1' WHEN (state = Ready) ELSE
					 '1' WHEN((state = Check_Tag) and (stall /= '1') and (valid_i = '1')) else
					 '1' WHEN ((State = Check_Tag_Wait) and (stall /= '1') and (valid_i = '1')) ELSE
					 '1' WHEN (((state = Write_Hit)) and (Data_Bank_Done /= '1')) else
					 '1' WHEN (((state = Read_Hit) OR (state = Read2) OR (state = Read3))) else 
					 '1' WHEN ((state = Evict_Line1) OR (state = Evict_Line2) OR (state = Invalidate)
								OR ((state = RU_Invalidate))) ELSE ---need to fix?? (npi_state /= idle)
					 '0';
					 
					 
	PROCESS(CLK)
		BEGIN
		IF(rising_edge(CLK)) THEN
			IF(FSL_Rst = '1') THEN   
				RU_Granted <= '0';
				CU_Granted <= '0';
			ELSIF((CU_Granted = '1') AND (CU_Wanted = '1')) THEN
				RU_Granted <= '0';
				CU_Granted <= '1';	
			ELSIF((RU_Granted = '1') AND (RU_Wanted = '1')) THEN
				RU_Granted <= '1';
				CU_Granted <= '0';
			ELSIF( (RU_Granted = '0') AND (CU_Granted = '0')) THEN
				IF(CU_Wanted = '1') THEN
					RU_Granted <= '0';
					CU_Granted <= '1';
				ELSIF(RU_Wanted = '1') THEN
					RU_Granted <= '1';
					CU_Granted <= '0';
				ELSE
					RU_Granted <= '0';
					CU_Granted <= '0';
				END IF;
			ELSE
					RU_Granted <= '0';
					CU_Granted <= '0';
			END IF;
		ELSE
			RU_Granted <= RU_Granted;
			CU_Granted <= CU_Granted;
		END IF;
	END PROCESS;
	
	---------------
	--Debug
	---------------

	process(clk)
	begin
	if(rising_edge(clk)) then
	debug_ss(30 downto 0) <= address(30 downto 0);
	debug_ss(31) <= NPI_RNW_s;
	--debug_ss(63 downto 32) <= data_in; --NPI_ADDR_ss; --data_bank_address;--data_in;
	debug_ss(63 downto 32) <= NPI_ADDR_s2;
	
	--debug_ss(63 downto 32) <= NPI_ADDR_ss;
	--debug_ss(44 downto 32) <= TAG_ADDRESS;
	-----------------debug_ss(45 downto 32) <= tag;
	
	------debug(127 downto 64) <= db_debug; --NPI_WrFIFO_Data_S;
--TAG
--  debug_ss(45 downto 32) <= returned_data_out(287 downto 274);
--  debug_ss(47 downto 46) <= "00";
--  debug_ss(49 downto 48) <= returned_data_out(290 downto 289); 
	

--	debug_ss(49 downto 32) <= A_s;--ring_buffer_data_out(63 downto 32); 
--	debug_ss(51 downto 50) <= "00";
	--debug_ss(52) <= CE_not_s;
	--debug_ss(53) <= CE2_s;
	--debug_ss(54) <= OE_not_s;
	--debug_ss(55) <= WE_not_S;
	--debug_ss(56) <= BWa_not_s;
	--debug_ss(57) <= BWb_not_s;
	--debug_ss(58) <= BWc_not_s;
	--debug_ss(59) <= BWd_not_s;
	
	--debug_ss(63 downto 32) <= data_bank_address;--ring_buffer_data_out(63 downto 32); 

	debug_ss(67 downto 64) <= debug_state;
	
	--debug_ss(68) <= ring_buffer_data_out(68);
	--debug_ss(71 downto 69) <= ring_buffer_data_out(4 downto 2);
	
	Case returned_state is
		WHEN Idle => debug_ss(71 downto 68) <= "0000";
		WHEN Write1 => debug_ss(71 downto 68) <= "0001";
		WHEN Write2 => debug_ss(71 downto 68) <= "0010";
		WHEN Read_Returned => debug_ss(71 downto 68) <= "0011";
		WHEN Read_Returned2 => debug_ss(71 downto 68) <= "0100";
		WHEN Read_Returned3 => debug_ss(71 downto 68) <= "0101";
		WHEN Read_Returned4 => debug_ss(71 downto 68) <= "0110";
		WHEN Invalidate => debug_ss(71 downto 68) <= "0111";
		WHEN Get_Data => debug_ss(71 downto 68) <= "1000";
		WHEN others => debug_ss(71 downto 68) <= "1111";
	end case;
	
--	debug(71 downto 68) <= "0000" when (returned_state = Idle) ELSE
--									"0001" WHEN (returned_state = Write1) ELSE
--									"0010" WHEN (returned_state = Write2) ELSE
--									"0011" WHEN (returned_state = Read_Returned) ELSE
--									"0100" WHEN (returned_state = Read_Returned2) ELSE
--									"0101" WHEN (returned_state = Read_Returned3) ELSE
--									"0110" WHEN (returned_state = Read_Returned4) ELSE
--									"0111" WHEN (returned_state = Invalidate) ELSE
--									"1000" WHEN (returned_state = Get_Data) ELSE
--									"1111";

	--debug_ss(69) <= RU_WRITE_EN;
	--debug_ss(71 downto 70) <= STD_LOGIC_VECTOR(TO_UNSIGNED(debug_lru,2));
	--debug_ss(73 downto 72) <= STD_LOGIC_VECTOR(TO_UNSIGNED(stack_pos,2));
	--debug_ss(75 downto 74) <= STD_LOGIC_VECTOR(TO_UNSIGNED(selected_set,2));
	--debug_ss(75 downto 74) <= STD_LOGIC_VECTOR(TO_UNSIGNED(db_Way_number,2));
	---debug_ss(74) <= RU_WRITE_EN;
	--debug_ss(77 downto 76) <= STD_LOGIC_VECTOR(TO_UNSIGNED(way_number,2));
	--debug_ss(79 downto 78) <= returned_data_out(290 downto 289); --when ((returned_state = Read_Returned)) ELSE
										--STD_LOGIC_VECTOR(TO_UNSIGNED(selected_set,2));
	
	--debug_ss(79 downto 78) <= way_db;
	--debug_ss(78) <= RnW_s;
	--"00";
	--debug_ss (92 downto 80) <= TAG_ADDRESS;
	--debug_ss(87 downto 80) <= rpolicy_bits;
	
	debug_ss(88) <= NPI_DATA_VALID_IN_2;--disable_cache;
	debug_ss(89) <= NPI_RQST_2;
	debug_ss(90) <= RnW_s;--Word_nBurst;
	debug_ss(91) <= NPI_TRANSFER_COMPLETE_2;
	debug_ss(92) <= FSL_M_Write_s;
	debug_ss(96 downto 93) <= byte_en;
	--debug_ss(97) <= InD;
	debug_ss(97) <= FSL_S_Exists_0;
	debug_ss(98) <= FSL_S_Exists_1;
	debug_ss(99) <= FSL_M_Read_s;
	--debug_ss(88) <= CE_not_s;
	--debug_ss(89) <= CE2_s;
	--debug_ss(90) <= FSL_S_Exists_1; --OE_not_s;
	--debug_ss(91) <= returned_match; --WE_not_S;
	--debug_ss(92) <= ring_buffer_match;--BWa_not_s;
	--debug_ss(93) <= stall;
	--debug_ss(94) <= db_stall(0); --RU_Granted;
	--debug_ss(95) <= db_stall(1);--CU_Granted;
	--debug_ss(95 downto 94) <= STD_LOGIC_VECTOR(TO_UNSIGNED(selected_invalid,2));   -- way_db;
	
	--debug_ss(95 downto 93) <= "000";
	--debug_ss(99 downto 96) <= 	WRITE_EN;
	--debug_ss(103 downto 100) <= 	valid_bank;
	--debug_ss(107 downto 104) <= 	match_bank;
	--debug_ss(115 downto 108) <= rpolicy_bits_to_RAM;--rpolicy_bits_from_RAM;
	--debug_ss(123 downto 116) <= rpolicy_bits_from_RAM;--rpolicy_bits;--rpolicy_bits_to_RAM;
	debug_ss(124) <= db_fsl;--FSL_M_Full_0;--db_fsl;--LOAD_LINE;
	debug_ss(125) <= RU_Granted;--ring_buffer_data_out(288);--READ_LINE;
	debug_ss(126) <= CU_Granted;--ring_buffer_load_data;--LOAD_WORD;
	debug_ss(127) <= FSL_S_DATA_0(7);--RnW_s;
	else
	debug_ss <= debug_ss;


	end if;
	end process;
	debug <= debug_ss;
	db_addr <= NPI_ADDR_ss;
	db_rnw	<= NPI_RNW_s;


--debug_data <= NPI_DATA_OUT_2(127 downto 0);
debug_data(31 downto 0) <= FSL_M_Data_s(35 downto 4);
--debug_data (55 downto 0) <= tag;
--debug_data(63 downto 0)<= NPI_WrFIFO_Data_S;--NPI_RdFIFO_Data;
--debug_data(127 downto 64)<= NPI_WrFIFO_Data_S;
--debug_data(17 downto 0) <= A_s;
--debug_data(22 downto 20) <= ring_buffer_data_out(4 downto 2);
--debug_data (31 downto 0) <= NPI_ADDR_s2;--NPI2_debug(31 downto 0); -- NPI_DATA_OUT_2(127 downto 0); --NPI2_debug;--NPI_DATA_OUT_2(127 downto 0);
--debug_data (63 downto 32) <= data_in;--FSL_S_Data_1;
--debug_data (95 downto 66) <= FSL_S_Data_0(41 downto 12);
--debug_data (65 downto 64) <= "00";
--debug_data(66) <= NPI_RNW_s;
--debug_data(67) <= NPI_RNW_s2;
--debug_data(68) <= NPI_RQST_2;
--debug_data (105 downto 64) <= FSL_S_Data_0;

--debug_data (95 downto 64) <= NPI_ADDR_s2;
--debug_data (127 downto 96) <= NPI_ADDR_ss; --data_in;


--debug_data (31 downto 0) <= FSL_S_Data_1;--FSL_S_Data_0(41 downto 10);--ring_buffer_data_in(31 downto 0);--NPI_ADDR_ss;
--debug_data(63 downto 32) <= ring_buffer_data_in(287 downto 256);--ring_buffer_data_out(31 downto 0);
--debug_data(95 downto 64) <=  Data_I_s (31 downto 0);--data_bank_address; -- NPI_ADDR_ss;
--debug_data(127 downto 96) <=  Data_O_s(31 downto 0);--Data_I_s (31 downto 0);--data_bank_address;

--debug_data <= LINE_IN;
	
END Behavioral;
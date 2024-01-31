LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY 	 Instruction_Fetch IS

PORT( 	 	PC_Out				: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			Instruction			: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			MDR 				: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);	
			ALU_Result  		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ALU_OUT  			: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			Mem_readAddress		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			PCSrc				: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			PC_Write_Cond 		: IN STD_LOGIC;
			PC_Write			: IN STD_LOGIC;
			IRWrite 			: IN STD_LOGIC; -- from control
			MemRead   			: IN STD_LOGIC;
			MemWrite  			: IN STD_LOGIC;
			Zero 				: IN STD_LOGIC;
			Jump_Address  		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			Write_Data 			: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Reg B from memory 
			Clock, Reset  		: IN STD_LOGIC
			 
			);
			
END Instruction_Fetch;

ARCHITECTURE behavioral OF Instruction_Fetch IS

--implement instruction component into Instruction_Fetch ARCHITECTURE
	COMPONENT instructionMemory is
	PORT(
			readAddress : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			Write_Data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			MemRead   : IN STD_LOGIC;
			MemWrite  : IN STD_LOGIC;
			IRWrite : IN STD_LOGIC;
			instruction : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			MDR	  			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			Clock, Reset 	: IN STD_LOGIC
	);
	END COMPONENT;
	
-- Instruction_Fetch signals 	
	SIGNAL PC : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL Next_PC : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL readAddress : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL Write_Mem : STD_LOGIC_VECTOR (31 DOWNTO 0);
	
BEGIN
	
-- Output Signals copied
	PC_Out <= PC;
	
		
-- Mux to select NEXT_PC as PC + 4, Branch Address or Jump Address
	Next_PC <= ALU_Result WHEN (PCSrc ="00") ELSE ALU_OUT WHEN (PCSrc = "01") ELSE Jump_Address WHEN (PCSrc = "10") ELSE x"00000000"; 

	Write_Mem <= Write_Data;

	readAddress <= Mem_readAddress;
	
-- Porting instruction model:
IM : instructionMemory PORT MAP (
		readAddress	=> readAddress,
		Write_Data => Write_Mem,
		instruction	=> Instruction,
		MemRead => MemRead,
		MemWrite => MemWrite,
		IRWrite => 	IRWrite,
		MDR => MDR,
		Clock => Clock,
		Reset => Reset
		);
	

PROCESS(Clock,Reset)
BEGIN
IF (Reset = '1') THEN
	PC <=	x"00000000";
ELSIF rising_edge (Clock) THEN
	IF ((PC_Write_Cond AND Zero) = '1' OR PC_Write ='1') THEN
		PC <= Next_PC;
	END IF;
END IF;
END PROCESS;
END behavioral;






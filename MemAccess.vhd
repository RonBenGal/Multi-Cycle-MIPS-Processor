LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY MemAccess IS
	PORT (
		ALU_OUT 			: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC					: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		lorD				: IN STD_LOGIC;
		Mem_readAddress		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		
	);
	
END MemAccess;

ARCHITECTURE Behavioral OF MemAccess IS
SIGNAL readAddress : STD_LOGIC_VECTOR (31 DOWNTO 0);
	
BEGIN

-- Mux to select readAddress as PC or ALU_OUT
	readAddress <= ("00" & PC(31 DOWNTO 2)) WHEN lorD ='0' ELSE ALU_OUT;

PROCESS(readAddress)
BEGIN
 Mem_readAddress <= readAddress;
END PROCESS;
	
END Behavioral;

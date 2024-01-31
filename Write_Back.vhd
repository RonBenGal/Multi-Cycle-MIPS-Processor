LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL; 

ENTITY Write_Back IS
PORT (
		MDR  : IN std_logic_vector(31 DOWNTO 0); -- from decode
		ALU_OUT  : IN std_logic_vector(31 DOWNTO 0); -- from execute
		MemtoReg  : IN STD_logic;
		WB_Write_Data  : OUT STD_logic_vector(31 DOWNTO 0)
		
	);
	
END Write_Back;

ARCHITECTURE Behavioral OF Write_Back IS
SIGNAL Write_Data : STD_logic_vector(31 DOWNTO 0);

BEGIN

Write_Data <= ALU_OUT WHEN (MemtoReg = '0') ELSE MDR ;

PROCESS (Write_Data)
BEGIN
WB_Write_Data <= Write_Data;
END PROCESS;
END Behavioral;


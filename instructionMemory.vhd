LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY instructionMemory IS
	PORT (
		readAddress 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- from fetch
		Write_Data  	: IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- Register B from memory
		MemRead   		: IN STD_LOGIC;
		MemWrite  		: IN STD_LOGIC;
		IRWrite			: IN STD_LOGIC;
		instruction	   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		MDR	  			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		Clock, Reset 	: IN STD_LOGIC
	);
	
END instructionMemory;
ARCHITECTURE Behavioral OF instructionMemory IS	
	TYPE RAM_256_x_32 IS ARRAY(0 TO 255) OF std_logic_vector(31 DOWNTO 0);
	SIGNAL IM : RAM_256_x_32 := (
		x"122D0003", -- 0x0000 0004: beq s1 t5 0003 
		x"02298820", -- 0x0000 0008: add s1 s1 t1 -- s1 = s1 + 1
		x"024A9020", -- 0x0000 000C: add s2 s2 t2 -- s2 = s2 + 2	
		x"08000000", -- 0x0000 0010: j 0000 -- jump to beq (imagine Loop: above beq command at line 0000)    
		x"AC120020", -- 0x0000 0014: sw s2 0x0020($zero)					 
		x"00000000", -- 0x0000 0018:  
		x"00000000", -- 0x0000 001C:  
		x"00000000", -- 0x0000 0020:
		x"00000000",   
		x"00000000",	
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
--		x"AC090020", -- 0x0000 0004: sw 	$t1 	0x0020($zero)				
--		x"11290001", -- 0x0000 0008: beq t1 t1 0001 		
--		x"8C110020", -- 0x0000 000C: lw 	$s1, 	0x0020($zero)	
--		x"016F9820", -- 0x0000 0010: add 	$s3, 	$t3, 	$t7	
--		x"014DA02A", -- 0x0000 0014: slt 	$s4, 	$t2, 	$t5	-- s4 = 1 because t2 < t5	
--		x"01EDA82A", -- 0x0000 0018: slt 	$s5, 	$t7, 	$t5 -- s5 = 0 because t7 > t5	
		others => x"00000000" 
		);	
		
BEGIN
PROCESS(Clock,Reset)
BEGIN

IF (Reset = '1') THEN
	instruction <= x"00000000";
	MDR <= x"00000000";
ELSIF RISING_EDGE(Clock) THEN
	IF (MemWrite = '1') THEN 
		IM(to_integer(unsigned(readAddress))) <= Write_Data;
	END IF;
	IF (IRWrite = '1') THEN 
		instruction <= IM(to_integer(unsigned(readAddress)));
	END IF;
	IF (MemRead = '1') THEN 
		MDR <= IM(to_integer(unsigned(readAddress)));
	END IF;
		
END IF;		
END PROCESS;
		
END Behavioral;
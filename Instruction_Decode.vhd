LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL; 


ENTITY Instruction_Decode IS
PORT ( 
		Read_Data_1 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- to exectue
		Read_Data_2 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- to exectue
		RegWrite			: IN STD_LOGIC; -- from control
		RegDst 			: IN STD_LOGIC; -- from control
		--Data Memory & MUX
		
		WB_Write_Data  	: IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- from WB Stage
		Instruction 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- from fetch
		Sign_Extend 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- to exectue
		Jump_Instr 		: OUT STD_LOGIC_VECTOR (25 DOWNTO 0); -- to exectue
		Funct 			: OUT STD_LOGIC_VECTOR (5 DOWNTO 0); -- to execute
		Opcode 			: OUT STD_LOGIC_VECTOR (5 DOWNTO 0); -- to control
		Clock, Reset 	: IN STD_LOGIC
		
		);
		
END Instruction_Decode;

ARCHITECTURE behavioral OF Instruction_Decode IS

--32 Registers each 32-bits wide
TYPE register_file IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL register_array : register_file := (
		x"00000000", --0  $zero
		x"00000000", --1  $at
		x"00000000", --2  $v0
		x"00000000", --3  $v1
		x"00000000", --4  $a0
		x"00000000", --5  $a1
		x"00000000", --6  $a2
		x"00000000", --7  $a3
		x"00000000", --8  $t0
		x"00000000", --9  $t1
		x"00000000", --0a $t2
		x"00000000", --0b $t3
		x"00000000", --0c $t4
		x"00000000", --0d $t5
		x"00000000", --0e $t6
		x"00000000", --0f $t7
		x"00000000", --10 $s0
		x"00000000", --11 $s1
		x"00000000", --12 $s2
		x"00000000", --13 $s3
		x"00000000", --14 $s4
		x"00000000", --15 $s5
		x"00000000", --16 $s6
		x"00000000", --17 $s7
		x"00000000", --18 $t8
		x"00000000", --19 $t9
		x"00000000", --1a $k0
		x"00000000", --1b $k1
		x"00000000", --1c $global pointer
		x"00000000", --1d $stack pointer
		x"00000000", --1e $frame pointer
		x"00000000"  --1f $return address
	);
		SIGNAL read_register_address1 : STD_LOGIC_VECTOR (4 DOWNTO 0);
		SIGNAL read_register_address2 : STD_LOGIC_VECTOR (4 DOWNTO 0);
		SIGNAL write_register_address : STD_LOGIC_VECTOR (4 DOWNTO 0); -- mux out
		SIGNAL write_register_address0: STD_LOGIC_VECTOR (4 DOWNTO 0); -- mux in1
		SIGNAL write_register_address1: STD_LOGIC_VECTOR (4 DOWNTO 0); -- mux in2
		SIGNAL write_data : STD_LOGIC_VECTOR (31 DOWNTO 0);
		 
		SIGNAL instruction_15_0 : STD_LOGIC_VECTOR (15 DOWNTO 0); -- to sign extend
		SIGNAL instruction_25_0 : STD_LOGIC_VECTOR (25 DOWNTO 0); -- to jump address 
BEGIN

	--Copy Instruction bits to signals
	read_register_address1 <= Instruction (25 DOWNTO 21);
	read_register_address2 <= Instruction (20 DOWNTO 16);
	write_register_address0 <= Instruction (20 DOWNTO 16);
	write_register_address1 <= Instruction (15 DOWNTO 11);
	instruction_15_0 <= Instruction (15 DOWNTO 0);
	instruction_25_0 <= Instruction (25 DOWNTO 0);
	Opcode <= Instruction (31 DOWNTO 26);
	Funct <= instruction_15_0 (5 DOWNTO 0);
	
	--Register File: Read_Data_1 Output
	Read_Data_1 <= register_array(to_integer(unsigned(read_register_address1(4 DOWNTO 0)))); -- A
--Register File: Read_Data_2 Output
	Read_Data_2 <= register_array(to_integer(unsigned(read_register_address2(4 DOWNTO 0)))); -- B	

--Register File: MUX to select Write Register Address
	write_register_address <= write_register_address1 WHEN (RegDst = '1') ELSE write_register_address0;
		
--Sign Extend
	Sign_Extend <= (x"0000" & instruction_15_0 (15 DOWNTO 0)) WHEN (instruction_15_0 (15) = '0') 
					ELSE  (x"FFFF" & instruction_15_0 (15 DOWNTO 0));
					
--Jump Instruction
	Jump_Instr <= instruction_25_0 (25 DOWNTO 0) ;

-- Write to Register File
	write_data <= WB_Write_Data; -- WB
	
	

PROCESS(Clock,Reset)
BEGIN
IF (Reset = '1') THEN
--Reset temporary Registers to respected numbers
	FOR i IN 8 TO 15 LOOP
	register_array(i) <= x"00000000" + i - "01000";
	END LOOP;	
ELSIF rising_edge(Clock) THEN	
	--Write Register File if RegWrite signal has been asserted, also restrict writing to $zero
	IF (RegWrite = '1') AND (write_register_address /= 0) THEN
		register_array(to_integer(unsigned(write_register_address (4 DOWNTO 0)))) <= write_data; 
	END IF;
END IF;
END PROCESS;
END behavioral;





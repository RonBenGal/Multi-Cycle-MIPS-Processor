LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY Execute IS
PORT( --ALU Signals
		Read_Data_1 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- from decode
		Read_Data_2 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- from decode
		Sign_Extend 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- from decode
		ALUSrc_A		: IN STD_LOGIC ; -- from control
		ALUSrc_B		: IN STD_LOGIC_VECTOR (1 DOWNTO 0) ; -- from control
		Zero 			: OUT STD_LOGIC; -- to fetch
		ALU_Result  	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- to fetch
		ALU_OUT 		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- to fetch
		PC				: IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- from fetch
		B_Reg_OUT 		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);-- to fetch
		--ALU Control
		ALU_Control_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0); -- simualation data
		Funct 			: IN STD_LOGIC_VECTOR (5 DOWNTO 0);	-- from decode
		ALU_Op 			: IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- from cotrol
		--Jump Adress
		Jump_Instr 		: IN STD_LOGIC_VECTOR (25 DOWNTO 0);
		Jump_Address 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		--Misc
		Clock, Reset 	: IN STD_LOGIC
		
		);
END Execute;

ARCHITECTURE behavioral of Execute IS
SIGNAL A_input, B_input : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL A_Reg , B_Reg : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL ALU_Res : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL Branch_Add : STD_LOGIC_VECTOR (31 DOWNTO 0); 
SIGNAL Jump_Add : STD_LOGIC_VECTOR (27 DOWNTO 0);
SIGNAL ALU_Control : STD_LOGIC_VECTOR (2 DOWNTO 0);
BEGIN

--Branch Sign Extended imm
	Branch_Add <= Sign_Extend (29 DOWNTO 0) & "00";

--MUX to select first ALU Input, indicate a problem on ALUSrc_A when result is x"AAAAAAAA"
	A_input <= PC WHEN ALUSrc_A = '0' ELSE A_Reg  WHEN ALUSrc_A = '1' ELSE x"AAAAAAAA";
	
--MUX to select second ALU Input , indicate a problem on ALUSrc_B when result is x"BBBBBBBB"
	B_input <= B_Reg WHEN (ALUSrc_B = "00") ELSE x"00000004" WHEN (ALUSrc_B = "01") ELSE (Sign_Extend (31 DOWNTO 0)) WHEN (ALUSrc_B = "10") ELSE Branch_Add WHEN (ALUSrc_B = "11") ELSE x"BBBBBBBB" ;
	
	ALU_Result <= ALU_Res;
	
--Set ALU Control Bits
	ALU_Control(2) <= (Funct(1) AND ALU_Op(1)) OR ALU_Op(0);
	ALU_Control(1) <= (NOT Funct(2)) OR (NOT ALU_Op(1));
	ALU_Control(0) <= ((Funct(0) OR Funct(3)) AND ALU_Op(1));
	
--Set ALU_Zero
Zero <= '1' WHEN ( ALU_Res (31 DOWNTO 0) = x"00000000") ELSE '0';

--Jump Address
Jump_Add <= Jump_Instr (25 DOWNTO 0) & "00";
Jump_Address <= PC (31 DOWNTO 28) & Jump_Add;
ALU_Control_OUT <= ALU_Control(2 DOWNTO 0);

PROCESS (ALU_Control, A_input, B_input)
BEGIN --ALU Operation
CASE ALU_Control IS
--Function: A_input AND B_input
WHEN "000" => ALU_Res <= A_input AND B_input;
--Function: A_input OR B_input
WHEN "001" => ALU_Res <= A_input OR B_input;
--Function: A_input ADD B_input
WHEN "010" => ALU_Res <= STD_LOGIC_VECTOR(unsigned(signed(A_input) + signed(B_input)));
--Function: A_input SUB B_input
WHEN "110" => ALU_Res <= STD_LOGIC_VECTOR(unsigned(signed(A_input) - signed(B_input)));
--Function: SLT (set less than)
WHEN "111" =>
IF (signed(A_input) < signed(B_input)) THEN
	ALU_Res <= x"00000001";
ELSE
	ALU_Res <= x"00000000";
END IF;
WHEN OTHERS => ALU_Res <= x"00000000";
END CASE;
END PROCESS;

PROCESS(Clock,Reset) 
BEGIN
IF(reset ='1') THEN
ALU_OUT <= x"00000000";
ELSIF rising_edge(Clock) THEN
ALU_OUT <= ALU_Res;
A_Reg <= Read_Data_1(31 DOWNTO 0);
B_Reg <= Read_Data_2(31 DOWNTO 0);
B_Reg_OUT <= Read_Data_2(31 DOWNTO 0);
END IF;
END PROCESS;
END behavioral;
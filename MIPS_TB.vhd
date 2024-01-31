LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY MIPS_TB IS
End MIPS_TB;


ARCHITECTURE Test of MIPS_TB IS

Component MIPS IS

PORT (
		PC 				 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		Instruction_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		ALU_OUT_Display : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		Mem_readAddress_OUT	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		RegA				 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		RegB				 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);	
		FSM_State		 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		Write_Data_OUT	 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		WB_Write_DataRF  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		SignedEx_OUT	 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		ALU_Control_Display : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		T_RegDst			: OUT STD_LOGIC; 
		T_RegWrite 		: OUT STD_LOGIC;
		T_ALUSrc_A			: OUT STD_LOGIC ;
		T_ALUSrc_B			: OUT STD_LOGIC_VECTOR (1 DOWNTO 0) ;
		T_ALU_Op 			: OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		T_PCSrc				: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		T_PC_Write_Cond  : OUT STD_LOGIC;
		T_PC_Write			: OUT STD_LOGIC;
		T_lorD				: OUT STD_LOGIC;		
		T_MemRead 			: OUT STD_LOGIC;
		T_MemWrite 		: OUT STD_LOGIC;
		T_MemtoReg			: OUT STD_LOGIC;
		T_IRWrite 			: OUT STD_LOGIC;
		Clock, Reset 	 : IN STD_LOGIC
		);

End Component;

constant clk_period : time := 20 ns;
constant Time_Period : time := 600 ns;

SIGNAL Clock : STD_LOGIC :='1';
SIGNAL Reset : STD_LOGIC :='0';
SIGNAL Instruction_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL PC : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL ALU_OUT_Display			 : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL RegA				 : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL RegB				 : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL Mem_readAddress_OUT	:  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Write_Data_OUT	 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL WB_Write_DataRF  :  STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL SignedEx_OUT		:  STD_LOGIC_VECTOR (31 DOWNTO 0);	
SIGNAL ALU_Control_OUT  :  STD_LOGIC_VECTOR (2 DOWNTO 0);
SIGNAL T_RegDst			:  STD_LOGIC;
SIGNAL T_RegWrite 		:  STD_LOGIC;
SIGNAL T_ALUSrc_A			:  STD_LOGIC ;
SIGNAL T_ALUSrc_B			:  STD_LOGIC_VECTOR (1 DOWNTO 0) ;
SIGNAL T_ALU_Op 			:  STD_LOGIC_VECTOR (1 DOWNTO 0);
SIGNAL T_PCSrc				:  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL T_PC_Write_Cond  :  STD_LOGIC;
SIGNAL T_PC_Write			:  STD_LOGIC;
SIGNAL T_lorD				:  STD_LOGIC;		
SIGNAL T_MemRead 			:  STD_LOGIC;
SIGNAL T_MemWrite 		:  STD_LOGIC;
SIGNAL T_MemtoReg			:  STD_LOGIC;
SIGNAL T_IRWrite 			:  STD_LOGIC;
SIGNAL FSM_State : STD_LOGIC_VECTOR (3 DOWNTO 0);


BEGIN

MIPS_UT :MIPS PORT MAP ( 

		PC => PC,
		Instruction_OUT => Instruction_OUT,
		ALU_OUT_Display => ALU_OUT_Display,
		RegA => RegA,
		RegB => RegB,
		Mem_readAddress_OUT => Mem_readAddress_OUT,
		Write_Data_OUT => Write_Data_OUT,
		WB_Write_DataRF => WB_Write_DataRF,
		SignedEx_OUT => SignedEx_OUT,
		ALU_Control_Display => ALU_Control_OUT,
		FSM_State => FSM_State,
		T_RegDst => T_RegDst,
		T_RegWrite => T_RegWrite,
		T_ALUSrc_A => T_ALUSrc_A,
		T_ALUSrc_B => T_ALUSrc_B,
		T_ALU_Op => T_ALU_Op,
		T_PCSrc => T_PCSrc,
		T_PC_Write_Cond => T_PC_Write_Cond,
		T_PC_Write => T_PC_Write,
		T_lorD => T_lorD,
		T_MemRead => T_MemRead,
		T_MemWrite => T_MemWrite,
		T_MemtoReg => T_MemtoReg,
		T_IRWrite => T_IRWrite,
		Clock => Clock,
		Reset => Reset
		
		);


Clock <= not Clock after clk_period/2;
Reset <= '1','0' after clk_period; 

-- test is done via modelsim wave view 
-- current instruction set completes withing 1450ns 

END Test;
	
	





	



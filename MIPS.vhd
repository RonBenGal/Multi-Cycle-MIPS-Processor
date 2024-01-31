LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY MIPS IS

--outputs are for simulation display purposes

PORT (
		PC 				 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		Instruction_OUT 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		ALU_OUT_Display 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		Mem_readAddress_OUT	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		RegA				 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		RegB				 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);	
		FSM_State		 	: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		Write_Data_OUT	 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		WB_Write_DataRF  	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		SignedEx_OUT	 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		ALU_Control_Display : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		T_RegDst			: OUT STD_LOGIC;
		T_RegWrite 			: OUT STD_LOGIC;
		T_ALUSrc_A			: OUT STD_LOGIC ;
		T_ALUSrc_B			: OUT STD_LOGIC_VECTOR (1 DOWNTO 0) ;
		T_ALU_Op 			: OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		T_PCSrc				: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		T_PC_Write_Cond  	: OUT STD_LOGIC;
		T_PC_Write			: OUT STD_LOGIC;
		T_lorD				: OUT STD_LOGIC;		
		T_MemRead 			: OUT STD_LOGIC;
		T_MemWrite 			: OUT STD_LOGIC;
		T_MemtoReg			: OUT STD_LOGIC;
		T_IRWrite 			: OUT STD_LOGIC;
		Clock, Reset 	 	: IN STD_LOGIC
		
		);

End MIPS;

ARCHITECTURE Structure of MIPS IS

--Declare all Components

Component Instruction_Fetch IS
PORT( 	 PC_Out				: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			 Instruction		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			 MDR					: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			 ALU_Result  		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			 ALU_OUT  			: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			 Mem_readAddress	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			 PCSrc				: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			 PC_Write_Cond 	: IN STD_LOGIC;
			 PC_Write			: IN STD_LOGIC;
			 IRWrite 			: IN STD_LOGIC; -- from control
			 MemRead   			: IN STD_LOGIC;
			 MemWrite  			: IN STD_LOGIC;
			 Zero 				: IN STD_LOGIC;
			 Jump_Address  	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			 Write_Data 		: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Reg B from memory 
			 Clock, Reset  	: IN STD_LOGIC
			 
			);
			
END COMPONENT;
			
Component Instruction_Decode IS
PORT ( 
		Read_Data_1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- to exectue
		Read_Data_2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- to exectue
		RegWrite : IN STD_LOGIC; -- from control
		RegDst : IN STD_LOGIC; -- from control
		--Data Memory & MUX
		
		WB_Write_Data : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- from WB Stage
		Instruction : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- from fetch
		Sign_Extend : OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- to exectue
		Jump_Instr : OUT STD_LOGIC_VECTOR (25 DOWNTO 0); -- to exectue
		Funct : OUT STD_LOGIC_VECTOR (5 DOWNTO 0); -- to execute
		Opcode : OUT STD_LOGIC_VECTOR (5 DOWNTO 0); -- to control
		Clock, Reset : IN STD_LOGIC
		
		);

END COMPONENT;

Component Control_Unit IS
PORT(  
		Opcode 			: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		RegDst			: OUT STD_LOGIC;
		RegWrite 		: OUT STD_LOGIC;
		ALUSrc_A			: OUT STD_LOGIC ;
		ALUSrc_B			: OUT STD_LOGIC_VECTOR (1 DOWNTO 0) ;
		ALU_Op 			: OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		PCSrc				: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		PC_Write_Cond  : OUT STD_LOGIC;
		PC_Write			: OUT STD_LOGIC;
		IorD				: OUT STD_LOGIC;		
		MemRead 			: OUT STD_LOGIC;
		MemWrite 		: OUT STD_LOGIC;
		MemtoReg			: OUT STD_LOGIC;
		IRWrite 			: OUT STD_LOGIC;
		State_Check		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- test 
		Clock, Reset 	: IN STD_LOGIC
		
		);
		
END Component;

Component Execute IS 
PORT( 
		Read_Data_1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- from decode
		Read_Data_2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- from decode
		Sign_Extend : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- from decode
		ALUSrc_A		: IN STD_LOGIC ; -- from control
		ALUSrc_B		: IN STD_LOGIC_VECTOR (1 DOWNTO 0) ; -- from control
		Zero 			: OUT STD_LOGIC; -- to fetch
		ALU_Result  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- to fetch
		ALU_OUT 		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- to fetch
		ALU_Control_OUT 		: OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		PC				: IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- from fetch
		B_Reg_OUT 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);-- to fetch
		Funct 		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);	-- from decode
		ALU_Op 		: IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- from cotrol
		Jump_Instr : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
		Jump_Address : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		Clock, Reset : IN STD_LOGIC
		
		);
		
END Component;

Component  MemAccess IS
	PORT (
		ALU_OUT 				: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC						: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		lorD					: IN STD_LOGIC;
		Mem_readAddress	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

	);
	
END Component;

Component Write_Back IS
PORT (

		MDR  : IN std_logic_vector(31 DOWNTO 0); -- from decode
		ALU_OUT  : IN std_logic_vector(31 DOWNTO 0); -- from execute
		MemtoReg  : IN STD_logic;
		WB_Write_Data  : OUT STD_logic_vector(31 DOWNTO 0)
		
		
	);
	
END Component;

--Signals used to connect Components
--fetch
SIGNAL PC_Out : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL Instruction : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL ALU_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ALU_Result : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL Mem_readAddress : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL Jump_Address : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL Write_Data : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL MDR : STD_LOGIC_VECTOR (31 DOWNTO 0);

--decode
SIGNAL	Read_Data_1 :  STD_LOGIC_VECTOR (31 DOWNTO 0); 	-- to exectue
SIGNAL	Read_Data_2 :  STD_LOGIC_VECTOR (31 DOWNTO 0); 	-- to exectue
SIGNAL	Sign_Extend :  STD_LOGIC_VECTOR (31 DOWNTO 0);	-- to exectue
SIGNAL	Jump_Instr :  STD_LOGIC_VECTOR (25 DOWNTO 0); 	-- to exectue
SIGNAL	Funct :  STD_LOGIC_VECTOR (5 DOWNTO 0); 			-- to execute

--exe

SIGNAL Zero 		:  STD_LOGIC;
SIGNAL B_Reg_OUT  :  STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL ALU_Control 		:  STD_LOGIC_VECTOR (2 DOWNTO 0);	
--control
SIGNAL	Opcode 			:  STD_LOGIC_VECTOR (5 DOWNTO 0);
SIGNAL	RegDst			:  STD_LOGIC :='0';
SIGNAL	RegWrite 		:  STD_LOGIC :='0';
SIGNAL	ALUSrc_A			:  STD_LOGIC :='0';
SIGNAL	ALUSrc_B			:  STD_LOGIC_VECTOR (1 DOWNTO 0) ;
SIGNAL	ALU_Op 			:  STD_LOGIC_VECTOR (1 DOWNTO 0) ;
SIGNAL	PCSrc				:  STD_LOGIC_VECTOR(1 DOWNTO 0) ;
SIGNAL	PC_Write_Cond  :  STD_LOGIC :='0';
SIGNAL	PC_Write			:  STD_LOGIC :='0';
SIGNAL	lorD				:  STD_LOGIC :='0';		
SIGNAL	MemRead 			:  STD_LOGIC :='0';
SIGNAL	MemWrite 		:  STD_LOGIC :='0';
SIGNAL	MemtoReg			:  STD_LOGIC :='0';
SIGNAL	IRWrite 			:  STD_LOGIC :='0';
SIGNAL 	State_Check		:  STD_LOGIC_VECTOR (3 DOWNTO 0) :="0000";

--mem

--WB
SIGNAL WB_Write_Data :  STD_LOGIC_VECTOR (31 DOWNTO 0);


BEGIN

--Signals assigned to display output pins for simulator

PC <= PC_Out;
Instruction_OUT <= Instruction;
FSM_State <= State_Check;
ALU_OUT_Display <= ALU_OUT;
ALU_Control_Display <= ALU_Control;
RegA <= Read_Data_1;		
RegB <= Read_Data_2;		
Mem_readAddress_OUT <= Mem_readAddress;
Write_Data_OUT <= Write_Data;
SignedEx_OUT <= Sign_Extend;
T_RegDst	<=	RegDst;	
T_RegWrite <= RegWrite;
T_ALUSrc_A <= ALUSrc_A;			
T_ALUSrc_B <= ALUSrc_B;			
T_ALU_Op <= ALU_Op;			
T_PCSrc <= PCSrc;				
T_PC_Write_Cond <= PC_Write_Cond;
T_PC_Write	<=	PC_Write;	
T_lorD <= lorD;						
T_MemRead <= MemRead;			
T_MemWrite <=	MemWrite;	
T_MemtoReg	<=	MemtoReg;	
T_IRWrite 	<=	IRWrite;	
WB_Write_DataRF <= WB_Write_Data;
	
--Connect each signal to respective line

IFE : Instruction_Fetch PORT MAP (

		PC_Out => PC_Out,
		Instruction => Instruction,
		MDR => MDR,
		ALU_Result => ALU_Result,
		ALU_OUT => ALU_OUT,
		Zero => Zero,
		Mem_readAddress => Mem_readAddress,
		PCSrc => PCSrc,
		PC_Write_Cond => PC_Write_Cond,
		PC_Write => PC_Write,
		IRWrite => IRWrite,
		MemRead => MemRead,
		MemWrite => MemWrite,
		Jump_Address => Jump_Address,
		Write_Data => Write_Data,
		Clock => Clock,
		Reset => Reset 
		
		);

ID :  Instruction_Decode PORT MAP (

		Read_Data_1 => Read_Data_1,
		Read_Data_2 => Read_Data_2,
		RegWrite => RegWrite,
		RegDst => RegDst,
		WB_Write_Data => WB_Write_Data,
		Instruction => Instruction,
		Sign_Extend => Sign_Extend,
		Jump_Instr => Jump_Instr,
		Funct => Funct,
		Opcode => Opcode,
		Clock => Clock,
		Reset => Reset 
		
		);		

CTRL : Control_Unit PORT MAP (

		Opcode => Opcode,
		RegDst => RegDst,
		RegWrite => RegWrite,
		ALUSrc_A => ALUSrc_A,
		ALUSrc_B => ALUSrc_B,
		ALU_Op => ALU_Op,
		PCSrc => PCSrc,
		PC_Write_Cond => PC_Write_Cond,
		PC_Write => PC_Write,
		IorD => lorD,
		MemRead => MemRead,
		MemWrite => MemWrite,
		MemtoReg => MemtoReg,
		IRWrite => IRWrite,
		State_Check => State_Check,
		Clock => Clock,
		Reset => Reset 
		
		);
		
		
EX : Execute PORT MAP (

		Read_Data_1 => Read_Data_1,
		Read_Data_2 => Read_Data_2,
		Sign_Extend => Sign_Extend,
		ALUSrc_A => ALUSrc_A,
		ALUSrc_B => ALUSrc_B,
		Zero => Zero,
		ALU_Control_OUT => ALU_Control,
		ALU_Result => ALU_Result,
		ALU_OUT => ALU_OUT,
		PC => PC_Out,
		B_Reg_OUT => Write_Data,
		Funct => Funct,
		ALU_Op => ALU_Op,
		Jump_Address => Jump_Address,
		Jump_Instr => Jump_Instr,
		Clock => Clock,
		Reset => Reset 
		
		);		

	
		
MEM : MemAccess PORT MAP (

		ALU_OUT => ALU_OUT,
		PC => PC_Out,
		lorD => lorD,
		Mem_readAddress => Mem_readAddress
		
	);

WB : Write_Back PORT MAP (

		MDR => MDR,
		ALU_OUT => ALU_OUT,
		MemtoReg =>  MemtoReg,
		WB_Write_Data => WB_Write_Data
		
	);	
		
END Structure;




























		
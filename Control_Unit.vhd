library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity Control_Unit is
port( 
		Opcode 			: in std_logic_vector (5 downto 0);
		RegDst			: out std_logic;
		RegWrite 		: out std_logic;
		ALUSrc_A		: out std_logic ;
		ALUSrc_B		: out std_logic_vector (1 downto 0) ;
		ALU_Op 			: out std_logic_vector (1 downto 0);
		PCSrc			: out std_logic_vector(1 downto 0);
		PC_Write_Cond	: out std_logic;
		PC_Write		: out std_logic;
		IorD			: out std_logic;		
		MemRead 		: out std_logic;
		MemWrite 		: out std_logic;
		MemtoReg		: out std_logic;
		IRWrite 		: out std_logic;
		State_check		: out std_logic_vector(3 downto 0); -- test 
		Clock, Reset 	: in std_logic
		
		);
		
end control_unit;
architecture behavioral of control_unit is

constant FETCH 		 : std_logic_vector(3 downto 0) := "0000"; -- 0 instruction fetch	
constant DECODE 	 : std_logic_vector(3 downto 0) := "0001"; -- 1 instruction decode
constant MEMADRCOMP  : std_logic_vector(3 downto 0) := "0010"; -- 2 memory address computation
constant MEMACCESSL  : std_logic_vector(3 downto 0) := "0011"; -- 3 memory access LW	 
constant MEMREADEND  : std_logic_vector(3 downto 0) := "0100"; -- 4 memory read completion
constant MEMACCESSS  : std_logic_vector(3 downto 0) := "0101"; -- 5 memory access SW
constant EXECUTION 	 : std_logic_vector(3 downto 0) := "0110"; -- 6 R-type execution
constant RTYPEEND 	 : std_logic_vector(3 downto 0) := "0111"; -- 7 R-type completion
constant BEQ 		 : std_logic_vector(3 downto 0) := "1000"; -- 8 branch completion
constant JUMP 		 : std_logic_vector(3 downto 0) := "1001"; -- 9 jump completion

signal state ,nextstate: std_logic_vector(3 downto 0) ; -- fsm states 

begin


				  
				  
state_check <= state; -- test 

			 
process(clock,reset)
begin
if(reset = '1') then
	state <= FETCH;
elsif rising_edge (Clock) then
	state <= nextstate;
end if;	
end process;




process(state , Opcode)
begin

case state is	 
 
when FETCH =>
		nextstate <= DECODE;

when DECODE => 
		case Opcode is 
			
			when "100011" => nextstate <= MEMADRCOMP;
		    when "101011" => nextstate <= MEMADRCOMP;
		    when "000000" => nextstate <= EXECUTION;
            when "000100" => nextstate <= BEQ;
			when "000010" => nextstate <= JUMP;
			when others => nextstate <= FETCH;
			
		end case;

when MEMADRCOMP =>
		
		case Opcode is 		
			
			when "100011" => nextstate <= MEMACCESSL;
            when "101011" => nextstate <= MEMACCESSS;  
			when others => nextstate <= FETCH;
			
        end case;

when MEMACCESSL =>  nextstate <= MEMREADEND;
when MEMREADEND =>  nextstate <= FETCH;
when MEMACCESSS =>  nextstate <= FETCH;
when EXECUTION	=> 	nextstate <= RTYPEEND;
when RTYPEEND	=> 	nextstate <= FETCH;
when BEQ		=>  nextstate <= FETCH;		
when JUMP 		=> 	nextstate  <= FETCH;                  
when others 	=> 	nextstate  <= FETCH;

end case;

end process;

process(state)
begin

RegDst 	 <= '0';
RegWrite <= '0';
ALUSrc_A <= '0';
ALUSrc_B <= "00";
ALU_Op <=  "00";
PCSrc  <= "00";		
PC_Write_Cond <= '0';
PC_Write <= '0';
IorD <=	'0';
MemRead  <= '0';
MemWrite <= '0';
MemtoReg <=	'0';
IRWrite  <= '0';


case state is 

when FETCH => 

	MemRead  <= '1';
	IRWrite <= '1';
	ALUSrc_A <= '0';
	ALUSrc_B <= "01";
	PC_Write <= '1';
	IorD <=	'0';
	PCSrc  <= "00";	
	ALU_Op <=  "00";
	
when DECODE => 	
	
	ALUSrc_A <= '0';
	ALUSrc_B <= "11";
	ALU_Op <=  "00";
	
when MEMADRCOMP => 
	
	ALUSrc_A <= '1';
	ALUSrc_B <= "10";
	ALU_Op <=  "00";
	
when MEMACCESSL => 
	
	MemRead  <= '1';
	IorD <=	'1';
	
when MEMREADEND => 

	RegDst 	 <= '0';
	RegWrite <= '1';
	MemtoReg <=	'1';
	
when MEMACCESSS =>
	
	MemWrite <= '1';
	IorD <=	'1';
	
when EXECUTION =>

	ALUSrc_A <= '1';
	ALUSrc_B <= "00";
	ALU_Op <=  "10";
	
when RTYPEEND =>
	
	RegDst 	 <= '1';
	RegWrite <= '1';
	
when BEQ =>
	
	ALUSrc_A <= '1';
    ALUSrc_B <= "00";
	ALU_Op <=  "01";
	PCSrc  <= "01";		
	PC_Write_Cond <= '1';
	
when JUMP =>
	
	PCSrc  <= "10";	
	PC_Write <= '1';
	
when others =>

	RegDst 	 <= '0';
	RegWrite <= '0';
	ALUSrc_A <= '0';
	ALUSrc_B <= "00";
	ALU_Op <=  "00";
	PCSrc  <= "00";		
	PC_Write_Cond <= '0';
	PC_Write <= '0';
	IorD <=	'0';
	MemRead  <= '0';
	MemWrite <= '0';
	MemtoReg <=	'0';
	IRWrite  <= '0';

end case;
end process;
end behavioral;
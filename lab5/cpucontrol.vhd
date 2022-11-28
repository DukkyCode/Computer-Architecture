library ieee;
use IEEE.std_logic_1164.all;

entity CPUControl is
-- Functionality should match the truth table shown in Figure 4.22 of the textbook, inlcuding the
--    output 'X' values.
-- The truth table in Figure 4.22 omits the unconditional branch instruction:
--    UBranch = '1'
--    MemWrite = RegWrite = '0'
--    all other outputs = 'X'	
port(Opcode   : in  STD_LOGIC_VECTOR(10 downto 0);
     Reg2Loc  : out STD_LOGIC;
     CBranch  : out STD_LOGIC;  --conditional
     MemRead  : out STD_LOGIC;
     MemtoReg : out STD_LOGIC;
     MemWrite : out STD_LOGIC;
     ALUSrc   : out STD_LOGIC;
     RegWrite : out STD_LOGIC;
     UBranch  : out STD_LOGIC; -- This is unconditional
     ALUOp    : out STD_LOGIC_VECTOR(1 downto 0)
);
end CPUControl;

architecture behavioral of CPUControl is
begin
     process(Opcode)
     begin
          case Opcode is
               --R type format
               when "10001010000" =>    Reg2Loc  <=  '0';        --AND 
                                        CBranch  <=  '0';
                                        MemRead  <=  '0';
                                        MemtoReg <=  '0';
                                        MemWrite <=  '0';
                                        ALUSrc   <=  '0';
                                        RegWrite <=  '1';
                                        UBranch  <=  '0';
                                        ALUOp    <= "10";

               when "10001011000" =>    Reg2Loc  <=  '0';        --ADD 
                                        CBranch  <=  '0';
                                        MemRead  <=  '0';
                                        MemtoReg <=  '0';
                                        MemWrite <=  '0';
                                        ALUSrc   <=  '0';
                                        RegWrite <=  '1';
                                        UBranch  <=  '0';
                                        ALUOp    <= "10";
                                        
               when "10101010000" =>    Reg2Loc  <=  '0';        --ORR 
                                        CBranch  <=  '0';
                                        MemRead  <=  '0';
                                        MemtoReg <=  '0';
                                        MemWrite <=  '0';
                                        ALUSrc   <=  '0';
                                        RegWrite <=  '1';
                                        UBranch  <=  '0';
                                        ALUOp    <= "10";
          
               when "11001011000" =>    Reg2Loc  <=  '0';        --SUB
                                        CBranch  <=  '0';
                                        MemRead  <=  '0';
                                        MemtoReg <=  '0';
                                        MemWrite <=  '0';
                                        ALUSrc   <=  '0';
                                        RegWrite <=  '1';
                                        UBranch  <=  '0';
                                        ALUOp    <= "10";
               
               when "11010011010" =>    Reg2Loc  <=  '0';        --LSR 
                                        CBranch  <=  '0';
                                        MemRead  <=  '0';
                                        MemtoReg <=  '0';
                                        MemWrite <=  '0';
                                        ALUSrc   <=  '1';
                                        RegWrite <=  '1';
                                        UBranch  <=  '0';
                                        ALUOp    <= "10";

               when "11010011011" =>    Reg2Loc  <=  '0';        --LSL 
                                        CBranch  <=  '0';
                                        MemRead  <=  '0';
                                        MemtoReg <=  '0';
                                        MemWrite <=  '0';
                                        ALUSrc   <=  '1';
                                        RegWrite <=  '1';
                                        UBranch  <=  '0';
                                        ALUOp    <= "10";
              
               --I type format                         
               when "10010001000"   =>  Reg2Loc  <=  '-';        --ADDI      
                                        CBranch  <=  '0';
                                        MemRead  <=  '-';
                                        MemtoReg <=  '0';
                                        MemWrite <=  '0';
                                        ALUSrc   <=  '1';
                                        RegWrite <=  '1';
                                        UBranch  <=  '0';
                                        ALUOp    <= "10";

               when "10010010000"   =>  Reg2Loc  <=  '-';        --ANDI      
                                        CBranch  <=  '0';
                                        MemRead  <=  '-';
                                        MemtoReg <=  '0';
                                        MemWrite <=  '0';
                                        ALUSrc   <=  '1';
                                        RegWrite <=  '1';
                                        UBranch  <=  '0';
                                        ALUOp    <= "10";
                                        
               when "10110010000"   =>  Reg2Loc  <=  '-';        --ORRI      
                                        CBranch  <=  '0';
                                        MemRead  <=  '-';
                                        MemtoReg <=  '0';
                                        MemWrite <=  '0';
                                        ALUSrc   <=  '1';
                                        RegWrite <=  '1';
                                        UBranch  <=  '0';
                                        ALUOp    <= "10";
               
               when "11010001000"   =>  Reg2Loc  <=  '-';        --SUBI      
                                        CBranch  <=  '0';
                                        MemRead  <=  '-';
                                        MemtoReg <=  '0';
                                        MemWrite <=  '0';
                                        ALUSrc   <=  '1';
                                        RegWrite <=  '1';
                                        UBranch  <=  '0';
                                        ALUOp    <= "10";
                                                       
               --load type format                   
               when "11111000010" =>    Reg2Loc  <= 'X';        
                                        CBranch  <= '0';
                                        MemRead  <= '1';
                                        MemtoReg <= '1';
                                        MemWrite <= '0';
                                        ALUSrc   <= '1';
                                        RegWrite <= '1';
                                        UBranch  <= '0';
                                        ALUOp    <="00";
               
               --store type format     
               when "11111000000" =>    Reg2Loc  <= '1';        
                                        CBranch  <= '0';
                                        MemRead  <= '0';
                                        MemtoReg <= 'X';
                                        MemWrite <= '1';
                                        ALUSrc   <= '1';
                                        RegWrite <= '0';
                                        UBranch  <= '0';
                                        ALUOp    <="00";         
               
               --conditional branch format
               when "10110100000" =>    Reg2Loc  <= '1';			--CBZ         
                                        CBranch  <= '1';
                                        MemRead  <= '0';
                                        MemtoReg <= 'X';
                                        MemWrite <= '0';
                                        ALUSrc   <= '0';
                                        RegWrite <= '0';
                                        UBranch  <= '0';
                                        ALUOp    <="01";
               
	       when "10110101000" =>	Reg2Loc  <= '1';                        --CBNZ
                                        CBranch  <= '1';
                                        MemRead  <= '0';
                                        MemtoReg <= 'X';
                                        MemWrite <= '0';
                                        ALUSrc   <= '0';
                                        RegWrite <= '0';
                                        UBranch  <= '0';
                                        ALUOp    <="01";

               --unconditional branch format
               when "00010100000" =>    Reg2Loc  <= 'X';        		--B
                                        CBranch  <= 'X';
                                        MemRead  <= 'X';
                                        MemtoReg <= 'X';
                                        MemWrite <= '0';
                                        ALUSrc   <= 'X';
                                        RegWrite <= '0';
                                        UBranch  <= '1';
                                        ALUOp    <="01";
               --others
               when others         =>   Reg2Loc  <= 'X';        
                                        CBranch  <= 'X';
                                        MemRead  <= 'X';
                                        MemtoReg <= 'X';
                                        MemWrite <= 'X';
                                        ALUSrc   <= 'X';
                                        RegWrite <= 'X';
                                        UBranch  <= 'X';
                                        ALUOp    <= "XX";
		end case;
	end process;              
end behavioral;

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
               when "1--0101-000" =>    Reg2Loc  <=  '0';      --R type format
                                        CBranch  <=  '0';
                                        MemRead  <=  '0';
                                        MemtoReg <=  '0';
                                        MemWrite <=  '0';
                                        ALUSrc   <=  '0';
                                        RegWrite <=  '1';
                                        UBranch  <=  '0';
                                        ALUOp    <= "10";
                                   
               when "11111000010" =>    Reg2Loc  <= 'X';        --load type format
                                        CBranch  <= '0';
                                        MemRead  <= '1';
                                        MemtoReg <= '1';
                                        MemWrite <= '0';
                                        ALUSrc   <= '1';
                                        RegWrite <= '1';
                                        UBranch  <= '0';
                                        ALUOp    <="00";

               when "11111000000" =>    Reg2Loc  <= '1';        --store type format
                                        CBranch  <= '0';
                                        MemRead  <= '0';
                                        MemtoReg <= 'X';
                                        MemWrite <= '1';
                                        ALUSrc   <= '1';
                                        RegWrite <= '0';
                                        UBranch  <= '0';
                                        ALUOp    <="00";         

               when "10110100---" =>    Reg2Loc  <= '1';         --conditional branch format
                                        CBranch  <= '1';
                                        MemRead  <= '0';
                                        MemtoReg <= 'X';
                                        MemWrite <= '0';
                                        ALUSrc   <= '0';
                                        RegWrite <= '0';
                                        UBranch  <= '0';
                                        ALUOp    <="01";
               
               when "00110100---" =>    Reg2Loc  <= 'X';        --unconditional branch format
                                        CBranch  <= 'X';
                                        MemRead  <= 'X';
                                        MemtoReg <= 'X';
                                        MemWrite <= '0';
                                        ALUSrc   <= 'X';
                                        RegWrite <= '0';
                                        UBranch  <= '1';
                                        ALUOp    <="01";

               when others         =>   Reg2Loc  <= 'X';        --others
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

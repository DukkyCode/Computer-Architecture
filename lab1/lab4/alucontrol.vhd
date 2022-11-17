library ieee;
use IEEE.std_logic_1164.all;


entity ALUControl is
-- Functionality should match truth table shown in Figure 4.13 in the textbook.
-- Check table on page2 of Green Card.pdf on canvas. Pay attention to opcode of operations and type of operations. 
-- If an operation doesn't use ALU, you don't need to check for its case in the ALU control implemenetation.	
--  To ensure proper functionality, you must implement the "don't-care" values in the funct field,
-- for example when ALUOp = '00", Operation must be "0010" regardless of what Funct is.
port(
     ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
     Opcode    : in  STD_LOGIC_VECTOR(10 downto 0);
     Operation : out STD_LOGIC_VECTOR(3 downto 0)
    );
end entity;

architecture behavioral of ALUcontrol is    
begin   
    process(ALUOp, Opcode)
        begin
            case ALUOp is
                when "00" => Operation <= "0010"; --Desired ALU action: add LOAD/STORE
                when "01" => case Opcode is 
                                when "10110101000" => Operation <= "0101"; --Desired ALU action: pass input b, CBNZ
                                when "10110100000" => Operation <= "0111"; --CBZ
				                when "00010100000" => Operation <= "0111"; --B
                                when others        => Operation <= "UUUU"; 
		                    end case;
		        when "10" => case Opcode is
                                --R-type
                                when "10001011000" => Operation <= "0010"; -- Desired ALU action: add
                                when "11001011000" => Operation <= "0110"; -- Desired ALU action: subtract
                                when "10001010000" => Operation <= "0000"; -- Desired ALU action: AND
                                when "10101010000" => Operation <= "0001"; -- Desired ALU action: OR

                                when "11010011010" => Operation <= "1011"; -- Desired ALU action: LSR
                                when "11010011011" => Operation <= "1110"; -- Desired ALU action: LSL

                                --I-Type
				                when "10010001000" => Operation <= "0010"; -- Desired ALU action: add
                                when "11010001000" => Operation <= "0110"; -- Desired ALU action: subtract
                                when "10010010000" => Operation <= "0000"; -- Desired ALU action: AND
                                when "10110010000" => Operation <= "0001"; -- Desired ALU action: OR      
                                when others => Operation <= "UUUU";
                            end case;
                when others => Operation <= "UUUU";
            end case;
    end process;   
end behavioral; 

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
-- Implement: AND, OR, ADD (signed), SUBTRACT (signed)
-- as described in Section 4.4 in the textbook.
-- The functionality of each instruction can be found on the 'ARM Reference Data' sheet at the
--    front of the textbook (or the Green Card pdf on Canvas).
port(
     in0       : in     STD_LOGIC_VECTOR(63 downto 0);
     in1       : in     STD_LOGIC_VECTOR(63 downto 0);
     operation : in     STD_LOGIC_VECTOR(3 downto 0);
     result    : buffer STD_LOGIC_VECTOR(63 downto 0);
     zero      : buffer STD_LOGIC;
     overflow  : buffer STD_LOGIC
    );
end ALU;

architecture behavioral of ALU is            
   
	    signal zero_sig		: std_logic;
	    signal complement_zero_sig	: std_logic;
	    signal zero_sel		: std_logic; 
   begin
        stimulus:process(operation, in0, in1)
            variable result_sig                : std_logic_vector(63 downto 0);
	    --variable zero_sig	               : std_logic;
	    --variable complement_zero_sig       : std_logic;
	    --variable zero_sel                  : std_logic;
            begin
                case operation is
                    when "0000" => result_sig  := in0 and in1                                                               ; --AND operation
                    when "0001" => result_sig  := in0 or in1                                                                ; --OR operation
                    when "0010" => result_sig  := std_logic_vector(signed(in0) + signed(in1))                               ; --ADD operation
                    when "0110" => result_sig  := std_logic_vector(signed(in0) - signed(in1))                               ; --SUBTRACT operation
                    
                    --when "1011" => result_sig  := std_logic_vector(signed(in0) srl to_integer(unsigned(in1)))               ; --LSR operation
                    --when "1110" => result_sig  := std_logic_vector(signed(in0) sll to_integer(unsigned(in1)))               ; --LSL operation    
                    
	            when "1011" => result_sig := std_logic_vector(shift_right(signed(in0), to_integer(unsigned(in1))));
		    when "1110" => result_sig := std_logic_vector(shift_left(signed(in0), to_integer(unsigned(in1))));

                    when "0111" => result_sig  := in1; zero_sel <= '0'                                                      ; --"pass input b" operation
                    when "0101" => result_sig  := in1; zero_sel <= '1'                                                      ; --branch if not zero 
		    
		    when "1100" => result_sig  := in0 nor in1                                                               ; --NOR operation
                    when others => null;
                end case;
	
		result <= result_sig;
		                
                --Setting the zero flag    
                if result_sig  = X"0000000000000000" then
                    zero_sig <= '1';
                else
                    zero_sig <= '0';
                end if;
		
		complement_zero_sig <= not zero_sig;
				
        end process;
		zero <= complement_zero_sig when (zero_sel = '1') else zero_sig;       
end behavioral;

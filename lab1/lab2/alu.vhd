library ieee;
use IEEE.std_logic_1164.all;

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
    --Bring component adder to the ALU
    component add is
        port(
            in0                 : in  std_logic_vector(63 downto 0);
            in1                 : in  std_logic_vector(63 downto 0);
            output              : out std_logic_vector(63 downto 0)
        );
    end component;
    
    --initialize signal	
    signal      result_sig          : std_logic_vector(63 downto 0);
    signal      add_result          : std_logic_vector(63 downto 0);
    signal      complement_result   : std_logic_vector(63 downto 0);
    signal      subtract_result     : std_logic_vector(63 downto 0);
    constant    incremental         : std_logic_vector(63 downto 0) := X"0000000000000001";
    
    begin
        --Adding arithmetic
        u1  : add port map(in0 => in0, in1 => in1, output => add_result);         
        
        --A - B = A + ~B + 1 (A is in0, B is in1, 1 is 1)
        u2  : add port map(in0 => "not"(in1), in1 => incremental, output => complement_result);
        
        --Subtracttion result
        u3  : add port map(in0 => in0, in1 => complement_result, output => subtract_result);

    stimulus:process(operation, in0, in1)      
     begin
        case operation is
            when "0000" => result_sig <= in0 and in1            ; --AND operation
            when "0001" => result_sig <= in0 or in1             ; --OR operation
            when "0010" => result_sig <= add_result             ; --ADD operation
            when "0110" => result_sig <= subtract_result        ; --SUBTRACT operation
            when "0111" => result_sig <= in1                    ; --"pass input b" operation
            when "1100" => result_sig <= in0 nor in1            ; --NOR operation
	    when others => null;
        end case;
        --Setting the zero flag    
        if result_sig = X"0000000000000000" then
            zero <= '1';
        else
            zero <= '0';
        end if;       
    end process;
    
    result <= result_sig;
    
end behavioral;

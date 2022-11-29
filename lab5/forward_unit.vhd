library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity forward_unit is
    port(
        IDEX_Rn         : in STD_LOGIC_VECTOR(4 downto 0);
        IDEX_Rm         : in STD_LOGIC_VECTOR(4 downto 0);
        
        EXMEM_Rd        : in STD_LOGIC_VECTOR(4 downto 0);
        MEMWB_Rd        : in STD_LOGIC_VECTOR(4 downt0 0);
        
        EXMEM_RegWrite  : in STD_LOGIC;
        MEMWB_RegWrite  : in STD_LOGIC;
        
        forwardA        : out STD_LOGIC_VECTOR(1 downt0 0);
        forwardB        : out STD_LOGIC_VECTOR(1 downto 0)        
    );
end forward_unit;

architecture behavioral of forward_unit is

begin
    forwarding: process(IDEX_Rn, IDEX_Rm, EXMEM_Rd, MEMWB_Rd, EXMEM_RegWrite, MEMWB_RegWrite)
    begin
        --FowardA Multiplexer Condition
        if (EXMEM_RegWrite = '1') and (EXMEM_Rd /= "11111") and (EXMEM_Rd = IDEX_Rn) then
            forwardA <= "10";
        elsif (MEMWB_RegWrite = '1') and (MEMWB_Rd /= "11111") and (MEMWB_Rd = IDEX_Rn) then 
            forwardA <= "01";
        else
            forwardA <= "00";
        end if;

        --FowardB Multiplexer Condition
        if (EXMEM_RegWrite = '1') and (EXMEM_Rd /= "11111") and (EXMEM_Rd = IDEX_Rm) then
            forwardB <= "10";
        elsif (MEMWB_RegWrite = '1') and (MEMWB_Rd /= "11111") and (MEMWB_Rd = IDEX_Rm) then 
            forwardB <= "01";
        else
            forwardB <= "00";
        end if;
    end process;

end behavioral;
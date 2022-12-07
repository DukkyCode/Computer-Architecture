library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity hazard_unit is
    port(
            IFID_Rn             : in STD_LOGIC_VECTOR(4 downto 0);
            IFID_Rm             : in STD_LOGIC_VECTOR(4 downto 0);        
            IDEX_MemRead        : in STD_LOGIC;
            IDEX_Rd             : in STD_LOGIC_VECTOR(4 downto 0);
            
            mux_sel             : out STD_LOGIC;
            IFID_Write          : out STD_LOGIC;
            PC_Write            : out STD_LOGIC  
    );
end hazard_unit;

architecture behavioral of hazard_unit is

begin 
    hazard: process(IFID_Rn, IFID_Rm, IDEX_MemRead, IDEX_Rd)
    begin
        if (IDEX_MemRead = '1') and ((IDEX_Rd = IFID_Rn) or (IDEX_Rd = IFID_Rm)) then
            mux_sel <= '1';
            PC_Write <= '0';
            IFID_Write <= '0';
        else
            mux_sel <= '0';
            PC_Write <= '1';
            IFID_Write <= '1'; 
        end if;
    end process;

end behavioral;
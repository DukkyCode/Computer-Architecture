library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MEMWB is
    port(
        clk             :   in STD_LOGIC;
        rst             :   in STD_LOGIC;
        --Control Lines
        MEM_RegWrite    :   in STD_LOGIC;
        MEM_MemtoReg    :   in STD_LOGIC;
        --Normal Lines
        MEM_ReadData    :   in STD_LOGIC_VECTOR(63 downto 0);
        MEM_aluresult   :   in STD_LOGIC_VECTOR(63 downto 0);
        MEM_in40        :   in STD_LOGIC_VECTOR(4 downto 0);
        --Control Lines        
	WB_RegWrite     :   out STD_LOGIC;
        WB_MemtoReg     :   out STD_LOGIC;
        --Normal Lines
        WB_in40         :   out STD_LOGIC_VECTOR(4 downto 0);
        WB_ReadData     :   out STD_LOGIC_VECTOR(63 downto 0);
        WB_aluresult    :   out STD_LOGIC_VECTOR(63 downto 0)        
    );
end entity;

architecture behavioral of MEMWB is    
    signal rst_val      :STD_LOGIC  := '1'; 
begin
    clock: process(clk, rst, MEM_RegWrite, MEM_MemtoReg, MEM_ReadData, MEM_aluresult)
    begin
        if rst = rst_val then
            --Control Lines
	    WB_MemtoReg     <= '0';
            WB_RegWrite     <= '0';
	    WB_in40	    <= (others => '0');
            --Normal Lines
            WB_aluresult    <=  (others => '0'); 
            WB_ReadData     <=  (others => '0');
        elsif rising_edge(clk) then
            --Control Lines
            WB_MemtoReg     <= MEM_MemtoReg;
            WB_RegWrite     <= MEM_RegWrite;
            --Normal Lines
	    WB_in40	    <= MEM_in40;
            WB_aluresult    <= MEM_aluresult; 
            WB_ReadData     <= MEM_ReadData;            
        end if;
    end process clock;
end behavioral;

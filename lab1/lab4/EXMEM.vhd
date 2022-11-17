library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity EXMEM is
    port(
            clk             : in STD_LOGIC;
            rst             : in STD_LOGIC;
            --Control Unit Lines
            EX_CBranch      : in STD_LOGIC;
            EX_UBranch      : in STD_LOGIC;
            EX_MemRead      : in STD_LOGIC;
            EX_MemtoReg     : in STD_LOGIC;
            EX_MemWrite     : in STD_LOGIC;
            EX_RegWrite     : in STD_LOGIC;
            --Normal Lines
            EX_addr         : in STD_LOGIC_VECTOR(63 downto 0);
            EX_zeroflag     : in STD_LOGIC;
            EX_aluresult    : in STD_LOGIC_VECTOR(63 downto 0);
            EX_RD2          : in STD_LOGIC_VECTOR(63 downto 0);
            EX_in40         : in STD_LOGIC_VECTOR(4 downto 0);
            --Control Unit Lines
            MEM_CBranch      : out STD_LOGIC;
            MEM_UBranch      : out STD_LOGIC;
            MEM_MemRead      : out STD_LOGIC;
            MEM_MemtoReg     : out STD_LOGIC;
            MEM_MemWrite     : out STD_LOGIC;
            MEM_RegWrite     : out STD_LOGIC;
            --Normal Lines
            MEM_addr         : out STD_LOGIC_VECTOR(63 downto 0);
            MEM_zeroflag     : out STD_LOGIC;
            MEM_aluresult    : out STD_LOGIC_VECTOR(63 downto 0);
            MEM_RD2          : out STD_LOGIC_VECTOR(63 downto 0);
            MEM_in40         : out STD_LOGIC_VECTOR(4 downto 0)
    );
end entity;

architecture behavioral of EXMEM is    
    signal rst_val      :STD_LOGIC  := '1'; 
begin
    clock: process(clk, rst, EX_CBranch, EX_UBranch, EX_MemRead, EX_MemtoReg, EX_MemWrite, EX_RegWrite, EX_addr, EX_zeroflag, EX_aluresult, EX_RD2, EX_in40)
    begin
        if rst = rst_val then
            --Normal Lines
            MEM_addr            <= (others => '0'); 
            MEM_zeroflag        <= '0';
            MEM_aluresult       <= (others => '0'); 
            MEM_RD2             <= (others => '0'); 
            MEM_in40            <= (others => '0');
            --Control Lines
            MEM_CBranch         <= '0';
            MEM_MemRead         <= '0';
            MEM_MemtoReg        <= '0';
            MEM_MemWrite        <= '0';
            MEM_RegWrite        <= '0';
            MEM_UBranch         <= '0';
            
        elsif rising_edge(clk) then
            --Normal Lines
            MEM_addr            <= EX_addr;
            MEM_zeroflag        <= EX_zeroflag;
            MEM_aluresult       <= EX_aluresult; 
            MEM_RD2             <= EX_RD2; 
            MEM_in40            <= EX_in40;
            --Control Lines
            MEM_CBranch         <= EX_CBranch;
            MEM_MemRead         <= EX_MemRead;
            MEM_MemtoReg        <= EX_MemtoReg;
            MEM_MemWrite        <= EX_MemWrite;
            MEM_RegWrite        <= EX_RegWrite;
            MEM_UBranch         <= EX_UBranch;          
        end if;
    end process clock;
end behavioral;

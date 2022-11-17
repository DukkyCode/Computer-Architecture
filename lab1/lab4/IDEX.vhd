library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IDEX is
    port(
        clk             : in STD_LOGIC;
        rst             : in STD_LOGIC;
        ID_pc           : in STD_LOGIC_VECTOR(63 downto 0);
        ID_RD1          : in STD_LOGIC_VECTOR(63 downto 0);
        ID_RD2          : in STD_LOGIC_VECTOR(63 downto 0);
        ID_signextend   : in STD_LOGIC_VECTOR(63 downto 0);
        ID_in3121       : in STD_LOGIC_VECTOR(10 downto 0);
        ID_in40         : in STD_LOGIC_VECTOR(4 downto 0);
        --Control Lines                     
        ID_CBranch      : in STD_LOGIC;
        ID_MemRead      : in STD_LOGIC;
        ID_MemtoReg     : in STD_LOGIC;
        ID_MemWrite     : in STD_LOGIC;
        ID_ALUSrc       : in STD_LOGIC;
        ID_RegWrite     : in STD_LOGIC;
        ID_UBranch      : in STD_LOGIC;
        ID_ALUOp        : in STD_LOGIC_VECTOR(1 downto 0);
        --Register, Instructions and sign extend output
        EX_pc           : out STD_LOGIC_VECTOR(63 downto 0);
        EX_RD1          : out STD_LOGIC_VECTOR(63 downto 0);
        EX_RD2          : out STD_LOGIC_VECTOR(63 downto 0);
        EX_signextend   : out STD_LOGIC_VECTOR(63 downto 0);
        EX_in3121       : out STD_LOGIC_VECTOR(10 downto 0);
        EX_in40         : out STD_LOGIC_VECTOR(4 downto 0);
        --Control Lines Output
        EX_CBranch      : out STD_LOGIC;
        EX_MemRead      : out STD_LOGIC;
        EX_MemtoReg     : out STD_LOGIC;
        EX_MemWrite     : out STD_LOGIC;
        EX_ALUSrc       : out STD_LOGIC;
        EX_RegWrite     : out STD_LOGIC;
        EX_UBranch      : out STD_LOGIC;
        EX_ALUOp        : out STD_LOGIC_VECTOR(1 downto 0)
    );        
end entity;

architecture behavioral of IDEX is
    signal rst_val      : STD_LOGIC  := '1';
begin
    clock: process(clk, rst, ID_pc, ID_RD1, ID_RD2, ID_signextend, ID_in3121, ID_in40, ID_CBranch, ID_MemRead, ID_MemtoReg, ID_MemWrite, ID_ALUSrc, ID_RegWrite, ID_UBranch, ID_ALUOp)
    begin
        if rst = rst_val then
            EX_pc           <= (others => '0');  
            EX_RD1          <= (others => '0'); 
            EX_RD2          <= (others => '0'); 
            EX_signextend   <= (others => '0'); 
            EX_in3121       <= (others => '0'); 
            EX_in40         <= (others => '0'); 
            --Control Lines Output
            EX_CBranch      <= '0';
            EX_MemRead      <= '0';
            EX_MemtoReg     <= '0';
            EX_MemWrite     <= '0';
            EX_ALUSrc       <= '0';
            EX_RegWrite     <= '0';
            EX_UBranch      <= '0';
            EX_ALUOp        <= (others => '0');
        elsif rising_edge(clk) then
            EX_pc           <= ID_pc;  
            EX_RD1          <= ID_RD1;
            EX_RD2          <= ID_RD2;
            EX_signextend   <= ID_signextend; 
            EX_in3121       <= ID_in3121; 
            EX_in40         <= ID_in40;
            --Control Lines Output
            EX_CBranch      <= ID_CBranch;
            EX_MemRead      <= ID_MemRead;
            EX_MemtoReg     <= ID_MemtoReg;
            EX_MemWrite     <= ID_MemWrite;
            EX_ALUSrc       <= ID_ALUSrc;
            EX_RegWrite     <= ID_RegWrite;
            EX_UBranch      <= ID_UBranch;
            EX_ALUOp        <= ID_ALUOp;
        end if;
    end process clock;
end behavioral;

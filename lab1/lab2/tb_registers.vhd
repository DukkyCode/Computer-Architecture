library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_registers is
    --Declare entity
end entity;

architecture behavioral of tb_registers is
    component registers is
        port(
                RR1      : in  STD_LOGIC_VECTOR (4 downto 0); 
                RR2      : in  STD_LOGIC_VECTOR (4 downto 0); 
                WR       : in  STD_LOGIC_VECTOR (4 downto 0); 
                WD       : in  STD_LOGIC_VECTOR (63 downto 0);
                RegWrite : in  STD_LOGIC;
                Clock    : in  STD_LOGIC;
                RD1      : out STD_LOGIC_VECTOR (63 downto 0);
                RD2      : out STD_LOGIC_VECTOR (63 downto 0);
                --Probe ports used for testing.
                -- Notice the width of the port means that you are 
                --      reading only part of the register file. 
                -- This is only for debugging
                -- You are debugging a sebset of registers here
                -- Temp registers: $X9 & $X10 & X11 & X12 
                -- 4 refers to number of registers you are debugging
                DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
                -- Saved Registers X19 & $X20 & X21 & X22 
                DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)

        );
    end component;

    signal    tb_RR1      : STD_LOGIC_VECTOR (4 downto 0); 
    signal    tb_RR2      : STD_LOGIC_VECTOR (4 downto 0); 
    signal    tb_WR       : STD_LOGIC_VECTOR (4 downto 0); 
    signal    tb_WD       : STD_LOGIC_VECTOR (63 downto 0);
    signal    tb_RegWrite : STD_LOGIC;
    signal    tb_Clock    : STD_LOGIC;
    signal    tb_RD1      : STD_LOGIC_VECTOR (63 downto 0);
    signal    tb_RD2      : STD_LOGIC_VECTOR (63 downto 0);

    constant clk_period   : time := 50 ns;

    signal   tb_DEBUG_TMP_REGS     : STD_LOGIC_VECTOR(64*4 - 1 downto 0);
    signal   tb_DEBUG_SAVED_REGS   : STD_LOGIC_VECTOR(64*4 - 1 downto 0);

begin  
    uut : registers port map(RR1 => tb_RR1, RR2 => tb_RR2, WR => tb_WR, WD => tb_WD, RegWrite => tb_RegWrite, Clock => tb_Clock, RD1 => tb_RD1, RD2 => tb_RD2, DEBUG_TMP_REGS => tb_DEBUG_TMP_REGS, DEBUG_SAVED_REGS => tb_DEBUG_SAVED_REGS);

    --Clock Cycle
    clock_cycle :process
    begin
        tb_Clock <= '0';
        wait for clk_period/2;
        tb_Clock <= '1';
        wait for clk_period/2;
    end process;    

    --Testing check
    stimlus: process
    begin
        tb_RR1      <= "01110"; --Read X14
        tb_RR2      <= "01111"; --Read X15
	tb_RegWrite <= '1';     --Enable Register Write
        tb_WR       <= "00010"; --Write into X4
        tb_WD       <= X"0000000000000004"; --Content is 4
        wait for 100 ns;

        tb_RR1      <= "00010"; --Read X4
        tb_RR2      <= "11010"; --Read X26
        tb_WR       <= "11111"; --Try to write into XZR/X31 --Should give error
        tb_WD       <= X"0000000000000004"; --Content is 4
        wait for 100 ns;
    end process;
end behavioral;

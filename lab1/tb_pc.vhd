
library ieee;
use ieee.std_logic_1164.all;

entity tb_pc is
    --Declared entity
end tb_pc;

architecture behavioral of tb_pc is
    --Declare component
    component pc is
        port(
            clk          : in  STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
            write_enable : in  STD_LOGIC; -- Only write if '1'
            rst          : in  STD_LOGIC; -- Asynchronous reset! Sets AddressOut to 0x0
            AddressIn    : in  STD_LOGIC_VECTOR(63 downto 0); -- Next PC address
            AddressOut   : out STD_LOGIC_VECTOR(63 downto 0) -- Current PC address
       );
    end component;
    
    --Initial Values
    signal tb_clk                       : STD_LOGIC := '0';
    signal tb_write_enable              : STD_LOGIC := '0';
    signal tb_rst                       : STD_LOGIC := '0';
    signal tb_AddressIn                 : STD_LOGIC_VECTOR(63 downto 0);
    signal tb_AddressOut                : STD_LOGIC_VECTOR(63 downto 0);
    --Clock constand for clock
    constant clk_period                 : time := 50 ns;

begin
    uut: pc port map(clk => tb_clk, write_enable => tb_write_enable, rst => tb_rst, AddressIn => tb_AddressIn, AddressOut => tb_AddressOut);
    --Clock Process
    clock_cycle :process
    begin
        tb_clk <= '0';
        wait for clk_period/2;
        tb_clk <= '1';
        wait for clk_period/2;
    end process;
    --Testing process
    stimlus :process
    begin
        tb_rst <= '1';
        tb_write_enable <= '1';
        tb_AddressIn <= X"0000000000000000";
        wait for 100 ns;
        tb_AddressIn <= X"0000000000000001";
        wait for 100 ns;
        tb_AddressIn <= X"0000000000000002";
        wait for 100 ns;
        tb_rst <= '0';
        wait for 100 ns;
        tb_rst <= '1';
        tb_AddressIn <= X"0000000000000003";
        wait for 100 ns;
	tb_write_enable <= '0';
	tb_AddressIn <= X"0000000000000004";
	wait for 100 ns;
    end process;    
end behavioral;

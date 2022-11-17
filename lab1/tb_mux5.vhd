
library ieee;
use ieee.std_logic_1164.all;

entity tb_mux5 is
    --Declard entity
end tb_mux5;

architecture behavioral of tb_mux5 is
    --Declare component
    component mux5 is
        port(
            in0    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 0
            in1    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 1
            sel    : in STD_LOGIC; -- selects in0 or in1
            output : out STD_LOGIC_VECTOR(4 downto 0)
        );
    end component;

    signal tb_in0       : STD_LOGIC_VECTOR(4 downto 0);
    signal tb_in1       : STD_LOGIC_VECTOR(4 downto 0);
    signal tb_sel       : STD_LOGIC := '0';
    signal tb_output    : STD_LOGIC_VECTOR(4 downto 0);

begin
    uut : mux5 port map (in0 => tb_in0, in1 => tb_in1, sel => tb_sel, output => tb_output);
    --Testing Process
    stimlus: process
    begin
        tb_in0 <= "11111";
        tb_in1 <= "00001";
        tb_sel <= '0';
        wait for 100 ns;
        tb_sel <= '1';
        wait for 100 ns;
        tb_sel <= '0';
    end process;
end behavioral;
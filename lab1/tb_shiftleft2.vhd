
library ieee;
use ieee.std_logic_1164.all;

entity tb_shiftleft2 is
    --Declared entity
end tb_shiftleft2;

architecture behavioral of tb_shiftleft2 is
    --Declare component
    component shiftleft2 is
        port(
            x : in  STD_LOGIC_VECTOR(63 downto 0);
            y : out STD_LOGIC_VECTOR(63 downto 0) -- x << 2
    );
    end component;

    signal tb_x: STD_LOGIC_VECTOR(63 downto 0);
    signal tb_y: STD_LOGIC_VECTOR(63 downto 0);

begin
    uut : shiftleft2 port map (x => tb_x, y => tb_y);
    --Testbench process
    stimulus: process
    begin
       tb_x <= X"0000000000000001";
       wait for 100 ns;
       tb_x <= X"000000000000000F";
       wait for 100 ns;
    end process;
end behavioral;
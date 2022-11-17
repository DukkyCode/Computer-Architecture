
library ieee;
use ieee.std_logic_1164.all;

entity tb_signextend is
    --Declared entity
end tb_signextend;

architecture behavioral of tb_signextend is
    --Declare component
    component SignExtend is
        port(
            x : in  STD_LOGIC_VECTOR(31 downto 0);
            y : out STD_LOGIC_VECTOR(63 downto 0) -- sign-extend(x)
    );
    end component;

    signal tb_x: STD_LOGIC_VECTOR(31 downto 0);
    signal tb_y: STD_LOGIC_VECTOR(63 downto 0);

begin
    uut : SignExtend port map (x => tb_x, y => tb_y);
    --Testbench process
    stimulus: process
    begin
       tb_x <= X"00000001";
       wait for 100 ns;
       tb_x <= X"F0000000";
       wait for 100 ns;
    end process;
end behavioral;

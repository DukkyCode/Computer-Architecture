
library ieee;
use ieee.std_logic_1164.all;

entity tb_and2 is
    --Declard entity
end tb_and2;

architecture behavioral of tb_and2 is
    --Declare component
component AND2 is
    port(
        in0     : in std_logic;
        in1     : in std_logic;
        output : out std_logic
    );
end component;

--Declard initial values
signal a,b,c    : std_logic := '0';

begin 

uut : AND2 port map (in0 => a, in1 => b, output => c);

stimulus    : process
begin
    a <= '0';
    b <= '0';
    wait for 100 ns;
    a <= '0';
    b <= '1';
    wait for 100 ns;
    a <= '1';
    b <= '0';
    wait for 100 ns;
    a <= '1';
    b <= '1';
    wait;
end process;

end behavioral;
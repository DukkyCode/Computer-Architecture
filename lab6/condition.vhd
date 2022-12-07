library ieee;
use ieee.std_logic_1164.all;

entity condition is
    port(
        x               : in std_logic_vector(63 downto 0);
        y               : in std_logic_vector(63 downto 0);
        z               : out std_logic;
    );
end condition;

architecture behavioral of condition is
    begin
        compare: process(x, y)
        begin
            if x = y then
                z = '1';
            else
                z = '0';
            end if;        
        end process compare;
end behavioral;
library ieee;
use ieee.std_logic_1164.all;

entity orgate is
    port(
        x               : in std_logic;
        y               : in std_logic;
        z               : out std_logic
    );
end orgate;

architecture behavioral of orgate is
    begin
        z     <= x or y;       
end behavioral;
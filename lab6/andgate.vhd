library ieee;
use ieee.std_logic_1164.all;

entity andgate is
    port(
        x               : in std_logic;
        y               : in std_logic;
        z               : out std_logic
    );
end entity;

architecture behavioral of andgate is
    begin
        z     <= x and y;       
end behavioral;
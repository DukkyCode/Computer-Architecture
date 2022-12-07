
library IEEE;
use IEEE.std_logic_1164.all;

entity halfadder is
    port(
        a               : in std_logic;
        b               : in std_logic;
        c               : out std_logic;
        sum             : out std_logic 
    );
end halfadder;

architecture behavioral of halfadder is
    begin
        sum             <= a xor b;
        c               <= a and b;
end behavioral;

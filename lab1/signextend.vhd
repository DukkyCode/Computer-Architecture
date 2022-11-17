library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignExtend is
port(
     x : in  STD_LOGIC_VECTOR(31 downto 0);
     y : out STD_LOGIC_VECTOR(63 downto 0) -- sign-extend(x)
);
end SignExtend;

architecture behavioral of SignExtend is
--Check if the most significant bytes is 1 or 0 
begin
     cycle: process(x)
     begin
          if x(31) = '0' then
               y <= X"00000000" & x;
          else
               y <= X"FFFFFFFF" & x;
          end if;
     end process;    
end behavioral;




library ieee;
use ieee.std_logic_1164.all;

entity MUX8 is -- Two by one mux with 5 bit inputs/outputs
port(
    in0    : in STD_LOGIC_VECTOR(7 downto 0); -- sel == 0
    in1    : in STD_LOGIC_VECTOR(7 downto 0); -- sel == 1
    sel    : in STD_LOGIC; -- selects in0 or in1
    output : out STD_LOGIC_VECTOR(7 downto 0)
);
end MUX8;

--Architechture for 2 by 1 mux with 5 bit inputs/outputs
architecture behavioral of MUX8 is
    begin
        output <= in1 when (sel = '1') else in0;
end behavioral;

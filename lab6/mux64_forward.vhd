library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MUX64_FORWARD is
    port(
        in0         : in STD_LOGIC_VECTOR(63 downto 0);
        in1         : in STD_LOGIC_VECTOR(63 downto 0);
        in2         : in STD_LOGIC_VECTOR(63 downto 0);
        sel         : in STD_LOGIC_VECTOR(1 downto 0);
        output      : out STD_LOGIC_VECTOR(63 downto 0)
    );
end MUX64_FORWARD;

architecture behavioral of MUX64_FORWARD is
begin 
    cycle: process(in0, in1, in2, sel)
    begin
        if (sel = "00") then
            output <= in0;
        elsif (sel = "01") then
            output <= in1;
        elsif (sel = "10") then
            output <= in2;
        else
            output <= (others => 'X');
        end if;
    end process;
end behavioral;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_signextend is
    --Declare entity
end entity;

architecture behavioral of tb_signextend is
    component signextend is
        port(
            x       : in std_logic_vector(31 downto 0);
            y       : out std_logic_vector(63 downto 0)   
    );
    end component;
    
    signal tb_x     : std_logic_vector(31 downto 0);
    signal tb_y     : std_logic_vector(63 downto 0);

begin
    uut : signextend port map(x => tb_x, y => tb_y);

    process
    begin
        tb_x(31 downto 21) <= "11111000000";
	tb_x(20 downto 0)  <= (others => '1');
	wait for 100 ns;
    end process;
    
end behavioral;
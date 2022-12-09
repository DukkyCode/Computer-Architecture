library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IFID is
    port(
        clk             : in STD_LOGIC;
        rst             : in STD_LOGIC;
        write_enable    : in STD_LOGIC;
        IF_pc           : in STD_LOGIC_VECTOR(63 downto 0);
        IF_imem         : in STD_LOGIC_VECTOR(31 downto 0);
        IF_Flush        : in  STD_LOGIC;
        ID_pc           : out STD_LOGIC_VECTOR(63 downto 0);
        ID_imem         : out STD_LOGIC_VECTOR(31 downto 0);
	ID_Flush        : out STD_LOGIC);
     
end IFID;

architecture behavioral of IFID is    
    signal rst_val      :STD_LOGIC  := '1'; 
begin
    clock: process(clk, rst, write_enable)
    begin
        if rst = rst_val then
            ID_imem     <= (others => '0'); 
            ID_pc       <= (others => '0');   
        elsif rising_edge(clk) then
            if write_enable = '1' then
                ID_imem     <= IF_imem;
                ID_pc       <= IF_pc;
                ID_Flush    <= IF_Flush;
            end if;                       
       end if;
    end process clock;
end behavioral;

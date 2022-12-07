library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signextend is
	port(
		x	: in std_logic_vector(31 downto 0);
		y	: out std_logic_vector(63 downto 0)
	);
end signextend;

architecture behavioral of signextend is
	signal OPcode 		: std_logic_vector(10 downto 0);
begin
	OPcode <= x(31 downto 21);
		
	process(OPcode,x)
	begin
		case OPcode is
			--Logical Shift Operation
			when "11010011010" => y <= "00" & X"00000000000000" & x(15 downto 10);		--LSR
			when "11010011011" => y <= "00" & X"00000000000000" & x(15 downto 10);		--LSL
			
			--I-Type Format
			when "10010001000" => y <= "0" & X"0000000000000" & x(20 downto 10);		--ADDI
			when "10010010000" => y <= "0" & X"0000000000000" & x(20 downto 10);		--ANDI
			when "10110010000" => y <= "0" & X"0000000000000" & x(20 downto 10);		--ORRI
			when "11010001000" => y <= "0" & X"0000000000000" & x(20 downto 10);		--SUBI

			--Normal format
			when "11111000010" => y <= "000" & X"0000000000000" & x(20 downto 12);		--Load instruction
			when "11111000000" => y <= "000" & X"0000000000000" & x(20 downto 12);		--Store instruction
			when "10110100000" => y <= "0" & X"00000000000" & x(23 downto 5);		--CBZ, Conditional Branch
			when "10110101000" => y <= "0" & X"00000000000" & x(23 downto 5);		--CBNZ, Conditional Branch
			when "00010100000" => y <= "00" & X"000000000" & x(25 downto 0);		--Unconditional Branch			  		
			when others => null;
		end case;
	end process;
end behavioral;

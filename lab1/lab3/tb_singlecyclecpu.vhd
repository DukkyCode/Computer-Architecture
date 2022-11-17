library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_singlecyclecpu is
	--Declare entity
end entity;

architecture behavioral of tb_singlecyclecpu is 
	component singlecyclecpu is 
		port(	clk :in STD_LOGIC;
     			rst :in STD_LOGIC;
    			--Probe ports used for testing
     			--The current address (AddressOut from the PC)
     			DEBUG_PC : out STD_LOGIC_VECTOR(63 downto 0);
     			--The current instruction (Instruction output of IMEM)
     			DEBUG_INSTRUCTION : out STD_LOGIC_VECTOR(31 downto 0);
     			--DEBUG ports from other components
     			DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
    			DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     			DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
		);
	end component;
	
	signal tb_clk	: std_logic := '1';
	signal tb_rst	: std_logic := '1';
     	signal tb_DEBUG_PC : STD_LOGIC_VECTOR(63 downto 0);
     	--The current instruction (Instruction output of IMEM)
     	signal tb_DEBUG_INSTRUCTION : STD_LOGIC_VECTOR(31 downto 0);
     	--DEBUG ports from other components
     	signal tb_DEBUG_TMP_REGS : STD_LOGIC_VECTOR(64*4 - 1 downto 0);
    	signal tb_DEBUG_SAVED_REGS : STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     	signal tb_DEBUG_MEM_CONTENTS : STD_LOGIC_VECTOR(64*4 - 1 downto 0);
 

begin
	uut: singlecyclecpu port map(	clk => tb_clk, 
					rst => tb_rst, 
					DEBUG_PC => tb_DEBUG_PC, 
					DEBUG_INSTRUCTION => tb_DEBUG_INSTRUCTION, 
					DEBUG_TMP_REGS => tb_DEBUG_TMP_REGS, 
					DEBUG_SAVED_REGS => tb_DEBUG_SAVED_REGS, 
					DEBUG_MEM_CONTENTS => tb_DEBUG_MEM_CONTENTS);
	stimulus: process
	begin
		
		tb_rst <= '1';
		
		wait for 20 ns;
		tb_rst <= '0';		
		
		tb_clk <= '0';		
		wait for 100 ns;
		tb_clk <= '1';
		
		wait for 100 ns;
		tb_clk <= '0';		
		wait for 100 ns;
		tb_clk <= '1';
		
		wait for 100 ns;
		tb_clk <= '0';		
		wait for 100 ns;
		tb_clk <= '1';
		
		wait for 100 ns;
		tb_clk <= '0';		
		wait for 100 ns;
		tb_clk <= '1';
		
		wait for 100 ns;
		tb_clk <= '0';
		wait for 100 ns;
		tb_clk <= '1';

		wait for 100 ns;
                tb_clk <= '0';
                wait for 100 ns;
                tb_clk <= '1';

		wait for 100 ns;
                tb_clk <= '0';
                wait for 100 ns;
                tb_clk <= '1';

		wait for 100 ns;
                tb_clk <= '0';
                wait for 100 ns;
                tb_clk <= '1';

		--wait for 100 ns;
                --tb_clk <= '0';
                --wait for 100 ns;
                --tb_clk <= '1';

	        wait for 100 ns;
                tb_clk <= '0';
		tb_rst <= '1';
				
		--wait for 100 ns;
		--tb_clk <= '1';
		--wait for 100 ns;
		--tb_clk <= '0';	
		wait;
	end process;	
end behavioral;

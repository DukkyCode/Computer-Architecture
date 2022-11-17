library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_pipelinecpu0 is
    --Declare Entity
end entity;


architecture behavioral of tb_pipelinecpu0 is 
	component PipelinedCPU0 is 
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
	uut: PipelinedCPU0 port map(	clk => tb_clk, 
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
		
        --Cycle 1
	tb_clk <= '0';		
	wait for 100 ns;
	tb_clk <= '1';
		
        --Cycle 2
	wait for 100 ns;
	tb_clk <= '0';		
	wait for 100 ns;
	tb_clk <= '1';
		
        --Cycle 3
	wait for 100 ns;
	tb_clk <= '0';		
	wait for 100 ns;
	tb_clk <= '1';
		
        --Cycle 4
	wait for 100 ns;
	tb_clk <= '0';		
	wait for 100 ns;
	tb_clk <= '1';
		
        --Cycle 5
	wait for 100 ns;
	tb_clk <= '0';
	wait for 100 ns;
	tb_clk <= '1';
        
        --Cycle 6
	wait for 100 ns;
        tb_clk <= '0';
        wait for 100 ns;
        tb_clk <= '1';
        
        --Cycle 7
	wait for 100 ns;
        tb_clk <= '0';
        wait for 100 ns;
        tb_clk <= '1';
        
        --Cycle 8
	wait for 100 ns;
        tb_clk <= '0';
        wait for 100 ns;
        tb_clk <= '1';
        
        --Cycle 9
	wait for 100 ns;
        tb_clk <= '0';
        wait for 100 ns;
        tb_clk <= '1';
       
        --Cycle 10
	wait for 100 ns;
        tb_clk <= '0';
        wait for 100 ns;
        tb_clk <= '1';

        --Cycle 11
	wait for 100 ns;
        tb_clk <= '0';
        wait for 100 ns;
        tb_clk <= '1';

        --Cycle 12
	wait for 100 ns;
        tb_clk <= '0';
        wait for 100 ns;
        tb_clk <= '1';

        --Cycle 13
        wait for 100 ns;
        tb_clk <= '0';
        wait for 100 ns;
        tb_clk <= '1';

        --Cycle 14
        wait for 100 ns;
        tb_clk <= '0';
        wait for 100 ns;
        tb_clk <= '1';

        --Cycle 15
        wait for 100 ns;
        tb_clk <= '0';
        wait for 100 ns;
        tb_clk <= '1';
	
	 --Cycle 16
        wait for 100 ns;
        tb_clk <= '0';
        wait for 100 ns;
        tb_clk <= '1';

	--Cycle 17
        wait for 100 ns;
        tb_clk <= '0';
        wait for 100 ns;
        tb_clk <= '1';

	--Cycle 18
        wait for 100 ns;
        tb_clk <= '0';
        wait for 100 ns;
        tb_clk <= '1';

	--Cycle 19
        wait for 100 ns;
        tb_clk <= '0';
        wait for 100 ns;
        tb_clk <= '1';
			       
        --Reset
	wait for 100 ns;
	tb_rst <= '1';
	wait;
	end process;	

end behavioral;

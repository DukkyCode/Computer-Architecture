library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity PipelinedCPU1 is
    port(
        clk :in std_logic;
        rst :in std_logic;
        --Probe ports used for testing
        -- Forwarding control signals
        DEBUG_FORWARDA : out std_logic_vector(1 downto 0);
        DEBUG_FORWARDB : out std_logic_vector(1 downto 0);
        --The current address (AddressOut from the PC)
        DEBUG_PC : out std_logic_vector(63 downto 0);
        --Value of PC.write_enable
        DEBUG_PC_WRITE_ENABLE : out STD_LOGIC;
        --The current instruction (Instruction output of IMEM)
        DEBUG_INSTRUCTION : out std_logic_vector(31 downto 0);
        --DEBUG ports from other components
        DEBUG_TMP_REGS : out std_logic_vector(64*4-1 downto 0);
        DEBUG_SAVED_REGS : out std_logic_vector(64*4-1 downto 0);
        DEBUG_MEM_CONTENTS : out std_logic_vector(64*4-1 downto 0)
    );
end PipelinedCPU1;

architecture behavioral of PipelinedCPU1 is
    --Basic gates
    component orgate is
        port(
            x               : in std_logic;
            y               : in std_logic;
            z               : out std_logic
        );
   end component;

   component andgate is
    port(
        x               : in std_logic;
        y               : in std_logic;
        z               : out std_logic
    );
    end component;   

    --Main Component
    component add is
        port(
            in0       : in std_logic_vector(63 downto 0);
            in1       : in std_logic_vector(63 downto 0);
            output    : out std_logic_vector(63 downto 0)
        );
    end component;
   
    component alu is
        port(
            in0       : in     STD_LOGIC_VECTOR(63 downto 0);
            in1       : in     STD_LOGIC_VECTOR(63 downto 0);
            operation : in     STD_LOGIC_VECTOR(3 downto 0);
            result    : buffer STD_LOGIC_VECTOR(63 downto 0);
            zero      : buffer STD_LOGIC;
            overflow  : buffer STD_LOGIC
        );          
    end component;

    component ALUControl is
        port(
            ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
            Opcode    : in  STD_LOGIC_VECTOR(10 downto 0);
            Operation : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component CPUControl is
        port(
            Opcode   : in  STD_LOGIC_VECTOR(10 downto 0);
            Reg2Loc  : out STD_LOGIC;
            CBranch  : out STD_LOGIC;  --conditional
            MemRead  : out STD_LOGIC;
            MemtoReg : out STD_LOGIC;
            MemWrite : out STD_LOGIC;
            ALUSrc   : out STD_LOGIC;
            RegWrite : out STD_LOGIC;
            UBranch  : out STD_LOGIC; -- This is unconditional
            ALUOp    : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

    component DMEM is
        port(
            WriteData          : in  STD_LOGIC_VECTOR(63 downto 0); -- Input data
            Address            : in  STD_LOGIC_VECTOR(63 downto 0); -- Read/Write address
            MemRead            : in  STD_LOGIC; -- Indicates a read operation
            MemWrite           : in  STD_LOGIC; -- Indicates a write operation
            Clock              : in  STD_LOGIC; -- Writes are triggered by a rising edge
            ReadData           : out STD_LOGIC_VECTOR(63 downto 0); -- Output data
            --Probe ports used for testing
            DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
        );
    end component;

    component imem is
        port(
            Address  : in  STD_LOGIC_VECTOR(63 downto 0); -- Address to read from
            ReadData : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component MUX5 is
        port(
            in0    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 0
            in1    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 1
            sel    : in STD_LOGIC; -- selects in0 or in1
            output : out STD_LOGIC_VECTOR(4 downto 0) 
        );
    end component;

   component MUX64 is
        port(
            in0    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 0
            in1    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 1
            sel    : in STD_LOGIC; -- selects in0 or in1
            output : out STD_LOGIC_VECTOR(63 downto 0)
        );
   end component;

   component PC is
        port(
            clk          : in  STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
            write_enable : in  STD_LOGIC; -- Only write if '1'
            rst          : in  STD_LOGIC; -- Asynchronous reset! Sets AddressOut to 0x0
            AddressIn    : in  STD_LOGIC_VECTOR(63 downto 0); -- Next PC address
            AddressOut   : out STD_LOGIC_VECTOR(63 downto 0) -- Current PC address               
        );
   end component;

    component registers is
        port(
            RR1      : in  STD_LOGIC_VECTOR (4 downto 0); 
            RR2      : in  STD_LOGIC_VECTOR (4 downto 0); 
            WR       : in  STD_LOGIC_VECTOR (4 downto 0); 
            WD       : in  STD_LOGIC_VECTOR (63 downto 0);
            RegWrite : in  STD_LOGIC;
            Clock    : in  STD_LOGIC;
            RD1      : out STD_LOGIC_VECTOR (63 downto 0);
            RD2      : out STD_LOGIC_VECTOR (63 downto 0);
            -- Temp registers: $X9 & $X10 & X11 & X12
            DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
            -- Saved Registers X19 & $X20 & X21 & X22 
            DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
        );
    end component;
   
    component ShiftLeft2 is
        port(
            x : in  STD_LOGIC_VECTOR(63 downto 0);
            y : out STD_LOGIC_VECTOR(63 downto 0) -- x << 2
        );
    end component;

    component signextend is
        port(
            x	: in std_logic_vector(31 downto 0);
            y	: out std_logic_vector(63 downto 0)
        );
    end component;

    --Pipeline Component
    component IFID is
        port(
            clk             : in STD_LOGIC;
            rst             : in STD_LOGIC;
            write_enable    : in STD_LOGIC;
            IF_pc           : in STD_LOGIC_VECTOR(63 downto 0);
            IF_imem         : in STD_LOGIC_VECTOR(31 downto 0);
            ID_pc           : out STD_LOGIC_VECTOR(63 downto 0);
            ID_imem         : out STD_LOGIC_VECTOR(31 downto 0)               
            );           
    end component;

    component IDEX is
        port(
            clk             : in STD_LOGIC;
            rst             : in STD_LOGIC;
            ID_pc           : in STD_LOGIC_VECTOR(63 downto 0);
            ID_RD1          : in STD_LOGIC_VECTOR(63 downto 0);
            ID_RD2          : in STD_LOGIC_VECTOR(63 downto 0);
            ID_signextend   : in STD_LOGIC_VECTOR(63 downto 0);
            ID_in3121       : in STD_LOGIC_VECTOR(10 downto 0);
            ID_in40         : in STD_LOGIC_VECTOR(4 downto 0);
            --Control Lines                     
            ID_CBranch      : in STD_LOGIC;
            ID_MemRead      : in STD_LOGIC;
            ID_MemtoReg     : in STD_LOGIC;
            ID_MemWrite     : in STD_LOGIC;
            ID_ALUSrc       : in STD_LOGIC;
            ID_RegWrite     : in STD_LOGIC;
            ID_UBranch      : in STD_LOGIC;
            ID_ALUOp        : in STD_LOGIC_VECTOR(1 downto 0);
            --Register, Instructions and sign extend output
            EX_pc           : out STD_LOGIC_VECTOR(63 downto 0);
            EX_RD1          : out STD_LOGIC_VECTOR(63 downto 0);
            EX_RD2          : out STD_LOGIC_VECTOR(63 downto 0);
            EX_signextend   : out STD_LOGIC_VECTOR(63 downto 0);
            EX_in3121       : out STD_LOGIC_VECTOR(10 downto 0);
            EX_in40         : out STD_LOGIC_VECTOR(4 downto 0);
            --Control Lines Output
            EX_CBranch      : out STD_LOGIC;
            EX_MemRead      : out STD_LOGIC;
            EX_MemtoReg     : out STD_LOGIC;
            EX_MemWrite     : out STD_LOGIC;
            EX_ALUSrc       : out STD_LOGIC;
            EX_RegWrite     : out STD_LOGIC;
            EX_UBranch      : out STD_LOGIC;
            EX_ALUOp        : out STD_LOGIC_VECTOR(1 downto 0)
        );        
   end component;

   component EXMEM is
    port(
            clk             : in STD_LOGIC;
            rst             : in STD_LOGIC;
            --Control Unit Lines
            EX_CBranch      : in STD_LOGIC;
            EX_UBranch      : in STD_LOGIC;
            EX_MemRead      : in STD_LOGIC;
            EX_MemtoReg     : in STD_LOGIC;
            EX_MemWrite     : in STD_LOGIC;
            EX_RegWrite     : in STD_LOGIC;
            --Normal Lines
            EX_addr         : in STD_LOGIC_VECTOR(63 downto 0);
            EX_zeroflag     : in STD_LOGIC;
            EX_aluresult    : in STD_LOGIC_VECTOR(63 downto 0);
            EX_RD2          : in STD_LOGIC_VECTOR(63 downto 0);
            EX_in40         : in STD_LOGIC_VECTOR(4 downto 0);
            --Control Unit Lines
            MEM_CBranch      : out STD_LOGIC;
            MEM_UBranch      : out STD_LOGIC;
            MEM_MemRead      : out STD_LOGIC;
            MEM_MemtoReg     : out STD_LOGIC;
            MEM_MemWrite     : out STD_LOGIC;
            MEM_RegWrite     : out STD_LOGIC;
            --Normal Lines
            MEM_addr         : out STD_LOGIC_VECTOR(63 downto 0);
            MEM_zeroflag     : out STD_LOGIC;
            MEM_aluresult    : out STD_LOGIC_VECTOR(63 downto 0);
            MEM_RD2          : out STD_LOGIC_VECTOR(63 downto 0);
            MEM_in40         : out STD_LOGIC_VECTOR(4 downto 0)
    );
    end component;

    component MEMWB is
        port(
            clk             :   in STD_LOGIC;
            rst             :   in STD_LOGIC;
            --Control Lines
            MEM_RegWrite    :   in STD_LOGIC;
            MEM_MemtoReg    :   in STD_LOGIC;
            --Normal Lines
            MEM_ReadData    :   in STD_LOGIC_VECTOR(63 downto 0);
            MEM_aluresult   :   in STD_LOGIC_VECTOR(63 downto 0);
            MEM_in40        :   in STD_LOGIC_VECTOR(4 downto 0);
            --Control Lines
            WB_RegWrite     :   out STD_LOGIC;
            WB_MemtoReg     :   out STD_LOGIC;
            --Normal Lines
            WB_in40         :   out STD_LOGIC_VECTOR(4 downto 0);
            WB_ReadData     :   out STD_LOGIC_VECTOR(63 downto 0);
            WB_aluresult    :   out STD_LOGIC_VECTOR(63 downto 0)        
        );
    end component;

    --Stalling and Forwarding Unit
    component forward_unit is
        port(
            IDEX_Rn         : in STD_LOGIC_VECTOR(4 downto 0);
            IDEX_Rm         : in STD_LOGIC_VECTOR(4 downto 0);
            
            EXMEM_Rd        : in STD_LOGIC_VECTOR(4 downto 0);
            MEMWB_Rd        : in STD_LOGIC_VECTOR(4 downt0 0);
            
            EXMEM_RegWrite  : in STD_LOGIC;
            MEMWB_RegWrite  : in STD_LOGIC;
            
            forwardA        : out STD_LOGIC_VECTOR(1 downt0 0);
            forwardB        : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

    component hazard_unit is
        port(
            IFID_Rn             : in STD_LOGIC_VECTOR(4 downto 0);
            IFID_Rm             : in STD_LOGIC_VECTOR(4 downto 0);        
            IDEX_MemRead        : in STD_LOGIC;
            IDEX_Rd             : in STD_LOGIC_VECTOR(4 downto 0);
            
            mux_sel             : out STD_LOGIC;
            IFID_Write          : out STD_LOGIC;
            PC_Write            : out STD_LOGIC  
        );
    end component;
    
    component MUX64_FORWARD is
        port(
            in0         : in STD_LOGIC_VECTOR(63 downto 0);
            in1         : in STD_LOGIC_VECTOR(63 downto 0);
            in2         : in STD_LOGIC_VECTOR(63 downto 0);
            sel         : in STD_LOGIC_VECTOR(1 downto 0);
            output      : out STD_LOGIC_VECTOR(63 downto 0)
        );
    end component;

    component MUX8 is
        port(
            in0    : in STD_LOGIC_VECTOR(7 downto 0); -- sel == 0
            in1    : in STD_LOGIC_VECTOR(7 downto 0); -- sel == 1
            sel    : in STD_LOGIC; -- selects in0 or in1
            output : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;



begin

end behavioral;
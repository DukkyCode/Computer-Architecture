library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity PipelinedCPU0 is
port(
     clk : in STD_LOGIC;
     rst : in STD_LOGIC;
     --Probe ports used for testing
     --The current address (AddressOut from the PC)
     DEBUG_PC : out STD_LOGIC_VECTOR(63 downto 0);
     --The current instruction (Instruction output of IMEM)
     DEBUG_INSTRUCTION : out STD_LOGIC_VECTOR(31 downto 0);
     --DEBUG ports from other components
     DEBUG_TMP_REGS     : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     DEBUG_SAVED_REGS   : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end PipelinedCPU0;

architecture behavioral of PipelinedCPU0 is     
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

     --Signal for components
     --System Clock and Reset
     signal sys_clk	          : std_logic;
     signal sys_rst           : std_logic;
     
     --------Pipeline Register: IFID--------
     --Component: PC
     signal we                :    std_logic := '1';
     signal pc_addressin      :    STD_LOGIC_VECTOR(63 downto 0);
     signal pc_addressout     :    STD_LOGIC_VECTOR(63 downto 0);   

     --Component: ADD
     signal add_out           :    std_logic_vector(63 downto 0);
     signal branch_pc         :    std_logic_vector(63 downto 0);
     signal branch_sel        :    std_logic;
     signal incremental       :    std_logic_vector(63 downto 0) := X"0000000000000004";
     
     --Component: Instruction memory
     signal imem_data         :    std_logic_vector(31 downto 0); 
     
     --Component: IFID Register
     signal sig_ID_pc         :    std_logic_vector(63 downto 0);
     signal sig_ID_imem       :    std_logic_vector(31 downto 0);

     --------Pipeline Register: IDEX--------
     --Component: CPU Control
     signal ID_Reg2Loc               : STD_LOGIC;
     signal sig_ID_CBranch           : STD_LOGIC;  --conditional
     signal sig_ID_MemRead           : STD_LOGIC;
     signal sig_ID_MemtoReg          : STD_LOGIC;
     signal sig_ID_MemWrite          : STD_LOGIC;
     signal sig_ID_ALUSrc            : STD_LOGIC;
     signal sig_ID_RegWrite          : STD_LOGIC;
     signal sig_ID_UBranch           : STD_LOGIC; -- This is unconditional
     signal sig_ID_ALUOp             : STD_LOGIC_VECTOR(1 downto 0);

     --Component: Register
     signal RR2_sel                   : STD_LOGIC_VECTOR(4 downto 0);
     signal Registers_WD              : STD_LOGIC_VECTOR(63 downto 0);
     signal Registers_RD1             : STD_LOGIC_VECTOR(63 downto 0);
     signal Registers_RD2             : STD_LOGIC_VECTOR(63 downto 0);

     --Component: SignExtend
     signal data_signextend           : STD_LOGIC_VECTOR(63 downto 0);

     --Component: IDEX Register
     --Register, Instructions and sign extend output
     signal sig_EX_pc                 : STD_LOGIC_VECTOR(63 downto 0);
     signal sig_EX_RD1                : STD_LOGIC_VECTOR(63 downto 0);
     signal sig_EX_RD2                : STD_LOGIC_VECTOR(63 downto 0);
     signal sig_EX_signextend         : STD_LOGIC_VECTOR(63 downto 0);
     signal sig_EX_in3121             : STD_LOGIC_VECTOR(10 downto 0);
     signal sig_EX_in40               : STD_LOGIC_VECTOR(4 downto 0);
     --Control Lines Output
     signal sig_EX_CBranch            : STD_LOGIC;
     signal sig_EX_MemRead            : STD_LOGIC; 
     signal sig_EX_MemtoReg           : STD_LOGIC;
     signal sig_EX_MemWrite           : STD_LOGIC;
     signal sig_EX_ALUSrc             : STD_LOGIC;
     signal sig_EX_RegWrite           : STD_LOGIC;
     signal sig_EX_UBranch            : STD_LOGIC;
     signal sig_EX_ALUOp              : STD_LOGIC_VECTOR(1 downto 0);  
     
     --------Pipeline Register: EXMEM--------
     --Component: Shift Left
     signal data_shiftleft            : STD_LOGIC_VECTOR(63 downto 0);

     --Component: MUX64
     signal alu_muxinput              : STD_LOGIC_VECTOR(63 downto 0);

     --Component: ALU
     signal alu_operation             : STD_LOGIC_VECTOR(3 downto 0);
     signal alu_zero                  : STD_LOGIC;
     signal alu_overflow              : STD_LOGIC;
     
     --Component: EXMEM
     signal sig_EX_addresult          : STD_LOGIC_VECTOR(63 downto 0);
     signal sig_EX_aluresult          : STD_LOGIC_VECTOR(63 downto 0);
     --Output
     signal sig_MEM_CBranch           : STD_LOGIC;                   
     signal sig_MEM_UBranch           : STD_LOGIC;
     signal sig_MEM_MemRead           : STD_LOGIC;  
     signal sig_MEM_MemtoReg          : STD_LOGIC;
     signal sig_MEM_MemWrite          : STD_LOGIC;
     signal sig_MEM_RegWrite          : STD_LOGIC;
     --Normal Lines Output
     signal sig_MEM_addr              : STD_LOGIC_VECTOR(63 downto 0);
     signal sig_MEM_zeroflag          : STD_LOGIC;
     signal sig_MEM_aluresult         : STD_LOGIC_VECTOR(63 downto 0);
     signal sig_MEM_RD2               : STD_LOGIC_VECTOR(63 downto 0);
     signal sig_MEM_in40              : STD_LOGIC_VECTOR(4 downto 0);

     --------Pipeline Register: EXMEM--------
     signal PCsrc                     : STD_LOGIC;
     --Component: AND Gate
     signal andgateoutput             : STD_LOGIC;
    
     --Component: MEMWB
     signal sig_MEM_ReadData          : STD_LOGIC_VECTOR(63 downto 0);
     --Control Lines
     signal sig_WB_RegWrite           : STD_LOGIC;   
     signal sig_WB_MemtoReg           : STD_LOGIC;
     --Normal Lines
     signal sig_WB_ReadData           : STD_LOGIC_VECTOR(63 downto 0);    
     signal sig_WB_aluresult          : STD_LOGIC_VECTOR(63 downto 0);
     signal sig_WB_in40               : STD_LOGIC_VECTOR(4 downto 0);

begin
     --------Pipeline Register: IFID--------
     u1   : PC port map(           clk => sys_clk, 
                                   write_enable => we,
                                   rst => sys_rst, 
                                   AddressIn => pc_addressin, 
                                   AddressOut => pc_addressout);
     DEBUG_PC <= pc_addressout;          
     
     u2  : MUX64 port map(         in0 => add_out,
                                   in1 => sig_MEM_addr,
                                   sel => PCsrc,
                                   output => pc_addressin);                     --REMEMBER TO FILL THIS
     
     u3   : add port map(          in0 => pc_addressout, 
                                   in1 => incremental, 
                                   output => add_out);

     u4   : IMEM port map(         Address => pc_addressout, 
                                   ReadData => imem_data);
     DEBUG_INSTRUCTION  <= imem_data;
     
     u5   : IFID port map(         clk => sys_clk,
                                   rst => sys_rst,
                                   IF_pc => pc_addressout,
                                   IF_imem => imem_data,
                                   ID_pc => sig_ID_pc,
                                   ID_imem => sig_ID_imem);

     --------Pipeline Register: IDEX--------
     u6   : CPUControl port map(   Opcode => sig_ID_imem(31 downto 21), 
                                   Reg2Loc => ID_Reg2Loc, 
                                   CBranch => sig_ID_CBranch, 
                                   MemRead => sig_ID_MemRead, 
                                   MemtoReg => sig_ID_MemtoReg, 
                                   MemWrite => sig_ID_MemWrite, 
                                   ALUSrc => sig_ID_ALUSrc, 
                                   RegWrite => sig_ID_RegWrite, 
                                   UBranch => sig_ID_UBranch, 
                                   ALUOp => sig_ID_ALUOp);     
     
     u7   : MUX5 port map(         in0 => sig_ID_imem(20 downto 16), 
                                   in1 => sig_ID_imem(4 downto 0), 
                                   sel => ID_Reg2Loc, 
                                   output => RR2_sel);

     u8   : signextend port map(   x => sig_ID_imem,
                                   y => data_signextend);

     u9   : Registers port map(    RR1 => sig_ID_imem(9 downto 5),                   --REMEMBER to comback and fill this
                                   RR2 => RR2_sel,  
                                   WR => sig_WB_in40,
                                   WD => Registers_WD,                               --IMPORTANT
                                   RegWrite => sig_WB_RegWrite,
                                   Clock => sys_clk,
                                   RD1 => Registers_RD1,
                                   RD2 => Registers_RD2,
                                   DEBUG_TMP_REGS => DEBUG_TMP_REGS,
                                   DEBUG_SAVED_REGS => DEBUG_SAVED_REGS); 

     u10  : IDEX port map(         clk  => sys_clk,
                                   rst  => sys_rst,
                                   ID_pc => sig_ID_pc,
                                   ID_RD1 => Registers_RD1,
                                   ID_RD2 => Registers_RD2,
                                   ID_signextend => data_signextend,
                                   ID_in3121 => sig_ID_imem(31 downto 21),
                                   ID_in40 => sig_ID_imem(4 downto 0),
                                   --Control Lines                     
                                   ID_CBranch => sig_ID_CBranch,
                                   ID_MemRead => sig_ID_MemRead,
                                   ID_MemtoReg => sig_ID_MemtoReg,
                                   ID_MemWrite => sig_ID_MemWrite,
                                   ID_ALUSrc => sig_ID_ALUSrc,
                                   ID_RegWrite => sig_ID_RegWrite,
                                   ID_UBranch => sig_ID_UBranch,
                                   ID_ALUOp => sig_ID_ALUOp,
                                   --Register, Instructions and sign extend output
                                   EX_pc     => sig_EX_pc,
                                   EX_RD1    => sig_EX_RD1,
                                   EX_RD2    => sig_EX_RD2,
                                   EX_signextend => sig_EX_signextend,
                                   EX_in3121 => sig_EX_in3121,
                                   EX_in40 => sig_EX_in40,
                                   --Control Lines Output
                                   EX_CBranch => sig_EX_CBranch,
                                   EX_MemRead => sig_EX_MemRead,  
                                   EX_MemtoReg => sig_EX_MemtoReg,
                                   EX_MemWrite => sig_EX_MemWrite,
                                   EX_ALUSrc => sig_EX_ALUSrc,
                                   EX_RegWrite => sig_EX_RegWrite,
                                   EX_UBranch => sig_EX_UBranch,
                                   EX_ALUOp => sig_EX_ALUOp);

     --------Pipeline Register: EXMEM--------
     u11   : ShiftLeft2 port map(   x => sig_EX_signextend,
                                   y => data_shiftleft);     

     u12  : MUX64 port map(        in0 => sig_EX_RD2,
                                   in1 => sig_EX_signextend,
                                   sel => sig_EX_ALUSrc,
                                   output => alu_muxinput);

     u13   : add port map(          in0 => sig_EX_pc,
                                   in1 => data_shiftleft,
                                   output => sig_EX_addresult);
                                   
     u14  : ALUControl port map(   ALUOp => sig_EX_ALUOp,
                                   Opcode => sig_EX_in3121,
                                   Operation => alu_operation);

     u15  : alu port map(          in0 => sig_EX_RD1,
                                   in1 => alu_muxinput,
                                   operation => alu_operation,
                                   result => sig_EX_aluresult,
                                   zero => alu_zero,
                                   overflow => alu_overflow);

     u16 : EXMEM port map(         clk  => sys_clk,
                                   rst  => sys_rst,
                                   --Control Unit Lines
                                   EX_CBranch => sig_EX_CBranch,
                                   EX_UBranch => sig_EX_UBranch,
                                   EX_MemRead => sig_EX_MemRead,
                                   EX_MemtoReg => sig_EX_MemtoReg,
                                   EX_MemWrite => sig_EX_MemWrite,
                                   EX_RegWrite => sig_EX_RegWrite,
                                   --Normal Lines
                                   EX_addr   => sig_EX_addresult,
                                   EX_zeroflag => alu_zero,
                                   EX_aluresult => sig_EX_aluresult,
                                   EX_RD2 => sig_EX_RD2,
                                   EX_in40 => sig_EX_in40,       
                                   --Control Unit Lines
                                   MEM_CBranch => sig_MEM_CBranch,      
                                   MEM_UBranch => sig_MEM_UBranch,     
                                   MEM_MemRead => sig_MEM_MemRead,
                                   MEM_MemtoReg => sig_MEM_MemtoReg,
                                   MEM_MemWrite => sig_MEM_MemWrite,    
                                   MEM_RegWrite => sig_MEM_RegWrite,    
                                   --Normal Lines
                                   MEM_addr  => sig_MEM_addr,         
                                   MEM_zeroflag => sig_MEM_zeroflag,    
                                   MEM_aluresult => sig_MEM_aluresult,  
                                   MEM_RD2 => sig_MEM_RD2,       
                                   MEM_in40 => sig_MEM_in40);

     --------Pipeline Register: MEMWB --------
     u17  : andgate port map(      x => sig_MEM_CBranch,
                                   y => sig_MEM_zeroflag,
                                   z => andgateoutput);

     u18  : orgate port map(       x => sig_MEM_UBranch,
                                   y => andgateoutput,
                                   z => PCsrc);

     u19  : DMEM port map(         WriteData => sig_MEM_RD2,
                                   Address => sig_MEM_aluresult,
                                   MemRead => sig_MEM_MemRead,
                                   MemWrite => sig_MEM_MemWrite,
                                   Clock => sys_clk,
                                   ReadData => sig_MEM_ReadData,
                                   DEBUG_MEM_CONTENTS => DEBUG_MEM_CONTENTS);
                                   
     u20  : MEMWB port map(        clk => sys_clk,
                                   rst => sys_rst,           
                                   --Control Lines
                                   MEM_RegWrite => sig_MEM_RegWrite,    
                                   MEM_MemtoReg => sig_MEM_MemtoReg,   
                                   --Normal Lines
                                   MEM_ReadData => sig_MEM_ReadData,   
                                   MEM_aluresult => sig_MEM_aluresult,
                                   MEM_in40 => sig_MEM_in40,  
                                   --Control Lines
                                   WB_RegWrite => sig_WB_RegWrite,  
                                   WB_MemtoReg => sig_WB_MemtoReg,
                                   --Normal Lines
                                   WB_in40 => sig_WB_in40,
                                   WB_ReadData => sig_WB_ReadData,   
                                   WB_aluresult => sig_WB_aluresult);
                              
     u21  : MUX64 port map(        in0 => sig_WB_aluresult,
                                   in1 => sig_WB_ReadData,
                                   sel => sig_WB_MemtoReg,
                                   output => Registers_WD); 
     sys_clk <= clk;
     sys_rst <= rst;
	
end behavioral;

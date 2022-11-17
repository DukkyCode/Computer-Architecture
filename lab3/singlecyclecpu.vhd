library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SingleCycleCPU is
port(clk :in STD_LOGIC;
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
end SingleCycleCPU;

architecture behavioral of SingleCycleCPU is
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

     component IMEM is
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

     component Registers is
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

     --SIGNAL for the components
     --Component: PC
     signal sys_clk	      :    std_logic;
     signal sys_rst           :    std_logic;

     signal pc_addressin      :    std_logic_vector(63 downto 0);
     signal pc_addressout     :    std_logic_vector(63 downto 0);
     signal we                :    STD_LOGIC := '1';
     signal incremental       :    std_logic_vector(63 downto 0) := X"0000000000000004";  

     --Component: ADD
     signal add_out           :    std_logic_vector(63 downto 0);
     signal branch_pc         :    std_logic_vector(63 downto 0);
     signal branch_sel        :    std_logic;
     
     --Component: Instruction memory
     signal imem_data         :    std_logic_vector(31 downto 0);

     --Component: CPU control
     signal control_Reg2Loc           : STD_LOGIC;
     signal control_CBranch           : STD_LOGIC;  --conditional
     signal control_MemRead           : STD_LOGIC;
     signal control_MemtoReg          : STD_LOGIC;
     signal control_MemWrite          : STD_LOGIC;
     signal control_ALUSrc            : STD_LOGIC;
     signal control_RegWrite          : STD_LOGIC;
     signal control_UBranch           : STD_LOGIC; -- This is unconditional
     signal control_ALUOp             : STD_LOGIC_VECTOR(1 downto 0);

     --Component: Register
     signal RR2_sel                   : STD_LOGIC_VECTOR(4 downto 0);
     signal Registers_WD              : STD_LOGIC_VECTOR(63 downto 0);
     signal Registers_RD1             : STD_LOGIC_VECTOR(63 downto 0);
     signal Registers_RD2             : STD_LOGIC_VECTOR(63 downto 0);

     --Component: SignExtend
     signal data_signextend           : STD_LOGIC_VECTOR(63 downto 0);

     --Component: Shiftleft
     signal data_shiftleft            : STD_LOGIC_VECTOR(63 downto 0);

     --Component: ALU
     signal alu_muxinput              : STD_LOGIC_VECTOR(63 downto 0);
     signal alu_result                : STD_LOGIC_VECTOR(63 downto 0);
     signal alu_zero                  : STD_LOGIC;
     signal alu_overflow              : STD_LOGIC;
     signal alu_operation             : STD_LOGIC_VECTOR(3 downto 0);

     --Component: AND gate
     signal andgate_output            :STD_LOGIC;
     
     --Component: Data Memory
     signal dmem_readdata             : STD_LOGIC_VECTOR(63 downto 0);
begin
     u1   : PC port map(           clk => sys_clk, 
                                   write_enable => we,
                                   rst => sys_rst, 
                                   AddressIn => pc_addressin, 
                                   AddressOut => pc_addressout);
     DEBUG_PC <= pc_addressout;
     
     u2   : add port map(          in0 => pc_addressout, 
                                   in1 => incremental, 
                                   output => add_out);
     
     u3   : IMEM port map(         Address => pc_addressout, 
                                   ReadData => imem_data);
     DEBUG_INSTRUCTION   <= imem_data;                                  

     u4   : CPUControl port map(   Opcode => imem_data(31 downto 21), 
                                   Reg2Loc => control_Reg2Loc, 
                                   CBranch => control_CBranch, 
                                   MemRead => control_MemRead, 
                                   MemtoReg => control_MemtoReg, 
                                   MemWrite => control_MemWrite, 
                                   ALUSrc => control_ALUSrc, 
                                   RegWrite => control_RegWrite, 
                                   UBranch => control_UBranch, 
                                   ALUOp => control_ALUOp);
          
     u5   : MUX5 port map(         in0 => imem_data(20 downto 16), 
                                   in1 => imem_data(4 downto 0), 
                                   sel => control_Reg2Loc, 
                                   output => RR2_sel);
     
     u6   : signextend port map(   x => imem_data,
                                   y => data_signextend);

     u7   : ShiftLeft2 port map(   x => data_signextend,
                                   y => data_shiftleft);

     u8   : add port map(          in0 => pc_addressout,
                                   in1 => data_shiftleft,
                                   output => branch_pc);

     u9  : Registers port map(     RR1 => imem_data(9 downto 5),
                                   RR2 => RR2_sel,  
                                   WR => imem_data(4 downto 0),
                                   WD => Registers_WD,
                                   RegWrite => control_RegWrite,
                                   Clock => sys_clk,
                                   RD1 => Registers_RD1,
                                   RD2 => Registers_RD2,
                                   DEBUG_TMP_REGS => DEBUG_TMP_REGS,
                                   DEBUG_SAVED_REGS => DEBUG_SAVED_REGS);

     u10  : MUX64 port map(        in0 => Registers_RD2,
                                   in1 => data_signextend,
                                   sel => control_ALUSrc,
                                   output => alu_muxinput);

     u11  : ALUControl port map(   ALUOp => control_ALUOp,
                                   Opcode => imem_data(31 downto 21),
                                   Operation => alu_operation);

     u12  : alu port map(          in0 => Registers_RD1,
                                   in1 => alu_muxinput,
                                   operation => alu_operation,
                                   result => alu_result,
                                   zero => alu_zero,
                                   overflow => alu_overflow);

     u13  : DMEM port map(         WriteData => Registers_RD2,
                                   Address => alu_result,
                                   MemRead => control_MemRead,
                                   MemWrite => control_MemWrite,
                                   Clock => sys_clk,
                                   ReadData => dmem_readdata,
                                   DEBUG_MEM_CONTENTS => DEBUG_MEM_CONTENTS);  
     
     u14  : andgate port map(      x => control_CBranch,
                                   y => alu_zero,
                                   z => andgate_output);
     
     u15  : orgate port map(       x => control_UBranch,
                                   y => andgate_output,
                                   z => branch_sel);
     
     u16  : MUX64 port map(        in0 => add_out,
                                   in1 => branch_pc, 
                                   sel => branch_sel,
                                   output => pc_addressin);
     
           

     u17  : MUX64 port map(        in0 => alu_result,
                                   in1 => dmem_readdata,
                                   sel => control_MemtoReg,
                                   output => Registers_WD);
    sys_clk <= clk;
    sys_rst <= rst;
     
end behavioral;

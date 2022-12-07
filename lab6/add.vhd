library ieee;
use IEEE.std_logic_1164.all;

entity ADD is
-- Adds two signed 64-bit inputs
-- output = in1 + in2
port(
     in0    : in  STD_LOGIC_VECTOR(63 downto 0);
     in1    : in  STD_LOGIC_VECTOR(63 downto 0);
     output : out STD_LOGIC_VECTOR(63 downto 0)
);
end ADD;

architecture structural of add is
     component fulladder is
          port(
               fa_in0         : in std_logic;
               fa_in1         : in std_logic;
               fa_carry_in    : in std_logic;
               fa_carry_out   : out std_logic;
               fa_output      : out std_logic
          );
     end component;

     component halfadder is
          port(
               a              : in std_logic; 
               b              : in std_logic;
               c              : out std_logic;
               sum            : out std_logic
          );
     end component;

     --Initialize carry value
     signal carry             : std_logic_vector(63 downto 0);
    
     begin
          --Lower Adder
          u0                   : halfadder port map(a      => in0(0), b      => in1(0), sum         => output(0), c        => carry(0));
          u1                   : fulladder port map(fa_in0 => in0(1), fa_in1 => in1(1), fa_carry_in => carry(0), fa_output => output(1), fa_carry_out => carry(1));
          u2                   : fulladder port map(fa_in0 => in0(2), fa_in1 => in1(2), fa_carry_in => carry(1), fa_output => output(2), fa_carry_out => carry(2));
          u3                   : fulladder port map(fa_in0 => in0(3), fa_in1 => in1(3), fa_carry_in => carry(2), fa_output => output(3), fa_carry_out => carry(3));
          u4                   : fulladder port map(fa_in0 => in0(4), fa_in1 => in1(4), fa_carry_in => carry(3), fa_output => output(4), fa_carry_out => carry(4));
          u5                   : fulladder port map(fa_in0 => in0(5), fa_in1 => in1(5), fa_carry_in => carry(4), fa_output => output(5), fa_carry_out => carry(5));
          u6                   : fulladder port map(fa_in0 => in0(6), fa_in1 => in1(6), fa_carry_in => carry(5), fa_output => output(6), fa_carry_out => carry(6));
          u7                   : fulladder port map(fa_in0 => in0(7), fa_in1 => in1(7), fa_carry_in => carry(6), fa_output => output(7), fa_carry_out => carry(7));
          u8                   : fulladder port map(fa_in0 => in0(8), fa_in1 => in1(8), fa_carry_in => carry(7), fa_output => output(8), fa_carry_out => carry(8));
          u9                   : fulladder port map(fa_in0 => in0(9), fa_in1 => in1(9), fa_carry_in => carry(8), fa_output => output(9), fa_carry_out => carry(9));
          u10                  : fulladder port map(fa_in0 => in0(10), fa_in1 => in1(10), fa_carry_in => carry(9), fa_output => output(10), fa_carry_out => carry(10));
          u11                  : fulladder port map(fa_in0 => in0(11), fa_in1 => in1(11), fa_carry_in => carry(10), fa_output => output(11), fa_carry_out => carry(11));
          u12                  : fulladder port map(fa_in0 => in0(12), fa_in1 => in1(12), fa_carry_in => carry(11), fa_output => output(12), fa_carry_out => carry(12));
          u13                  : fulladder port map(fa_in0 => in0(13), fa_in1 => in1(13), fa_carry_in => carry(12), fa_output => output(13), fa_carry_out => carry(13));
          u14                  : fulladder port map(fa_in0 => in0(14), fa_in1 => in1(14), fa_carry_in => carry(13), fa_output => output(14), fa_carry_out => carry(14));
          u15                  : fulladder port map(fa_in0 => in0(15), fa_in1 => in1(15), fa_carry_in => carry(14), fa_output => output(15), fa_carry_out => carry(15));
          u16                  : fulladder port map(fa_in0 => in0(16), fa_in1 => in1(16), fa_carry_in => carry(15), fa_output => output(16), fa_carry_out => carry(16));
          u17                  : fulladder port map(fa_in0 => in0(17), fa_in1 => in1(17), fa_carry_in => carry(16), fa_output => output(17), fa_carry_out => carry(17));
          u18                  : fulladder port map(fa_in0 => in0(18), fa_in1 => in1(18), fa_carry_in => carry(17), fa_output => output(18), fa_carry_out => carry(18));
          u19                  : fulladder port map(fa_in0 => in0(19), fa_in1 => in1(19), fa_carry_in => carry(18), fa_output => output(19), fa_carry_out => carry(19));
          u20                  : fulladder port map(fa_in0 => in0(20), fa_in1 => in1(20), fa_carry_in => carry(19), fa_output => output(20), fa_carry_out => carry(20));
          u21                  : fulladder port map(fa_in0 => in0(21), fa_in1 => in1(21), fa_carry_in => carry(20), fa_output => output(21), fa_carry_out => carry(21));
          u22                  : fulladder port map(fa_in0 => in0(22), fa_in1 => in1(22), fa_carry_in => carry(21), fa_output => output(22), fa_carry_out => carry(22));
          u23                  : fulladder port map(fa_in0 => in0(23), fa_in1 => in1(23), fa_carry_in => carry(22), fa_output => output(23), fa_carry_out => carry(23));
          u24                  : fulladder port map(fa_in0 => in0(24), fa_in1 => in1(24), fa_carry_in => carry(23), fa_output => output(24), fa_carry_out => carry(24));
          u25                  : fulladder port map(fa_in0 => in0(25), fa_in1 => in1(25), fa_carry_in => carry(24), fa_output => output(25), fa_carry_out => carry(25));
          u26                  : fulladder port map(fa_in0 => in0(26), fa_in1 => in1(26), fa_carry_in => carry(25), fa_output => output(26), fa_carry_out => carry(26));
          u27                  : fulladder port map(fa_in0 => in0(27), fa_in1 => in1(27), fa_carry_in => carry(26), fa_output => output(27), fa_carry_out => carry(27));
          u28                  : fulladder port map(fa_in0 => in0(28), fa_in1 => in1(28), fa_carry_in => carry(27), fa_output => output(28), fa_carry_out => carry(28));
          u29                  : fulladder port map(fa_in0 => in0(29), fa_in1 => in1(29), fa_carry_in => carry(28), fa_output => output(29), fa_carry_out => carry(29));
          u30                  : fulladder port map(fa_in0 => in0(30), fa_in1 => in1(30), fa_carry_in => carry(29), fa_output => output(30), fa_carry_out => carry(30));
          u31                  : fulladder port map(fa_in0 => in0(31), fa_in1 => in1(31), fa_carry_in => carry(30), fa_output => output(31), fa_carry_out => carry(31));

          --Upper Adder
          u32                  : fulladder port map(fa_in0 => in0(32), fa_in1 => in1(32), fa_carry_in => carry(31), fa_output => output(32), fa_carry_out => carry(32));
          u33                  : fulladder port map(fa_in0 => in0(33), fa_in1 => in1(33), fa_carry_in => carry(32), fa_output => output(33), fa_carry_out => carry(33));
          u34                  : fulladder port map(fa_in0 => in0(34), fa_in1 => in1(34), fa_carry_in => carry(33), fa_output => output(34), fa_carry_out => carry(34));
          u35                  : fulladder port map(fa_in0 => in0(35), fa_in1 => in1(35), fa_carry_in => carry(34), fa_output => output(35), fa_carry_out => carry(35));
          u36                  : fulladder port map(fa_in0 => in0(36), fa_in1 => in1(36), fa_carry_in => carry(35), fa_output => output(36), fa_carry_out => carry(36));
          u37                  : fulladder port map(fa_in0 => in0(37), fa_in1 => in1(37), fa_carry_in => carry(36), fa_output => output(37), fa_carry_out => carry(37));
          u38                  : fulladder port map(fa_in0 => in0(38), fa_in1 => in1(38), fa_carry_in => carry(37), fa_output => output(38), fa_carry_out => carry(38));
          u39                  : fulladder port map(fa_in0 => in0(39), fa_in1 => in1(39), fa_carry_in => carry(38), fa_output => output(39), fa_carry_out => carry(39));
          u40                  : fulladder port map(fa_in0 => in0(40), fa_in1 => in1(40), fa_carry_in => carry(39), fa_output => output(40), fa_carry_out => carry(40));
          u41                  : fulladder port map(fa_in0 => in0(41), fa_in1 => in1(41), fa_carry_in => carry(40), fa_output => output(41), fa_carry_out => carry(41));
          u42                  : fulladder port map(fa_in0 => in0(42), fa_in1 => in1(42), fa_carry_in => carry(41), fa_output => output(42), fa_carry_out => carry(42));
          u43                  : fulladder port map(fa_in0 => in0(43), fa_in1 => in1(43), fa_carry_in => carry(42), fa_output => output(43), fa_carry_out => carry(43));
          u44                  : fulladder port map(fa_in0 => in0(44), fa_in1 => in1(44), fa_carry_in => carry(43), fa_output => output(44), fa_carry_out => carry(44));
          u45                  : fulladder port map(fa_in0 => in0(45), fa_in1 => in1(45), fa_carry_in => carry(44), fa_output => output(45), fa_carry_out => carry(45));
          u46                  : fulladder port map(fa_in0 => in0(46), fa_in1 => in1(46), fa_carry_in => carry(45), fa_output => output(46), fa_carry_out => carry(46));
          u47                  : fulladder port map(fa_in0 => in0(47), fa_in1 => in1(47), fa_carry_in => carry(46), fa_output => output(47), fa_carry_out => carry(47));
          u48                  : fulladder port map(fa_in0 => in0(48), fa_in1 => in1(48), fa_carry_in => carry(47), fa_output => output(48), fa_carry_out => carry(48));
          u49                  : fulladder port map(fa_in0 => in0(49), fa_in1 => in1(49), fa_carry_in => carry(48), fa_output => output(49), fa_carry_out => carry(49));
          u50                  : fulladder port map(fa_in0 => in0(50), fa_in1 => in1(50), fa_carry_in => carry(49), fa_output => output(50), fa_carry_out => carry(50));
          u51                  : fulladder port map(fa_in0 => in0(51), fa_in1 => in1(51), fa_carry_in => carry(50), fa_output => output(51), fa_carry_out => carry(51));
          u52                  : fulladder port map(fa_in0 => in0(52), fa_in1 => in1(52), fa_carry_in => carry(51), fa_output => output(52), fa_carry_out => carry(52));
          u53                  : fulladder port map(fa_in0 => in0(53), fa_in1 => in1(53), fa_carry_in => carry(52), fa_output => output(53), fa_carry_out => carry(53));
          u54                  : fulladder port map(fa_in0 => in0(54), fa_in1 => in1(54), fa_carry_in => carry(53), fa_output => output(54), fa_carry_out => carry(54));
          u55                  : fulladder port map(fa_in0 => in0(55), fa_in1 => in1(55), fa_carry_in => carry(54), fa_output => output(55), fa_carry_out => carry(55));
          u56                  : fulladder port map(fa_in0 => in0(56), fa_in1 => in1(56), fa_carry_in => carry(55), fa_output => output(56), fa_carry_out => carry(56));
          u57                  : fulladder port map(fa_in0 => in0(57), fa_in1 => in1(57), fa_carry_in => carry(56), fa_output => output(57), fa_carry_out => carry(57));
          u58                  : fulladder port map(fa_in0 => in0(58), fa_in1 => in1(58), fa_carry_in => carry(57), fa_output => output(58), fa_carry_out => carry(58));
          u59                  : fulladder port map(fa_in0 => in0(59), fa_in1 => in1(59), fa_carry_in => carry(58), fa_output => output(59), fa_carry_out => carry(59));
          u60                  : fulladder port map(fa_in0 => in0(60), fa_in1 => in1(60), fa_carry_in => carry(59), fa_output => output(60), fa_carry_out => carry(60));
          u61                  : fulladder port map(fa_in0 => in0(61), fa_in1 => in1(61), fa_carry_in => carry(60), fa_output => output(61), fa_carry_out => carry(61));
          u62                  : fulladder port map(fa_in0 => in0(62), fa_in1 => in1(62), fa_carry_in => carry(61), fa_output => output(62), fa_carry_out => carry(62));
          u63                  : fulladder port map(fa_in0 => in0(63), fa_in1 => in1(63), fa_carry_in => carry(62), fa_output => output(63), fa_carry_out => carry(63));
       
end structural;
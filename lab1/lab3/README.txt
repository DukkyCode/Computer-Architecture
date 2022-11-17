--This is the instruction currently in IMEM
ADDI		X9, X9, 1
ADD  		X10,X9,X11
STUR 		X10, [X11,0]
LDUR 		X12, [X11, 0]
CBZ 		X9, 2
B 		3
ADD 		X9, X10, X11
ADD 		X9, X10, X11
ADDI  	X9, X9, 1
ADD   	X21, X10, X9
LSL		X9, 2
LSR		X9, 2

--Compilation Order
andgate.vhd
orgate.vhd
halfadder.vhd
fulladder.vhd
mux5.vhd
mux64.vhd
add.vhd
pc.vhd
alu.vhd
alucontrol.vhd
cpucontrol.vhd
dmem.vhd
imem.vhd
registers.vhd
shiftleft2.vhd
signextend.vhd
singlecyclecpu.vhd
tb_signextend.vhd
tb_singlecyclecpu.vhd

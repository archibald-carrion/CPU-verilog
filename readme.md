# CPU writen in Verilog hardware description language

## General informations about the project :
1. It's a very basic CPU :
    * it works with a very minimalistic instrucction set RISC.
    * it doesn't have a pipeline system or any other speed augmentation technique.
2. Data size :
    * A word is 32bits
    * A dirrection is 16bits
3. The circuit are not connected yet
    - Each independant circuit works correctly, yet they are not connected and therefore the CPU as a whole does not execute the given instructions
    - not all the needed instructions have been implanted, but the main arithmetic and logical ones are already functional

## Content of the project :
The project contains the following files :
- alu.v
- alu_tb.v
- cpu.v
- cpu_tb.v
- memoria.v
- memoria_tb.v
- registros.v
- registros_tb.v
- CPU_signals.gtkw
- opcodes.gtkw
- opcodes.vh
- stages.gtkw
- Whiteboard.png    (an illustration for better understanding of the problem)
## Project objectives :
- [x] Finish alu.v file
- [x] Finish alu_tb.v file
- [x] Finish cpu.v file
- [x] Finish cpu_tb.v file
- [x] Finish registros.v file
- [x] Finish registros_tb.v file
- [x] Finish memoria.v file
- [x] Finish memoria_tb.v file
- [x] Finish layout and comment code
- [ ] Connect the circuits together
- [ ] Add a pipeline system (optional)
- [ ] Implementation of the readmemh and writememh function (optional)
## Compilation & test running commands :
There is a compile commend for each testbench file:
```
iverilog alu.v cpu.v memoria.v registros.v alu_tb.v
iverilog alu.v cpu.v memoria.v registros.v cpu_tb.v
iverilog alu.v cpu.v memoria.v registros.v memoria_tb.v
iverilog alu.v cpu.v memoria.v registros.v registros_tb.v
```
Once compiled, there is an a.out file that we can execute.
To execute the .out file we use the following command :
```
vvp a.out
```
During the execution we can see all the "monitor" function that we have in the code to debbug the circuit.
Once executed, thanks those 2 instrucction in the code :  
note : the dumpFileName depend on wich testbench you compiled, because each testbench have a different .vcd file that contains the grafic of it's own circuit.
```verilog
$dumpfile("dumpFileName.vcd");
$dumpvars;		 
```
We have a new file, the dumpFileName.vcd file that can be open with the following instruction to visualize the circuit :
```
gtkwave dumpFileName.vcd
```
# CPU writen in Verilog hardware description language

## General informations about the project :
1. It's a very basic CPU :
    * it works with a very minimalistic instrucction set RISC
    * it doesn't have a pipeline system or any other speed augmentation technique
2. Data size :
    * A word is 32bits
    * A dirrection is 16bits

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
- [ ] Finish alu.v file
- [ ] Finish cpu.v file
- [ ] Finish the testbench
- [ ] Finish registros.v file
- [ ] Finish memoria.v file
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
# CPU writen in Verilog hardware description language

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
- [x] Finish the testbench
- [ ] Finish registros.v file
- [ ] Finish memoria.v file
## Compilation & test running commands :
There is a compile commend for each testbench file:
```
iverilog alu.v cpu.v memoria.v registros.v alu_tb.v
iverilog alu.v cpu.v memoria.v registros.v cpu_tb.v
iverilog alu.v cpu.v memoria.v registros.v memoria_tb.v
iverilog alu.v cpu.v memoria.v registros.v registros_tb.v
```
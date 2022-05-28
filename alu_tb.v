/*******************************
Universidad de Costa Rica
CI-0114: Fundamentos de Arquitectura

Prueba para la ALU
*********************************/

`timescale 1us/100ns

module ALU_tb;
  wire [31:0] R;
  wire C, S, O, Z;
  reg  [31:0] A;
  reg  [31:0] B;
  reg  [4:0]  op;
 
  initial begin
    $dumpfile("ALU.vcd");
    $dumpvars;
    op = `OP_NOP; A = 0; B = 0;
    #1 op = `OP_ADD; A = 0; B = 0;
    #1 op = `OP_ADD; A = 32'h8000_0000; B = 32'h8000_0000;
    #1 op = `OP_ADD; A = 32'hFFFF_0000; B = 32'hFFFF_FFFF;
    #1 op = `OP_ADD; A = 32'hFFFF_0000; B = 32'h0FFF_1111;
    #1 op = `OP_ADD; A = 32'h7FFF_0000; B = 32'h7FFF_1111;
    #1 op = `OP_ADD; A = 32'h7FFF_0000; B = 32'h0FFF_1111;
    #1 op = `OP_NOT; A = 32'hACED_CAFE; B = 32'hXXXX_XXXX;
    #1 op = `OP_NOT; A = R; B = 32'hXXXX_XXXX;
    #1 $finish;
  end
  
  ALU alu(.resultado(R),
          .C(C),
          .S(S),
          .O(O),
          .Z(Z),
          .operando_a(A),
          .operando_b(B),
          .opcode(op));

endmodule

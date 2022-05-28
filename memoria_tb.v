/*******************************
Universidad de Costa Rica
CI-0114: Fundamentos de Arquitectura

Prueba para el modulo de memoria
*********************************/

`timescale 1us/100ns

module Memoria_tb;
  wire [31:0] data_salida;
  reg  [31:0] data_entrada;
  reg  [15:0] direccion;
  reg         escribir;
  reg         clk;
  
  always begin
    #0.5 clk = ~clk;
  end
 
  initial begin
    $dumpfile("Memoria.vcd");
    $dumpvars;
    clk = 1; escribir = 0;
    #1 direccion = 5;
    #2 data_entrada = 'hACED_CAFE; direccion = 4; escribir = 1;
    #1 escribir = 0;
    #1 direccion = 3; data_entrada = 'hDEAD_BEEF;
    #6 $finish;
  end
  
  Mem_D32b_A16b mem(.data_out(data_salida),
                    .data_in(data_entrada),
                    .address(direccion),
                    .write(escribir),
                    .clk(clk));
endmodule

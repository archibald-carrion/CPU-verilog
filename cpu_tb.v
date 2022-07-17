/*******************************
Universidad de Costa Rica
CI-0114: Fundamentos de Arquitectura

Prueba y conexion para el CPU y la Memoria
*********************************/

`timescale 1us/100ns

module Memoria_tb;
  wire [31:0] bus_de_datos_salida;
  wire [31:0] bus_de_datos_entrada;
  wire [15:0] bus_de_direcciones;
  wire        bit_de_control_escritura;
  reg         clk;
  reg         reset;
  
  always begin
    #0.5 clk = ~clk;
  end
 
  initial begin
    $dumpfile("cpu.vcd");
    $dumpvars;
    clk = 0; reset = 1;
    #1 reset = 0;
    #500 $finish;
  end
  
  CPU cpu(.MBR_W(bus_de_datos_salida),
          .write(bit_de_control_escritura),
          .MAR(bus_de_direcciones),
          .MBR_R(bus_de_datos_entrada),
          .reset(reset),
          .clk(clk));
  
  Mem_D32b_A16b mem(.data_out(bus_de_datos_entrada), // Note, la salida de la memoria a la entra del CPU
                    .data_in(bus_de_datos_salida),   // Note, la salida del CPU, a la entrada de la memoria
                    .address(bus_de_direcciones),
                    .write(bit_de_control_escritura),
                    .clk(clk));

  
endmodule




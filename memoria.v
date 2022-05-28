/*******************************
Universidad de Costa Rica
CI-0114: Fundamentos de Arquitectura

Simple memoria lectura asincrónica y escritura sincrónica
basada en Flip Flops
1 Puerto de lectura
1 Puerto de escritura

Ancho de palabra (Datos) 32 bits
Ancho de direcciones 16 bits (64Ki Words)

Contiene las primeras words precargadas
Con algunos valores de prueba

*********************************/

module Mem_D32b_A16b(data_out, data_in, address, write, clk);
  parameter BITS_DATA = 32;
  parameter BITS_ADDR = 16;

  output [BITS_DATA-1:0] data_out;
  input  [BITS_DATA-1:0] data_in;
  input  [BITS_ADDR-1:0] address;
  input                  write;
  input                  clk;
  
  reg [BITS_DATA-1:0] data [(2**BITS_ADDR)-1:0];
  
  assign data_out = data[address];
  
  always @(negedge clk) begin
    if (write) begin
      data[address] <= data_in;
    end
  end
  
  // Para leer/escribir archivos de texto como memorias en verilog (nos permite una inicialización
  // más flexible)
  // https://stackoverflow.com/questions/628603/what-is-the-function-of-readmemh-and-writememh-in-verilog
  // Otro tutorial: https://www.fullchipdesign.com/readmemh.htm
  //
  // De momento, los datos se inicializan manualmente
  initial begin    
    data[0] = 'h00000000;
    data[1] = 'h00000000;
    data[2] = 'h00000000;
    data[3] = 'h00000000;
    data[4] = 'h00000000;
    data[5] = 'hF8000000;
  end
  
  // Workaround para lograr visualizar la memoria en gtkwave
  // Agregamos solo los primeros 64 entries para no hacer la simulación
  // innecesariamente lenta
  generate
    genvar idx;
    for(idx = 0; idx < 64; idx = idx + 1) begin: register
      wire [31:0] tmp;
      assign tmp = data[idx];
    end
  endgenerate

endmodule

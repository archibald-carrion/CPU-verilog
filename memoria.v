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
  
  // Para leer/escribir archivos de texto como memorias en verilog (nos permite una inicialización más flexible)
  // https://stackoverflow.com/questions/628603/what-is-the-function-of-readmemh-and-writememh-in-verilog
  // Otro tutorial: https://www.fullchipdesign.com/readmemh.htm
  //
  // De momento, los datos se inicializan manualmente
  
  initial begin    
    data[0] = 'b00001_001_00000000_0000000000001101;  // load en registro 0 la constante 13
    data[1] = 'b00001_001_00000001_0000000000000001;  // load en registro 1 la variable 1 (resultado final)
    data[2] = 'b00001_001_00000010_0000000000000001;  // load enregistro 2 la variable contador que empieza en 1 (multiplicador)
    data[3] = 'b00001_001_00000011_0000000000000001;  // load en registro 3 la constante 1 (incrementador)
    data[4] = 'b10111_000_00000001_0000000000000010;  // se multiplican los regitros 1 y 2, se guarda el resultado en registro 1
    data[5] = 'b10101_000_00000010_0000000000000011;  // se suman los reigstros 2 y 3, se guarda el resultado en registro 2
    data[6] = 'b11010_001_00000000_0000000000100010;  // se hace un jump hacia la instruction de address 4 si los registros 0 y 2 son diferentes
    data[7] = 'b00010_011_00000001_0001111101000000;  // store el contenido del registro 1 en la dirección 0X8000
    data[8] = 'b00000_000_00000000_0000000000000000;  // NOP (fin del programa)
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

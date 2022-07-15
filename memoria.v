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
    //data[0] = 'h00000000;
	  //data[0] = 'hFFFFFFFF; //el estado HLT funciona correctamente
	  //data[0] = 'h0000FFFF;
    //00001001 xxxxx000
    //data[1] = 'h01005555;
    //data[2] = 'h33331111;
	  //data[3] = 'hFFFFFFFF;
    //data[3] = 'h00000000;
    //data[4] = 'h00000000;
    //data[5] = 'hF8000000;
data[0] = 'b00001_000_00000000_0000000000001100;
data[1] = 'b00001_001_00000000_0000000000000001;
data[2] = 'b00001_010_00000000_0000000000000001;
data[3] = 'b00001_011_00000000_0000000000000001;
data[4] = 'b10111_000_00000001_0000000000000010;
data[5] = 'b10101_000_00000010_0000000000000011;
data[6] = 'b11010_000_00000000_1111101000000001;
data[7] = 'b00010_000_00000001_0001111101000000;
data[8] = 'b00000_000_00000000_0000000000000000;
    /*

00001_000_00000000_0000000000001100		--> 12 en r0
00001_001_00000000_0000000000000001		--> 1 en r1
00001_010_00000000_0000000000000001		--> 1 en r2
00001_011_00000000_0000000000000001		--> 1 en r3	(const)
10111_000_00000001_0000000000000010		--> multiplicar r1 y r2, guardar resultado en r1
10101_000_00000010_0000000000000011		--> add 1 to r2
11010_000_00000000_1111101000000001		-->salta a 0X8000 si r0 (000) == r1 (001)
00010_000_00000001_0001111101000000		--> se guarda el contenido de r1 en 0X8000
00000_000_00000000_0000000000000000


    */
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

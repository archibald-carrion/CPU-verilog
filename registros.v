/*******************************
Universidad de Costa Rica
CI-0114: Fundamentos de Arquitectura

Circuito simple de registro que permite almacenar 32 bits
*****************************/

module memoryRegister(dataOutput, dirrOutput, dataInput);
	parameter BITS_DATA = 32;
	parameter BITS_ADDR = 16;
	
	output reg [BITS_DATA-1:0] dataOutput;
	output reg [BITS_ADDR-1:0] dirrOutput;
	input [BITS_DATA-1:0] dataInput;
	
endmodule

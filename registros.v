/*******************************
Universidad de Costa Rica
CI-0114: Fundamentos de Arquitectura

Circuito simple de registro que permite almacenar 32 bits
*****************************/

module memoryRegister(dataOutput, dirrOutput, dataInput);
	parameter BITS_DATA = 32;
	parameter BITS_ADDR = 16;
	
	output wire [BITS_DATA-1:0] dataOutput;
	output wire [BITS_ADDR-1:0] dirrOutput;
	input reg [BITS_DATA-1:0] dataInput;
	
	reg [BITS_DATA-1:0] contentRegister;
	
	always @ (dataInput) begin
		contentRegister = dataInput;
		dataOutput = contentRegister;
	end
	
endmodule

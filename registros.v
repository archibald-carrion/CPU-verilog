/*******************************
Universidad de Costa Rica
CI-0114: Fundamentos de Arquitectura

Circuito simple de registro que permite almacenar 32 bits
*****************************/

module registersArray(inputData, outputData1, outputData2, dirrInput, dirrOutput1, dirrOutput2);
	parameter BITS_DATA = 32;	//tamano de los registros
	parameter BITS_ADDR = 3;	//dirrecion que permite saber con cual registro trabajar
	
	
	
	
	
	
	//parameter BITS_DATA = 32;
	//parameter BITS_ADDR = 16;
	
	//output [BITS_DATA-1:0] dataOutput;
	//wire dataOutput;
	//output [BITS_ADDR-1:0] dirrOutput;
	//wire dirrOutput;
	//input [BITS_DATA-1:0] dataInput;
	//wire dataInput;
//	reg dataInput, dataOutput, dirrOutput;
	
	//reg [BITS_DATA-1:0] contentRegister;
	
	//always @ (dataInput) begin
		//contentRegister = dataInput;
		//dirrOutput = contentRegister[16:BITS_DATA-1];
		//dataOutput = dataInput;
//	end
	
endmodule

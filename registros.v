/*******************************
Universidad de Costa Rica
CI-0114: Fundamentos de Arquitectura

Circuito simple de registro que permite almacenar 32 bits

iverilog registros.v registros_tb.v
*****************************/

module registersArray(inputData, dirrInput, dirrOutput1, dirrOutput2, outputData1, outputData2, write_en, clk);
	parameter BITS_DATA = 32;								//tamano de los registros
	parameter BITS_ADDR = 3;								//tamano de las dirreciones
	
	input [BITS_DATA-1:0] inputData;						//data que hay que agregar en uno de los registros
	input [BITS_ADDR-1:0] dirrInput;						//posicion donde hay que agregar el data inputData
	input [BITS_ADDR-1:0] dirrOutput1;						//posicion del elemento que se quiere sacar de la lista de registros y se guarda en outputData1
	input [BITS_ADDR-1:0] dirrOutput2;						//posicion del elemento que se quiere sacar de la lista de registros y se guarda en outputData2
	input write_en;											// abreviado para "write enable", si esta en 1 permite cambiar el contenido de los registros, sino no puede
	input clk;												//signal del reloj
	output reg [BITS_DATA-1:0] outputData1;					//data sacado del array de registros
	output reg [BITS_DATA-1:0] outputData2;					//data sacado del array de registros
	
	reg [BITS_DATA-1:0] registersArray [7:0];				// un array de 8 array de 32 bits
	
	always @(negedge clk) begin
		if (write_en) begin
		  registersArray[dirrInput] <= inputData;
		end
	end
	
	always @(posedge clk or dirrOutput1) begin
		outputData1 <= registersArray[dirrOutput1];
	end
	
	always @(posedge clk or dirrOutput2) begin
		outputData2 <= registersArray[dirrOutput2];
	end
endmodule
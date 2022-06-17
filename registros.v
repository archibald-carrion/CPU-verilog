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
	
	//"arreglo" de todos los registers de 32 bits
	/*
	reg [BITS_DATA-1:0] R0;
	reg [BITS_DATA-1:0] R1;
	reg [BITS_DATA-1:0] R2;
	reg [BITS_DATA-1:0] R3;
	reg [BITS_DATA-1:0] R4;
	reg [BITS_DATA-1:0] R5;
	reg [BITS_DATA-1:0] R6;
	reg [BITS_DATA-1:0] R7;
	*/
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
	
	/*
	//para agregar un elemento en el arreglo de registros
	always @(dirrInput) begin
		if(write_en) begin
			case (dirrInput)
				'b000: begin
					R0 = inputData;
					
				end
				
				'b001: begin
					R1 = inputData;
				end
				
				'b010: begin
					R2 = inputData;
				end
				
				'b011: begin
					R3 = inputData;
				end
				
				'b100: begin
					R4 = inputData;
				end
				
				'b101: begin
					R5 = inputData;
				end
				
				'b110: begin
					R6 = inputData;
				end
				
				'b111: begin
					R7 = inputData;
				end
				
				default: begin
					//default case
				end
			endcase	
		end
	end
	
	//para sacar un primer elemento del arreglo de registros
	always @(dirrOutput1) begin
		case (dirrOutput1)
			'b000: begin
				outputData1 = R0;
			end
			
			'b001: begin
				outputData1 = R1;
			end
			
			'b010: begin
				outputData1 = R2;
			end
			
			'b011: begin
				outputData1 = R3;
			end
			
			'b100: begin
				outputData1 = R4;
			end
			
			'b101: begin
				outputData1 = R5;
			end
			
			'b110: begin
				outputData1 = R6;
			end
			
			'b111: begin
				outputData1 = R7;
			end
			
			default: begin
				//default case
			end
		endcase	
	end
	
	//para sacar un segundo elemento del arreglo de registros
	always @(dirrOutput2) begin
		case (dirrOutput2)
			'b000: begin
				outputData2 = R0;
			end
			
			'b001: begin
				outputData2 = R1;
			end
			
			'b010: begin
				outputData2 = R2;
			end
			
			'b011: begin
				outputData2 = R3;
			end
			
			'b100: begin
				outputData2 = R4;
			end
			
			'b101: begin
				outputData2 = R5;
			end
			
			'b110: begin
				outputData2 = R6;
			end
			
			'b111: begin
				outputData2 = R7;
			end
			
			default: begin
				//default case
			end
		endcase	
	end	
	*/
endmodule

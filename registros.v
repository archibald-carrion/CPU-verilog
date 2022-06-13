/*******************************
Universidad de Costa Rica
CI-0114: Fundamentos de Arquitectura

Circuito simple de registro que permite almacenar 32 bits

iverilog registros.v registros_tb.v
*****************************/

module registersArray(inputData, dirrInput, dirrOutput1, dirrOutput2, outputData1, outputData2);
	parameter BITS_DATA = 32;	//tamano de los registros
	parameter BITS_ADDR = 3;	//dirrecion que permite saber con cual registro trabajar
	
	input [BITS_DATA-1:0] inputData;
	input [BITS_ADDR-1:0] dirrInput;
	input [BITS_ADDR-1:0] dirrOutput1;
	input [BITS_ADDR-1:0] dirrOutput2;
	output reg [BITS_DATA-1:0] outputData1;
	output reg [BITS_DATA-1:0] outputData2;
	
	
	reg [BITS_DATA-1:0] R0;
	reg [BITS_DATA-1:0] R1;
	reg [BITS_DATA-1:0] R2;
	reg [BITS_DATA-1:0] R3;
	reg [BITS_DATA-1:0] R4;
	reg [BITS_DATA-1:0] R5;
	reg [BITS_DATA-1:0] R6;
	reg [BITS_DATA-1:0] R7;
	
	//para agregar un elemento en el arreglo de registros
	always @(dirrInput) begin
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
	
	//para sacar un primer elemento del arreglo de registros
	always @(dirrOutput1) begin
		case (dirrOutput1)
			'b000: begin
				outputData1 = R0;
				//dirrOutput1 <= R0[7:5];
			end
			
			'b001: begin
				outputData1 = R1;
				//dirrOutput1 <= R1[7:5];
			end
			
			'b010: begin
				outputData1 = R2;
				//dirrOutput1 <= R2[7:5];
			end
			
			'b011: begin
				outputData1 = R3;
				//dirrOutput1 <= R3[7:5];
			end
			
			'b100: begin
				outputData1 = R4;
				//dirrOutput1 <= R4[7:5];
			end
			
			'b101: begin
				outputData1 = R5;
				//dirrOutput1 <= R5[7:5];
			end
			
			'b110: begin
				outputData1 = R6;
				//dirrOutput1 <= R6[7:5];
			end
			
			'b111: begin
				outputData1 = R7;
				//dirrOutput1 <= R7[7:5];
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
				//dirrOutput1 <= R0[7:5];
			end
			
			'b001: begin
				outputData2 = R1;
				//dirrOutput1 <= R1[7:5];
			end
			
			'b010: begin
				outputData2 = R2;
				//dirrOutput1 <= R2[7:5];
			end
			
			'b011: begin
				outputData2 = R3;
				//dirrOutput1 <= R3[7:5];
			end
			
			'b100: begin
				outputData2 = R4;
				//dirrOutput1 <= R4[7:5];
			end
			
			'b101: begin
				outputData2 = R5;
				//dirrOutput1 <= R5[7:5];
			end
			
			'b110: begin
				outputData2 = R6;
				//dirrOutput1 <= R6[7:5];
			end
			
			'b111: begin
				outputData2 = R7;
				//dirrOutput1 <= R7[7:5];
			end
			
			default: begin
				//default case
			end
		endcase	
	end
	
	//para sacar un segundo elemento del arreglo de registros
	/*always @(dirrOutput2) begin
		case (dirrInput)
			'b000: begin
				//code
			end
			
			'b001: begin
				//code
			end
			
			'b010: begin
				//code
			end
			
			'b011: begin
				//code
			end
			
			'b100: begin
				//code
			end
			
			'b101: begin
				//code
			end
			
			'b110: begin
				//code
			end
			
			'b111: begin
				//code
			end
			
			default: begin
				//code
			end
		endcase	
	end*/
	//WE WILL USE A SWITCH FOR EVERY CASE OF DIRR OUTPUT
	
	
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

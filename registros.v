/*******************************
Universidad de Costa Rica
CI-0114: Fundamentos de Arquitectura

Circuito simple de registro que permite almacenar 32 bits

iverilog registros.v registros_tb.v
*****************************/

module registersArray(inputData, outputData1, outputData2, dirrInput, dirrOutput1, dirrOutput2);
	parameter BITS_DATA = 32;	//tamano de los registros
	parameter BITS_ADDR = 3;	//dirrecion que permite saber con cual registro trabajar
	
	input [BITS_DATA-1:0] inputData;
	input [BITS_ADDR-1:0] dirrInput;
	output [BITS_DATA-1:0] outputData1;
	output [BITS_DATA-1:0] outputData2;
	output [BITS_ADDR-1:0] dirrOutput1;
	output [BITS_ADDR-1:0] dirrOutput2;
	
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
				//caso default
			end
		endcase	
	end
	
	//para sacar un primer elemento del arreglo de registros
	always @(dirrOutput1) begin
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
	end
	
	//para sacar un segundo elemento del arreglo de registros
	always @(dirrOutput2) begin
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
	end
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

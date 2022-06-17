/*******************************
Universidad de Costa Rica
CI-0114: Fundamentos de Arquitectura

Modulo de CPU completado
Archibald Emmanuel Carrion Claeys
C01736

Ancho de palabra (Datos) 32 bits, ancho de direcciones 16 bits (64Ki Words)
iverilog alu.v cpu.v memoria.v registros.v cpu_tb.v
*********************************/

`include "opcodes.vh"

`define STAGE_FE_0 0	// fetch 0
`define STAGE_FE_1 1	// fetch 1
`define STAGE_DE_0 2	// decode 0
`define STAGE_DE_1 3	// decode 1
`define STAGE_EX_0 4	// execute 0
`define STAGE_EX_1 5	// execute 1
`define STAGE_MA_0 6	// memory access 0
`define STAGE_MA_1 7	// memory access 1
`define STAGE_WB_0 8	// write back 0
`define STAGE_WB_1 9	// write back 1
`define STAGE_HLT  10	// halt

module CPU(MBR_W, write, MAR, MBR_R, reset, clk);
	
	parameter BITS_DATA = 32;
	parameter BITS_ADDR = 16;

	output reg [BITS_DATA-1:0] MBR_W;
	output reg [BITS_ADDR-1:0] MAR;
	output reg                 write;
  
	input  [BITS_DATA-1:0] MBR_R;
	input                  reset;
	input                  clk;
 
	reg [BITS_DATA-1:0] IR;		//	--> instruction actual
	reg [BITS_ADDR-1:0] PC;		//  --> adress of actual instruction
	
	//registros y wires para el ALU
	reg [4:0]           opcode;
	reg [2:0]           dirReg;
	reg [BITS_DATA-1:0] operandoA;
	reg [BITS_DATA-1:0] operandoB;
	wire [31:0] R;
	wire C, S, O, Z;
	
	//registros y wires para el array de registros
	reg [31:0] _inputData;
	reg [2:0] _dirrInput;
	reg [2:0] _dirrOutput1;
	reg [2:0] _dirrOutput2;
	reg _enableWrite;
	wire [31:0] _outputData1;
	wire [31:0] _outputData2;
 
	reg [3:0] stage;
	
	//se ejecuta la maquina de estado durante los posedge del reloj
	always @(posedge clk or reset) begin
		if (reset) begin
			stage <= `STAGE_FE_0;
			PC    <= 0;  // Podría definirse cualquier otra dirección como primer fetch
		end else begin
			case (stage)
				`STAGE_FE_0: begin
					stage <= `STAGE_FE_1;
					MAR   <= PC;
				end

				`STAGE_FE_1: begin
					stage <= `STAGE_DE_0;
					PC <= PC + 1;
					IR <= MBR_R;
				end

				`STAGE_DE_0: begin
					stage <= `STAGE_DE_1;
					opcode <= IR[31:27];
					opcode = IR[31:24];
					dirReg = IR[26:24];
					//DECODE 0
				end

				`STAGE_DE_1: begin
					stage <= `STAGE_EX_0;
					
					operandoA = IR[23:16];
					operandoB = IR[15:0];
					//DECODE 1
				end
				
				`STAGE_EX_0: begin
				  stage <= `STAGE_EX_1;
				  //hay que "llamar" el alu con los operandos y el opcode dado
				end

				`STAGE_EX_1: begin
				  stage <= `STAGE_MA_0;
				end

				`STAGE_MA_0: begin
				  stage <= `STAGE_MA_1;
				end

				`STAGE_MA_1: begin
				  stage <= `STAGE_WB_0;
				end

				`STAGE_WB_0: begin
					stage <= `STAGE_WB_1;
				end

				`STAGE_WB_1: begin
					stage <= `STAGE_FE_0;
				end

				default: begin
					stage <= `STAGE_HLT;
				end
			endcase
		end
	end
	
	//se guarda los valores en los registros cuando es el negedge del reloj
	always @(negedge clk) begin
		_dirrInput = IR[26:24]; _enableWrite=1;
	end
	
	ALU alu(.resultado(R), .C(C), .S(S), .O(O), .Z(Z), .operando_a(operandoA), .operando_b(operandoB), .opcode(opcode));
	registersArray registro(IR, _dirrInput, _dirrOutput1, _dirrOutput2, _outputData1, _outputData2, _enableWrite);
	//ALU alu(resultado, C, S, O, Z, operando_a, operando_b, opcode);
endmodule

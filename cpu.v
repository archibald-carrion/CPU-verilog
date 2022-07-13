/*******************************
Universidad de Costa Rica
CI-0114: Fundamentos de Arquitectura

Modulo de CPU completado
Archibald Emmanuel Carrion Claeys
C01736

Ancho de palabra (Datos) 32 bits, ancho de direcciones 16 bits (64Ki Words)
iverilog alu.v cpu.v memoria.v registros.v cpu_tb.v
*********************************/


// iverilog ejemplo_and_or.v ejemplo_and_or_tb.v
// vvp a.out
// gtkwave ejemplo_and_or.vcd



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
	reg [2:0] dst;
	reg [2:0] src;

	wire [31:0] R;
	//output wire C, S, O, Z;
	
	//registros y wires para el array de registros
	reg [31:0] _inputData;
	//reg [2:0] _dirrInput;
	//reg [2:0] _dirrOutput1;
	//reg [2:0] _dirrOutput2;
	reg _enableWrite;
	wire [31:0] _outputData1;
	wire [31:0] _outputData2;
 
	reg [3:0] stage;
	
	
	reg [BITS_DATA-1:0] resultado;
	reg C;
	reg S;
	reg O;
	reg Z;
	
	//se ejecuta la maquina de estado durante los posedge del reloj
	always @(posedge clk or reset) begin
		_enableWrite=0;
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
					PC <= PC + 1;				//se incrementa el PC para poder hacer fetch de la instruction siguiente en el proximo ciclo
					IR <= MBR_R;
				end

				`STAGE_DE_0: begin
					stage <= `STAGE_DE_1;
					//opcode <= IR[31:27];
					opcode <= IR[31:27];
					dirReg = IR[26:24];
					operandoA = IR[23:19];
					dst = IR[18:16];
					operandoB = IR[15:3];
					src = IR[2:0];

					//DECODE 0
				end

				`STAGE_DE_1: begin
					stage <= `STAGE_EX_0;					
					//DECODE 1
				end
				
				`STAGE_EX_0: begin
					if(opcode>=16 && opcode<=25) begin
				  		ALU alu(resultado, C, S, O, Z, operandoA, operandoB, opcode);
						stage <= `STAGE_WB_0;
					end 
					else begin
						stage <= `STAGE_EX_1;
					end
				end

				`STAGE_EX_1: begin
				  	
					case(opcode)
						`OP_LD: begin
							stage <= `STAGE_MA_0;
						end

						`OP_STR: begin
							stage <= `STAGE_MA_1;
						end

						default: begin
							stage <= `STAGE_HLT;
						end

				end

				`STAGE_MA_0: begin	//LOAD
					
				  	stage <= `STAGE_WB_0;
					Mem_D32b_A16b mem(resultado, 						// output de la memoria
									resultado,   						// input de la memoria
									dirReg,						// address de memoria de la celda que se quiere leer
									0,									// write = 0, ya que queremos leer la memoria y no guardar nada
									clk);									// clk en 1, ya que la escritura se ejecuta en clk = 0	

					//hay que guardarlo en registros
									
				end

				`STAGE_MA_1: begin	//STORE
					
				  	stage <= `STAGE_WB_1;
					Mem_D32b_A16b mem(operandoA, 						// output de la memoria
						operandoA,   						// input de la memoria
						dirReg,						// address de memoria de la celda que se quiere leer
						1,									// write = 0, ya que queremos leer la memoria y no guardar nada
						~clk);									// clk en 1, ya que la escritura se ejecuta en clk = 0

					//aqui se guarda en la memoria
							
				end

				`STAGE_WB_0: begin
					stage <= `STAGE_WB_1;
					//aqui se guarda en los registros
					registersArray registros(.inputData(resultado), 
											 .dirrInput(dirReg), 
											 .dirrOutput1(dst), 
											 .dirrOutput2(src), 
											 .outputData1(operandoA), 
											 .outputData2(operandoB), 
											 .write_en(1), 
											 .clk(clk));
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

endmodule

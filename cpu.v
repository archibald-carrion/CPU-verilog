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
	reg [7:0]           opcode;
	reg [BITS_DATA-1:0] operandoA;
	reg [BITS_DATA-1:0] operandoB;
	reg [2:0] dst;
	reg [2:0] src;
  wire[BITS_DATA-1:0] resultado;
  reg [BITS_DATA-1:0] resultadoReg;
	output wire C, S, O, Z;
	
  //registros y wires para memoria
  wire [BITS_DATA-1:0] salidaMemoria;
  reg [BITS_DATA-1:0] entradaMemoria;
  reg writeMemoria;

	//registros y wires para el array de registros
  wire [BITS_DATA-1:0] salidaRegistros;
  reg [BITS_DATA-1:0] entradaRegistros;
  reg [2:0] addressRegistros;
  reg writeRegistros;
 
	reg [3:0] stage;

	//reg C;
	//reg S;
	//reg O;
	//reg Z;
	
	//se ejecuta la maquina de estado durante los posedge del reloj
	always @(posedge clk or reset) begin
		if (reset) begin
			stage <= `STAGE_FE_0;
			PC    <= 0;  // Podría definirse cualquier otra dirección como primer fetch
		end 
    else begin
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
          opcode <= IR[31:24];

          // Decode para la Alu
					operandoA = IR[23:16];
					operandoB = IR[15:0];

          // Decode de uso general
          dst = IR[18:16];
          src = IR[2:0];

          // Decode para load INM
          entradaRegistros = IR[15:0];

          // Decode para Load Reg
          addressRegistros = IR[15:0];

					//DECODE 0
				end

				`STAGE_DE_1: begin
					stage <= `STAGE_EX_0;
          // Si desea realizar un load de registro a registro
          if (opcode == 10)	begin
            writeRegistros = 0;
          end			
					//DECODE 1
				end
				
				`STAGE_EX_0: begin
					if(opcode>=16 && opcode<=25) begin
            resultadoReg = resultado;
            stage <= `STAGE_WB_0;
					end 
          else begin
            stage <= `STAGE_EX_1;
          end
				end

				`STAGE_EX_1: begin
          if(opcode==2 || opcode==11) begin
            stage <= `STAGE_MA_0;
					end 
          else begin
            stage <= `STAGE_WB_0;
          end

					/*case(opcode)
						`OP_LD: begin
							stage <= `STAGE_MA_0;
						end

						`OP_STR: begin
							stage <= `STAGE_MA_1;
						end

						default: begin
							stage <= `STAGE_HLT;
						end*/

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

ALU alu(resultado, C, S, O, Z, operandoA, operandoB, opcode[7:3]);

Mem_D32b_A16b mem(salidaMemoria, 					   	// output de la memoria
						entradaMemoria,   						    // input de la memoria
						MAR,						                  // address de memoria de la celda que se quiere leer
						writeMemoria,									    // write = 0, ya que queremos leer la memoria y no guardar nada
						clk);									            // clk en 1, ya que la escritura se ejecuta en clk = 0

registersArray registros(.inputData(entradaRegistros), 
											 .dirrInput(addressRegistros), 
											 .dirrOutput1(addressRegistros), 
											 .dirrOutput2(addressRegistros), 
											 .outputData1(salidaRegistros), 
											 .outputData2(salidaRegistros), 
											 .write_en(writeRegistros), 
											 .clk(clk));

endmodule

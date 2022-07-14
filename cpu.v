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
  reg [BITS_DATA-1:0] salidaMemoriaReg;
  reg [BITS_DATA-1:0] entradaMemoria;
  reg [BITS_ADDR-1:0] addressMemoria;
  reg writeMemoria;

	//registros y wires para el array de registros
  wire [BITS_DATA-1:0] salidaRegistros;
  reg [BITS_DATA-1:0] salidaRegistrosReg01;
  reg [BITS_DATA-1:0] salidaRegistrosReg02;
  reg [BITS_DATA-1:0] entradaRegistros;
  reg [2:0] addressRegistrosLectura;
  reg [2:0] addressRegistrosEscritura;
  reg writeRegistros;
 
  // registros y wires para el JUMP
  reg [12:0] saltoIntruccion;

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
          addressRegistrosLectura = IR[2:0];
          // Load directo
          addressMemoria = IR[15:0];

          addressRegistrosEscritura = IR[18:16];

          // Decode para JUMP
          saltoIntruccion = IR[15:3];

					//DECODE 0
				end

				`STAGE_DE_1: begin
					stage <= `STAGE_EX_0;
          // Si desea realizar un load de registro a registro
          // o es un store o un salto
          if (opcode == 10 || opcode == 2 || opcode == 209)	begin
            // Lea el valor en ese registro
            writeRegistros = 0;
          end			
					//DECODE 1
				end
				
				`STAGE_EX_0: begin
          // Si es una operacion de la ALU
					if(opcode>=16 && opcode<=25) begin
            // Guarde el resultado en un buffer
            resultadoReg = resultado;
            // Vaya directo a Write-Back (WB)
            stage <= `STAGE_WB_0;
					end 
          else begin
            // Si la instruccion es un salto
            if (opcode == 209) begin
              // guarde el primer valor para comparar
              salidaRegistrosReg01 = salidaRegistros;

              // Lea el otro valor
              addressRegistrosLectura = dst;
              writeRegistros = 0;
            end
            stage <= `STAGE_EX_1;
          end
				end

				`STAGE_EX_1: begin
          // Si es un Load Directo o un store (usa memoria)
          if(opcode==2 || opcode==11) begin
            // Vaya a memory access (MA)
            stage <= `STAGE_MA_0;
					end 
          
          else begin
            // Si la instruccion es un salto
            if (opcode == 209) begin
              // guarde el segundo valor para comparar
              salidaRegistrosReg02 = salidaRegistros;
              
              // Si la condicion de salto se cumple
              if (salidaRegistrosReg01 != salidaRegistrosReg02) begin
                // Cambie la instruccion siguiente a la indicada
                PC = saltoIntruccion;
              end
              // Vuelva al fetch
              stage <= `STAGE_FE_0;
            end

            // Si la instruccion es un Load INM o un Load Reg
            else begin
              stage <= `STAGE_WB_0;
            end
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
          // Si estamos haciendo un store
          if (opcode == 2) begin
            // Guardamos el valor de registros que queremos
            // escribir en memoria
            salidaRegistrosReg01 = salidaRegistros;
            // Habilitamos escritura
            writeMemoria = 1;
          end
          // Si estamos haciendo un Load directo
          else begin
            // Deshabilitamos escritura
            writeMemoria = 0;
          end
				end

				`STAGE_MA_1: begin	
          // Si estamos haciendo un store
          if (opcode == 2) begin
            // Cambiamos el valor de escritura
            entradaMemoria = salidaRegistrosReg01;
            // Ya has terminado tu funcion
            stage <= `STAGE_FE_0;
          end
          // Si estamos haciendo un Load directo
          else begin
            // Guardamos el valor de la memoria
            salidaMemoriaReg = salidaMemoria;
            // Continuar con escritura en registros
            stage <= `STAGE_WB_0;
          end

				end

				`STAGE_WB_0: begin
          stage <= `STAGE_WB_1;
          case (opcode)
            `OPD_LD_INM: begin
            end
            `OPD_LD_REG: begin
              // Guardamos el valor del registro src
              salidaRegistrosReg01 = salidaRegistros;
              // Cambiamos el valor de escritura al valor de src
              entradaRegistros = salidaRegistrosReg01;
            end
            `OPD_LD_DIRECT: begin
              // Cambiamos el valor de escritura al valor de la memoria
              entradaRegistros = salidaMemoriaReg;
            end
            // Casos de opcode para Alu
            default: begin
              // Cambiamos el valor de escritura al valor obtenido de la Alu
              entradaRegistros = resultadoReg;
            end
          endcase;
				end

				`STAGE_WB_1: begin
          stage <= `STAGE_FE_0;
          // Escribimos el valor en los registros
          writeRegistros = 1;
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
						addressMemoria,						        // address de memoria de la celda que se quiere leer
						writeMemoria,									    // write = 0, ya que queremos leer la memoria y no guardar nada
						clk);									            // clk en 1, ya que la escritura se ejecuta en clk = 0

registersArray registros(.inputData(entradaRegistros), 
											 .dirrInput(addressRegistrosEscritura), 
											 .dirrOutput1(addressRegistrosLectura), 
											 .dirrOutput2(addressRegistrosLectura), 
											 .outputData1(salidaRegistros), 
											 .outputData2(salidaRegistros), 
											 .write_en(writeRegistros), 
											 .clk(clk));

endmodule

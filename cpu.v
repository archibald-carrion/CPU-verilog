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

  // input & ouput del CPU
	output reg [BITS_DATA-1:0] MBR_W;
	output reg [BITS_ADDR-1:0] MAR;
	output reg write;
	input  [BITS_DATA-1:0] MBR_R;
	input reset;
	input clk;
 
  // registers & wires para el CPU
	reg [BITS_DATA-1:0] IR;		//	--> instruction actual
	reg [BITS_ADDR-1:0] PC;		//  --> adress of actual instruction
	reg [3:0] stage;
  reg [4:0] opcodeReduced;

	// registers & wires para el ALU
	reg [7:0] opcode;
	reg [BITS_DATA-1:0] operandoA;
	reg [BITS_DATA-1:0] operandoB;
  wire[BITS_DATA-1:0] resultado;
  reg [BITS_DATA-1:0] resultadoReg;
	output wire C, S, O, Z;
	
  // registers & wires para el array de registros
  wire [BITS_DATA-1:0] salidaRegistros01;
  wire [BITS_DATA-1:0] salidaRegistros02;
  reg [BITS_DATA-1:0] salidaRegistrosReg01;
  reg [BITS_DATA-1:0] salidaRegistrosReg02;
  reg [BITS_DATA-1:0] entradaRegistros;
  reg [2:0] addressRegistrosLectura01;
  reg [2:0] addressRegistrosLectura02;
  reg [2:0] addressRegistrosEscritura;
  reg writeRegistros;
 
  // registros y wires para el Load INM
  reg [BITS_ADDR-1:0] valorInmediato;

  // registros y wires para el Store directo
  // No utiliza BITS_ADDR porque es dependiente de la instruccion
  reg [15:0] direccionMemoria;

  // registros y wires para el JUMP
  reg[15:0] nuevaDirrecion;
  reg [12:0] saltoIntruccion;
	
	//se ejecuta la maquina de estado durante los posedge del reloj
	always @(posedge clk or reset) begin
		if (reset) begin
			stage <= `STAGE_FE_0;
			PC    <= 0;                          // Podría definirse cualquier otra dirección como primer fetch
		end 
    else begin
			case (stage)

        //############################################################################################

				`STAGE_FE_0: begin
					stage <= `STAGE_FE_1;
          writeRegistros <= 0;
          write <= 0;
					MAR   <= PC;
				end

        //############################################################################################

				`STAGE_FE_1: begin
					stage <= `STAGE_DE_0;
					PC <= PC + 1;				                               // Se incrementa PC para hacer fetch de la instruction siguiente en el proximo ciclo
					IR <= MBR_R;
				end

        //############################################################################################

				`STAGE_DE_0: begin
					stage <= `STAGE_DE_1;
          
          // Decode de uso general
          opcode <= IR[31:24];                               // Opcode con dir (Load inmediato, Store directo, Jump)
          opcodeReduced <= IR[31:27];                        // Opcode sin dir (Operaciones de la ALU y NOP)

          // Decode para Load INM u operaciones de la ALU
          addressRegistrosEscritura <= IR[18:16];            // Address al registro donde se va a escribir (dst)

          // Decode para load INM
          valorInmediato <= IR[15:0];                        // Valor inmediato a escribir se encuentra en los ultimos 15 bits

          // Decode para Lectura de registros (operaciones de ALU, Jump y Store directo)
          addressRegistrosLectura01 <= IR[18:16];            // Address hacia el operando A (ALU), al primer registro para comparar (Jump) o al registro para copiar a memoria (Store)
          addressRegistrosLectura02 <= IR[2:0];              // Address hacia el operando B (ALU) o al segundo registro para comparar (Jump)

          // Decode para Store directo
          direccionMemoria <= IR[15:0];                      // Address hacia la direccion de memoria en la que se quiere escribir

          // Decode para JUMP
          saltoIntruccion <= IR[15:3];                       // Address de memoria hacia la cual hay que saltar
        end

        //############################################################################################

				`STAGE_DE_1: begin
					stage <= `STAGE_EX_0;
          if(opcode == 19) begin                                                         // Si es un Store directo
            writeRegistros <= 0;                                                         // leer el contenido de un registro
          end
          else if ((opcodeReduced>=16 && opcodeReduced<=25) || opcode == 209) begin      // Si es una operacion de ALU o un Jump
            writeRegistros <= 0;                                                         // leer el contenido de dos registros
          end
          else if (opcode == 0) begin                                                    // Si se le pide al CPU que no realice operaciones
            stage <= `STAGE_HLT;                                                         // Detenga la CPU
          end
				end

        //############################################################################################
				
				`STAGE_EX_0: begin
          stage <= `STAGE_EX_1;
					if(opcodeReduced>=16 && opcodeReduced<=25) begin      // Si es una operacion de la ALU
            operandoA <= salidaRegistros01;                     // Guarde los operandos obtenidos de los registros
            operandoB <= salidaRegistros02;                     // Para la operacion
					end 
          else if (opcode == 209) begin                         // Si es un Jump
            nuevaDirrecion <= 0;                                // Agreguele 000 al inicio de la direccion dado que no existian suficientes bits en la instruccion
            nuevaDirrecion[12:0] <= saltoIntruccion;            // Actualice el resto de la instrucción
            salidaRegistrosReg01 <= salidaRegistros01;          // Guarde las salidas de los registros
            salidaRegistrosReg02 <= salidaRegistros02;          // Para su comparación
          end
          else if (opcode == 19) begin                          // Si es un Store directo
            salidaRegistrosReg01 <= salidaRegistros01;          // Guarde el contenido del registro DST
          end
				end

        //############################################################################################

				`STAGE_EX_1: begin
          if(opcode == 19) begin                                        // Si es un Store directo (escribe en memoria)
            stage <= `STAGE_MA_0;                                       // Vaya a Memory Access (MA)
					end 
          
          else begin                                                    // De lo contrario (no interactua con la memoria)
            if (opcode == 209) begin                                    // Si la instruccion es un Jump
              if (salidaRegistrosReg01 != salidaRegistrosReg02) begin   // Si los dos registros ingresados en la instruccion no tienen el mismo valor
                PC <= nuevaDirrecion;                              // Cambie la instruccion siguiente a la indicada
              end
              stage <= `STAGE_FE_0;                                     // Vaya directo al Fetch de la siguiente instruccion
            end

            else begin                                                  // Si es otra operacion (escribe en registros)
              if (opcodeReduced>=16 && opcodeReduced<=25) begin         // Si la instruccion es un operacion de la ALU
                resultadoReg = resultado;                               // Guarde el resultado de la operacion en un reg buffer
              end   
              stage <= `STAGE_WB_0;                                     // Vaya a Write Back (WB)
            end
          end

        end

        //############################################################################################

				`STAGE_MA_0: begin	
				  stage <= `STAGE_MA_1;            
          MBR_W <= salidaRegistrosReg01;    // Se guarda en data_in de memoria el valor del registro
          MAR <= direccionMemoria;          // Se guarda la direccion de memoria en la que se desea hacer el store directo
				end

        //############################################################################################

				`STAGE_MA_1: begin	
          stage <= `STAGE_FE_0;
          write <= 1;                       // Se escribe el valor en la memoria
				end

        //############################################################################################

				`STAGE_WB_0: begin
          stage <= `STAGE_WB_1;
          if(opcodeReduced>=16 && opcodeReduced<=25) begin      // Si es una operacion de la ALU
            entradaRegistros <= resultadoReg;                   // Indicar que debe escribir el resultado de la operacion obtenido
          end
          else begin                                            // Si es un Load INM
            entradaRegistros <= 0;                              // Ponga los primeros bits no aprovechados en 0
            entradaRegistros[15:0] <= valorInmediato;           // Indicar que debe escribir el valor inmediato obtenido de la instruccion
          end
				end

        //############################################################################################

				`STAGE_WB_1: begin
          stage <= `STAGE_FE_0;
          writeRegistros <= 1;                                  // Escribimos el valor en los registros
				end

        //############################################################################################

				default: begin
					stage <= `STAGE_HLT;
				end

        //############################################################################################

			endcase
		end
	end

ALU alu(resultado, C, S, O, Z, operandoA, operandoB, opcodeReduced);

registersArray registros(.inputData(entradaRegistros), 
											 .dirrInput(addressRegistrosEscritura), 
											 .dirrOutput1(addressRegistrosLectura01), 
											 .dirrOutput2(addressRegistrosLectura02), 
											 .outputData1(salidaRegistros01), 
											 .outputData2(salidaRegistros02), 
											 .write_en(writeRegistros), 
											 .clk(clk));

endmodule

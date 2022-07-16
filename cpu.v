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
  reg [BITS_DATA-1:0] bigRegister; //registro usado para almacenar temporalmente cantidad grandes de bits

	// registers & wires para el ALU
	reg [7:0] opcode;
	reg [BITS_DATA-1:0] operandoA;
	reg [BITS_DATA-1:0] operandoB;
	reg [2:0] dst;
	reg [2:0] src;
  wire[BITS_DATA-1:0] resultado;
  reg [BITS_DATA-1:0] resultadoReg;
	output wire C, S, O, Z;
	
  // registers & wires para el array de registros
  wire [BITS_DATA-1:0] salidaRegistros;
  reg [BITS_DATA-1:0] salidaRegistrosReg01;
  reg [BITS_DATA-1:0] salidaRegistrosReg02;
  reg [BITS_DATA-1:0] entradaRegistros;
  reg [2:0] addressRegistrosLectura;
  reg [2:0] addressRegistrosEscritura;
  reg writeRegistros;
 
  // registros y wires para el JUMP
  reg [12:0] saltoIntruccion;

	
	
	//se ejecuta la maquina de estado durante los posedge del reloj
	always @(posedge clk or reset) begin
		if (reset) begin
			stage <= `STAGE_FE_0;
			PC    <= 0;  // Podría definirse cualquier otra dirección como primer fetch
		end 
    else begin
			case (stage)

        //############################################################################################

				`STAGE_FE_0: begin
					stage <= `STAGE_FE_1;
					MAR   <= PC;
				end

        //############################################################################################

				`STAGE_FE_1: begin
					stage <= `STAGE_DE_0;
					PC <= PC + 1;				//se incrementa PC para hacer fetch de la instruction siguiente en el proximo ciclo
					IR <= MBR_R;
				end

        //############################################################################################

				`STAGE_DE_0: begin
					stage <= `STAGE_DE_1;
          
          // Decode de uso general
          opcode <= IR[31:24];
          opcodeReduced <= IR[31:27];
          dst <= IR[18:16];
          src <= IR[2:0];

          // Decode para la Alu
					operandoA <= IR[23:16];
					operandoB <= IR[15:0];

          // Decode para load INM
          entradaRegistros <= IR[15:0];

          // Decode para Load Reg
          addressRegistrosLectura <= IR[2:0];
          addressRegistrosEscritura <= IR[18:16];

          // Decode para JUMP
          saltoIntruccion <= IR[15:0];  // address de memoria hacia la cual hay que saltar
        end

        //############################################################################################

				`STAGE_DE_1: begin
					stage <= `STAGE_EX_0;
          if(opcode == 19 || opcode == 209) begin
            writeRegistros <= 0;  // no se puede modificar el contenido de los registros cuando se hace un store o un jump
          end			
          else begin
            writeRegistros <= 1;  // se puede modificar el contenido de los registros en todos los otros casos
          end
				end

        //############################################################################################
				
				`STAGE_EX_0: begin
					if(opcodeReduced>=16 && opcodeReduced<=25) begin      // Si es una operacion de la ALU
            resultadoReg <= resultado;                          // Guarde el resultado en un buffer
            stage <= `STAGE_WB_0;                               // Vaya directo a Write-Back (WB)
					end 
          else begin
            
            if (opcode == 209) begin                            // Si la instruccion es un salto
             
              salidaRegistrosReg01 <= salidaRegistros;          // guarde el primer valor para comparar
              addressRegistrosLectura <= dst;                   // Lea el otro valor
              writeRegistros <= 0;
            end
            stage <= `STAGE_EX_1;
          end
				end

        //############################################################################################

				`STAGE_EX_1: begin
          // Si es un Load Directo o un store (usa memoria)
          if(opcodeReduced==2 || opcodeReduced==11) begin
            // Vaya a memory access (MA)
            stage <= `STAGE_MA_0;
					end 
          else begin
            if (opcode == 209) begin                                      // Si la instruccion es un salto
              salidaRegistrosReg02 <= salidaRegistros;                    // guarde el segundo valor para comparar
              if (salidaRegistrosReg01 != salidaRegistrosReg02) begin     // Si la condicion de salto se cumple
                PC <= saltoIntruccion;                                    // Cambie la instruccion siguiente a la indicada
                //MAR <= saltoIntruccion;
              end
              stage <= `STAGE_FE_0;                                       // Vuelva al fetch
            end
            else begin                                                    // Si la instruccion es un Load INM o un Load Reg
              stage <= `STAGE_WB_0;
            end
          end
        end

        //############################################################################################

				`STAGE_MA_0: begin	
				  stage <= `STAGE_MA_1;
          if (opcodeReduced == 2) begin               // Si estamos haciendo un store
            salidaRegistrosReg01 <= salidaRegistros;  // se guarda en un register el valor que hay que guardar en memoria
            // Habilitamos escritura
            //writeMemoria = 1;
            write <= 1;
          end
          // Si estamos haciendo un Load directo
          else begin
            //writeMemoria = 0;
            write <= 0;                               // se deshabilita escritura
          end
				end

        //############################################################################################

				`STAGE_MA_1: begin	
          // Si estamos haciendo un store
          if (opcodeReduced == 2) begin
            // Cambiamos el valor de escritura
            //entradaMemoria = salidaRegistrosReg01;
            MBR_W <= salidaRegistrosReg01;    //se guarda en data_in de memoria el valor del registro 
            // Ya has terminado tu funcion
            stage <= `STAGE_FE_0;
          end
          // Si estamos haciendo un Load directo
          else begin
            // Guardamos el valor de la memoria
            //salidaMemoriaReg = salidaMemoria;
            //salidaMemoriaReg <= MBR_R;
            // Continuar con escritura en registros
            stage <= `STAGE_WB_0;
          end
				end

        //############################################################################################

				`STAGE_WB_0: begin
          stage <= `STAGE_WB_1;
          case (opcode)
            `OPD_LD_INM: begin
              // se guarda en un registro el contenido de una celda de memoria de la cual 
              // tenemos el address
              entradaRegistros <= operandoB;
            end
            `OPD_LD_REG: begin
              salidaRegistrosReg01 <= salidaRegistros;  // Guardamos el valor del registro src
              entradaRegistros <= salidaRegistrosReg01; // Cambiamos el valor de escritura al valor de src
            end
            `OPD_LD_DIRECT: begin
              // Cambiamos el valor de escritura al valor de la memoria
              //entradaRegistros <= salidaMemoriaReg;
              //entradaRegistros <= MBR_R;
              //entradaRegistros <= operandoB;
            end
            // Casos de opcode para Alu
            default: begin
              // Cambiamos el valor de escritura al valor obtenido de la Alu
              entradaRegistros <= resultadoReg;
            end
          endcase;
				end

        //############################################################################################

				`STAGE_WB_1: begin
          stage <= `STAGE_FE_0;
          writeRegistros <= 1;    // Escribimos el valor en los registros
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
											 .dirrOutput1(addressRegistrosLectura), 
											 .dirrOutput2(addressRegistrosLectura), 
											 .outputData1(salidaRegistros), 
											 .outputData2(salidaRegistros), 
											 .write_en(writeRegistros), 
											 .clk(clk));

endmodule

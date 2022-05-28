/*******************************
Universidad de Costa Rica
CI-0114: Fundamentos de Arquitectura

Modulo de CPU vacío

Ancho de palabra (Datos) 32 bits
Ancho de direcciones 16 bits (64Ki Words)

*********************************/

`include "opcodes.vh"

`define STAGE_FE_0 0
`define STAGE_FE_1 1
`define STAGE_DE_0 2
`define STAGE_DE_1 3
`define STAGE_EX_0 4
`define STAGE_EX_1 5
`define STAGE_MA_0 6
`define STAGE_MA_1 7
`define STAGE_WB_0 8
`define STAGE_WB_1 9
`define STAGE_HLT  10

module CPU(MBR_W, write, MAR, MBR_R, reset, clk);
  parameter BITS_DATA = 32;
  parameter BITS_ADDR = 16;

  output reg [BITS_DATA-1:0] MBR_W;
  output reg [BITS_ADDR-1:0] MAR;
  output reg                 write;
  
  input  [BITS_DATA-1:0] MBR_R;
  input                  reset;
  input                  clk;
  
  reg [BITS_DATA-1:0] IR;
  reg [BITS_ADDR-1:0] PC;
  reg [4:0]           opcode;
  
  reg [3:0] stage;
  
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
        end

        `STAGE_DE_1: begin
          stage <= `STAGE_EX_0;
        end

        `STAGE_EX_0: begin
          stage <= `STAGE_EX_1;
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
  

endmodule

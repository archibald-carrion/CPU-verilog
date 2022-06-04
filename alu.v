/*******************************
Universidad de Costa Rica
CI-0114: Fundamentos de Arquitectura

Modulo de una ALU combinacional,
parcialmente implementada

*********************************/

`include "opcodes.vh"

module ALU(resultado, C, S, O, Z, operando_a, operando_b, opcode);
  parameter BITS_DATA = 32;

  output reg [BITS_DATA-1:0] resultado;
  output reg C;
  output reg S;
  output reg O;
  output reg Z;

  input [BITS_DATA-1:0] operando_a;
  input [BITS_DATA-1:0] operando_b;
  input [4:0] opcode;
  
  // Con el @*, estamos definiendo un bloque combinacional
  // ya que no depende de ningún reloj
  // La lógica combinacional debe usar asignación bloqueante
  always @* begin
    case (opcode)
		`OP_NOP: begin
		
		end
		
		`OP_HLT: begin
		
		end
		
		`OP_LD: begin 
		
		end
		
		`OP_STR: begin
		
		end
		
		`OP_NOT: begin
			resultado = ~operando_a;
			C = 0;
			S = resultado[BITS_DATA-1];
			O = 0;
			Z = ~(|resultado);
		end
		
		`OP_AND: begin
		
		end
		
		`OP_OR: begin
		
		end
		
		`OP_XOR: begin
		
		end
		
		`OP_NEG: begin
		
		end

		`OP_ADD: begin
			{C,resultado} = operando_a + operando_b;
			S = resultado[BITS_DATA-1];
			// Overflow es 1 cuando hay cambio en el bit de signo. Solo
			// puedo ocurrir cuando los operandos tienen el mismo signo
			O = (operando_a[BITS_DATA-1] == operando_b[BITS_DATA-1]) &&
				(operando_a[BITS_DATA-1] !=  resultado[BITS_DATA-1]);
			Z = ~(|resultado);
		end
		
		`OP_SUB: begin
		
		end
		
		`OP_MUL: begin
		
		end
		
		`OP_DIV: begin
		
		end
		
		`OP_MOD: begin
		
		end
		
		`OP_JMP: begin
		
		end
		
		`OP_JC: begin
		
		end
		
		`OP_JS: begin
		
		end
		
		`OP_JO: begin
		
		end
		
		`OP_JZ: begin
		
		end

		default: begin
			// El opcode no esta implementado o bien no es un
			// opcode de ALU valido. Intencionalmente propagaremos
			// Xs (indeterminado) a las salidas 
			resultado = 'hXXXX_XXXX;
			C = 'bx;
			S = 'bx;
			O = 'bx;
			Z = 'bx;
		end
    endcase
  end

endmodule
 
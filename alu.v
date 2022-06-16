/***********************************************************
Universidad de Costa Rica
CI-0114: Fundamentos de Arquitectura

Modulo de una ALU combinacional, completamente implementada
************************************************************/

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
	
		//solo hay que hacer la parte de decodificacion de la instruccion, no hay que ejecutarla <- hay que verificar eso
		case (opcode)
			`OP_NOP: begin	//NO OPERATION
				resultado = 'hXXXX_XXXX;
				C = 'bx;
				S = 'bx;
				O = 'bx;
				Z = 'bx;
			end
			
			`OP_HLT: begin	//HALT
				resultado = 'hXXXX_XXXX;
				C = 'bx;
				S = 'bx;
				O = 'bx;
				Z = 'bx;
			end
			
			//`OP_LD: begin 	//LOAD
			
			//end
			
			//`OP_STR: begin	//STORE
			
			//end
			
			`OP_NOT: begin	//NOT gate
				resultado = ~operando_a;
				C = 0;
				S = resultado[BITS_DATA-1];
				O = 0;
				Z = ~(|resultado);
			end
			
			`OP_AND: begin	//AND gate
				resultado = operando_a & operando_b;
				C = 0;
				S = resultado[BITS_DATA-1];
				O = 0;
				Z = ~(|resultado);
			
			end
			
			`OP_OR: begin	//OR gate
				resultado = operando_a | operando_b;
				C = 0;
				S = resultado[BITS_DATA-1];
				O =	0;
				Z = ~(|resultado);
			
			end
			
			//`OP_XOR: begin	//XOR gate
			
			//end
			
			`OP_NEG: begin	//negation
				resultado = -operando_a;			
				C = 0;
				S = resultado[BITS_DATA-1];
				O = 0;
				Z = ~(|resultado);
			end

			`OP_ADD: begin	//addition
				{C,resultado} = operando_a + operando_b;
				S = resultado[BITS_DATA-1];
				// Overflow es 1 cuando hay cambio en el bit de signo. Solo
				// puedo ocurrir cuando los operandos tienen el mismo signo
				O = (operando_a[BITS_DATA-1] == operando_b[BITS_DATA-1]) && (operando_a[BITS_DATA-1] !=  resultado[BITS_DATA-1]);
				Z = ~(|resultado);
			end
			
			`OP_SUB: begin	//substraction
				{C,resultado} = operando_a - operando_b;
				S = resultado[BITS_DATA-1];
				O = (operando_a[BITS_DATA-1] == operando_b[BITS_DATA-1]) && (operando_a[BITS_DATA-1] !=  resultado[BITS_DATA-1]);
				Z = ~(|resultado);
			end
			
			//`OP_MUL: begin	//multiplication
			
			//end
			
			//`OP_DIV: begin	//division
			
			//end
			
			//`OP_MOD: begin 	//modulo
			
			//end
			
			//`OP_JMP: begin
			
			//end
			
			//`OP_JC: begin
			
			//end
			
			//`OP_JS: begin
			
			//end
			
			//`OP_JO: begin
			
			//end
			
			//`OP_JZ: begin
			
			//end

			default: begin
				// El opcode no esta implementado o bien no es un opcode de ALU valido. Intencionalmente propagaremos Xs (indeterminado) a las salidas 
				resultado = 'hXXXX_XXXX;
				C = 'bx;
				S = 'bx;
				O = 'bx;
				Z = 'bx;
			end
		endcase
	end

endmodule
 
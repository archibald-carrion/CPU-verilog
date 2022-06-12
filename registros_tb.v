/*******************************
Universidad de Costa Rica
CI-0114: Fundamentos de Arquitectura

Circuito de prueba para el circuito registro.v
*********************************/

`timescale 1us/100ns

module Register_tb;
	wire [31:0] data_Output;
	reg  [31:0] data_Input;
	reg  [15:0] data_Dirrecion;
  
	initial begin
		$dumpfile("Registro.vcd");
		$dumpvars;
	end
endmodule

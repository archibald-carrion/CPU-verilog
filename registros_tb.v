/*******************************
Universidad de Costa Rica
CI-0114: Fundamentos de Arquitectura

Circuito de prueba para el circuito registro.v
*********************************/

`timescale 1us/100ns

module Register_tb;
	reg [31:0] data_Output;
	reg  [31:0] data_Input;
	reg  [2:0] dirr;
  
	initial begin
		$dumpfile("registros.vcd");
		$dumpvars;
		// en 1 registor cabe 32bits, lo cual son 4 bytes, y por lo tanto 4 char
		
		//monitor instruction 
		
		//clk = 1; escribir = 0;
		//#1 direccion = 5;
		//#2 data_entrada = 'hACED_CAFE; direccion = 4; escribir = 1;
		//#1 data_Input <= 'hHOLA;  
		//#1 data_Input = 'hACED_CAFE;
		//#1 data_Input = 'hDEAD_BEEF;
		#1 $finish;
		//#1 escribir = 0;
		//#1 direccion = 3; data_entrada = 'hDEAD_BEEF;
		//#6 $finish;
	end
	
	//registersArray registro();
	//Mem_D32b_A16b mem(.data_out(data_salida),.data_in(data_entrada),.address(direccion),.write(escribir),.clk(clk));
endmodule



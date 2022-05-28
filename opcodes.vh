// Modos de direccionamiento (addressing) (son parte del opcode [7:0], específicamente los bits [2:0])
`define DIRECC_IMP    'b000  // Direccionamiento implícito o no necesario para la operación
`define DIRECC_INM    'b001  // Direccionamiento inmediato
`define DIRECC_REG    'b010  // Direccionamiento de registros
`define DIRECC_DIRECT 'b011  // Direccionamiento directo
`define DIRECC_INDREG 'b100  // Direccionamiento indirecto por registros

// Opcodes

// Opcodes especiales
`define OP_NOP        'b00000  // (0x00) Ningúna Operación (hace nada, No Op)
`define OP_HLT        'b11111  // (0x1F) Halt. Detiene la máquina/CPU
// Memoria
`define OP_LD         'b00001  // (0x01)
`define OP_STR        'b00010  // (0x02)
// Lógicas
`define OP_NOT        'b10000  // (0x10)
`define OP_AND        'b10001  // (0x11)
`define OP_OR         'b10010  // (0x12)
`define OP_XOR        'b10011  // (0x13)
// Aritméticas
`define OP_NEG        'b10100  // (0x14)
`define OP_ADD        'b10101  // (0x15)
`define OP_SUB        'b10110  // (0x16)
`define OP_MUL        'b10111  // (0x17)
`define OP_DIV        'b11000  // (0x18)
`define OP_MOD        'b11001  // (0x19)
// Control
`define OP_JMP        'b11010  // (0x1A)
`define OP_JC         'b11011  // (0x1B)
`define OP_JS         'b11100  // (0x1C)
`define OP_JO         'b11101  // (0x1D)
`define OP_JZ         'b11110  // (0x1E)

// Combinaciones válidas de Opcodes y Direccionamiento

// Opcodes especiales
`define OPD_NOP        'b00000_000  // (0x00) Ningúna Operación (hace nada, No Op)
`define OPD_HLT        'b11111_000  // (0xF8) Halt. Detiene la máquina/CPU
// Memoria
// (Para el load, el destino siempre es un registro. La fuente puede variar dependiendo del modo de direccionamiento)
`define OPD_LD_INM     'b00001_001  // (0x09) Carga un valor inmediato al registro. Ya que el valor inmediato son 16 bits y el registro 32 bits, se hará extensión de signo
`define OPD_LD_REG     'b00001_010  // (0x0A) Load entre registros. Permite mover fácilmente el valor de un Registro A a otro Registro B
`define OPD_LD_DIRECT  'b00001_011  // (0x0B)
`define OPD_LD_INDREG  'b00001_100  // (0x0C)
// (Para el store, la fuente siempre es un registro. El destino puede variar dependiendo del modo de direccionamiento)
`define OPD_STR_DIRECT 'b00010_011  // (0x13)
`define OPD_STR_INDREG 'b00010_100  // (0x14)
// Lógicas (Todas usa direccionamiento de registros únicamente)
`define OPD_NOT        'b10000_010  // (0x82)
`define OPD_AND        'b10001_010  // (0x86)
`define OPD_OR         'b10010_010  // (0x92)
`define OPD_XOR        'b10011_010  // (0x96)
// Aritméticas (Todas usa direccionamiento de registros únicamente)
`define OPD_NEG        'b10100_010  // (0xA2)
`define OPD_ADD        'b10101_010  // (0xA6)
`define OPD_SUB        'b10110_010  // (0xB2)
`define OPD_MUL        'b10111_010  // (0xB6)
`define OPD_DIV        'b11000_010  // (0xC2)
`define OPD_MOD        'b11001_010  // (0xC6)
// Control (Todas son saltos absolutos, y usan direccionamiento inmediato únicamente)
`define OPD_JMP        'b11010_001  // (0xD1)
`define OPD_JC         'b11011_001  // (0xD9)
`define OPD_JS         'b11100_001  // (0xE1)
`define OPD_JO         'b11101_001  // (0xE9)
`define OPD_JZ         'b11110_001  // (0xF1)

// Para ver los opcodes con nombres en GTKWave
// https://electronics.stackexchange.com/questions/530123/viewing-verilog-enums-in-iverilog-gtkwave

// Create a file with the extension gtkw. This file contains how you want the state variable to be displayed on
// the waveform. For your example it would be:
//
// 00 STATE0
// 01 STATE1
// 10 STATE2
//
// Because you have used logic type which is 2 bits wide and have not encoded the state variables, SystemVerilog
// assigns the state variables the default values in ascending order. In this case the default binary values would
// be from 00 to 10 since you have 3 State variables.
// 
// Open the waveform and dump the signal. Do  Right-Mouse -> Data Format -> Translate Filter File -> Enable and Select.
// The Select Signal Filter Dialog Box opens. Then left click on Add Filter to List button. Select the gtkw extension file
// that you created. This file will then be displayed in the Select Signal Filter dialog box. Select your file in the Select
// Filter Dialog Box, make sure it is highlighted, then left click on the OK button. The binary signals in the waveform should
// be replaced with the enum values.
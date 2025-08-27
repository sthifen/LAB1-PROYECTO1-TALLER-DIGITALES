`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/22/2025 05:10:21 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
// top.sv
module top(
  input  logic [15:0] SW,       // 16 switches
  input  logic [1:0] BTN,       // 2 botones para seleccionar
  output logic CA, CB, CC, CD, CE, CF, CG, DP,
  output logic [7:0] AN
);
  logic [3:0] nibble;           // Valor seleccionado (4 bits)
  logic [6:0] seg;

  // MUX: elegir grupo según botones
  always_comb begin
    case (BTN)
      2'b00: nibble = SW[3:0];
      2'b01: nibble = SW[7:4];
      2'b10: nibble = SW[11:8];
      2'b11: nibble = SW[15:12];
    endcase
  end

  // Decodificador a 7 segmentos
  hex7seg_al u_dec(.x(nibble), .seg_al(seg));

  // Conexiones a la placa
  assign {CA,CB,CC,CD,CE,CF,CG} = seg;
  assign DP = 1'b1;          // punto apagado
  assign AN = 8'b1111_1110;  // usa solo AN0
endmodule

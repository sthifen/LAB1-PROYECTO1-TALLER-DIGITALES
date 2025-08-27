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
  input  logic [3:0] SW,          // <-- añadir
  output logic CA, CB, CC, CD, CE, CF, CG, DP,
  output logic [7:0] AN
);
  logic [6:0] seg;
  hex7seg_al u_dec(.x(SW), .seg_al(seg));

  assign {CA,CB,CC,CD,CE,CF,CG} = seg;
  assign DP = 1'b1;
  assign AN = 8'b1111_1110;
endmodule


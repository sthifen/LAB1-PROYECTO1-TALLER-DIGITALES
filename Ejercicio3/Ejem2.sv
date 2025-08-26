`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/11/2025 11:50:13 AM
// Design Name: 
// Module Name: Ejem2
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

// Ejem2.sv
// hex7seg_al.sv  (AL = Active Low)



module hex7seg_al (
  input  logic [3:0] x,
  output logic [6:0] seg_al
);
  logic [6:0] seg_cc;
  always_comb
    unique case (x)
      4'h0: seg_cc = 7'b1111110;
      4'h1: seg_cc = 7'b0110000;
      4'h2: seg_cc = 7'b1101101;
      4'h3: seg_cc = 7'b1111001;
      4'h4: seg_cc = 7'b0110011;
      4'h5: seg_cc = 7'b1011011;
      4'h6: seg_cc = 7'b1011111;
      4'h7: seg_cc = 7'b1110000;
      4'h8: seg_cc = 7'b1111111;
      4'h9: seg_cc = 7'b1111011;
      4'hA: seg_cc = 7'b1110111; // A
      4'hB: seg_cc = 7'b0011111; // b
      4'hC: seg_cc = 7'b1001110; // C
      4'hD: seg_cc = 7'b0111101; // d
      4'hE: seg_cc = 7'b1001111; // E
      4'hF: seg_cc = 7'b1000111; // F
      default: seg_cc = 7'b0000000;
    endcase
  assign seg_al = ~seg_cc;   // activo-bajo
endmodule

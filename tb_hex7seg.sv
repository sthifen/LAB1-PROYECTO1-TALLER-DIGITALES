`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/22/2025 07:57:43 PM
// Design Name: 
// Module Name: tb_hex7seg
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



module tb_hex7seg;
  // Señales internas para conectar al DUT
  logic [3:0] x;        // entrada al DUT (hexadecimal)
  logic [6:0] seg_al;   // salida del DUT (segmentos activos en bajo)

  // Instancia del módulo a probar (DUT)
  hex7seg_al dut (
    .x(x),
    .seg_al(seg_al)
  );

  // Patrones esperados para cada valor 0..F
  logic [6:0] expected [0:15];

  initial begin
    // Inicializa tabla de patrones esperados (igual a tu case en el DUT)
    expected[4'h0] = ~7'b1111110;
    expected[4'h1] = ~7'b0110000;
    expected[4'h2] = ~7'b1101101;
    expected[4'h3] = ~7'b1111001;
    expected[4'h4] = ~7'b0110011;
    expected[4'h5] = ~7'b1011011;
    expected[4'h6] = ~7'b1011111;
    expected[4'h7] = ~7'b1110000;
    expected[4'h8] = ~7'b1111111;
    expected[4'h9] = ~7'b1111011;
    expected[4'hA] = ~7'b1110111;
    expected[4'hB] = ~7'b0011111;
    expected[4'hC] = ~7'b1001110;
    expected[4'hD] = ~7'b0111101;
    expected[4'hE] = ~7'b1001111;
    expected[4'hF] = ~7'b1000111;

    $display("=== INICIO SIMULACIÓN ===");

    // Probar todas las entradas
for (int i = 0; i < 16; i++) begin
      x = i;
      #10; // espera 10ns para que DUT procese
      if (seg_al !== expected[i])
        $display("ERROR: x=%h esperado=%b obtenido=%b", i, expected[i], seg_al);
      else
        $display("OK: x=%h salida=%b", i, seg_al);
    end

    $display("=== FIN SIMULACIÓN ===");
    $stop; // detener simulación
  end
endmodule

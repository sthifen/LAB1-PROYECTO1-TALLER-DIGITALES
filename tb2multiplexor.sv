`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2025 12:24:44 PM
// Design Name: 
// Module Name: tb2multiplexor
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

module tb2multiplexor;
  // ENTRADAS AL DUT
  logic [15:0] SW;
  logic [1:0]  BTN;       // <-- 2 bits

  // SALIDAS DEL DUT
  logic CA, CB, CC, CD, CE, CF, CG, DP;
  logic [7:0] AN;

  // DUT
  top dut (
    .SW (SW),
    .BTN(BTN),
    .CA (CA), .CB (CB), .CC (CC), .CD (CD), .CE (CE), .CF (CF), .CG (CG),
    .DP (DP),
    .AN (AN)
  );

  // Referencia: calcula patrón activo-bajo esperado
  function automatic logic [6:0] hex7seg_al(input logic [3:0] x);
    logic [6:0] seg_cc;
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
      4'hA: seg_cc = 7'b1110111;
      4'hB: seg_cc = 7'b0011111;
      4'hC: seg_cc = 7'b1001110;
      4'hD: seg_cc = 7'b0111101;
      4'hE: seg_cc = 7'b1001111;
      4'hF: seg_cc = 7'b1000111;
      default: seg_cc = 7'b0000000;
    endcase
    return ~seg_cc; // activo-bajo
  endfunction

  function automatic logic [6:0] seg_bus();
    return {CA,CB,CC,CD,CE,CF,CG};
  endfunction

  // Chequeo por botón y valor
  task automatic check_display(input logic [1:0] btn, input logic [3:0] val);
    logic [6:0] exp;
    BTN = btn;
    case (btn)
      2'b00: SW = {12'b0, val};        // SW[3:0]
      2'b01: SW = { 8'b0, val, 4'b0};  // SW[7:4]
      2'b10: SW = { 4'b0, val, 8'b0};  // SW[11:8]
      2'b11: SW = {      val, 12'b0};  // SW[15:12]
    endcase
    #1; // pequeño delay combinacional

    exp = hex7seg_al(val);

    assert (seg_bus() === exp)
      else $error("SEG MISMATCH: BTN=%b val=%h got=%b exp=%b",
                  btn, val, seg_bus(), exp);

    assert (AN === 8'b1111_1110)
      else $error("AN incorrecto: got %b (esperado 11111110)", AN);

    assert (DP === 1'b1)
      else $error("DP incorrecto: got %b (esperado 1)", DP);

    $display("OK  BTN=%b  val=%h  seg=%b  AN=%b  DP=%b",
             btn, val, seg_bus(), AN, DP);
  endtask

  task automatic run_tests();
    for (int b = 0; b < 4; b++)
      for (int v = 0; v < 16; v++)
        check_display(b[1:0], v[3:0]);
  endtask

  // ÚNICO initial
  initial begin
    SW  = '0;
    BTN = 2'b00;
    run_tests();
    $display("All tests completed");
    $finish;
  end
endmodule
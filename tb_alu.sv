`timescale 1ns/1ps

module tb_alu;
  // parametros
  localparam int N = 8;
 
  localparam bit TB_AH_IS_ARITH_RIGHT = 1;
  localparam bit TB_SIGNED_COMPARE    = 0;

  // Senales al DUT 
  logic [N-1:0] A, B, Y;
  logic  [3:0]  op;  // ALUControl
  logic         fin; //ALUFlagIn
  logic  [1:0]  flags; // C y Z
  // Instancia del Out/Dut
  alu #(
    .N(N),
    .AH_IS_ARITH_RIGHT(TB_AH_IS_ARITH_RIGHT),
    .SIGNED_COMPARE(TB_SIGNED_COMPARE)
  ) DUT (
    .A(A), .B(B), .ALUControl(op), .ALUFlagIn(fin), .Y(Y), .ALUFlags(flags)
  );

  // Replica para poder comparar
  function automatic [N:0] shl_fill_model(input logic [N-1:0] a, input int unsigned sh, input logic fill);
    logic [N-1:0] r; logic c;
    r=a; c=1'b0;
    for (int i=0;i<sh;i++) begin
      c = r[N-1];
      r = {r[N-2:0], fill};
    end
    return {c,r};
  endfunction

  function automatic [N:0] shr_fill_model(input logic [N-1:0] a, input int unsigned sh, input logic fill);
    logic [N-1:0] r; logic c;
    r=a; c=1'b0;
    for (int i=0;i<sh;i++) begin
      c = r[0];
      r = {fill, r[N-1:1]};
    end
    return {c,r};
  endfunction

  function automatic [N:0] sra_signed_model(input logic [N-1:0] a, input int unsigned sh);
    logic [N-1:0] r; logic c;
    r=a; c=1'b0;
    for (int i=0;i<sh;i++) begin
      c = r[0];
      r = {r[N-1], r[N-1:1]};
    end
    return {c,r};
  endfunction

  typedef struct packed {logic [N-1:0] y; logic c; logic z;} res_t;

  function automatic res_t golden (input logic [N-1:0] Ai, Bi, input logic [3:0] opi, input logic fini);
    res_t g; logic [N:0] ext; logic [N-1:0] sel; int unsigned sh;
    sel = (fini) ? Bi : Ai;
    sh  = (N==1) ? 0 : (Bi % N);
    g.c = 1'b0; g.y = '0;

    unique case (opi)
      4'h0: g.y = Ai & Bi;
      4'h1: g.y = Ai | Bi;
      4'h2: g.y = ~sel;
      4'h3: begin ext = {1'b0,Ai}+{1'b0,Bi}+fini; g.y=ext[N-1:0]; g.c=ext[N]; end
      4'h4: begin ext = {1'b0,Ai}+{1'b0,~Bi}+fini; g.y=ext[N-1:0]; g.c=ext[N]; end
      4'h5: begin ext = {1'b0,sel}+1;            g.y=ext[N-1:0]; g.c=ext[N]; end
      4'h6: begin ext = {1'b0,sel}+{{N{1'b1}},1'b1}; g.y=ext[N-1:0]; g.c=ext[N]; end
      4'h7: g.y = Ai ^ Bi;
      4'h8: begin {g.c,g.y} = shl_fill_model(Ai, sh, fini); end
      4'h9: begin {g.c,g.y} = shr_fill_model(Ai, sh, fini); end
      4'hA: begin
        if (TB_AH_IS_ARITH_RIGHT) {g.c,g.y} = sra_signed_model(Ai, sh);
        else                      {g.c,g.y} = shl_fill_model(Ai, sh, fini);
      end
      4'hB: g.y = (TB_SIGNED_COMPARE) ? 
                   (($signed(Ai) >= $signed(Bi)) ? Ai : Bi) :
                   ((Ai >= Bi) ? Ai : Bi);
      4'hC: g.y = (TB_SIGNED_COMPARE) ? 
                   (($signed(Ai) <= $signed(Bi)) ? Ai : Bi) :
                   ((Ai <= Bi) ? Ai : Bi);
      default: begin g.y='0; g.c=1'b0; end
    endcase
    g.z = (g.y=='0);
    return g;
  endfunction

  // Checkeos y aciertos
  int pass=0, fail=0;

  task automatic check(string name);
    res_t exp;
    #1; // deja propagar
    exp = golden(A,B,op,fin);

    // esperado
    assert (Y == exp.y)
      else begin
        $error("FAIL %s: Y esperado=%0h, obtenido=%0h  (A=%0h B=%0h op=%0h fin=%0b)",
               name, exp.y, Y, A, B, op, fin);
        fail++;
      end

    assert (flags[1] == exp.c)
      else begin
        $error("FAIL %s: C esperado=%0b, obtenido=%0b", name, exp.c, flags[1]);
        fail++;
      end

    assert (flags[0] == exp.z)
      else begin
        $error("FAIL %s: Z esperado=%0b, obtenido=%0b", name, exp.z, flags[0]);
        fail++;
      end

    if ((Y==exp.y) && (flags[1]==exp.c) && (flags[0]==exp.z)) begin
      pass++;
      $display("OK  %s: A=%0h B=%0h op=%0h fin=%0b -> Y=%0h C=%0b Z=%0b",
               name, A, B, op, fin, Y, flags[1], flags[0]);
    end
  endtask

  // Generador de estimulos y reporte
  initial begin
    A=8'h3C; B=8'h0F; fin=0;

    op=4'h0; check("AND");
    op=4'h1; check("OR");

    op=4'h2; fin=0; check("NOT A");
    op=4'h2; fin=1; check("NOT B");

    op=4'h3; fin=0; check("ADD Cin=0");
    op=4'h3; fin=1; check("ADD Cin=1");

    op=4'h4; fin=1; check("SUB (A-B)");

    op=4'h5; fin=0; check("INC A");
    op=4'h5; fin=1; check("INC B");

    op=4'h6; fin=0; check("DEC A");
    op=4'h6; fin=1; check("DEC B");

    op=4'h7; check("XOR");

    A=8'b1101_0110; B=8'b0000_0011; fin=1; op=4'h8; check("SHL fill=1, sh=3");
    A=8'b1101_0110; B=8'b0000_0011; fin=0; op=4'h9; check("SHR fill=0, sh=2");

    A=8'b1001_0001; B=8'd3; op=4'hA; check("Ah");

    A=8'h80; B=8'h7F; op=4'hB; check("MAX");
    op=4'hC; check("MIN");

    A='0; B='0; op=4'h0; check("ZERO");
    
    // Peor caso ripple ADD (FF + 00 + Cin=1)
    A = 8'hFF; B = 8'h00; fin = 1; op = 4'h3; check("ADD worst-case ripple");
    
    // Peor caso ripple SUB (A - B) con patrón alternante
    A = 8'h55; B = ~A;    fin = 1; op = 4'h4; check("SUB worst-case ripple");
    
    // Overflows/inc/dec
    A = 8'hFF; op = 4'h5; fin = 0;        check("INC A all-ones"); // -> Y=00, C=1
    A = 8'h00; op = 4'h6; fin = 0;        check("DEC A zero");     // -> Y=FF
    
    // Shifts bordes
    A = 8'h80; B = 8'd1;  fin = 0; op = 4'h8; check("SHL expulsa MSB=1");
    A = 8'h03; B = 8'd1;  fin = 0; op = 4'h9; check("SHR expulsa LSB=1");
    
    // Shifts extremos de conteo
    A = 8'h81; B = 8'd0;  fin = 1; op = 4'h8; check("SHL B=0 (no cambia)");
    A = 8'h81; B = 8'd7;  fin = 1; op = 4'h8; check("SHL B=7");
    A = 8'h81; B = 8'd7;  fin = 0; op = 4'h9; check("SHR B=7");
    
    // Max/Min (unsigned)
    A = 8'h80; B = 8'h7F; op = 4'hB; check("MAX unsigned");
    op = 4'hC;            check("MIN unsigned");
    

    // Reporte final
    if (fail==0) begin
      $display("\n==============================");
      $display("  TODAS LAS PRUEBAS PASARON  ");
      $display("  Casos verificados: %0d", pass);
      $display("==============================\n");
    end else begin
      $fatal(1, "\nERROR: %0d fallos, %0d OK\n", fail, pass);
    end
    $finish;
  end
endmodule

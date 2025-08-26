// --------------------------------------------
// ALU parametrizable n bits
// Grupo 20
// --------------------------------------------
`timescale 1ns/1ps
module alu #(
  parameter int N = 8,
  // Ah: 1 = shift aritmético a la DERECHA
  //     0 = shift "aritmético" a la IZQUIERDA (es igual a lógico izq).
  parameter bit AH_IS_ARITH_RIGHT = 1,
  // Comparación para max/min: 0=unsigned, 1=signed (C2)
  parameter bit SIGNED_COMPARE = 0
  
// Puertos (I/O)
)(
  input  logic [N-1:0] A,
  input  logic [N-1:0] B,
  input  logic  [3:0]  ALUControl,
  input  logic         ALUFlagIn,   // carry-in, bit de entrada en shifts o selector A/B en ~,inc,dec
  output logic [N-1:0] Y,
  output logic  [1:0]  ALUFlags     // {C, Z}
);

  // funciones auxiliares de corrimiento con "llenado" y reporte de bit expulsado 
  // Izquierda
  function automatic [N:0] shl_fill(input logic [N-1:0] a, input int unsigned sh, input logic fill);
    logic [N-1:0] r; logic c;
    r = a; c = 1'b0;
    for (int i = 0; i < sh; i++) begin
      c = r[N-1];               // MSB que sale
      r = {r[N-2:0], fill};     // entra "fill" por LSB
    end
    return {c, r};
  endfunction
  
  // Derecha
  function automatic [N:0] shr_fill(input logic [N-1:0] a,
                                    input int unsigned sh,
                                    input logic fill);
    logic [N-1:0] r; logic c;
    r = a; c = 1'b0;
    for (int i = 0; i < sh; i++) begin
      c = r[0];                 // LSB que sale
      r = {fill, r[N-1:1]};     // entra "fill" por MSB
    end
    return {c, r};
  endfunction

  function automatic [N:0] sra_signed(input logic [N-1:0] a, input int unsigned sh);
    // shift aritmético a la derecha: replica signo
    logic [N-1:0] r; logic c;
    r = a; c = 1'b0;
    for (int i = 0; i < sh; i++) begin
      c = r[0];
      r = {r[N-1], r[N-1:1]};   // relleno con MSB actual (signo)
    end
    return {c, r};
  endfunction

  // Señales internas
  logic [N:0] ext;     // para resultados con carry (n + 1 bits)
  logic       C;
  logic       Z;
  logic [N-1:0] sel_op; // para ~, inc, dec, segun ALUFlagIn
  int unsigned sh;      // Cantidad de corrimientos 

  always_comb begin
    Y = '0; C = 1'b0;
    sel_op = (ALUFlagIn) ? B : A; // Selector de operacion (not, inc, dec)
    sh = (N == 1) ? 0 : (B % N);  // desplazar 0..N-1

    unique case (ALUControl) 
      4'h0: begin // AND
        Y = A & B;
      end
      4'h1: begin // OR
        Y = A | B;
      end
      4'h2: begin // NOT sobre A o B (según ALUFlagIn)
        Y = ~sel_op;
      end
      4'h3: begin // SUMA: A + B + Cin
        ext = {1'b0, A} + {1'b0, B} + ALUFlagIn;
        Y   = ext[N-1:0];
        C   = ext[N];
      end
      4'h4: begin // RESTA (C2) con cadena: A + (~B) + Cin
        // Para "A - B" ALUFlagIn=1.
        ext = {1'b0, A} + {1'b0, ~B} + ALUFlagIn;
        Y   = ext[N-1:0];
        C   = ext[N]; // carry de la suma equivalente
      end
      4'h5: begin // INC sobre A o B
        ext = {1'b0, sel_op} + 1;
        Y   = ext[N-1:0];
        C   = ext[N];
      end
      4'h6: begin // DEC sobre A o B
        ext = {1'b0, sel_op} + { {N{1'b1}}, 1'b1 }; // = sel_op - 1
        Y   = ext[N-1:0];
        C   = ext[N]; 
      end
      4'h7: begin // XOR
        Y = A ^ B;
      end
      4'h8: begin // Shift left con "fill" = ALUFlagIn
        {C, Y} = shl_fill(A, sh, ALUFlagIn);
      end
      4'h9: begin // Shift right lógico con "fill" = ALUFlagIn
        {C, Y} = shr_fill(A, sh, ALUFlagIn);
      end
      4'hA: begin
        if (AH_IS_ARITH_RIGHT) begin
          {C, Y} = sra_signed(A, sh);    // aritmético a la DERECHA
        end else begin
          {C, Y} = shl_fill(A, sh, ALUFlagIn); // "aritmético" izq = igual al lógico izq
        end
      end
      4'hB: begin // MAX
        if (SIGNED_COMPARE)
          Y = ($signed(A) >= $signed(B)) ? A : B;
        else
          Y = (A >= B) ? A : B;
      end
      4'hC: begin // MIN
        if (SIGNED_COMPARE)
          Y = ($signed(A) <= $signed(B)) ? A : B;
        else
          Y = (A <= B) ? A : B;
      end
      default: begin
        Y = '0; C = 1'b0; // en caso de codigo de operacion no definido
      end
    endcase

    Z = (Y == '0); // Comprobamos que Y de n bits sea = 0 y hace z=1
  end

  assign ALUFlags = {C, Z};

endmodule

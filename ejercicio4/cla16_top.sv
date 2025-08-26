// cla16_top.sv - CLA de 16 bits usando 4 cla4_block
module cla16_top(
  input  logic [15:0] a, b,
  input  logic        cin,
  output logic [15:0] sum,
  output logic        cout
);
  // P/G por bloque y carries de bloque
  logic [3:0] P, G;
  logic [4:0] C;
  assign C[0] = cin;

  // Lookahead entre bloques (hacia los bits 4, 8, 12 y 16)
  assign C[1] = G[0] | (P[0] & C[0]);                                      // c4
  assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);               // c8
  assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0])                // c12
                      | (P[2] & P[1] & P[0] & C[0]);
  assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1])                // c16
                      | (P[3] & P[2] & P[1] & G[0])
                      | (P[3] & P[2] & P[1] & P[0] & C[0]);

  // Cuatro bloques de 4 bits
  cla4_block U0 (.a(a[3:0]),    .b(b[3:0]),    .cin(C[0]),
                 .sum(sum[3:0]),    .cout(/*unused*/),
                 .P(P[0]), .G(G[0]));
  cla4_block U1 (.a(a[7:4]),    .b(b[7:4]),    .cin(C[1]),
                 .sum(sum[7:4]),    .cout(/*unused*/),
                 .P(P[1]), .G(G[1]));
  cla4_block U2 (.a(a[11:8]),   .b(b[11:8]),   .cin(C[2]),
                 .sum(sum[11:8]),   .cout(/*unused*/),
                 .P(P[2]), .G(G[2]));
  cla4_block U3 (.a(a[15:12]),  .b(b[15:12]),  .cin(C[3]),
                 .sum(sum[15:12]), .cout(/*unused*/),
                 .P(P[3]), .G(G[3]));

  // Carry-out global del grupo
  assign cout = C[4];
endmodule

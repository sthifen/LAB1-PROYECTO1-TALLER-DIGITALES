// cla4_block.sv  -- Carry Lookahead Adder de 4 bits (con P,G de bloque)
module cla4_block(
  input  logic [3:0] a, b,
  input  logic       cin,
  output logic [3:0] sum,
  output logic       cout,
  output logic       P,   // propagate grupal
  output logic       G    // generate  grupal
);
  logic [3:0] p, g;
  logic c1, c2, c3, c4;

  assign p  = a ^ b;
  assign g  = a & b;

  // carries por lookahead
  assign c1 = g[0] | (p[0] & cin);
  assign c2 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
  assign c3 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
  assign c4 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0])
                        | (p[3] & p[2] & p[1] & p[0] & cin);

  assign sum  = p ^ {c3, c2, c1, cin};
  assign cout = c4;

  // P,G de bloque
  assign P = &p; // p3&p2&p1&p0
  assign G = g[3] | (p[3]&g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0]);
endmodule

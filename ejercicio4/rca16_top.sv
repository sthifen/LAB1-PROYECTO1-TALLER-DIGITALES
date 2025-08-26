// rca16_top.sv  -- Wrapper de 16 bits para tu rca_param existente
module rca16_top(
  input  logic [15:0] a, b,
  input  logic        cin,
  output logic [15:0] sum,
  output logic        cout
);
  rca_param #(.N(16)) U (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));
endmodule

// top_rca64_timed.sv - wrapper con registros de lanzamiento/captura y reloj de 10 MHz
module top_rca64_timed(
  input  logic        clk,        // reloj de análisis (10 MHz)
  input  logic [63:0] a_in, b_in,
  input  logic        cin_in,
  output logic [63:0] sum_out,
  output logic        cout_out
);
  // Registros de entrada (lanzan datos)
  logic [63:0] a_q, b_q;
  logic        cin_q;
  always_ff @(posedge clk) begin
    a_q  <= a_in;
    b_q  <= b_in;
    cin_q<= cin_in;
  end

  // Lógica combinacional: el RCA de 64 bits
  logic [63:0] sum_c;
  logic        cout_c;
  rca_param #(.N(64)) DUT (
    .a   (a_q),
    .b   (b_q),
    .cin (cin_q),
    .sum (sum_c),
    .cout(cout_c)
  );

  // Registros de salida (capturan resultados)
  always_ff @(posedge clk) begin
    sum_out  <= sum_c;
    cout_out <= cout_c;
  end
endmodule

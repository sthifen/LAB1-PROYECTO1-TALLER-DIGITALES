// top_rca_nexys4.sv -- usa switches/LEDs de la Nexys 4
module top_rca_nexys4 #(
  parameter int N = 8
)(
  input  logic [15:0] sw,   // switches
  input  logic        btnC, // botón central = cin
  output logic [15:0] led   // LEDs
);
  // Requiere 2N <= 16 (8 bits por defecto)
  initial if (2*N > 16) $error("N debe ser <= 8 para usar switches/LEDs de la Nexys 4");

  logic [N-1:0] a = sw[N-1:0];       // A en SW[N-1:0]
  logic [N-1:0] b = sw[2*N-1:N];     // B en SW[2N-1:N] (para N=8 => SW[15:8])
  logic [N-1:0] sum; 
  logic         cout;

  rca_param #(.N(N)) U (.a(a), .b(b), .cin(btnC), .sum(sum), .cout(cout));

  // Mostrar: SUM en LED[7:0] y COUT en LED[15]
  assign led[7:0]  = sum;
  assign led[14:8] = '0;
  assign led[15]   = cout;
endmodule

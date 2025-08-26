`timescale 1ns/1ps
module tb_rca64_100Msps_vs_10MHz;

  // Clocks
  logic clk10   = 0;  // 10 MHz -> T=100 ns
  logic clk100  = 0;  // 100 MHz -> T=10 ns

  always #50 clk10  = ~clk10;   // 100 ns / 2
  always #5  clk100 = ~clk100;  // 10  ns / 2

  localparam int N = 64;

  logic [N-1:0] a, b;
  logic         cin;
  logic [N-1:0] sum;
  logic         cout;

  // --- VCD dump (opción B) ---
`ifdef DUMP_VCD
  initial begin
    // El VCD quedará en .../RCA_param.sim/sim_1/behav/xsim/
    $dumpfile("tb_rca64_100Msps_vs_10MHz.vcd");

    // Señales clave (archivo ligero)
    $dumpvars(0, clk10, clk100, a, b, cin, sum, cout);

    // (Opcional) activar el volcado más tarde:
    // $dumpoff; #200ns; $dumpon;
  end
`endif

  // === DUT: usa tu adder combinacional ===
  rca_param #(.N(N)) dut ( .a(a), .b(b), .cin(cin), .sum(sum), .cout(cout) );

  // === Estímulos a 100 Msps ===
  always_ff @(posedge clk100) begin
    a   <= {$urandom(), $urandom()}; // 64-bit
    b   <= {$urandom(), $urandom()}; // 64-bit
    cin <= $urandom_range(0,1);
  end

  // Checker: muestrea a 10 MHz (cada 100 ns)
  always_ff @(posedge clk10) begin
    logic [N:0] exp;
    exp = a + b + cin; // cálculo inmediato (blocking)
    assert({cout, sum} == exp)
      else $error("Mismatch @%0t: a=%h b=%h cin=%0d -> sum=%h cout=%0d (exp=%h)",
                  $time, a, b, cin, sum, cout, exp);
  end

  initial begin
    repeat (200) @(posedge clk10);  // ~20 µs de simulación
    $finish;
  end
endmodule

`timescale 1ns/1ps
module tb_rca_param_exhaustivo;
  parameter N = 8;

  reg  [N-1:0] a, b;
  reg          cin;
  wire [N-1:0] sum;
  wire         cout;

  rca_param #(.N(N)) dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

  integer aa, bb, cc;
  integer errors, total;
  reg [N:0] exp;  // N+1 bits (incluye overflow)

  initial begin
    errors = 0; total = 0;
    $display("=== TB EXHAUSTIVO N=%0d ===", N);

    for (aa = 0; aa < (1<<N); aa = aa + 1) begin
      for (bb = 0; bb < (1<<N); bb = bb + 1) begin
        for (cc = 0; cc < 2; cc = cc + 1) begin
          a = aa[N-1:0];
          b = bb[N-1:0];
          cin = cc[0];
          #1;
          exp = aa + bb + cc;   // resultado N+1 bits
          if ({cout, sum} !== exp) begin
            $display("ERROR: a=%0d b=%0d cin=%0b -> sum=%0h cout=%0b (esp=%0h)",
                     aa, bb, cc, sum, cout, exp);
            errors = errors + 1;
          end
          total = total + 1;
        end
      end
    end

    if (errors == 0)
      $display("PASS: %0d vectores sin errores.", total);
    else
      $display("FAIL: %0d errores de %0d vectores.", errors, total);

    $finish;
  end
endmodule

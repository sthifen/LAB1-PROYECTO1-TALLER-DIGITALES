`timescale 1ns/1ps
module rca_param #(
    parameter int N = 64
)(
    input  logic [N-1:0] a, b,
    input  logic         cin,
    output logic [N-1:0] sum,
    output logic         cout
);
    logic [N:0] c;
    assign c[0] = cin;

    for (genvar i = 0; i < N; i++) begin : FA_CHAIN
        full_adder_1bit fa_i (.a(a[i]), .b(b[i]), .cin(c[i]), .sum(sum[i]), .cout(c[i+1]));
    end

    assign cout = c[N];
endmodule

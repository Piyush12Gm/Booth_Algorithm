`timescale 1ns / 1ps

//Shift Register
module shiftreg (data_out,data_in,s_in, clk, ld, clr, sft);
input s_in, clk, ld, clr, sft;
input [15:0] data_in;
output reg [15:0] data_out;

always @(posedge clk)
begin
    if (clr) data_out <= 0;
    else if (ld)
        data_out <= data_in;
    else if (sft)
        data_out <= {s_in,data_out [15:1]};
end

endmodule

//Parallel input parallel output
module PIPO (data_out, data_in, clk, load);
input [15:0] data_in;
input load, clk;
output reg [15:0] data_out;

always @(posedge clk)
    if (load) data_out <= data_in;

endmodule

//D Flip Flop
module dff (d, q, clk, clr);
input d, clk, clr;
output reg q;

always @(posedge clk)
    if (clr) q <= 0;
    else q <= d;

endmodule


//Arithmetic And Logic Unit
module ALU (out, inl, in2, addsub);
input [15:0] inl, in2;
input addsub;
output reg [15:0] out;

always @(*)
    begin
        if (addsub == 0) out = inl - in2;
        else out = inl + in2;
    end

endmodule


//Counter
module counter (
    output reg [4:0] data_out,
    input decr,
    input ldent,
    input clk
);

always @(posedge clk)
begin
    if (ldent)
        data_out <= 5'b10000;
    else if (decr)
        data_out <= data_out - 1;
end

endmodule


// Booth Algorithm 
module BOOTH (
    input ldA, ldQ, ldM, clrA, clrQ, clrff, sftA, sftQ, addsub, decr, ldent, clk,
    input [15:0] data_in,
    output qml, eqz,
    output [15:0] A_out, Q_out,
    output qm1_out
);

    wire [15:0] A, M, Q, Z;
    wire [4:0] count;
    wire qm1;

    // Output signals
    assign eqz = ~|count;  // eqz = 1 when count == 0
    assign qml = qm1;
    assign A_out = A;
    assign Q_out = Q;
    assign qm1_out = qm1;

    // Shift register for A (Accumulator)
    shiftreg AR (A, Z, A[15], clk, ldA, clrA, sftA);

    // Shift register for Q (Multiplier)
    shiftreg QR (Q, data_in, A[0], clk, ldQ, clrQ, sftQ);

    // D flip-flop for Q-1
    dff QM1 (Q[0], qm1, clk, clrff);

    // Parallel-in parallel-out register for M (Multiplicand)
    PIPO MR (data_in, M, clk, ldM);

    // ALU for addition/subtraction
    ALU AS (Z, A, M, addsub);

    // 5-bit counter
    counter CN (count, decr, ldent, clk);

endmodule






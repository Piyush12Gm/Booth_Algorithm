`timescale 1ns / 1ps

module controller (
    input clk, q0, qml, start,
    output reg ldA, clrA, sftA,
    output reg ldQ, clrQ, sftQ,
    output reg ldM, clrff,
    output reg addsub, decr, ldent, done
);

reg [2:0] state;
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010,
          S3 = 3'b011, S4 = 3'b100, S5 = 3'b101, S6 = 3'b110;

reg qm1, eqz;  // You may need to pass these as inputs instead if they're from datapath

always @(posedge clk) begin
    case (state)
        S0: if (start) state <= S1;
        S1: state <= S2;
        S2: begin
            if ({q0, qml} == 2'b01) state <= S3;
            else if ({q0, qml} == 2'b10) state <= S4;
            else state <= S5;
        end
        S3: state <= S5;
        S4: state <= S5;
        S5: begin
            if (!eqz && ({q0, qml} == 2'b01)) state <= S3;
            else if (!eqz && ({q0, qml} == 2'b10)) state <= S4;
            else if (eqz) state <= S6;
        end
        S6: state <= S6;
        default: state <= S0;
    endcase
end

always @(*) begin
    // Default all outputs
    ldA = 0; clrA = 0; sftA = 0;
    ldQ = 0; clrQ = 0; sftQ = 0;
    ldM = 0; clrff = 0;
    addsub = 0; decr = 0; ldent = 0; done = 0;

    case (state)
        S0: ;  // All outputs already zero
        S1: begin clrA = 1; clrff = 1; ldent = 1; ldM = 1; end
        S2: begin ldQ = 1; end
        S3: begin ldA = 1; addsub = 1; end
        S4: begin ldA = 1; addsub = 0; end
        S5: begin sftA = 1; sftQ = 1; decr = 1; end
        S6: done = 1;
    endcase
end

endmodule


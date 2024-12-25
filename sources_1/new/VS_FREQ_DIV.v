`timescale 1ns / 1ps


module VS_FREQ_DIV #(
    parameter div=100000
)(
    input CLK,
    input RST,
    output reg CE_1KHz
);

reg [$clog2(div)-1:0] CNT;

always@(posedge CLK, posedge RST)
    if (RST) begin
        CNT <= 0;
        CE_1KHz <= 1'b0;
    end
    else if (CNT == div - 1) begin
        CNT <= 0;
        CE_1KHz <= 1'b1;
    end
    else begin
        CNT <= CNT + 1'b1;
        CE_1KHz <= 1'b0;
    end
endmodule

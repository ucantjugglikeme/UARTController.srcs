`timescale 1ns / 1ps


module VS_RX_C(
    input CLK,
    input RST,
    input UART_CE,
    input RXCT_R,
    output RX_CE
    );

reg [3:0] RX_SAMP_CT;

always@(posedge CLK, posedge RST)
    if (RST) RX_SAMP_CT <= 0;
    else if (RXCT_R) RX_SAMP_CT <= 0;
    else if (UART_CE) RX_SAMP_CT <= RX_SAMP_CT + 1'b1;

assign RX_CE = UART_CE & (RX_SAMP_CT == 4'h7);

endmodule

`timescale 1ns / 1ps


module VS_TX_C(
    input CLK,
    input RST,
    input UART_CE,
    input TXCT_R,
    output TX_CE
);

reg [3:0] TX_SAMP_CT;

always@(posedge CLK, posedge RST)
    if (RST) TX_SAMP_CT <= 0;
    else if (TXCT_R) TX_SAMP_CT <= 0;
    else if (UART_CE) TX_SAMP_CT <= TX_SAMP_CT + 1'b1;

assign TX_CE = UART_CE & (TX_SAMP_CT == 4'hf);
endmodule

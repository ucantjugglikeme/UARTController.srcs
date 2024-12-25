`timescale 1ns / 1ps


module VS_UART(
    input CLK,
    input RST,
    
    input RXD,
    output TXD,
    
    output RX_DATA_EN,
    output [9:0]RX_DATA_T,
    
    input TX_RDY_T,
    input [7:0] TX_DATA_R,
    output TX_RDY_R
    );

wire RXD_RG;
wire UART_CE;
wire RXCT_R;
wire RX_CE;
wire TXCT_R;
wire TX_CE;

VS_SYNC SYNC(
    .CLK(CLK),
    .RST(RST),
    .RXD(RXD),
    .RXD_RG(RXD_RG)
);

VS_FREQ_DIV #(.div(868)) FREQ_DIV(  // 100_000_000 / 7200 * 16 = 868
    .CLK(CLK),
    .RST(RST),
    .CE_1KHz(UART_CE)
);

VS_RX_FSM RX_FSM(
    .RXD_RG(RXD_RG),
    .CLK(CLK),
    .RST(RST),
    .RX_DATA_EN(RX_DATA_EN),
    .RX_DATA_T(RX_DATA_T),
    .RXCT_R(RXCT_R),
    .RX_CE(RX_CE)
);
VS_TX_FSM TX_FSM(
    .CLK(CLK),
    .RST(RST),
    .TXD(TXD),
    .UART_CE(UART_CE),
    .TX_CE(TX_CE),
    .TXCT_R(TXCT_R),
    .TX_RDY_T(TX_RDY_T),
    .TX_DATA_R(TX_DATA_R),
    .TX_RDY_R(TX_RDY_R)
);
VS_RX_C RX_C(
    .CLK(CLK),
    .RST(RST),
    .UART_CE(UART_CE),
    .RXCT_R(RXCT_R),
    .RX_CE(RX_CE)
);
VS_TX_C TX_C(
    .CLK(CLK),
    .RST(RST),
    .UART_CE(UART_CE),
    .TX_CE(TX_CE),
    .TXCT_R(TXCT_R)
);
endmodule

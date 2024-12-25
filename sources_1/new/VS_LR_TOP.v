`timescale 1ns / 1ps


module VS_LR_TOP(
    input CLK,
    input SYS_NRST,
    input BTN_0,
    input BTN_1,
    input UART_RXD,
    output UART_TXD
    );

wire RST;
wire CE_1KHz;
wire GEN_FRT_ERR;
wire GEN_PAR_ERR;

wire RX_DATA_EN;
wire [9:0] RX_DATA;

wire [1:0] TX_RDY;
wire [7:0] TX_DATA;

wire [9:0] RX_DATA_ERR;

wire [7:0 ]ASCII_DATA;
wire HEX_FLAG;
wire [3:0] DC_HEX_DATA;

wire [3:0] HEX_DATA;
wire [7:0] DC_ASCII_DATA;

wire [6:0] ADDR;
wire [7:0] MEM_DATA;

VS_RST_SYNC RST_SYNC(
    .CLK(CLK),
    .SYS_NRST(SYS_NRST),
    .RST(RST)
);
VS_FREQ_DIV FREQ_DIV(
    .CLK(CLK),
    .RST(RST),
    .CE_1KHz(CE_1KHz)
);
M_BTN_FILTER_V10 BTN_0_FILTER(
    .CLK(CLK),
    .CE(CE_1KHz),
    .BTN_IN(BTN_0),
    .RST(RST),
    .BTN_OUT(GEN_FRT_ERR)
);
M_BTN_FILTER_V10 BTN_1_FILTER(
    .CLK(CLK),
    .CE(CE_1KHz),
    .BTN_IN(BTN_1),
    .RST(RST),
    .BTN_OUT(GEN_PAR_ERR)
);
VS_UART UART(
    .CLK(CLK),
    .RST(RST),
    .RXD(UART_RXD),
    .TXD(UART_TXD),
    .RX_DATA_EN(RX_DATA_EN),
    .RX_DATA_T(RX_DATA),
    .TX_RDY_T(TX_RDY[1]),
    .TX_DATA_R(TX_DATA),
    .TX_RDY_R(TX_RDY[0])
);
VS_GEN_ERR GEN_ERR(
    .RX_DATA_T(RX_DATA),
    .GEN_FRT_ERR(GEN_FRT_ERR),
    .GEN_PAR_ERR(GEN_PAR_ERR),
    .DATA(RX_DATA_ERR)
);
VS_FSM FSM(
    .CLK(CLK),
    .RST(RST),
    .RX_DATA_EN(RX_DATA_EN),
    .RX_DATA_R(RX_DATA_ERR),
    .TX_RDY_T(TX_RDY[1]),
    .TX_DATA_T(TX_DATA),
    .TX_RDY_R(TX_RDY[0]),
    .ASCII_DATA(ASCII_DATA),
    .HEX_FLAG(HEX_FLAG),
    .DC_HEX_DATA(DC_HEX_DATA),
    .HEX_DATA(HEX_DATA),
    .DC_ASCII_DATA(DC_ASCII_DATA),
    .ADDR(ADDR),
    .DATA(MEM_DATA)
);
VS_DC_ASCII_HEX DC_ASCII_HEX(
    .ASCII(ASCII_DATA),
    .HEX(DC_HEX_DATA),
    .HEX_FLG(HEX_FLAG)
);
VS_DC_HEX_ASCII DC_HEX_ASCII(
    .HEX(HEX_DATA),
    .ASCII(DC_ASCII_DATA)
);
VS_ROM ROM(
    .ADDR(ADDR),
    .DATA(MEM_DATA)
);
endmodule

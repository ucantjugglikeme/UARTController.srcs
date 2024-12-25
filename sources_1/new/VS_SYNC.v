`timescale 1ns / 1ps


module VS_SYNC(
    input CLK,
    input RXD,
    input RST,
    output RXD_RG
    );

VS_RG RG(
    .CLK(CLK),
    .D(RXD),
    .RST(RST),
    .Q(RXD_RG)
);


endmodule

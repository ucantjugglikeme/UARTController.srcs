`timescale 1ns / 1ps


module VS_RG(
    input CLK,
    input D,
    input RST,
    output Q
    );
    
wire QD1;    
wire QD2; 

VS_DTR DTR_0(
    .CLK(CLK),
    .D(D),
    .RST(RST),
    .Q(QD1)
);
VS_DTR DTR_1(
    .CLK(CLK),
    .D(QD1),
    .RST(RST),
    .Q(QD2)
);
VS_DTR DTR_2(
    .CLK(CLK),
    .D(QD2),
    .RST(RST),
    .Q(Q)
);

endmodule

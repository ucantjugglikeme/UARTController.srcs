`timescale 1ns / 1ps


module VS_DTR(
    input CLK,
    input D,
    input RST,
    output reg Q
    );
    
always@(posedge CLK, posedge RST)
    if (RST)
        Q<=1'b1;
    else
        Q<= D;
endmodule

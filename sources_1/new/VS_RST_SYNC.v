`timescale 1ns / 1ps


module VS_RST_SYNC(
    input CLK,
    input SYS_NRST,
    output RST
    );

reg [1:0] SYNC;

always@(posedge CLK, negedge SYS_NRST)
    if(~SYS_NRST) SYNC <= 2'b11;
    else SYNC <= {SYNC[0], 1'b0};
     
assign RST = SYNC[1];

endmodule

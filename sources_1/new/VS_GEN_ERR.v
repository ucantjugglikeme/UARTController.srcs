`timescale 1ns / 1ps


module VS_GEN_ERR(
    input [9:0] RX_DATA_T,
    input GEN_FRT_ERR,
    input GEN_PAR_ERR,
    output [9:0] DATA
    );
   
assign DATA[0] = RX_DATA_T[0];
assign DATA[1] = RX_DATA_T[1];
assign DATA[2] = RX_DATA_T[2];
assign DATA[3] = RX_DATA_T[3];
assign DATA[4] = RX_DATA_T[4];
assign DATA[5] = RX_DATA_T[5];
assign DATA[6] = RX_DATA_T[6];
assign DATA[7] = RX_DATA_T[7];
assign DATA[8] = RX_DATA_T[8]^GEN_PAR_ERR;
assign DATA[9] = RX_DATA_T[9]^GEN_FRT_ERR;
    
endmodule

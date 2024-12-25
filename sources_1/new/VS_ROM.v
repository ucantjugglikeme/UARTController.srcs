`timescale 1ns / 1ps


module VS_ROM(
    input [6:0] ADDR,
    output [7:0] DATA
    );

reg [7:0] ROM0 [0:127];

initial begin
    $readmemh("ROM.mem",ROM0);
end

assign DATA = ROM0[ADDR];

endmodule

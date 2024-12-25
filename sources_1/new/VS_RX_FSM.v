`timescale 1ns / 1ps


module VS_RX_FSM(
    input RXD_RG,
    input CLK,
    input RST,
    output reg RX_DATA_EN,
    output reg [9:0] RX_DATA_T,
    output reg RXCT_R,
    input RX_CE
);

reg [2:0] RX_STATE;
reg [2:0] RX_DATA_CT;

localparam
    IDLE = 3'd0,
    RSTRB = 3'd1,
    RDT = 3'd2,
    RPARB = 3'd3,
    RSTB1 = 3'd4,
    RSTB2 = 3'd5,
    WEND = 3'd6;
    
always@(posedge CLK, posedge RST)
    if (RST) begin
        RX_DATA_EN <= 1'b0;
        RX_DATA_T <= 10'h000;
        RX_DATA_CT <= {3{1'b0}};
        RXCT_R <= 1'b1;
        RX_STATE <= IDLE;
    end
    else case (RX_STATE)
        IDLE: begin
            if (~RXD_RG) begin
                RX_DATA_EN <= 1'b0;
                RX_DATA_T[9] <= 1'b0;
                RXCT_R <= 1'b0;
                RX_STATE <= RSTRB;
            end
            else RX_DATA_EN <= 1'b0;
        end
        
        RSTRB: begin
            if (RX_CE) begin
                if(RXD_RG) begin
                    RXCT_R <= 1'b1;
                    RX_STATE <= IDLE;
                end
                else RX_STATE <= RDT;
            end
        end
        
        RDT: begin
            if (RX_CE) begin
                RX_DATA_T[7:0] <= {RXD_RG, RX_DATA_T[7:1]};
                RX_DATA_CT <= RX_DATA_CT + 1'b1;
                
                if (RX_DATA_CT == 4'h7) RX_STATE <= RPARB;
            end
        end
        
        RPARB: begin
            if (RX_CE) begin
                RX_DATA_T[8] <= RXD_RG ^ (^RX_DATA_T[7:0]);
                RX_STATE <= RSTB1;
            end
        end
        
        RSTB1: begin
            if (RX_CE) begin
                RX_DATA_T[9] <= ~RXD_RG;
                RX_STATE <= RSTB2;
            end
        end
        
        RSTB2: begin
             if (RX_CE) begin
                if (RXD_RG) begin
                    RX_DATA_EN <= 1'b1;
                    RXCT_R <= 1'b1;
                    RX_STATE <= IDLE;
                end
                else begin
                    RX_DATA_T[9] = 1'b1;
                    RX_STATE <= WEND;
                end
            end
        end
        
        WEND: begin
            if (RXD_RG) begin
                RX_DATA_EN <= 1'b1;
                RXCT_R <= 1'b1;
                RX_STATE <= IDLE;
            end
        end
        default: RX_STATE <= IDLE;
    endcase
endmodule

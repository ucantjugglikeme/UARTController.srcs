`timescale 1ns / 1ps


module VS_TX_FSM(
    input CLK,
    input RST,
    input UART_CE,
    input TX_CE,
    output reg TXCT_R,
    input TX_RDY_T,
    input [7:0] TX_DATA_R,
    output reg TX_RDY_R,
    output reg TXD
);

reg [2:0] TX_STATE;
reg [7:0] TX_DATA;
reg TX_PAR_BIT_RG;
reg [2:0] TX_DATA_CT;

localparam 
    IDLE = 3'd0,
    WCE = 3'd1,
    TSTRB = 3'd2,
    TDT = 3'd3,
    TPARB = 3'd4,
    TSTB1 = 3'd5,
    TSTB2 = 3'd6;
    
always@(posedge CLK, posedge RST)
    if (RST) begin
        TX_DATA <= 8'h00;
        TX_PAR_BIT_RG <= 1'b0;
        TX_RDY_R <= 1'b1;
        TX_DATA_CT <= 3'b000;
        TXD <= 1'b1;
        TXCT_R <= 1'b1;
        TX_STATE <= IDLE;
    end
    else case(TX_STATE)
        IDLE: begin
            if(TX_RDY_T) begin
                TX_DATA <= TX_DATA_R;
                TX_PAR_BIT_RG <= (^TX_DATA_R[7:0]);
                TX_RDY_R <= 1'b0;
                
                if(UART_CE) begin
                    TXD <= 1'b0;
                    TXCT_R <= 1'b0;
                    TX_STATE <= TSTRB;
                end
                else TX_STATE <= WCE;
            end
        end
        
        WCE: begin
           if(UART_CE) begin
                TXD <= 1'b0;
                TXCT_R <= 1'b0;
                TX_STATE <= TSTRB;
            end
        end
        
        TSTRB: begin
            if(TX_CE) begin
                TXD <= TX_DATA[0];
                TX_DATA <= {1'b0, TX_DATA[7:1]};
                TX_STATE <= TDT;
            end
        end
        
        TDT: begin
            if (TX_CE) begin
                TX_DATA <= {1'b0, TX_DATA[7:1]};
                TX_DATA_CT <= TX_DATA_CT + 1'b1;
                
                if(TX_DATA_CT == 4'h7) begin
                    TXD <= TX_PAR_BIT_RG;
                    TX_STATE <= TPARB;
                end
                else TXD <= TX_DATA[0];
            end 
        end
        
        TPARB: begin
            if (TX_CE) begin
                TXD <= 1'b1;
                TX_STATE <= TSTB1;
            end
        end
        
        TSTB1: begin
            if(TX_CE) begin
                TXD <= 1'b1;
                TX_STATE <= TSTB2;
            end
        end
        
        TSTB2: begin
            if(TX_CE) begin
                TX_RDY_R <= 1'b1;
                TXCT_R <= 1'b1;
                TX_STATE <= IDLE;
            end
        end
        default: TX_STATE <= IDLE;
    endcase
endmodule

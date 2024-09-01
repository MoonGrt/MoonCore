`include "../para.v"

module ID_EX #(
    parameter CPU_WIDTH = 16
) (
    input wire clk,
    input wire rst_n,
    input wire hold_flag,

    input wire [          2:0] ID_rd,
    input wire [CPU_WIDTH-1:0] ID_RD,
    input wire [CPU_WIDTH-1:0] ID_RS,
    input wire [CPU_WIDTH-1:0] ID_IMM,

    input wire       ID_IMMop,
    input wire [2:0] ID_ALUop,
    input wire [1:0] ID_CMPop,
    input wire       ID_RegWe,
    input wire       ID_RWSel,
    input wire       ID_ABSel,
    input wire       ID_IMMSel,
    input wire       ID_mem_ctrl,

    output reg [          2:0] EX_rd,
    output reg [CPU_WIDTH-1:0] EX_RD,
    output reg [CPU_WIDTH-1:0] EX_RS,
    output reg [CPU_WIDTH-1:0] EX_IMM,

    output reg       EX_IMMop,
    output reg [2:0] EX_ALUop,
    output reg [1:0] EX_CMPop,
    output reg       EX_RegWe,
    output reg       EX_RWSel,
    output reg       EX_ABSel,
    output reg       EX_IMMSel,
    output reg       EX_mem_ctrl
);

    //*****************************************************
    //**                    Register
    //*****************************************************
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            EX_rd <= 'b0;
            EX_RD <= 'b0;
            EX_RS <= 'b0;
            EX_IMM <= 'b0;
            EX_IMMop <= 'b0;
            EX_ALUop <= 'b0;
            EX_CMPop <= 'b0;
            EX_RegWe <= 'b0;
            EX_RWSel <= 'b0;
            EX_ABSel <= 'b0;
            EX_IMMSel <= 'b0;
            EX_mem_ctrl <= 'b0;
        end else if (hold_flag) begin
            EX_rd <= EX_rd;
            EX_RD <= EX_RD;
            EX_RS <= EX_RS;
            EX_IMM <= EX_IMM;
            EX_IMMop <= EX_IMMop;
            EX_ALUop <= EX_ALUop;
            EX_CMPop <= EX_CMPop;
            EX_RegWe <= EX_RegWe;
            EX_RWSel <= EX_RWSel;
            EX_ABSel <= EX_ABSel;
            EX_IMMSel <= EX_IMMSel;
            EX_mem_ctrl <= EX_mem_ctrl;
        end else begin
            EX_rd <= ID_rd;
            EX_RD <= ID_RD;
            EX_RS <= ID_RS;
            EX_IMM <= ID_IMM;
            EX_IMMop <= ID_IMMop;
            EX_ALUop <= ID_ALUop;
            EX_CMPop <= ID_CMPop;
            EX_RegWe <= ID_RegWe;
            EX_RWSel <= ID_RWSel;
            EX_ABSel <= ID_ABSel;
            EX_IMMSel <= ID_IMMSel;
            EX_mem_ctrl <= ID_mem_ctrl;
        end
    end

endmodule

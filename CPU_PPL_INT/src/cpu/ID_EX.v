`include "../para.v"

module ID_EX (
    input wire             clk,
    input wire             rst_n,
    input wire [`CLEARBUS] clear_flag,
    input wire [ `HOLDBUS] hold_flag,

    input wire [     2:0] ID_rd,
    input wire [`DATABUS] ID_RD,
    input wire [`DATABUS] ID_RS,
    input wire [`DATABUS] ID_IMM,

    input wire [`DATABUS] ID_inst_addr,
    input wire       ID_CSR_wr,
    input wire [1:0] ID_JUMPop,
    input wire       ID_IMMop,
    input wire [2:0] ID_ALUop,
    input wire [1:0] ID_CMPop,
    input wire       ID_RegWe,
    input wire       ID_RWSel,
    input wire       ID_ABSel,
    input wire       ID_IMMSel,
    input wire       ID_mem_ctrl,

    // output reg [     2:0] EX_rd,
    // output reg [`DATABUS] EX_RD,
    // output reg [`DATABUS] EX_RS,
    // output reg [`DATABUS] EX_IMM,

    // output reg [`DATABUS] EX_inst_addr,
    // output reg       EX_CSR_wr,
    // output reg [1:0] EX_JUMPop,
    // output reg       EX_IMMop,
    // output reg [2:0] EX_ALUop,
    // output reg [1:0] EX_CMPop,
    // output reg       EX_RegWe,
    // output reg       EX_RWSel,
    // output reg       EX_ABSel,
    // output reg       EX_IMMSel,
    // output reg       EX_mem_ctrl

    output wire [     2:0] EX_rd,
    output wire [`DATABUS] EX_RD,
    output wire [`DATABUS] EX_RS,
    output wire [`DATABUS] EX_IMM,

    output wire [`DATABUS] EX_inst_addr,
    output wire       EX_CSR_wr,
    output wire [1:0] EX_JUMPop,
    output wire       EX_IMMop,
    output wire [2:0] EX_ALUop,
    output wire [1:0] EX_CMPop,
    output wire       EX_RegWe,
    output wire       EX_RWSel,
    output wire       EX_ABSel,
    output wire       EX_IMMSel,
    output wire       EX_mem_ctrl
);

    //*****************************************************
    //**                    Register
    //*****************************************************
    wire hold_en = (hold_flag == `Hold_PPL) | (hold_flag == `Hold_EX);
    wire clear_en = (clear_flag == `Clear_PPL) | (clear_flag == `Clear_EX);
    PPLreg #(`CPU_WIDTH) inst_reg(clk, ~rst_n|clear_en, hold_en, 16'b0, ID_inst_addr, EX_inst_addr);
    PPLreg #(`CPU_WIDTH) rd_reg(clk, ~rst_n|clear_en, hold_en, 16'b0, ID_rd, EX_rd);
    PPLreg #(`CPU_WIDTH) RD_reg(clk, ~rst_n|clear_en, hold_en, 16'b0, ID_RD, EX_RD);
    PPLreg #(`CPU_WIDTH) RS_reg(clk, ~rst_n|clear_en, hold_en, 16'b0, ID_RS, EX_RS);
    PPLreg #(`CPU_WIDTH) IMM_reg(clk, ~rst_n|clear_en, hold_en, 16'b0, ID_IMM, EX_IMM);
    PPLreg #(`CPU_WIDTH) CSRwr_reg(clk, ~rst_n|clear_en, hold_en, 16'b0, ID_CSR_wr, EX_CSR_wr);
    PPLreg #(`CPU_WIDTH) JUMPop_reg(clk, ~rst_n|clear_en, hold_en, 16'b0, ID_JUMPop, EX_JUMPop);
    PPLreg #(`CPU_WIDTH) IMMop_reg(clk, ~rst_n|clear_en, hold_en, 16'b0, ID_IMMop, EX_IMMop);
    PPLreg #(`CPU_WIDTH) ALUop_reg(clk, ~rst_n|clear_en, hold_en, 16'b0, ID_ALUop, EX_ALUop);
    PPLreg #(`CPU_WIDTH) CMPop_reg(clk, ~rst_n|clear_en, hold_en, 16'b0, ID_CMPop, EX_CMPop);
    PPLreg #(`CPU_WIDTH) RegWe_reg(clk, ~rst_n|clear_en, hold_en, 16'b0, ID_RegWe, EX_RegWe);
    PPLreg #(`CPU_WIDTH) RWSel_reg(clk, ~rst_n|clear_en, hold_en, 16'b0, ID_RWSel, EX_RWSel);
    PPLreg #(`CPU_WIDTH) ABSel_reg(clk, ~rst_n|clear_en, hold_en, 16'b0, ID_ABSel, EX_ABSel);
    PPLreg #(`CPU_WIDTH) IMMSel_reg(clk, ~rst_n|clear_en, hold_en, 16'b0, ID_IMMSel, EX_IMMSel);
    PPLreg #(`CPU_WIDTH) memctrl_reg(clk, ~rst_n|clear_en, hold_en, 16'b0, ID_mem_ctrl, EX_mem_ctrl);

    // always @(posedge clk or negedge rst_n) begin
    //     if (~rst_n) begin
    //         EX_inst_addr <= 'b0;
    //         EX_rd <= 'b0;
    //         EX_RD <= 'b0;
    //         EX_RS <= 'b0;
    //         EX_IMM <= 'b0;
    //         EX_CSR_wr <= 'b0;
    //         EX_JUMPop <= 'b0;
    //         EX_IMMop <= 'b0;
    //         EX_ALUop <= 'b0;
    //         EX_CMPop <= 'b0;
    //         EX_RegWe <= 'b0;
    //         EX_RWSel <= 'b0;
    //         EX_ABSel <= 'b0;
    //         EX_IMMSel <= 'b0;
    //         EX_mem_ctrl <= 'b0;
    //     end else if ((hold_flag == `Hold_PPL) | (hold_flag == `Hold_EX)) begin
    //         // EX_inst_addr <= EX_inst_addr;
    //         // EX_rd <= EX_rd;
    //         // EX_RD <= EX_RD;
    //         // EX_RS <= EX_RS;
    //         // EX_IMM <= EX_IMM;
    //         // EX_CSR_wr <= EX_CSR_wr;
    //         // EX_JUMPop <= EX_JUMPop;
    //         // EX_IMMop <= EX_IMMop;
    //         // EX_ALUop <= EX_ALUop;
    //         // EX_CMPop <= EX_CMPop;
    //         // EX_RegWe <= EX_RegWe;
    //         // EX_RWSel <= EX_RWSel;
    //         // EX_ABSel <= EX_ABSel;
    //         // EX_IMMSel <= EX_IMMSel;
    //         // EX_mem_ctrl <= EX_mem_ctrl;
    //         EX_inst_addr <= 'b0;
    //         EX_rd <= 'b0;
    //         EX_RD <= 'b0;
    //         EX_RS <= 'b0;
    //         EX_IMM <= 'b0;
    //         EX_CSR_wr <= 'b0;
    //         EX_JUMPop <= 'b0;
    //         EX_IMMop <= 'b0;
    //         EX_ALUop <= 'b0;
    //         EX_CMPop <= 'b0;
    //         EX_RegWe <= 'b0;
    //         EX_RWSel <= 'b0;
    //         EX_ABSel <= 'b0;
    //         EX_IMMSel <= 'b0;
    //         EX_mem_ctrl <= 'b0;
    //     end else begin
    //         EX_inst_addr <= ID_inst_addr;
    //         EX_rd <= ID_rd;
    //         EX_RD <= ID_RD;
    //         EX_RS <= ID_RS;
    //         EX_IMM <= ID_IMM;
    //         EX_CSR_wr <= ID_CSR_wr;
    //         EX_JUMPop <= ID_JUMPop;
    //         EX_IMMop <= ID_IMMop;
    //         EX_ALUop <= ID_ALUop;
    //         EX_CMPop <= ID_CMPop;
    //         EX_RegWe <= ID_RegWe;
    //         EX_RWSel <= ID_RWSel;
    //         EX_ABSel <= ID_ABSel;
    //         EX_IMMSel <= ID_IMMSel;
    //         EX_mem_ctrl <= ID_mem_ctrl;
    //     end
    // end

endmodule

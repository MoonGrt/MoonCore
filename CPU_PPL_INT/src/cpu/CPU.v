`include "../para.v"

module CPU #(
    parameter CPU_WIDTH = 16
) (
    input wire clk,
    input wire rst_n,

    input wire [7:0] irq,

    output wire [CPU_WIDTH-1:0] inst_addr,
    input  wire [CPU_WIDTH-1:0] inst_data,

    output wire [CPU_WIDTH-1:0] mem_addr,
    output wire [CPU_WIDTH-1:0] mem_wd,
    input  wire [CPU_WIDTH-1:0] mem_rd,
    output wire                 mem_ctrl
);

    wire                                           EX_jump_flag;
    wire [CPU_WIDTH-1:0] IF_inst_data = inst_data;
    wire [CPU_WIDTH-1:0]                           IF_inst_addr;
    wire [CPU_WIDTH-1:0]                           EX_IMM;
    assign inst_addr = IF_inst_addr;
    IF #(
        .CPU_WIDTH(CPU_WIDTH)
    ) IF (
        .clk  (clk),
        .rst_n(rst_n),

        .irq      (irq),
        .jump_flag(EX_jump_flag),
        .branch_pc(EX_IMM),

        .inst_data(IF_inst_data),

        .inst_addr(IF_inst_addr)
    );


    wire [CPU_WIDTH-1:0] ID_inst_data;
    IF_ID #(
        .CPU_WIDTH(CPU_WIDTH)
    ) IF_ID (
        .clk      (clk),
        .rst_n    (rst_n),
        .hold_flag(1'b0),

        .IF_inst_data(IF_inst_data),

        .ID_inst_data(ID_inst_data)
    );


    wire [          2:0] ID_rd;
    wire [          2:0] ID_rs;
    wire [CPU_WIDTH-1:0] ID_RD;
    wire [CPU_WIDTH-1:0] ID_RS;
    wire [CPU_WIDTH-1:0] ID_IMM;
    wire                 ID_IMMop;
    wire [          2:0] ID_ALUop;
    wire [          1:0] ID_CMPop;
    wire                 ID_RegWe;
    wire                 ID_mem_ctrl;
    wire                 ID_RWSel;
    wire                 ID_ABSel;
    wire                 ID_IMMSel;

    wire [          2:0] EX_rd;
    wire [CPU_WIDTH-1:0] EX_WB_data;
    wire                 EX_RegWe;
    ID #(
        .CPU_WIDTH(CPU_WIDTH)
    ) ID (
        .rst_n(rst_n),
        .inst (ID_inst_data),

        .rd (ID_rd),
        .rs (ID_rs),
        .IMM(ID_IMM),

        .IMMop   (ID_IMMop),
        .ALUop   (ID_ALUop),
        .CMPop   (ID_CMPop),
        .RegWe   (ID_RegWe),
        .mem_ctrl(ID_mem_ctrl),
        .RWSel   (ID_RWSel),
        .ABSel   (ID_ABSel),
        .IMMSel  (ID_IMMSel)
    );

    REG Reg (
        .clk  (clk),
        .rst_n(rst_n),

        .rd(ID_rd),
        .rs(ID_rs),

        .WB_addr(EX_rd),
        .WB_data(EX_WB_data),
        .RegWe  (EX_RegWe),

        .RD(ID_RD),
        .RS(ID_RS)
    );


    wire [CPU_WIDTH-1:0] EX_RD;
    wire [CPU_WIDTH-1:0] EX_RS;
    // wire [CPU_WIDTH-1:0] EX_IMM;
    wire                 EX_IMMop;
    wire [          2:0] EX_ALUop;
    wire [          1:0] EX_CMPop;
    wire                 EX_mem_ctrl;
    wire                 EX_RWSel;
    wire                 EX_ABSel;
    wire                 EX_IMMSel;
    ID_EX #(
        .CPU_WIDTH(CPU_WIDTH)
    ) ID_EX (
        .clk      (clk),
        .rst_n    (rst_n),
        .hold_flag(1'b0),

        .ID_rd      (ID_rd),
        .ID_RD      (ID_RD),
        .ID_RS      (ID_RS),
        .ID_IMM     (ID_IMM),
        .ID_IMMop   (ID_IMMop),
        .ID_ALUop   (ID_ALUop),
        .ID_CMPop   (ID_CMPop),
        .ID_RegWe   (ID_RegWe),
        .ID_RWSel   (ID_RWSel),
        .ID_ABSel   (ID_ABSel),
        .ID_IMMSel  (ID_IMMSel),
        .ID_mem_ctrl(ID_mem_ctrl),

        .EX_rd      (EX_rd),
        .EX_RD      (EX_RD),
        .EX_RS      (EX_RS),
        .EX_IMM     (EX_IMM),
        .EX_IMMop   (EX_IMMop),
        .EX_ALUop   (EX_ALUop),
        .EX_CMPop   (EX_CMPop),
        .EX_RegWe   (EX_RegWe),
        .EX_RWSel   (EX_RWSel),
        .EX_ABSel   (EX_ABSel),
        .EX_IMMSel  (EX_IMMSel),
        .EX_mem_ctrl(EX_mem_ctrl)
    );


    wire [CPU_WIDTH-1:0] EX_ALUout;
    wire [          1:0] EX_CMPout;
    wire [CPU_WIDTH-1:0] EX_RAMdata;
    assign EX_RAMdata = mem_rd;
    EX #(
        .CPU_WIDTH(CPU_WIDTH)
    ) EX (
        .rst_n(rst_n),
        .RD   (EX_RD),
        .RS   (EX_RS),
        .IMM  (EX_IMM),
        .ABSel(EX_ABSel),
        .IMMop(EX_IMMop),
        .ALUop(EX_ALUop),
        .CMPop(EX_CMPop),

        .CMPout   (EX_CMPout),
        .ALUout   (EX_ALUout),
        .jump_flag(EX_jump_flag)
    );
    WB #(
        .CPU_WIDTH(CPU_WIDTH)
    ) WB (
        .ALUout (EX_ALUout),
        .RAMdata(EX_RAMdata),
        .RWSel  (EX_RWSel),
        .WB_data(EX_WB_data)
    );


    assign mem_addr = EX_ALUout;
    assign mem_wd   = EX_RD;
    assign mem_ctrl = EX_mem_ctrl;

endmodule

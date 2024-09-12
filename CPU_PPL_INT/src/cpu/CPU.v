`include "../para.v"

module CPU (
    input wire clk,
    input wire rst_n,

    input wire [`INT_BUS] int,

    output wire [`ADDRBUS] inst_addr,
    input  wire [`DATABUS] inst_data,

    output wire [`ADDRBUS] mem_addr,
    output wire [`DATABUS] mem_wd,
    input  wire [`DATABUS] mem_rd,
    output wire            mem_ctrl
);

    wire [`DATABUS]  IF_inst_data = inst_data;
    wire [`ADDRBUS]  IF_inst_addr;
    assign inst_addr = IF_inst_addr;

    wire [`ADDRBUS] ID_inst_addr;
    wire [     2:0] ID_rd;
    wire [     2:0] ID_rs;
    wire [`DATABUS] ID_RD;
    wire [`DATABUS] ID_RS;
    wire [`DATABUS] ID_IMM;
    wire            ID_CSR_wr;
    wire [     1:0] ID_JUMPop;
    wire            ID_IMMop;
    wire [     2:0] ID_ALUop;
    wire [     1:0] ID_CMPop;
    wire            ID_RegWe;
    wire            ID_mem_ctrl;
    wire            ID_RWSel;
    wire            ID_ABSel;
    wire            ID_IMMSel;
    wire [`ADDRBUS] ID_inst_data;
    wire            ID_reg_clear;

    wire [`ADDRBUS] EX_inst_addr;
    wire [     2:0] EX_rd;
    wire [`DATABUS] EX_WB_data;
    wire            EX_RegWe;
    wire [`DATABUS] EX_RD;
    wire [`DATABUS] EX_RS;
    wire [`DATABUS] EX_IMM;
    wire            EX_jump_flag;
    wire [`DATABUS] EX_jump_pc;
    wire [`DATABUS] EX_jump_addr = EX_IMM;
    wire            EX_IMMop;
    wire [     2:0] EX_ALUop;
    wire [     1:0] EX_CMPop;
    wire            EX_mem_ctrl;
    wire            EX_RWSel;
    wire            EX_CSR_wr;
    wire [     1:0] EX_JUMPop;
    wire            EX_ABSel;
    wire            EX_IMMSel;
    wire [`DATABUS] EX_CSRout;
    wire [`DATABUS] EX_ALUout;
    wire [     1:0] EX_CMPout;
    wire [`DATABUS] EX_RAMdata;
    assign EX_RAMdata = mem_rd;

    assign mem_addr = EX_ALUout;
    assign mem_wd   = EX_RD;
    assign mem_ctrl = EX_mem_ctrl;


    wire            int_we;
    wire [`ADDRBUS] int_raddr;
    wire [`ADDRBUS] int_waddr;
    wire [`DATABUS] int_wdata;
    wire [`DATABUS] int_rdata;
    wire [`DATABUS] csr_mtvec;
    wire [`DATABUS] csr_mepc;
    wire [`DATABUS] csr_mstatus;

    wire global_int_en;
    wire hold_flag_int;
    wire [`HOLDBUS] hold_flag;

    ctrl ctrl(
        .rst_n(rst_n),

        .jump_flag     (EX_jump_flag),
        .hold_flag_ex  (1'b0),
        .jtag_halt_flag(1'b0),
        .hold_flag_int (hold_flag_int),

        .hold_flag     (hold_flag)
    );

    CLINT CLINT(
        .clk  (clk),
        .rst_n(rst_n),

        .int_flag     (int),
        .inst_data    (IF_inst_data),
        .inst_addr    (IF_inst_addr),
        .jump_flag    (EX_jump_flag),
        .jump_addr    (EX_jump_addr),
        .int_rdata    (int_rdata),
        .csr_mtvec    (csr_mtvec),
        .csr_mepc     (csr_mepc),
        .csr_mstatus  (csr_mstatus),
        .global_int_en(global_int_en),

        .hold_flag_int(hold_flag_int),
        .int_we       (int_we),
        .int_waddr    (int_raddr),
        .int_raddr    (int_waddr),
        .int_wdata    (int_wdata),
        .int_addr     (),
        .int_assert   ()
    );

    CSR CSR(
        .clk  (clk),
        .rst_n(rst_n),

        .EX_we    (),
        .EX_raddr (),
        .EX_waddr (),
        .EX_rdata (),
        .int_we   (int_we),
        .int_raddr(int_raddr),
        .int_waddr(int_waddr),
        .int_wdata(int_wdata),

        .int_rdata    (csr_rdata),
        .csr_mtvec    (csr_mtvec),
        .csr_mepc     (csr_mepc),
        .csr_mstatus  (csr_mstatus),
        .global_int_en(global_int_en),
        .EX_wdata     ()
    );




    IF IF (
        .clk  (clk),
        .rst_n(rst_n),

        .hold_flag(hold_flag),
        .jump_flag(EX_jump_flag),
        .jump_pc  (EX_jump_pc),

        .inst_data(IF_inst_data),
        .inst_addr(IF_inst_addr)
    );

    IF_ID IF_ID (
        .clk      (clk),
        .rst_n    (rst_n),
        .hold_flag(hold_flag),

        .IF_inst_data(IF_inst_data),
        .IF_inst_addr(IF_inst_addr),
        .ID_inst_data(ID_inst_data),
        .ID_inst_addr(ID_inst_addr)
    );

    ID ID (
        .rst_n(rst_n),
        .inst (ID_inst_data),

        .rd (ID_rd),
        .rs (ID_rs),
        .IMM(ID_IMM),

        .CSR_wr   (ID_CSR_wr),
        .JUMPop   (ID_JUMPop),
        .IMMop    (ID_IMMop),
        .ALUop    (ID_ALUop),
        .CMPop    (ID_CMPop),
        .RegWe    (ID_RegWe),
        .mem_ctrl (ID_mem_ctrl),
        .RWSel    (ID_RWSel),
        .ABSel    (ID_ABSel),
        .IMMSel   (ID_IMMSel),
        .reg_clear(ID_reg_clear)
    );
    REG Reg (
        .clk  (clk),
        .rst_n(rst_n),

        .rd(ID_rd),
        .rs(ID_rs),

        .WB_addr(EX_rd),
        .WB_data(EX_WB_data),
        .RegWe  (EX_RegWe),
        .clear  (ID_reg_clear),

        .RD(ID_RD),
        .RS(ID_RS)
    );

    ID_EX ID_EX (
        .clk      (clk),
        .rst_n    (rst_n),
        .hold_flag(hold_flag),

        .ID_inst_addr(ID_inst_addr),
        .ID_rd      (ID_rd),
        .ID_RD      (ID_RD),
        .ID_RS      (ID_RS),
        .ID_IMM     (ID_IMM),
        .ID_CSR_wr  (ID_CSR_wr),
        .ID_JUMPop  (ID_JUMPop),
        .ID_IMMop   (ID_IMMop),
        .ID_ALUop   (ID_ALUop),
        .ID_CMPop   (ID_CMPop),
        .ID_RegWe   (ID_RegWe),
        .ID_RWSel   (ID_RWSel),
        .ID_ABSel   (ID_ABSel),
        .ID_IMMSel  (ID_IMMSel),
        .ID_mem_ctrl(ID_mem_ctrl),

        .EX_inst_addr(EX_inst_addr),
        .EX_rd      (EX_rd),
        .EX_RD      (EX_RD),
        .EX_RS      (EX_RS),
        .EX_IMM     (EX_IMM),
        .EX_CSR_wr  (EX_CSR_wr),
        .EX_JUMPop  (EX_JUMPop),
        .EX_IMMop   (EX_IMMop),
        .EX_ALUop   (EX_ALUop),
        .EX_CMPop   (EX_CMPop),
        .EX_RegWe   (EX_RegWe),
        .EX_RWSel   (EX_RWSel),
        .EX_ABSel   (EX_ABSel),
        .EX_IMMSel  (EX_IMMSel),
        .EX_mem_ctrl(EX_mem_ctrl)
    );

    EX EX (
        .rst_n(rst_n),

        .pc   (EX_inst_addr),
        .RD   (EX_RD),
        .RS   (EX_RS),
        .IMM  (EX_IMM),

        .CSR_wr(EX_CSR_wr),
        .JUMPop(EX_JUMPop),
        .ABSel(EX_ABSel),
        .IMMop(EX_IMMop),
        .ALUop(EX_ALUop),
        .CMPop(EX_CMPop),

        .CSRout   (EX_CSRout),
        .CMPout   (EX_CMPout),
        .ALUout   (EX_ALUout),
        .jump_flag(EX_jump_flag),
        .jump_pc  (EX_jump_pc)
    );
    WB WB (
        .CSRout (EX_CSRout),
        .ALUout (EX_ALUout),
        .RAMdata(EX_RAMdata),
        .CSR_wr (EX_CSR_wr),
        .RWSel  (EX_RWSel),
        .WB_data(EX_WB_data)
    );

endmodule

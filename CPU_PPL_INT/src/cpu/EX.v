`include "../para.v"

module EX (
    input wire rst_n,
    input wire [`DATABUS] pc,

    input wire [`DATABUS] RD,
    input wire [`DATABUS] RS,
    input wire [`DATABUS] IMM,

    input wire       CSR_wr,
    input wire [1:0] JUMPop,
    input wire       ABSel,
    input wire       IMMop,
    input wire [2:0] ALUop,
    input wire [1:0] CMPop,

    // from csr
    input wire [`DATABUS]  EX_rdata,  // EX模块读CSR寄存器数据

    // to ex
    output wire            EX_we,     // EX模块写CSR寄存器标志
    output wire [`ADDRBUS] EX_raddr,  // EX模块读CSR寄存器地址
    output wire [`ADDRBUS] EX_waddr,  // EX模块写CSR寄存器地址
    output wire [`DATABUS] EX_wdata,  // EX模块写CSR寄存器数据

    output wire [`DATABUS] CSRout,
    output wire [`DATABUS] ALUout,
    output wire [     1:0] CMPout,
    output wire            jump_flag,
    output wire [`DATABUS] jump_pc
);

    //*****************************************************
    //**                    wire reg
    //*****************************************************
    wire [`DATABUS] ALU_Ain, ALU_Bin, CMP_Ain, CMP_Bin;

    assign ALU_Ain = ABSel ? RS : RD;
    assign ALU_Bin = IMMop ? IMM : RS;
    assign CMP_Ain = RD;
    assign CMP_Bin = IMMop ? IMM : RS;

    //*****************************************************
    //**                    main
    //*****************************************************
    ALU ALU (
        .A       (ALU_Ain),
        .B       (ALU_Bin),
        .ALUop   (ALUop),
        .ALUout  (ALUout),
        .overflow()
    );

    CMP CMP (
        .A     (CMP_Ain),
        .B     (CMP_Bin),
        .CMPout(CMPout)
    );

    //*****************************************************
    //**                    jump
    //*****************************************************
    assign jump_flag = JUMPop ? 1'b1 :
                       (CMPop == `BEQ_op) ? (CMPout == `CMP_EQ) : 
                       (CMPop == `BLE_op) ? (CMPout == `CMP_L) : 1'b0;
    assign jump_pc = (JUMPop == `JR_op) ? RD + IMM : IMM;  // TODO: 条件跳转 转为 pc +- imm

    //*****************************************************
    //**                     CSR
    //*****************************************************
    assign EX_we = CSR_wr;  // 1'b0 read; 1'b1 write
    assign EX_raddr = IMM[4:0];
    assign CSRout = EX_rdata;
    assign EX_waddr = IMM[4:0];
    assign EX_wdata = RD;

endmodule

`include "../para.v"

module EX (
    input wire rst_n,

    input wire [`DATABUS] RD,
    input wire [`DATABUS] RS,
    input wire [`DATABUS] IMM,

    input wire       ABSel,
    input wire       IMMop,
    input wire [2:0] ALUop,
    input wire [1:0] CMPop,

    output wire [`DATABUS] ALUout,
    output wire [     1:0] CMPout,
    output wire            jump_flag
);

    //*****************************************************
    //**                    wire reg
    //*****************************************************
    wire [`DATABUS] ALU_Ain, ALU_Bin, CMP_Ain, CMP_Bin;

    assign ALU_Ain = ABSel ? RS : RD;
    assign ALU_Bin = IMMop ? IMM : RS;
    assign CMP_Ain = RD;
    assign CMP_Bin = IMMop ? IMM : RS;

    assign jump_flag = (CMPop == `BEQ_op) ? (CMPout == `CMP_EQ) : 
                       (CMPop == `BLE_op) ? (CMPout == `CMP_L) : 1'b0;

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

endmodule

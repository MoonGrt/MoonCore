`include "../para.v"

module IF (
    input wire clk,
    input wire rst_n,

    input wire [`HOLDBUS] hold_flag,
    input wire            jump_flag,
    input wire [`ADDRBUS] branch_pc,

    input  wire [`DATABUS] inst_data,
    output wire [`ADDRBUS] inst_addr
);

    wire hold_en = (hold_flag == `Hold_PPL) | (hold_flag == `Hold_PC);

    reg  [`ADDRBUS] pc;
    wire [`ADDRBUS] pc4 = pc + 1;
    wire [`ADDRBUS] npc = (jump_flag) ? branch_pc : (inst_data ? pc4 : pc);
    assign inst_addr = pc;

    //*****************************************************
    //**                    main
    //*****************************************************
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) pc <= 0;
        else pc <= npc;
    end

    //inst_mem inst_mem(
    //       .a(pc[9: 0]),
    //       .spo(inst)
    //   );

endmodule

`include "../para.v"

module IF (
    input wire clk,
    input wire rst_n,

    input wire            jump_flag,
    input wire [`ADDRBUS] jump_pc,
    input wire [`HOLDBUS] hold_flag,

    input  wire [`DATABUS] inst_data,
    output wire [`ADDRBUS] inst_addr,
    output wire            hold_pc
);

    wire hold_en = (hold_flag == `Hold_PPL) | (hold_flag == `Hold_PC);

    //*****************************************************
    //**                    jump
    //*****************************************************
    wire [4:0] opecode = inst_data[4:0];
    assign hold_pc = (opecode == `BEQ) | (opecode == `BLE) | (opecode == `JAL) | (opecode == `JR);


    //*****************************************************
    //**                    pc
    //*****************************************************
    // reg  [`ADDRBUS] pc;
    // wire [`ADDRBUS] npc = jump_flag ? jump_pc : 
    //                       hold_en ? pc : 
    //                       inst_data ? pc + 'b1 : 
    //                     //   inst_addr == 16'b1 ? pc + 'b1 : 
    //                       pc;
    // assign inst_addr = pc;

    // always @(posedge clk or negedge rst_n) begin
    //     if (~rst_n) pc <= 0;
    //     else pc <= npc;
    // end

    reg [`ADDRBUS] pc = 16'b0;
    assign inst_addr = pc;
    always @(posedge clk) begin
        if (~rst_n) 
            pc <= 0;
        else if (jump_flag)
            pc <= jump_pc;
        else if (hold_en)
            pc <= pc;
        else
            pc <= pc + 'b1;
    end

endmodule

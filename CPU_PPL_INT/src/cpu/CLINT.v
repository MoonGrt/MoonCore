`include "../para.v"

// core local interruptor module && arbitration module
module CLINT (
    input wire clk,
    input wire rst_n,

    // from core
    input wire [`INT_BUS] int_flag,      // 中断输入信号
    // from id
    input wire [`DATABUS] inst_data,     // 指令内容
    input wire [`ADDRBUS] inst_addr,     // 指令地址
    // from ex
    input wire            jump_flag,
    input wire [`ADDRBUS] jump_addr,
    // from csr
    input wire [`DATABUS] int_rdata,     // CSR寄存器输入数据
    input wire [`DATABUS] csr_mtvec,     // mtvec寄存器
    input wire [`DATABUS] csr_mepc,      // mepc寄存器
    input wire [`DATABUS] csr_mstatus,   // mstatus寄存器
    input wire            global_int_en, // 全局中断使能标志

    // to ctrl
    output wire           hold_flag_int,  // 流水线暂停标志
    // to csr
    output reg            int_we,         // CLINT写CSR寄存器标志
    output reg [`ADDRBUS] int_waddr,      // CLINT写CSR寄存器地址
    output reg [`ADDRBUS] int_raddr,      // CLINT读CSR寄存器地址
    output reg [`DATABUS] int_wdata,      // CLINT写CSR寄存器数据
    // to ex
    output reg [`ADDRBUS] int_addr,       // 中断入口地址
    output reg            int_assert      // 中断标志
);

    // 中断状态定义
    localparam S_INT_IDLE = 4'b0001;
    // localparam S_INT_SYNC_ASSERT = 4'b0010;
    localparam S_INT_ASYNC_ASSERT = 4'b0100;
    localparam S_INT_MRET = 4'b1000;

    // 写CSR寄存器状态定义
    localparam S_CSR_IDLE = 5'b00001;
    localparam S_CSR_MSTATUS = 5'b00010;
    localparam S_CSR_MEPC = 5'b00100;
    localparam S_CSR_MSTATUS_MRET = 5'b01000;
    localparam S_CSR_MCAUSE = 5'b10000;

    reg [     3:0] int_state;
    reg [     4:0] csr_state;
    reg [`ADDRBUS] inst_addr_reg;
    reg [`DATABUS] cause;

    assign hold_flag_int = ((int_state != S_INT_IDLE) | (csr_state != S_CSR_IDLE)) ? 1'b1 : 1'b0;

    // 中断仲裁逻辑
    always @(*) begin
        if (~rst_n) begin
            int_state = S_INT_IDLE;
        end else begin
            if (int_flag != `INT_NONE && global_int_en) begin
                int_state = S_INT_ASYNC_ASSERT;
            end else if (inst_data == 16'h1000) begin  // Set 16'h0000 for interrupt return instruction
                int_state = S_INT_MRET;
            end else begin
                int_state = S_INT_IDLE;
            end
        end
    end

    // 写CSR寄存器状态切换
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            csr_state <= S_CSR_IDLE;
            cause <= 16'b0;
            inst_addr_reg <= 16'b0;
        end else begin
            case (csr_state)
                S_CSR_IDLE: begin
                    // // 同步中断
                    // if (int_state == S_INT_SYNC_ASSERT) begin
                    //     csr_state <= S_CSR_MEPC;
                    //     // 在中断处理函数里会将中断返回地址加4
                    //     if (jump_flag == `JumpEnable) begin
                    //         inst_addr_reg <= jump_addr - 4'h4;
                    //     end else begin
                    //         inst_addr_reg <= inst_addr;
                    //     end
                    //     case (inst_data)
                    //         `INST_ECALL: begin
                    //             cause <= 32'd11;
                    //         end
                    //         `INST_EBREAK: begin
                    //             cause <= 32'd3;
                    //         end
                    //         default: begin
                    //             cause <= 32'd10;
                    //         end
                    //     endcase
                    // // 异步中断
                    // end else 
                    if (int_state == S_INT_ASYNC_ASSERT) begin
                        if (int_flag == `INT_TIMER) begin
                            // 定时器中断
                            cause <= 32'h80000004;
                            csr_state <= S_CSR_MEPC;
                            if (jump_flag) begin
                                inst_addr_reg <= jump_addr;
                            end else begin
                                inst_addr_reg <= inst_addr;
                            end
                        end
                    // 中断返回
                    end else if (int_state == S_INT_MRET) begin
                        csr_state <= S_CSR_MSTATUS_MRET;
                    end
                end
                S_CSR_MEPC: begin
                    csr_state <= S_CSR_MSTATUS;
                end
                S_CSR_MSTATUS: begin
                    csr_state <= S_CSR_MCAUSE;
                end
                S_CSR_MCAUSE: begin
                    csr_state <= S_CSR_IDLE;
                end
                S_CSR_MSTATUS_MRET: begin
                    csr_state <= S_CSR_IDLE;
                end
                default: begin
                    csr_state <= S_CSR_IDLE;
                end
            endcase
        end
    end

    // 发出中断信号前，先写几个CSR寄存器
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            int_we <= 1'b0;
            int_waddr <= 16'b0;
            int_wdata <= 16'b0;
        end else begin
            case (csr_state)
                // 将mepc寄存器的值设为当前指令地址
                S_CSR_MEPC: begin
                    int_we <= 1'b1;
                    int_waddr <= {4'b0, `CSR_MEPC};
                    int_wdata <= inst_addr_reg;
                end
                // 写中断产生的原因
                S_CSR_MCAUSE: begin
                    int_we <= 1'b1;
                    int_waddr <= {4'b0, `CSR_MCAUSE};
                    int_wdata <= cause;
                end
                // 关闭全局中断
                S_CSR_MSTATUS: begin
                    int_we <= 1'b1;
                    int_waddr <= {4'b0, `CSR_MSTATUS};
                    int_wdata <= {csr_mstatus[15:4], 1'b0, csr_mstatus[2:0]};  // 第四位
                end
                // 中断返回
                S_CSR_MSTATUS_MRET: begin
                    int_we <= 1'b1;
                    int_waddr <= {4'b0, `CSR_MSTATUS};
                    int_wdata <= {csr_mstatus[15:4], csr_mstatus[7], csr_mstatus[2:0]};
                end
                default: begin
                    int_we <= 1'b0;
                    int_waddr <= 16'b0;
                    int_wdata <= 16'b0;
                end
            endcase
        end
    end

    // 发出中断信号给ex模块
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            int_assert <= 1'b0;
            int_addr   <= 16'b0;
        end else begin
            case (csr_state)
                // 发出中断进入信号.写完mcause寄存器才能发
                S_CSR_MCAUSE: begin
                    int_assert <= 1'b1;
                    int_addr   <= csr_mtvec;
                end
                // 发出中断返回信号
                S_CSR_MSTATUS_MRET: begin
                    int_assert <= 1'b1;
                    int_addr   <= csr_mepc;
                end
                default: begin
                    int_assert <= 1'b0;
                    int_addr   <= 16'b0;
                end
            endcase
        end
    end

endmodule

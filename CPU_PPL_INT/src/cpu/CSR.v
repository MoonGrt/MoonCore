`include "../para.v"

// CSR module
module CSR (
    input wire clk,
    input wire rst_n,

    // form ex
    input wire            EX_we,      // ex模块写寄存器标志
    input wire [`ADDRBUS] EX_raddr,   // ex模块读寄存器地址
    input wire [`ADDRBUS] EX_waddr,   // ex模块写寄存器地址
    input wire [`DATABUS] EX_rdata,   // ex模块写寄存器数据
    // from int
    input wire            csr_we,     // int模块写寄存器标志
    input wire [`ADDRBUS] csr_raddr,  // int模块读寄存器地址
    input wire [`ADDRBUS] csr_waddr,  // int模块写寄存器地址
    input wire [`DATABUS] csr_wdata,  // int模块写寄存器数据

    // to int
    output reg  [`DATABUS] csr_rdata,      // int模块读寄存器数据
    output wire [`DATABUS] csr_mtvec,      // mtvec
    output wire [`DATABUS] csr_mepc,       // mepc
    output wire [`DATABUS] csr_mstatus,    // mstatus
    output wire            global_int_en,  // 全局中断使能标志
    // to ex
    output reg  [`DATABUS] EX_wdata        // ex模块读寄存器数据
);

    reg [    31:0 ] cycle;
    reg [`DATABUS]  mtvec;
    reg [`DATABUS]  mcause;
    reg [`DATABUS]  mepc;
    reg [`DATABUS]  mie;
    reg [`DATABUS]  mstatus;
    reg [`DATABUS]  mscratch;

    assign global_int_en = (mstatus[3] == 1'b1) ? 1'b1 : 1'b0;
    assign csr_mtvec = mtvec;
    assign csr_mepc = mepc;
    assign csr_mstatus = mstatus;

    // cycle counter
    // 复位撤销后就一直计数
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            cycle <= 32'b0;
        end else begin
            cycle <= cycle + 1'b1;
        end
    end

    // write reg
    // 写寄存器操作
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mtvec <= 16'b0;
            mcause <= 16'b0;
            mepc <= 16'b0;
            mie <= 16'b0;
            mstatus <= 16'b0;
            mscratch <= 16'b0;
        end else begin
            // 优先响应ex模块的写操作
            if (EX_we) begin
                case (EX_waddr[11:0])
                    `CSR_MTVEC: begin
                        mtvec <= EX_rdata;
                    end
                    `CSR_MCAUSE: begin
                        mcause <= EX_rdata;
                    end
                    `CSR_MEPC: begin
                        mepc <= EX_rdata;
                    end
                    `CSR_MIE: begin
                        mie <= EX_rdata;
                    end
                    `CSR_MSTATUS: begin
                        mstatus <= EX_rdata;
                    end
                    `CSR_MSCRATCH: begin
                        mscratch <= EX_rdata;
                    end
                    default: begin

                    end
                endcase
                // int模块写操作
            end else if (csr_we) begin
                case (csr_waddr[11:0])
                    `CSR_MTVEC: begin
                        mtvec <= csr_wdata;
                    end
                    `CSR_MCAUSE: begin
                        mcause <= csr_wdata;
                    end
                    `CSR_MEPC: begin
                        mepc <= csr_wdata;
                    end
                    `CSR_MIE: begin
                        mie <= csr_wdata;
                    end
                    `CSR_MSTATUS: begin
                        mstatus <= csr_wdata;
                    end
                    `CSR_MSCRATCH: begin
                        mscratch <= csr_wdata;
                    end
                    default: begin

                    end
                endcase
            end
        end
    end

    // read reg
    // ex模块读CSR寄存器
    always @(*) begin
        if ((EX_waddr[11:0] == EX_raddr[11:0]) && EX_we) begin
            EX_wdata = EX_rdata;
        end else begin
            case (EX_raddr[11:0])
                `CSR_CYCLE: begin
                    EX_wdata = cycle[31:0];
                end
                `CSR_CYCLEH: begin
                    EX_wdata = cycle[63:32];
                end
                `CSR_MTVEC: begin
                    EX_wdata = mtvec;
                end
                `CSR_MCAUSE: begin
                    EX_wdata = mcause;
                end
                `CSR_MEPC: begin
                    EX_wdata = mepc;
                end
                `CSR_MIE: begin
                    EX_wdata = mie;
                end
                `CSR_MSTATUS: begin
                    EX_wdata = mstatus;
                end
                `CSR_MSCRATCH: begin
                    EX_wdata = mscratch;
                end
                default: begin
                    EX_wdata = 16'b0;
                end
            endcase
        end
    end

    // read reg
    // int模块读CSR寄存器
    always @(*) begin
        if ((csr_waddr[11:0] == csr_raddr[11:0]) && csr_we) begin
            csr_rdata = csr_wdata;
        end else begin
            case (csr_raddr[11:0])
                `CSR_CYCLE: begin
                    csr_rdata = cycle[31:0];
                end
                `CSR_CYCLEH: begin
                    csr_rdata = cycle[63:32];
                end
                `CSR_MTVEC: begin
                    csr_rdata = mtvec;
                end
                `CSR_MCAUSE: begin
                    csr_rdata = mcause;
                end
                `CSR_MEPC: begin
                    csr_rdata = mepc;
                end
                `CSR_MIE: begin
                    csr_rdata = mie;
                end
                `CSR_MSTATUS: begin
                    csr_rdata = mstatus;
                end
                `CSR_MSCRATCH: begin
                    csr_rdata = mscratch;
                end
                default: begin
                    csr_rdata = 16'b0;
                end
            endcase
        end
    end

endmodule

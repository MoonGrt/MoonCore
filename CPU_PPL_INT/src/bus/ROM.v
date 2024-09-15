`include "../para.v"

module ROM (
    input  wire            clk,
    input  wire            rst_n,
    input  wire            EN,
    input  wire            ctrl,
    input  wire [`ADDRBUS] addr,
    input  wire [`DATABUS] wdata,
    output wire [`DATABUS] rdata
);

    reg data_flag = 1'b0;
    reg [7:0] data_reg = 8'b0;
    reg [`ADDRBUS] data_addr = 16'b0;
    wire [`ADDRBUS] data = {data_reg, wdata[7:0]};
    wire data_valid = ctrl&data_flag;
    always @(posedge clk) begin
        if (rst_n) begin  // Enable on reset
            data_flag <= 1'b0;
            data_reg <= 8'b0;
            data_addr <= 16'b0;
        end else if (ctrl) begin
            data_flag <= ~data_flag;
            data_reg <= wdata[7:0];
                if (data_flag)
                    data_addr <= data_addr + 1'b1;
        end
    end

    //*****************************************************
    //**                   INST MEM
    //*****************************************************
    wire [`ADDRBUS] ROM_addr = rst_n ? addr : data_addr;
    // Connect ROM
    RAM_Gen #(
        .INIT_FILE("F:/Project/Sipeed/FPGA/Tang_Primer/CPU/code/UART"),
        .DP(`RAM_DEPTH),
        .DW(16),
        .MW(2),  // (WIDTH/8)
        .AW(16)
    ) inst_mem (
        .clk  (clk),
        .addr (ROM_addr),
        .wdata(data),
        .sel  ({2{data_valid}}),
        .we   (data_valid),
        .rdata(rdata)
    );


endmodule

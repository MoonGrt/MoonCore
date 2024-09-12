`include "../para.v"

module IF_ID (
    input wire            clk,
    input wire            rst_n,
    input wire [`HOLDBUS] hold_flag,

    input  wire [`ADDRBUS] IF_inst_addr,
    input  wire [`DATABUS] IF_inst_data,
    output reg  [`ADDRBUS] ID_inst_addr,
    output reg  [`DATABUS] ID_inst_data
);

    //*****************************************************
    //**                    Register
    //*****************************************************
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            ID_inst_data <= 'b0;
            ID_inst_addr <= 'b0;
        end else if ((hold_flag == `Hold_PPL) | (hold_flag == `Hold_ID)) begin
            // ID_inst_data <= ID_inst_data;
            // ID_inst_addr <= ID_inst_addr;
            ID_inst_data <= 'b0;
            ID_inst_addr <= 'b0;
        end else begin
            ID_inst_data <= IF_inst_data;
            ID_inst_addr <= IF_inst_addr;
        end
    end

endmodule

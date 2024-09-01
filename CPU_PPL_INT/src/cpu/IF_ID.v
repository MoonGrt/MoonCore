`include "../para.v"

module IF_ID #(
    parameter CPU_WIDTH = 16
) (
    input wire clk,
    input wire rst_n,
    input wire hold_flag,

    input wire [CPU_WIDTH-1:0] IF_inst_data,
    output reg [CPU_WIDTH-1:0] ID_inst_data
);

    //*****************************************************
    //**                    Register
    //*****************************************************
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            ID_inst_data[CPU_WIDTH-1:0] <= 'b0;
        end else if (hold_flag) begin
            ID_inst_data[CPU_WIDTH-1:0] <= ID_inst_data[CPU_WIDTH-1:0];
        end else begin
            ID_inst_data[CPU_WIDTH-1:0] <= IF_inst_data[CPU_WIDTH-1:0];
        end
    end

endmodule

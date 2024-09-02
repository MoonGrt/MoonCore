`include "../para.v"

module IF_ID (
    input wire            clk,
    input wire            rst_n,
    input wire [`HOLDBUS] hold_flag,

    input  wire [`DATABUS] IF_inst_data,
    output reg  [`DATABUS] ID_inst_data
);

    //*****************************************************
    //**                    Register
    //*****************************************************
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            ID_inst_data[`DATABUS] <= 'b0;
        end else if ((hold_flag == `Hold_PPL) | (hold_flag == `Hold_ID)) begin
            ID_inst_data[`DATABUS] <= ID_inst_data[`DATABUS];
        end else begin
            ID_inst_data[`DATABUS] <= IF_inst_data[`DATABUS];
        end
    end

endmodule

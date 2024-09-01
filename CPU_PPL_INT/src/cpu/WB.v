`include "../para.v"

module WB #(
    parameter CPU_WIDTH = 16
) (
    input  wire [CPU_WIDTH-1:0] ALUout,
    input  wire [CPU_WIDTH-1:0] RAMdata,
    input  wire                 RWSel,
    output wire [CPU_WIDTH-1:0] WB_data
);

    assign WB_data = RWSel ? RAMdata : ALUout;

endmodule

`include "../para.v"

module WB (
    input wire [`DATABUS] ALUout,
    input wire [`DATABUS] RAMdata,
    input wire            RWSel,

    output wire [`DATABUS] WB_data
);

    assign WB_data = RWSel ? RAMdata : ALUout;

endmodule

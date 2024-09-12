`include "../para.v"

module WB (
    input wire [`DATABUS] CSRout,
    input wire [`DATABUS] ALUout,
    input wire [`DATABUS] RAMdata,
    input wire            CSR_wr,
    input wire            RWSel,

    output wire [`DATABUS] WB_data
);

    assign WB_data = RWSel ? RAMdata : 
                     CSR_wr ? CSRout : ALUout;

endmodule

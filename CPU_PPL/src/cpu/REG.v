`include "../para.v"

module REG #(
    parameter CPU_WIDTH = 16
) (
    input wire clk,
    input wire rst_n,

    input wire [          2:0] rd,
    input wire [          2:0] rs,

    input wire [          2:0] WB_addr,
    input wire [CPU_WIDTH-1:0] WB_data,
    input wire                 RegWe,

    output wire [CPU_WIDTH-1:0] RD,
    output wire [CPU_WIDTH-1:0] RS
);

    //*****************************************************
    //**                    Forwarding
    //*****************************************************
    reg [2:0] last_rd;
    // wire [2:0] last_rs;  // only write data to rd
    wire rd_forward = (rd == last_rd);
    wire rs_forward = (rs == last_rd);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            last_rd <= 3'b0;
            // last_rs <= 3'b0;
        end else begin
            last_rd <= rd;
            // last_rs <= rs;
        end
    end


    //*****************************************************
    //**                  Write Data
    //*****************************************************
    reg [CPU_WIDTH-1:0] rf[7:0];  // 寄存器
    assign RD = rd_forward ? WB_data : rf[(rd)];
    assign RS = rs_forward ? WB_data : rf[(rs)];
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            for (i = 0; i < 8; i = i + 1) 
                rf[i][CPU_WIDTH-1:0] <= 16'h0;
        else if (RegWe == `REGWE_WRITE) 
            rf[WB_addr] <= WB_data;
    end

endmodule

`include "../para.v"

module Counter(
    input  wire            en,
    input  wire            clk,
    input  wire [`DATABUS] cnt,
    output wire            int
);

    reg [25:0] counter = 'b0;
    assign int = ((counter == cnt) && en) ? 'b1 : 'b0;

    always @(posedge clk) begin
        if (counter == cnt) counter <= 'b0;
        else counter <= counter + 'b1;
    end

endmodule

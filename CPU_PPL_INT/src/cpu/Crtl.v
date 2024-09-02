`include "../para.v"

// Control module
// Signal jump, pause pipeline
module ctrl (
    input wire rst_n,

    // from ex
    input wire jump_flag,
    input wire hold_flag_ex,
    // from jtag
    input wire jtag_halt_flag,
    // from int
    input wire hold_flag_int,

    output reg [`HOLDBUS] hold_flag
);

    always @(*) begin
        if (~rst_n) begin
            hold_flag = `Hold_None;
        end else begin
            hold_flag = `Hold_None;  // default: `Hold_None
            // prioritize requests from different modules
            if (jump_flag || hold_flag_ex || hold_flag_int) begin
                // suspend the entire assembly line
                hold_flag = `Hold_PPL;
            end else if (jtag_halt_flag) begin
                // suspend the entire assembly line
                hold_flag = `Hold_PPL;
            end else begin
                hold_flag = `Hold_None;
            end
        end
    end

endmodule

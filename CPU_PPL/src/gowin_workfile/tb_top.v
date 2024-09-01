`timescale 1ns / 1ps

module tb_top;

    reg        clk = 0;
    reg        rst_n = 0;
    reg  [3:0] buttom = 4'h01;
    reg  [3:0] switch = 4'h02;
    wire [3:0] led;
    reg        uart_rx = 1;  //UART接收端口
    wire       uart_tx;  //UART发送端口

    always #5 clk = ~clk;

    initial
    begin
        #15 rst_n <= 1'b1;
    end

    top top(
        .clk     (clk),
        .rst_n   (rst_n),
        .buttom  (buttom),
        .switch  (switch),
        .led     (led),
        .uart_rx (uart_rx),
        .uart_tx (uart_tx)
    );

endmodule

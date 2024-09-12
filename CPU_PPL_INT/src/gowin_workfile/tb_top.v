`timescale 1ns / 1ps

module tb_top;

    reg        clk;
    reg        rst_n;
    reg        int_timer;
    reg  [3:0] buttom;
    reg  [3:0] switch;
    wire [3:0] led;
    reg        uart_rx = 1;  //UART接收端口
    wire       uart_tx;  //UART发送端口

    always #5 clk <= ~clk;

    initial begin
        clk <= 0;
        rst_n <= 0;
        int_timer <= 0;
        buttom <= 4'h1;
        switch <= 4'h2;
        uart_rx <= 1;

        #15 rst_n <= 1'b1;
        #67 int_timer <= 1'b1;
        #10 int_timer <= 1'b0;
    end

    top top (
        .clk      (clk),
        .rst_n    (rst_n),
        .int_timer(int_timer),
        .buttom   (buttom),
        .switch   (switch),
        .led      (led),
        .uart_rx  (uart_rx),
        .uart_tx  (uart_tx)
    );

endmodule

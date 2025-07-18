timescale 1ns/1ps

module tb_uart;
    reg clk;
    reg rst_n;
    reg [7:0] tx_data;
    reg tx_start;
    wire tx_ready;
    wire TXD;
    reg RXD;
    wire rx_ready;
    wire [7:0] rx_data;
    wire framing_error, parity_error, overrun_error;

    uart_top DUT (
        .clk(clk),
        .rst_n(rst_n),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx_ready(tx_ready),
        .TXD(TXD),
        .RXD(TXD), // loopback
        .rx_ready(rx_ready),
        .rx_data(rx_data),
        .framing_error(framing_error),
        .parity_error(parity_error),
        .overrun_error(overrun_error)
    );

    // Clock Generation
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz

    // VCD Dump
    initial begin
        $dumpfile("uart.vcd");
        $dumpvars(0, tb_uart);
    end

    // Test Sequence
    initial begin
        rst_n = 0; tx_data = 8'h00; tx_start = 0;
        #100 rst_n = 1;
        #100;
        send_byte(8'hA5);
        #200000;
        send_byte(8'h3C);
        #200000;
        $finish;
    end

    task send_byte(input [7:0] data);
        begin
            @(posedge clk);
            while (!tx_ready) @(posedge clk);
            tx_data = data;
            tx_start = 1;
            @(posedge clk);
            tx_start = 0;
        end
    endtask
endmodule

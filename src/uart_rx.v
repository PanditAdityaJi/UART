module uart_rx (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       RXD,
    input  wire       baud_tick,
    output reg        rx_ready,
    output reg [7:0]  rx_data,
    output reg        framing_error,
    output reg        parity_error,
    output reg        overrun_error
);
    reg        rx_busy;
    reg [3:0]  bit_cnt;
    reg [9:0]  rx_shift;
    reg        rxd_sync1, rxd_sync2;

    always @(posedge clk) begin
        rxd_sync1 <= RXD;
        rxd_sync2 <= rxd_sync1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_busy       <= 0;
            rx_ready      <= 0;
            framing_error <= 0;
            parity_error  <= 0;
            overrun_error <= 0;
            bit_cnt       <= 0;
        end else if (!rx_busy && !rxd_sync2) begin
            rx_busy <= 1;
            bit_cnt <= 0;
        end else if (baud_tick && rx_busy) begin
            rx_shift <= {rxd_sync2, rx_shift[9:1]};
            bit_cnt <= bit_cnt + 1;
            if (bit_cnt == 9) begin
                rx_busy <= 0;
                rx_data <= rx_shift[8:1];
                framing_error <= (rx_shift[0] != 1);
                rx_ready <= 1;
            end else begin
                rx_ready <= 0;
            end
        end else begin
            rx_ready <= 0;
        end
    end
endmodule

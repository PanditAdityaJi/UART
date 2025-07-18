module uart_top (
    input  wire clk,
    input  wire rst_n,
    input  wire [7:0] tx_data,
    input  wire       tx_start,
    output wire       tx_ready,
    output wire       TXD,
    input  wire       RXD,
    output wire       rx_ready,
    output wire [7:0] rx_data,
    output wire       framing_error,
    output wire       parity_error,
    output wire       overrun_error
);

    wire baud_tick;
    wire [15:0] baud_inc = 16'd87;

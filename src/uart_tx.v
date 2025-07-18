module uart_tx (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] tx_data,
    input  wire       tx_start,
    input  wire       baud_tick,
    output reg        tx_ready,
    output reg        TXD
);
    reg [3:0] bit_cnt;
    reg [9:0] tx_shift;
    reg       tx_active;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_ready  <= 1;
            tx_active <= 0;
            TXD       <= 1;
            bit_cnt   <= 0;
        end else begin
            if (tx_start && tx_ready) begin
                tx_shift <= {1'b1, tx_data, 1'b0};
                tx_active <= 1;
                tx_ready <= 0;
                bit_cnt <= 0;
            end else if (baud_tick && tx_active) begin
                TXD <= tx_shift[0];
                tx_shift <= {1'b1, tx_shift[9:1]};
                bit_cnt <= bit_cnt + 1;
                if (bit_cnt == 9) begin
                    tx_active <= 0;
                    tx_ready <= 1;
                end
            end
        end
    end
endmodule

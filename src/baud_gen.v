module baudgen (
    input  wire clk,
    input  wire rst_n,
    input  wire [15:0] baud_inc,
    output reg  baud_tick
);
    reg [15:0] acc;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc <= 16'h0000;
            baud_tick <= 1'b0;
        end else begin
            {baud_tick, acc} <= acc + baud_inc;
        end
    end
endmodule

// uart_tx.v
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

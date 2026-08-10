// ============================================================
// DESIGN : UART Transmitter FSM
// ============================================================

module uart_tx_fsm (
    input        clk,
    input        rst,
    input        start,
    input  [7:0]  data_in,

    output reg   tx,
    output reg   busy
);

    parameter IDLE  = 2'b00;
    parameter START = 2'b01;
    parameter DATA  = 2'b10;
    parameter STOP  = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    always @(posedge clk or posedge rst) begin

        if (rst) begin
            state     <= IDLE;
            bit_count <= 0;
            data_reg  <= 0;
            tx        <= 1;
            busy      <= 0;
        end

        else begin

            case (state)

                IDLE: begin
                    tx   <= 1;
                    busy <= 0;

                    if (start) begin
                        data_reg <= data_in;
                        state    <= START;
                        busy     <= 1;
                    end
                end

                START: begin
                    tx    <= 0;
                    state <= DATA;
                end

                DATA: begin
                    tx <= data_reg[bit_count];

                    if (bit_count == 3'd7) begin
                        bit_count <= 0;
                        state     <= STOP;
                    end
                    else begin
                        bit_count <= bit_count + 1;
                    end
                end

                STOP: begin
                    tx    <= 1;
                    state <= IDLE;
                    busy  <= 0;
                end

                default: begin
                    state <= IDLE;
                    tx    <= 1;
                    busy  <= 0;
                end

            endcase

        end
    end

endmodule


// ============================================================
// TB : UART Transmitter FSM
// ============================================================

module uart_tx_fsm_tb;

    reg       clk;
    reg       rst;
    reg       start;
    reg [7:0] data_in;

    wire      tx;
    wire      busy;

    uart_tx_fsm dut (
        .clk     (clk),
        .rst     (rst),
        .start   (start),
        .data_in (data_in),
        .tx      (tx),
        .busy    (busy)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin

        clk     = 0;
        rst     = 1;
        start   = 0;
        data_in = 8'b00000000;

        // Reset
        #10;
        rst = 0;

        // Send 10101010
        #10;
        data_in = 8'b10101010;
        start   = 1;

        #10;
        start = 0;

        // Wait for transmission
        #120;

        // Send another byte
        data_in = 8'b11001100;
        start   = 1;

        #10;
        start = 0;

        #120;

        $finish;

    end

endmodule

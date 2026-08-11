//======================================================
// SPI Master FSM
// Serial Peripheral Interface
// Data Width : 8-bit
// MSB First
//======================================================

module spi_master (
    input  wire       clk,
    input  wire       rst,
    input  wire       start,
    input  wire [7:0] tx_data,
    input  wire       miso,

    output reg        mosi,
    output reg        sclk,
    output reg        cs,
    output reg [7:0]  rx_data,
    output reg        busy,
    output reg        done
);

    //==================================================
    // FSM State Parameters
    //==================================================

    parameter IDLE  = 3'b000;
    parameter LOAD  = 3'b001;
    parameter CLK_H = 3'b010;
    parameter CLK_L = 3'b011;
    parameter DONE  = 3'b100;

    // Current FSM state
    reg [2:0] state;

    // Shift registers
    reg [7:0] tx_shift;
    reg [7:0] rx_shift;

    // Bit counter
    reg [2:0] bit_count;

    // FSM

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            state     <= IDLE;

            tx_shift  <= 8'b0;
            rx_shift  <= 8'b0;
            rx_data   <= 8'b0;

            bit_count <= 3'b0;

            mosi      <= 1'b0;
            sclk      <= 1'b0;
            cs        <= 1'b1;

            busy      <= 1'b0;
            done      <= 1'b0;

        end

        else begin

            case (state)

                // IDLE
            
                IDLE: begin

                    cs   <= 1'b1;
                    sclk <= 1'b0;
                    busy <= 1'b0;
                    done <= 1'b0;

                    if (start)
                        state <= LOAD;

                end

                // LOAD

                LOAD: begin

                    cs        <= 1'b0;
                    busy      <= 1'b1;

                    tx_shift  <= tx_data;
                    rx_shift  <= 8'b0;

                    bit_count <= 3'd7;

                    // Send MSB first
                    mosi <= tx_data[7];

                    state <= CLK_H;

                end


                //======================================
                // CLK_H
                // Rising edge of SPI clock
                //
                // Slave samples MOSI
                // Master samples MISO
                //======================================

                CLK_H: begin

                    sclk <= 1'b1;

                    // Receive MISO bit
                    rx_shift[bit_count] <= miso;

                    state <= CLK_L;

                end


                //======================================
                // CLK_L
                // Falling edge of SPI clock
                //
                // Prepare next MOSI bit
                //======================================

                CLK_L: begin

                    sclk <= 1'b0;

                    if (bit_count == 0) begin

                        state <= DONE;

                    end

                    else begin

                        bit_count <= bit_count - 1'b1;

                        tx_shift <= {tx_shift[6:0], 1'b0};

                        // Prepare next bit
                        mosi <= tx_shift[6];

                        state <= CLK_H;

                    end

                end

                // DONE
                // Transfer completed

                DONE: begin

                    cs      <= 1'b1;
                    sclk    <= 1'b0;

                    busy    <= 1'b0;
                    done    <= 1'b1;

                    rx_data <= rx_shift;

                    state <= IDLE;

                end

              default: begin

                    state <= IDLE;

                end

            endcase

        end

    end

//======================================================
// Testbench for SPI Master FSM
//======================================================

`timescale 1ns/1ps

module spi_master_tb;

    // Testbench Signals

    reg        clk;
    reg        rst;
    reg        start;

    reg [7:0]  tx_data;
    reg        miso;

    wire       mosi;
    wire       sclk;
    wire       cs;

    wire [7:0] rx_data;

    wire       busy;
    wire       done;

    // DUT
  
    spi_master uut (

        .clk(clk),
        .rst(rst),
        .start(start),

        .tx_data(tx_data),
        .miso(miso),

        .mosi(mosi),
        .sclk(sclk),
        .cs(cs),

        .rx_data(rx_data),

        .busy(busy),
        .done(done)

    );

    // Clock Generation

    always #5 clk = ~clk;

    // SPI Slave Data

    reg [7:0] slave_data;

    integer i;

    // Test Sequence

    initial begin

        // Initial values
        clk        = 1'b0;
        rst        = 1'b1;
        start      = 1'b0;

        tx_data    = 8'b10101010;
        miso       = 1'b0;

        slave_data = 8'b11001100;


        // Reset
        #20;
        rst = 1'b0;


        // Start SPI transfer
        #10;
        start = 1'b1;

        #10;
        start = 1'b0;

        // SPI Slave
        // Send data MSB first


        for (i = 7; i >= 0; i = i - 1) begin

            @(negedge sclk);

            miso = slave_data[i];

        end


        // Wait until transfer completes
        wait(done);


        // Display results
        #10;

        $display("-----------------------------------------");
        $display("       SPI MASTER FSM SIMULATION");
        $display("-----------------------------------------");

        $display("TX DATA  = %b", tx_data);
        $display("RX DATA  = %b", rx_data);

        $display("MOSI     = %b", mosi);
        $display("MISO     = %b", miso);

        $display("CS       = %b", cs);
        $display("SCLK     = %b", sclk);

        $display("BUSY     = %b", busy);
        $display("DONE     = %b", done);

        $display("-----------------------------------------");


        #20;
        $finish;

    end

endmodule
endmodule

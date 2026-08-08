//==============================================================
// Washing Machine Controller using FSM
//==============================================================

module washing_machine (
    input  wire clk,
    input  wire reset,
    input  wire start,

    output reg water_in,
    output reg wash,
    output reg drain,
    output reg spin,
    output reg done
);

    // State Declaration

    parameter IDLE  = 3'b000;
    parameter FILL  = 3'b001;
    parameter WASH  = 3'b010;
    parameter DRAIN = 3'b011;
    parameter SPIN  = 3'b100;
    parameter DONE  = 3'b101;

    reg [2:0] state, next_state;

    // State Register

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next State Logic

    always @(*) begin

        case (state)

            IDLE: begin
                if (start)
                    next_state = FILL;
                else
                    next_state = IDLE;
            end

            FILL: begin
                next_state = WASH;
            end

            WASH: begin
                next_state = DRAIN;
            end

            DRAIN: begin
                next_state = SPIN;
            end

            SPIN: begin
                next_state = DONE;
            end

            DONE: begin
                next_state = IDLE;
            end

            default:
                next_state = IDLE;

        endcase
    end

    // Output Logic

    always @(*) begin

        // Default outputs
        water_in = 1'b0;
        wash     = 1'b0;
        drain    = 1'b0;
        spin     = 1'b0;
        done     = 1'b0;

        case (state)

            IDLE: begin
                // Machine waiting for start
            end

            FILL: begin
                water_in = 1'b1;
            end

            WASH: begin
                wash = 1'b1;
            end

            DRAIN: begin
                drain = 1'b1;
            end

            SPIN: begin
                spin = 1'b1;
            end

            DONE: begin
                done = 1'b1;
            end

            default: begin
                water_in = 1'b0;
                wash     = 1'b0;
                drain    = 1'b0;
                spin     = 1'b0;
                done     = 1'b0;
            end

        endcase
    end

  `timescale 1ns/1ps

//==============================================================
// Testbench for Washing Machine Controller
//==============================================================

module washing_machine_tb;

    // Testbench Signals

    reg clk;
    reg reset;
    reg start;

    wire water_in;
    wire wash;
    wire drain;
    wire spin;
    wire done;

    // DUT Instantiation

    washing_machine uut (
        .clk(clk),
        .reset(reset),
        .start(start),

        .water_in(water_in),
        .wash(wash),
        .drain(drain),
        .spin(spin),
        .done(done)
    );

    // Clock Generation
    // 10 ns clock period

    always #5 clk = ~clk;

    // Test Sequence

    initial begin

        // Initialize signals
        clk   = 1'b0;
        reset = 1'b1;
        start = 1'b0;

        // Apply reset
        #10;
        reset = 1'b0;

        // Start washing machine
        #10;
        start = 1'b1;

        #10;
        start = 1'b0;

        // Allow complete washing cycle
        #70;

        // Reset machine
        reset = 1'b1;
        #10;
        reset = 1'b0;

        #20;

        $finish;
    end

    // Monitor Outputs

    initial begin
        $monitor(
            "Time=%0t | Reset=%b Start=%b | Water=%b Wash=%b Drain=%b Spin=%b Done=%b",
            $time,
            reset,
            start,
            water_in,
            wash,
            drain,
            spin,
            done
        );
    end

endmodule

endmodule

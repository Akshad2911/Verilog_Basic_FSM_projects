//==============================================================
// Mealy FSM Sequence Detector (Detects 1011)
//==============================================================

module mealy_fsm (
    input  wire clk,
    input  wire reset,
    input  wire x,
    output reg  y
);

    // State Encoding
    parameter S0 = 2'b00;  // Initial State
    parameter S1 = 2'b01;  // Detected '1'
    parameter S2 = 2'b10;  // Detected '10'
    parameter S3 = 2'b11;  // Detected '101'

    reg [1:0] state, next_state;

    // State Register

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next State Logic and Output Logic (Mealy)

    always @(*) begin
        next_state = state;
        y = 1'b0;

        case (state)

            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S2;
            end

            S2: begin
                if (x)
                    next_state = S3;
                else
                    next_state = S0;
            end

            S3: begin
                if (x) begin
                    next_state = S1;
                    y = 1'b1;      // Sequence 1011 detected
                end
                else
                    next_state = S2;
            end

            default: begin
                next_state = S0;
                y = 1'b0;
            end

        endcase
    end

endmodule

`timescale 1ns/1ps

module mealy_fsm_tb;

    reg clk;
    reg reset;
    reg x;
    wire y;

    mealy_fsm uut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y)
    );

    // Clock Generation (10 ns period)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        x = 0;

        #10 reset = 0;

        // Input Sequence: 1 0 1 1 (Detected)
        x=1; #10;
        x=0; #10;
        x=1; #10;
        x=1; #10;

        // Input Sequence: 0 1 0 1 1 (Detected again)
        x=0; #10;
        x=1; #10;
        x=0; #10;
        x=1; #10;
        x=1; #10;

        #20;
        $finish;
    end

    initial begin
        $display("Time\tState_Input\tOutput");
        $monitor("%0t\t%b\t\t%b", $time, x, y);
    end

endmodule

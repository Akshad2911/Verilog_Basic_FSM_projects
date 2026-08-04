// Moore Finite State Machine (FSM)

module moore_fsm (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  out
);

    // State Declaration
    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    parameter S3 = 2'b11;

    reg [1:0] state, next_state;

    // State Register

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next State Logic
 
    always @(*) begin
        case (state)
            S0: begin
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                if (in)
                    next_state = S2;
                else
                    next_state = S0;
            end

            S2: begin
                if (in)
                    next_state = S3;
                else
                    next_state = S0;
            end

            S3: begin
                if (in)
                    next_state = S3;
                else
                    next_state = S0;
            end

            default: next_state = S0;
        endcase
    end

    // Output Logic (Moore FSM)
  
    always @(*) begin
        case (state)
            S0: out = 1'b0;
            S1: out = 1'b0;
            S2: out = 1'b0;
            S3: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule

//==============================================================
// Testbench for Moore FSM
//==============================================================

`timescale 1ns/1ps

module moore_fsm_tb;

    reg clk;
    reg reset;
    reg in;
    wire out;

    // Instantiate DUT
    moore_fsm uut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .out(out)
    );

    // Clock Generation (10 ns period)
    always #5 clk = ~clk;

    initial begin
        $display("-------------------------------------------------");
        $display("Time\tReset\tIn\tState Output");
        $display("-------------------------------------------------");
        $monitor("%0t\t%b\t%b\t%b",
                 $time, reset, in, out);

        clk = 0;
        reset = 1;
        in = 0;

        #10 reset = 0;

        // Apply inputs
        #10 in = 1;
        #10 in = 1;
        #10 in = 1;   // Output becomes 1 after entering S3
        #10 in = 1;
        #10 in = 0;   // Return to S0
        #10 in = 1;
        #10 in = 1;
        #10 in = 0;

        #20 $finish;
    end

endmodule

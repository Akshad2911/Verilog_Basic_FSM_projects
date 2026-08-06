//==============================================================
// Vending Machine Controller using Moore FSM
//==============================================================

module vending_machine(
    input clk,
    input reset,
    input coin5,
    input coin10,
    output reg dispense
);

    // State encoding
    parameter S0  = 2'b00; // ₹0
    parameter S5  = 2'b01; // ₹5
    parameter S10 = 2'b10; // ₹10
    parameter S15 = 2'b11; // ₹15 (Dispense)

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
        next_state = state;

        case(state)
            S0: begin
                if (coin5)
                    next_state = S5;
                else if (coin10)
                    next_state = S10;
            end

            S5: begin
                if (coin5)
                    next_state = S10;
                else if (coin10)
                    next_state = S15;
            end

            S10: begin
                if (coin5 || coin10)
                    next_state = S15;
            end

            S15: begin
                next_state = S0;
            end

            default: next_state = S0;
        endcase
    end

    // Output Logic
    always @(*) begin
        if (state == S15)
            dispense = 1'b1;
        else
            dispense = 1'b0;
    end

endmodule

//==============================================================
// Testbench for Vending Machine Controller using Moore FSM
//==============================================================

module vending_machine_tb;

reg clk, reset;
reg coin5, coin10;
wire dispense;

vending_machine uut(
    .clk(clk),
    .reset(reset),
    .coin5(coin5),
    .coin10(coin10),
    .dispense(dispense)
);

// Clock Generation
always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    coin5 = 0;
    coin10 = 0;

    #10 reset = 0;

    // Insert ₹5
    #10 coin5 = 1;
    #10 coin5 = 0;

    // Insert ₹10
    #10 coin10 = 1;
    #10 coin10 = 0;

    // Wait
    #20;

    // Insert ₹10
    #10 coin10 = 1;
    #10 coin10 = 0;

    // Insert ₹5
    #10 coin5 = 1;
    #10 coin5 = 0;

    #30 $finish;
end

initial begin
    $monitor("Time=%0t State=%b coin5=%b coin10=%b dispense=%b",
             $time, uut.state, coin5, coin10, dispense);
end

endmodule

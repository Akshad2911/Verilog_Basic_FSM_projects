//==============================================================
// Project : Smart Shoe
//==============================================================

module smart_shoe (
    input  wire clk,
    input  wire reset,
    input  wire obstacle,
    input  wire pressure,
    input  wire low_battery,

    output reg  led,
    output reg buzzer,
    output reg vibration
);

    // State Declaration

    parameter IDLE       = 2'b00;
    parameter WALKING    = 2'b01;
    parameter OBSTACLE  = 2'b10;
    parameter LOW_BATT   = 2'b11;

    reg [1:0] state, next_state;

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
                if (low_battery)
                    next_state = LOW_BATT;
                else if (obstacle)
                    next_state = OBSTACLE;
                else if (pressure)
                    next_state = WALKING;
                else
                    next_state = IDLE;
            end

            WALKING: begin
                if (low_battery)
                    next_state = LOW_BATT;
                else if (obstacle)
                    next_state = OBSTACLE;
                else if (!pressure)
                    next_state = IDLE;
                else
                    next_state = WALKING;
            end

            OBSTACLE: begin
                if (low_battery)
                    next_state = LOW_BATT;
                else if (!obstacle)
                    next_state = IDLE;
                else
                    next_state = OBSTACLE;
            end

            LOW_BATT: begin
                if (!low_battery)
                    next_state = IDLE;
                else
                    next_state = LOW_BATT;
            end

            default:
                next_state = IDLE;

        endcase

    end

    // Output Logic

    always @(*) begin

        // Default outputs
        led       = 1'b0;
        buzzer    = 1'b0;
        vibration = 1'b0;

        case (state)

            // No activity
            IDLE: begin
                led = 1'b0;
            end

            // User is walking
            WALKING: begin
                led = 1'b1;
            end

            // Obstacle detected
            OBSTACLE: begin
                led       = 1'b1;
                buzzer    = 1'b1;
                vibration = 1'b1;
            end

            // Battery is low
            LOW_BATT: begin
                led    = 1'b1;
                buzzer = 1'b1;
            end

            default: begin
                led       = 1'b0;
                buzzer    = 1'b0;
                vibration = 1'b0;
            end

        endcase

    end

endmodule

`timescale 1ns/1ps

//==============================================================
// Testbench : Smart Shoe
//==============================================================

module smart_shoe_tb;

    // Inputs
    reg clk;
    reg reset;
    reg obstacle;
    reg pressure;
    reg low_battery;

    // Outputs
    wire led;
    wire buzzer;
    wire vibration;

    // Instantiate Smart Shoe

    smart_shoe uut (
        .clk(clk),
        .reset(reset),
        .obstacle(obstacle),
        .pressure(pressure),
        .low_battery(low_battery),
        .led(led),
        .buzzer(buzzer),
        .vibration(vibration)
    );

    // Clock Generation

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Test Sequence

    initial begin

        // Initialize inputs
        reset       = 1'b1;
        obstacle    = 1'b0;
        pressure    = 1'b0;
        low_battery = 1'b0;

        // Reset
        #10;
        reset = 1'b0;

        // Test 1: IDLE
      
        #10;
        pressure = 1'b0;
        obstacle = 1'b0;
        low_battery = 1'b0;

        // Test 2: Walking
      
        #10;
        pressure = 1'b1;
      
        // Test 3: Obstacle Detected
      
        #20;
        obstacle = 1'b1;

  
        // Test 4: Obstacle Removed
      
        #20;
        obstacle = 1'b0;

        // Test 5: Stop Walking

        #20;
        pressure = 1'b0;

        // Test 6: Low Battery

        #20;
        low_battery = 1'b1;

        // Test 7: Battery Restored

        #20;
        low_battery = 1'b0;

        // End simulation
        #20;
        $finish;

    end

    // Monitor
 

    initial begin
        $monitor("Time=%0t | Reset=%b | Pressure=%b | Obstacle=%b | Low_Battery=%b | LED=%b | Buzzer=%b | Vibration=%b",
                 $time, reset, pressure, obstacle, low_battery,
                 led, buzzer, vibration);
    end

endmodule

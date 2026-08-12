// ============================================================
// DESIGN : ATM Controller
// ============================================================

module atm_controller (
    input clk,
    input rst,
    input enter,
    input [15:0] pin,
    input [1:0] option,
    input [15:0] amount,

    output reg [15:0] balance,
    output reg authenticated,
    output reg transaction_done,
    output reg insufficient_funds
);

    reg [2:0] state;

    parameter IDLE     = 3'b000;
    parameter PIN      = 3'b001;
    parameter MENU     = 3'b010;
    parameter WITHDRAW = 3'b011;
    parameter DEPOSIT  = 3'b100;
    parameter BALANCE  = 3'b101;

    parameter WITHDRAW_OP = 2'b01;
    parameter DEPOSIT_OP  = 2'b10;
    parameter BALANCE_OP  = 2'b11;

    parameter CORRECT_PIN = 16'd1234;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state              <= IDLE;
            balance            <= 16'd1000;
            authenticated      <= 0;
            transaction_done   <= 0;
            insufficient_funds <= 0;
        end
        else begin
            transaction_done   <= 0;
            insufficient_funds <= 0;

            case (state)

                IDLE: begin
                    if (enter)
                        state <= PIN;
                end

                PIN: begin
                    if (enter) begin
                        if (pin == CORRECT_PIN) begin
                            authenticated <= 1;
                            state <= MENU;
                        end
                        else begin
                            authenticated <= 0;
                            state <= IDLE;
                        end
                    end
                end

                MENU: begin
                    if (enter) begin
                        case (option)
                            WITHDRAW_OP: state <= WITHDRAW;
                            DEPOSIT_OP : state <= DEPOSIT;
                            BALANCE_OP : state <= BALANCE;
                            default    : state <= MENU;
                        endcase
                    end
                end

                WITHDRAW: begin
                    if (enter) begin
                        if (amount <= balance) begin
                            balance <= balance - amount;
                            transaction_done <= 1;
                        end
                        else begin
                            insufficient_funds <= 1;
                        end

                        state <= IDLE;
                    end
                end

                DEPOSIT: begin
                    if (enter) begin
                        balance <= balance + amount;
                        transaction_done <= 1;
                        state <= IDLE;
                    end
                end

                BALANCE: begin
                    if (enter) begin
                        transaction_done <= 1;
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;

            endcase
        end
    end

endmodule


// ============================================================
// TESTBENCH
// ============================================================

module atm_controller_tb;

    reg clk;
    reg rst;
    reg enter;
    reg [15:0] pin;
    reg [1:0] option;
    reg [15:0] amount;

    wire [15:0] balance;
    wire authenticated;
    wire transaction_done;
    wire insufficient_funds;

    atm_controller dut (
        .clk(clk),
        .rst(rst),
        .enter(enter),
        .pin(pin),
        .option(option),
        .amount(amount),
        .balance(balance),
        .authenticated(authenticated),
        .transaction_done(transaction_done),
        .insufficient_funds(insufficient_funds)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;
        enter = 0;
        pin = 0;
        option = 0;
        amount = 0;

        #10 rst = 0;

        // Login
        #10 enter = 1;
        #10 enter = 0;

        pin = 16'd1234;
        #10 enter = 1;
        #10 enter = 0;

        // Withdraw ₹300
        option = 2'b01;
        #10 enter = 1;
        #10 enter = 0;

        amount = 16'd300;
        #10 enter = 1;
        #10 enter = 0;

        // Login again
        #10 enter = 1;
        #10 enter = 0;

        pin = 16'd1234;
        #10 enter = 1;
        #10 enter = 0;

        // Deposit ₹500
        option = 2'b10;
        #10 enter = 1;
        #10 enter = 0;

        amount = 16'd500;
        #10 enter = 1;
        #10 enter = 0;

        // Login again
        #10 enter = 1;
        #10 enter = 0;

        pin = 16'd1234;
        #10 enter = 1;
        #10 enter = 0;

        // Balance inquiry
        option = 2'b11;
        #10 enter = 1;
        #10 enter = 0;

        #10 enter = 1;
        #10 enter = 0;

        #20;

        $display("Final Balance = %d", balance);

        $finish;
    end

endmodule

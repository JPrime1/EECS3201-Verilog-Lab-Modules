// purpose: control overall ATM system flow using finite state machine
// handles transitions between PIN entry, menu, and transaction states

module ATMStateFSM(
    input clk,              // clock input (50 MHz)
    input rst,              // synchronous reset
    input enterPulse,       // ENTER button pulse (action confirm)
    input nextPulse,        // NEXT button pulse (menu navigation / back)
    input pinValid,         // signal indicating correct PIN entry
    input pinFail,          // signal indicating incorrect PIN entry
    input timeout,          // signal indicating PIN entry timeout
    input [2:0] menuIndex,  // input from menu register to select menu options
    input [9:0] amount,     // transaction amount (from InputRegister)
    input [9:0] balance,    // current balance (from BalanceRegister)

    output reg depositEn,   // enables deposit operation in BalanceRegister
    output reg withdrawEn,  // enables withdraw operation in BalanceRegister
    output reg txnSuccess,  // high when transaction succeeds
    output reg txnError,    // high when transaction fails
    output reg [3:0] state,  // current system state for display/control
    output reg inMenuState   // indicates when system is in MENU - fix indexing
);

    // state encoding (3-bit FSM states)
    localparam IDLE      = 3'd0;    // system idle / startup (acts as locked entry point)
    localparam PIN_ENTRY = 3'd1;    // PIN input state
    localparam MENU      = 3'd2;    // main menu selection state
    localparam DEPOSIT   = 3'd3;    // deposit transaction state
    localparam WITHDRAW  = 3'd4;    // withdraw transaction state
    localparam BALANCE   = 3'd5;    // balance display state
    localparam LOCKED    = 3'd6;    // locked state after failed PIN attempts
    localparam PIN_SET   = 3'd7;    // PIN set state

    reg [3:0] currentState;
    reg [3:0] nextState;

    // sequential state update block
    always @(posedge clk) begin

        // synchronous reset brings system back to IDLE
        if (rst) begin
            currentState <= IDLE;
        end
        else begin
            currentState <= nextState;
        end

    end

    // combinational next-state logic + output logic
    always @(*) begin

        nextState = currentState;   // default hold state

        depositEn = 1'b0;           // default: no deposit
        withdrawEn = 1'b0;          // default: no withdraw
        txnSuccess = 1'b0;          // default: no success signal
        txnError = 1'b0;            // default: no error signal

        case (currentState)

            IDLE: begin
                // system starts here (acts as locked default state)
                nextState = PIN_ENTRY;
            end

            PIN_ENTRY: begin
                if (pinValid) begin
                    nextState = MENU;
                end
                else if (pinFail) begin
                    nextState = LOCKED;
                end
                else if (timeout) begin
                    nextState = IDLE;
                end
            end

            LOCKED: begin
                // locked state holds until reset (or future extension)
                nextState = LOCKED;
            end

            PIN_SET: begin
                if (enterPulse) begin
                    nextState = MENU; // fixed: safe return after PIN update
                end
                else begin
                    nextState = PIN_SET;
                end
            end

            MENU: begin
                if (enterPulse) begin
                    case (menuIndex)

                        3'd0: nextState = BALANCE;
                        3'd1: nextState = DEPOSIT;
                        3'd2: nextState = WITHDRAW;
                        3'd3: nextState = PIN_SET;
                        3'd4: nextState = LOCKED;

                        default: nextState = MENU;

                    endcase
                end
            end

            BALANCE: begin
                if (nextPulse) begin
                    nextState = MENU;
                end
                else begin
                    nextState = BALANCE;
                end
            end

            DEPOSIT: begin

                if (enterPulse) begin
                    depositEn = 1'b1;
                    txnSuccess = 1'b1;
                    nextState = MENU;
                end
                else if (nextPulse) begin
                    nextState = MENU;
                end
                else begin
                    nextState = DEPOSIT;
                end

            end

            WITHDRAW: begin

                if (enterPulse && (balance >= amount)) begin
                    withdrawEn = 1'b1;
                    txnSuccess = 1'b1;
                    nextState = MENU;
                end
                else if (enterPulse && (balance < amount)) begin
                    txnError = 1'b1;
                    nextState = WITHDRAW;
                end
                else if (nextPulse) begin
                    nextState = MENU;
                end
                else begin
                    nextState = WITHDRAW;
                end

            end

            default: begin
                nextState = IDLE;
            end

        endcase
    end

    // output current state to system/display
    always @(*) begin
        state = currentState;
        inMenuState = (currentState == MENU);  // menu gate signal
    end

endmodule
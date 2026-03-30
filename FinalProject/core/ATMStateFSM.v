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
    output reg [2:0] state  // current system state for display/control
);

    // state encoding (3-bit FSM states)
    localparam IDLE      = 3'd0;    // system idle / startup
    localparam PIN_ENTRY = 3'd1;    // PIN input state
    localparam MENU      = 3'd2;    // main menu selection state
    localparam DEPOSIT   = 3'd3;    // deposit transaction state
    localparam WITHDRAW  = 3'd4;    // withdraw transaction state
    localparam BALANCE   = 3'd5;    // balance display state
    localparam LOCKED    = 3'd6;    // locked state after failed PIN attempts

    reg [2:0] currentState;         // holds current FSM state
    reg [2:0] nextState;            // holds next FSM state logic result

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

        case (currentState)

            IDLE: begin
                // system boots directly into PIN entry
                nextState = PIN_ENTRY;
            end

            PIN_ENTRY: begin

                // correct PIN → go to menu
                if (pinValid) begin
                    nextState = MENU;
                end

                // incorrect PIN → lock system
                else if (pinFail) begin
                    nextState = LOCKED;
                end

                // timeout → restart system
                else if (timeout) begin
                    nextState = IDLE;
                end

            end

            MENU: begin

                // only act when user confirms selection
                if (enterPulse) begin
                    case (menuIndex)

                        3'd0: nextState = BALANCE;  // view balance
                        3'd1: nextState = DEPOSIT;  // deposit money
                        3'd2: nextState = WITHDRAW; // withdraw money
                        3'd3: nextState = PIN_ENTRY;// re-enter PIN
                        3'd4: nextState = IDLE;     // exit system

                        default: nextState = MENU;  // invalid index safe fallback

                    endcase
                end

            end

            BALANCE: begin

                // return to menu on NEXT
                if (nextPulse) begin
                    nextState = MENU;
                end

            end

            DEPOSIT: begin

                // enable deposit only on ENTER press
                depositEn = enterPulse;

                // return to menu on NEXT
                if (nextPulse) begin
                    nextState = MENU;
                end

            end

            WITHDRAW: begin

                // allow withdraw only if enough balance exists
                if (enterPulse && (balance >= amount)) begin
                    withdrawEn = 1'b1;
                end
                else begin
                    withdrawEn = 1'b0;
                end

                // return to menu on NEXT
                if (nextPulse) begin
                    nextState = MENU;
                end

            end

            LOCKED: begin
                // system remains locked until external reset
                nextState = LOCKED;
            end

            default: begin
                // safety fallback state
                nextState = IDLE;
            end

        endcase
    end

    // output current state to system/display
    always @(*) begin
        state = currentState;
    end

endmodule
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
    input lockTimeout,      // NEW: lock timer finished signal
    input [2:0] menuIndex,  // input from menu register to select menu options
    input [9:0] amount,     // transaction amount (from InputRegister)
    input [9:0] balance,    // current balance (from BalanceRegister)

    output reg depositEn,   // enables deposit operation in BalanceRegister
    output reg withdrawEn,  // enables withdraw operation in BalanceRegister
    output reg txnSuccess,  // high when transaction succeeds
    output reg txnError,    // high when transaction fails
    output reg [3:0] state, // current system state for display/control
    output reg inMenuState, // indicates when system is in MENU

    output reg [9:0] lastDeposit,   // last successful deposit amount
    output reg [9:0] lastWithdraw,  // last successful withdraw amount

    output reg loadPin,     // enables storing new PIN

    output reg inLock,      // NEW: indicates LOCK state
    output reg lockStart    // NEW: 1-cycle pulse to start lock timer
);

    // state encoding (3-bit FSM states)
    localparam IDLE      = 3'd0;
    localparam PIN_ENTRY = 3'd1;
    localparam MENU      = 3'd2;
    localparam DEPOSIT   = 3'd3;
    localparam WITHDRAW  = 3'd4;
    localparam BALANCE   = 3'd5;
    localparam LOCKED    = 3'd6;
    localparam PIN_SET   = 3'd7;

    reg [3:0] currentState;
    reg [3:0] nextState;

    // sequential state update block
    always @(posedge clk) begin

        if (rst) begin
            currentState <= IDLE;
            lastDeposit <= 10'd0;
            lastWithdraw <= 10'd0;
        end
        else begin
            currentState <= nextState;

            // store last successful deposit
            if (depositEn)
                lastDeposit <= amount;

            // store last successful withdraw
            if (withdrawEn)
                lastWithdraw <= amount;
        end
    end

    // combinational next-state logic + output logic
    always @(*) begin

        nextState = currentState;   // default hold state

        depositEn = 1'b0;           // default: no deposit
        withdrawEn = 1'b0;          // default: no withdraw
        txnSuccess = 1'b0;          // default: no success signal
        txnError = 1'b0;            // default: no error signal
        loadPin = 1'b0;             // default: do not update PIN
        lockStart = 1'b0;           // default: do not start lock timer
        inLock = 1'b0;              // default: not in lock state

        case (currentState)

            IDLE: begin
                // system starts here (acts as locked default state)
                nextState = PIN_ENTRY;
            end

            PIN_ENTRY: begin
                if (pinValid) nextState = MENU;
                else if (pinFail) nextState = LOCKED;
                else if (timeout) nextState = IDLE;
            end

            LOCKED: begin
                // locked state holds until timer expires
                inLock = 1'b1;

                if (lockTimeout)
                    nextState = IDLE;
                else
                    nextState = LOCKED;
            end

            PIN_SET: begin
                // store new PIN on ENTER
                if (enterPulse) begin
                    loadPin = 1'b1;
                    nextState = MENU;
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
                if (nextPulse) nextState = MENU;
                else nextState = BALANCE;
            end

            DEPOSIT: begin
                if (enterPulse) begin
                    depositEn = 1'b1;
                    txnSuccess = 1'b1;
                    nextState = MENU;
                end
                else if (nextPulse) nextState = MENU;
                else nextState = DEPOSIT;
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
                else if (nextPulse) nextState = MENU;
                else nextState = WITHDRAW;
            end

            default: begin
                nextState = IDLE;
            end

        endcase
    end

    // output state
    always @(*) begin
        state = currentState;
        inMenuState = (currentState == MENU);
    end

endmodule
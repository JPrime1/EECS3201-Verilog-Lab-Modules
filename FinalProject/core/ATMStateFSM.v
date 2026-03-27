// purpose: control overall ATM system flow using finite state machine
// handles transitions between PIN entry, menu, and transaction states

module ATMStateFSM(
    input clk,              // clock input (50 MHz)
    input rst,              // synchronous reset
    input pinValid,         // signal indicating correct PIN entry
    input pinFail,          // signal indicating incorrect PIN entry
    input timeout,          // signal indicating PIN entry timeout
    input [2:0] menuIndex,  // input from menu register to select menu options
    output reg [2:0] state  // 3-bit state output to control display and other modules
);

    // state encoding
    localparam IDLE      = 3'd0;
    localparam PIN_ENTRY = 3'd1;
    localparam MENU      = 3'd2;
    localparam DEPOSIT   = 3'd3;
    localparam WITHDRAW  = 3'd4;
    localparam BALANCE   = 3'd5;
    localparam LOCKED    = 3'd6;

    always @(posedge clk) begin

        // reset system to idle state
        if (rst) begin
            state <= IDLE;
        end

        else begin

            case (state)

                IDLE: begin
                    state <= PIN_ENTRY;
                end

                PIN_ENTRY: begin
                    if (pinValid) begin
                        state <= MENU;
                    end
                    else if (pinFail) begin
                        state <= LOCKED;
                    end
                    else if (timeout) begin
                        state <= IDLE;
                    end
                end

                MENU: begin
                    case (menuIndex)

                        3'd0: state <= BALANCE;
                        3'd1: state <= DEPOSIT;
                        3'd2: state <= WITHDRAW;
                        3'd3: state <= PIN_ENTRY; // PIN change (simplified for now)
                        3'd4: state <= IDLE;

                        default: state <= MENU;

                    endcase
                end

                BALANCE: state <= MENU;
                DEPOSIT: state <= MENU;
                WITHDRAW: state <= MENU;

                LOCKED: state <= LOCKED;

                default: state <= IDLE;

            endcase

        end

    end

endmodule
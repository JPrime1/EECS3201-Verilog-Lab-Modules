// Based off lab03 display driver, but significantly expanded for final project
// purpose: display system state, balance, and transaction information on 7-seg displays
// replaces simple switch display with FSM-driven output

module ATMDisplayDriver(
    input [2:0] state,      // current FSM state
    input [2:0] menuIndex,  // current menu selection
    input [9:0] balance,    // current account balance
    input [9:0] amount,     // current input amount
    input txnSuccess,       // transaction success pulse
    input txnError,         // transaction error pulse

    output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 // 6 displays
);

    // state encoding (must match FSM)
    localparam IDLE      = 3'd0;
    localparam PIN_ENTRY = 3'd1;
    localparam MENU      = 3'd2;
    localparam DEPOSIT   = 3'd3;
    localparam WITHDRAW  = 3'd4;
    localparam BALANCE   = 3'd5;
    localparam LOCKED    = 3'd6;

    reg [23:0] displayValue; // 6 hex digits (4 bits each)

    always @(*) begin

        // default blank display
        displayValue = 24'hFFFFFF;

        // show success message (highest priority)
        if (txnSuccess) begin
            displayValue = 24'h0D0E0E; // crude "donE"
        end

        // show error message
        else if (txnError) begin
            displayValue = 24'h0E0A0A; // crude "Err"
        end

        else begin
            case (state)

                MENU: begin
                    // show menu index
                    displayValue[3:0] = menuIndex;
                end

                BALANCE: begin
                    // show balance (lower digits only for now)
                    displayValue[9:0] = balance;
                end

                DEPOSIT: begin
                    // show input amount
                    displayValue[9:0] = amount;
                end

                WITHDRAW: begin
                    // show input amount
                    displayValue[9:0] = amount;
                end

                LOCKED: begin
                    displayValue = 24'h0A0C0C; // crude "LOC"
                end

                default: begin
                    displayValue = 24'hFFFFFF;
                end

            endcase
        end

    end

    // map 6 hex digits to displays
    hex_display_decoder d0(.in(displayValue[3:0]),   .hex_out(HEX0));
    hex_display_decoder d1(.in(displayValue[7:4]),   .hex_out(HEX1));
    hex_display_decoder d2(.in(displayValue[11:8]),  .hex_out(HEX2));
    hex_display_decoder d3(.in(displayValue[15:12]), .hex_out(HEX3));
    hex_display_decoder d4(.in(displayValue[19:16]), .hex_out(HEX4));
    hex_display_decoder d5(.in(displayValue[23:20]), .hex_out(HEX5));

endmodule
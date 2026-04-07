// purpose: ATM display driver
// converts FSM state and system values into 7-segment output using charEncoder

module ATMDisplayDriver(
    input [3:0] state,        // FSM state
    input [2:0] menuIndex,    // menu selection index
    input [9:0] lastDeposit,  // NEW: last successful deposit amount (for future display use)
    input [9:0] lastWithdraw, // NEW: last successful withdraw amount (for future display use)
    input [9:0] balance,      // account balance
    input [9:0] amount,       // transaction amount
    input txnSuccess,         // transaction success flag
    input txnError,           // transaction error flag

    input [2:0] lockSeconds,
    input [2:0] attemptCount,

    output [7:0] HEX0,
    output [7:0] HEX1,
    output [7:0] HEX2,
    output [7:0] HEX3,
    output [7:0] HEX4,
    output [7:0] HEX5
);

    // internal character codes (5-bit IDs)
    reg [4:0] d0, d1, d2, d3, d4, d5;

    // digit extraction (0–99 safe display)
    reg [3:0] bal_tens, bal_ones;
    reg [3:0] amt_tens, amt_ones;

    always @(*) begin

        // default blank
        d0 = 5'h1E;
        d1 = 5'h1E;
        d2 = 5'h1E;
        d3 = 5'h1E;
        d4 = 5'h1E;
        d5 = 5'h1E;

        // 2-digit split (00–99 only)
        // balance digits
        bal_tens = (balance % 100) / 10;
        bal_ones = balance % 10;

        // amount digits (live switch input)
        amt_tens = (amount % 100) / 10;
        amt_ones = amount % 10;

        // PRIORITY OVERRIDE: TRANSACTION FEEDBACK
        if (txnError) begin
            d5 = 5'h0E; // E
            d4 = 5'h16; // R
            d3 = 5'h16; // R
            d2 = 5'h1E;
            d1 = 5'h1E;
            d0 = 5'h1E;
        end
        else if (txnSuccess) begin
            d5 = 5'h14; // O
            d4 = 5'h0B; // K=B
            d3 = 5'h1E;
            d2 = 5'h1E;
            d1 = 5'h1E;
            d0 = 5'h1E;
        end
        else begin            
            case (state)

                // PIN state
                3'd1: begin
                    d5 = 5'h15; // P
                    d4 = 5'h10; // I
                    d3 = 5'h13; // N

                    d2 = lockSeconds;     // countdown timer
                    d1 = 5'h1E;          // blank
                    d0 = attemptCount;   // attempts
                end

                // SET PIN screen: clear instruction to user
                3'd7: begin                    
                    d5 = 5'h05; // S
                    d4 = 5'h0E; // E
                    d3 = 5'h1E; // Blank
                    d2 = 5'h15; // P
                    d1 = 5'h10; // I
                    d0 = 5'h13; // N
                end

                // MENU state
                3'd2: begin
                    case(menuIndex)

                        // BALANCE
                        3'd0: begin
                            d5 = 5'h0B; // B
                            d4 = 5'h0A; // A
                            d3 = 5'h11; // L
                            d2 = 5'h1E;
                            d1 = 5'h1E;
                            d0 = 5'h1E;
                        end

                        // DEPOSIT
                        3'd1: begin
                            d5 = 5'h0D; // D
                            d4 = 5'h0E; // E
                            d3 = 5'h15; // P
                            d2 = 5'h1E;
                            d1 = 5'h1E;
                            d0 = 5'h1E;
                        end

                        // WITHDRAW
                        3'd2: begin
                            d5 = 5'h18; // -
                            d4 = 5'h0D; // D
                            d3 = 5'h16; // R
                            d2 = 5'h1E;
                            d1 = 5'h1E;
                            d0 = 5'h1E;
                        end

                        // PIN_SET
                        3'd3: begin
                            d5 = 5'h15; // P
                            d4 = 5'h10; // I
                            d3 = 5'h13; // N
                            d2 = 5'h18; // -
                            d1 = 5'h05; // S
                            d0 = 5'h15; // P
                        end

                        // LOCKED
                        3'd4: begin
                            d5 = 5'h11; // L
                            d4 = 5'h14; // O
                            d3 = 5'h0C; // C

                            d2 = 5'h1E;
                            d1 = 5'h1E;
                            d0 = 5'h1E;
                        end

                        // Default: blank
                        default: begin
                            d5 = 5'h1E;
                            d4 = 5'h1E;
                            d3 = 5'h1E;
                            d2 = 5'h1E;
                            d1 = 5'h1E;
                            d0 = 5'h1E;
                        end

                    endcase
                end

                // BALANCE state
                3'd5: begin
                    d5 = 5'h0B; // B
                    d4 = 5'h0A; // A
                    d3 = 5'h11; // L

                    d2 = 5'h1E; // Blank
                    d1 = bal_tens;
                    d0 = bal_ones;
                end

                // LOCK state
                3'd6: begin
                    d5 = 5'h11; // L
                    d4 = 5'h14; // O
                    d3 = 5'h0C; // C
                    d2 = 5'h1E;
                    d1 = 5'h1E;
                    d0 = 5'h1E;
                end

                // DEPOSIT
                3'd3: begin
                    d5 = 5'h11; // L

                    d4 = (lastDeposit % 100) / 10;; // last deposit tens
                    d3 = lastDeposit % 10;        // last deposit ones

                    d2 = 5'h0C; // C

                    d1 = amt_tens;       // current deposit tens
                    d0 = amt_ones;             // current deposit ones
                end

                // WITHDRAW
                3'd4: begin
                    d5 = 5'h11; // LAST

                    d4 = (lastWithdraw % 100) / 10; // last withdraw tens
                    d3 = lastWithdraw % 10;        // last withdraw ones

                    d2 = 5'h0C; // Current

                    d1 = amt_tens;       // current withdraw tens
                    d0 = amt_ones;              // current withdraw ones
                end

            endcase
        end
    end

    // char encoding stage
    charEncoder e0(.in(d0), .hex_out(HEX0));
    charEncoder e1(.in(d1), .hex_out(HEX1));
    charEncoder e2(.in(d2), .hex_out(HEX2));
    charEncoder e3(.in(d3), .hex_out(HEX3));
    charEncoder e4(.in(d4), .hex_out(HEX4));
    charEncoder e5(.in(d5), .hex_out(HEX5));

endmodule
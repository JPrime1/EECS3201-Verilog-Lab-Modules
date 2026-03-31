// purpose: ATM display driver
// converts FSM state and system values into 7-segment output using charEncoder

module ATMDisplayDriver(
    input [2:0] state,        // FSM state
    input [2:0] menuIndex,    // menu selection index
    input [9:0] balance,      // account balance
    input [9:0] amount,       // transaction amount
    input txnSuccess,         // transaction success flag
    input txnError,           // transaction error flag

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

        bal_tens = balance / 10;
        bal_ones = balance % 10;

        amt_tens = amount / 10;
        amt_ones = amount % 10;

        case (state)

            // PIN state
            3'd1: begin
                d5 = 5'h15; // P
                d4 = 5'h10; // I
                d3 = 5'h13; // N
            end

            // MENU state
            3'd2: begin
                d5 = 5'h12; // M
                d4 = 5'h0E; // E
                d3 = 5'h13; // N
                d2 = 5'h17; // U

                d0 = {2'b00, menuIndex}; // menu number (0–7 fits 5-bit map)
            end

            // BALANCE state
            3'd5: begin
                d5 = 5'h0B; // B
                d4 = 5'h0A; // A
                d3 = 5'h11; // L

                d1 = bal_tens;
                d0 = bal_ones;
            end

            // LOCK state
            3'd6: begin
                d5 = 5'h11; // L
                d4 = 5'h14; // O
                d3 = 5'h0C; // C
            end

            3'd3: begin
                // DEPOSIT
                d5 = 5'h0D; // D
                d4 = 5'h0E; // E
                d3 = 5'h15; // P

                d1 = amt_tens;
                d0 = amt_ones;
            end

            3'd4: begin
                // WITHDRAW shown as "-DR"
                d5 = 5'h18; // '-' (or blank if you don't have it)
                d4 = 5'h0D; // D
                d3 = 5'h16; // R

                d1 = amt_tens;
                d0 = amt_ones;
            end

        endcase
    end

    // char encoding stage
    charEncoder e0(.in(d0), .hex_out(HEX0));
    charEncoder e1(.in(d1), .hex_out(HEX1));
    charEncoder e2(.in(d2), .hex_out(HEX2));
    charEncoder e3(.in(d3), .hex_out(HEX3));
    charEncoder e4(.in(d4), .hex_out(HEX4));
    charEncoder e5(.in(d5), .hex_out(HEX5));

endmodule
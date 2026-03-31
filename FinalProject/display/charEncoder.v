// purpose: encode ATM character IDs into 7-segment display patterns
// expanded to 5-bit input for full ATM UI character set

module charEncoder(
    input  [4:0] in,          // 5-bit character ID (0–31)
    output reg [7:0] hex_out  // 7-seg output
);

    always @(*) begin
        case (in)

            // digits 0–9
            5'h00: hex_out = 8'hC0;
            5'h01: hex_out = 8'hF9;
            5'h02: hex_out = 8'hA4;
            5'h03: hex_out = 8'hB0;
            5'h04: hex_out = 8'h99;
            5'h05: hex_out = 8'h92;
            5'h06: hex_out = 8'h82;
            5'h07: hex_out = 8'hF8;
            5'h08: hex_out = 8'h80;
            5'h09: hex_out = 8'h90;

            // letters used in ATM UI

            5'h0A: hex_out = 8'h88; // A
            5'h0B: hex_out = 8'h83; // B
            5'h0C: hex_out = 8'hC6; // C
            5'h0D: hex_out = 8'hA1; // D
            5'h0E: hex_out = 8'h86; // E
            5'h0F: hex_out = 8'h8E; // F

            5'h10: hex_out = 8'hF9; // I
            5'h11: hex_out = 8'hC7; // L
            5'h12: hex_out = 8'hAB; // M (approx)
            5'h13: hex_out = 8'hC8; // N (approx)
            5'h14: hex_out = 8'hC0; // O
            5'h15: hex_out = 8'h8C; // P (approx)
            5'h16: hex_out = 8'hAF; // R
            5'h17: hex_out = 8'hE3; // U
            5'h18: hex_out = 8'hBF; // -

            // UI controls
            5'h1E: hex_out = 8'hFF; // blank
            5'h1F: hex_out = 8'h8E; // error indicator

            default: hex_out = 8'hFF;

        endcase
    end

endmodule
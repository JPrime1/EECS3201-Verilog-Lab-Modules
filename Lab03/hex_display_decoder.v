module hex_display_decoder(
    input  [3:0] in,
    output reg [7:0] hex_out
);

    // Combinational decoder for 4-bit hexadecimal input
    // Outputs 8-bit seven-segment display pattern
    // Format assumed: hex_out = {a,b,c,d,e,f,g, dp}
    // Usage of hex for visability

    always @(*) begin
        case (in)

            // Digits 0–9
            4'h0: hex_out = 8'hC0;
            4'h1: hex_out = 8'hF9;
            4'h2: hex_out = 8'hA4;
            4'h3: hex_out = 8'hB0;
            4'h4: hex_out = 8'h99;
            4'h5: hex_out = 8'h92;
            4'h6: hex_out = 8'h82;
            4'h7: hex_out = 8'hF8;
            4'h8: hex_out = 8'h80;
            4'h9: hex_out = 8'h90;

            // Hex digits A–F
            4'hA: hex_out = 8'h88;
            4'hB: hex_out = 8'h83;
            4'hC: hex_out = 8'hC6;
            4'hD: hex_out = 8'hA1;
            4'hE: hex_out = 8'h86;
            4'hF: hex_out = 8'h8E;

            // Safe default (all segments OFF including dp)
            default: hex_out = 8'hFF;

        endcase
    end

endmodule
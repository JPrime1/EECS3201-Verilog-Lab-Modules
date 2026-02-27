module symbol_logic(
    input s,            // Operation selector (0 = add, 1 = subtract)
    input carryOut,     // Carry out from the addition/subtraction operation

    output [7:0] op,    // display for symbol (+ or -)
    output [7:0] eq,    // display for EQUAL SIGN (=)
    output [7:0] prefix // display for carry out (1 or - or BLANK(hFF))    
);

    // Internal logic for symbol displays

    // '=' symbol (segments to display '=')
    assign eq = 8'hB7; 

    // s = 1 '-' symbol: 8'hBF (segments to display '-')
    // s = 0 '+' symbol: 8'h8F (segments to display '+')    
    assign op = s ? 8'hBF : 8'h8F;

    // Internal logic for prefix display
    // '-' symbol: 8'hBF (when s = 1 and carryOut = 1)
    // '1' symbol: 8'hF9 (when s = 0 and carryOut = 1)
    // Blank:      8'hFF (otherwise)
    assign prefix = (s && carryOut) ? 8'hBF :   // '-'
                  (!s && carryOut) ? 8'hF9  :   // '1'
                  8'hFF;                        // Blank

endmodule
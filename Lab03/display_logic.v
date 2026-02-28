module display_logic(
    input [3:0] a0,     // 4-bit input A0
    input [3:0] a1,     // 4-bit input A1
    
    input [7:0] op,     // Display for operation symbol (+ or -)
    input [7:0] eq,     // Display for EQUAL SIGN (=)
    input [7:0] prefix, // Display for carry out (1 or - or BLANK(hFF))
    input [3:0] result, // 4-bit result ALU output

    output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
    //DISPLAY LAYOUT
    // HEX5 A0
    hex_display_decoder d5 (.in(a0), .hex_out(HEX5));

    // connect op to HEX4 for '+' or '-'
    assign HEX4 = op; 
    
    // HEX3 A1
    hex_display_decoder d3 (.in(a1), .hex_out(HEX3));
    
    // connect eq to HEX2 for '='
    assign HEX2 = eq;
    
    // connect prefix to HEX1 for carry out display (1, - or BLANK)
    assign HEX1 = prefix;
    
    // HEX0 F (result)
    hex_display_decoder d0 (.in(result), .hex_out(HEX0));          

endmodule
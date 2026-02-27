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
    //HEX5 A0
    hex_display_decoder d5 (.in(a0), .hex_out(HEX5));

    //HEX4 +/-
    hex_display_decoder d4 (.in(op), .hex_out(HEX4));
    
    //HEX3 A1
    hex_display_decoder d3 (.in(a1), .hex_out(HEX3));
    
    //HEX2 =
    hex_display_decoder d2 (.in(eq), .hex_out(HEX2));
    
    //HEX1 1/-
    hex_display_decoder d1 (.in(prefix), .hex_out(HEX1));
    
    //HEX0 F (result)
    hex_display_decoder d0 (.in(result), .hex_out(HEX0));          

endmodule
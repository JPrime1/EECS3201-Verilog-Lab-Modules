module display_logic(
    input [3:0] a0,
    input [3:0] a1,

    output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
    //setup wiring
    wire [3:0] a0_disp;
    wire [3:0] a1_disp;

    //assign input to wires
    assign a0_disp = a0;
    assign a1_disp = a1;

    //DISPLAY LAYOUT
    //HEX5 A0
    hex_display_decoder d0 (.in(a0_disp), .hex_out(HEX5));

    //HEX4 +/-
    
    //HEX3 A1
    hex_display_decoder d2 (.in(a1_disp), .hex_out(HEX3));
    
    //HEX2 =
    //HEX1 1/-
    //HEX0 F (result)
    
    

endmodule
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

    //quick display
    seven_seg_decoder d5(.in(a0_disp), .seg(HEX5));
    seven_seg_decoder d3(.in(a1_disp), .seg(HEX3));

endmodule
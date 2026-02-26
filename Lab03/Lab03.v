module Lab03 (
    input  [9:0] SW,
    output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

    wire [3:0] a0;
    wire [3:0] a1;
    wire s;

    assign a0 = SW[7:4];
    assign a1 = SW[3:0];
    assign s  = SW[9];

    wire [3:0] F;
    wire Cout;

    display_logic disp (
        //DISPLAY LAYOUT
        //HEX5 A0
        .a0(a0),
        .HEX5(HEX5),

        //HEX4 +/-
        
        //HEX3 A1        
        .a1(a1),
        .HEX3(HEX3)

        //HEX2 =        
        //HEX1 1/-
        //HEX0 F (result)                
    );

endmodule
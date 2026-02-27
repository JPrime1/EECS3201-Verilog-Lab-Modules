module Lab03 (
    input  [9:0] SW,
    output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
    // Extracting inputs from switches
    wire [3:0] a0;  // 4-bit input A0
    wire [3:0] a1;  // 4-bit input A1
    wire s;         // Operation selector (0 for addition, 1 for subtraction)
    assign a0 = SW[7:4];
    assign a1 = SW[3:0];
    assign s  = SW[9];

    // ALU operation
    wire [3:0] F;   // 4-bit result from ALU
    wire Cout;      // Carry out from ALU
    add_sub alu (
        .a0(a0),
        .a1(a1),
        .s(s),
        .result(F),
        .carryOut(Cout)
    );

    // Symbol Logic for Display
    wire [7:0] op;     
    wire [7:0] eq;     
    wire [7:0] prefix;
    symbol_logic sym (
        .s(s),
        .carryOut(Cout),
        .op(op),
        .eq(eq),
        .prefix(prefix)
    );

    // Display Logic for HEX displays
    display_logic disp (
        .a0(a0),         
        .a1(a1),
        .op(op),
        .eq(eq),
        .prefix(prefix),
        .result(F),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

endmodule
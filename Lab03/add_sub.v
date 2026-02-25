module add_sub(
    input  [3:0] a0,        // 1st number
    input  [3:0] a1,        // 2nd number
    input        s,         // 0 = add, 1 = subtract
    output [3:0] result,
    output       carryOut
    );

    // Setup Wiring
    wire [4:0] temp;        //5 bit bus for carryout extraction

    // Behavioural Addition/Subtraction
    // Dependent on switch behavior
    assign temp = s ? (a0 - a1) : (a0 + a1);

    assign result   = temp[3:0];
    assign carryOut = temp[4];        

endmodule
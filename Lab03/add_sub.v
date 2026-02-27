module add_sub(
    input  [3:0] a0,        // 4-bit input A0
    input  [3:0] a1,        // 4-bit input A1
    input        s,         // 0 = add, 1 = subtract
    
    output [3:0] result,    // 4-bit result of addition/subtraction
    output       carryOut   // Carry out from the addition/subtraction operation
    );

    // Setup Wiring
    wire [4:0] temp;        //5 bit bus for carryout extraction

    // Behavioural Addition/Subtraction
    // Dependent on switch behavior
    assign temp = s ? (a0 - a1) : (a0 + a1);

    assign carryOut = temp[4];  
    assign result = (carryOut && s) ? ((~temp[3:0]) + 4'd1) : temp[3:0];    //if negative result and subtract, 2's complement
          

endmodule
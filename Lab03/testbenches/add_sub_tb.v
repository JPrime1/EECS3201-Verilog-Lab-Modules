`timescale 1ns/1ps

module add_sub_tb;

    reg  [3:0] a0;
    reg  [3:0] a1;
    reg        s;

    wire [3:0] result;
    wire       carryOut;

    // Instantiate DUT
    add_sub uut (
        .a0(a0),
        .a1(a1),
        .s(s),
        .result(result),
        .carryOut(carryOut)
    );

    initial begin
        $display("Time | s | a0 | a1 | carry | result");
        $display("------------------------------------");

        // ADDITION TESTS
        s = 0;

        a0 = 4'd3; a1 = 4'd2; #10;
        $display("%4t | %b | %d  | %d  |   %b   |  %d",
                  $time, s, a0, a1, carryOut, result);

        a0 = 4'd9; a1 = 4'd9; #10;  // overflow case
        $display("%4t | %b | %d  | %d  |   %b   |  %d",
                  $time, s, a0, a1, carryOut, result);

        a0 = 4'd15; a1 = 4'd1; #10; // max + 1
        $display("%4t | %b | %d  | %d  |   %b   |  %d",
                  $time, s, a0, a1, carryOut, result);


        // SUBTRACTION TESTS
        s = 1;

        a0 = 4'd7; a1 = 4'd2; #10;
        $display("%4t | %b | %d  | %d  |   %b   |  %d",
                  $time, s, a0, a1, carryOut, result);

        a0 = 4'd3; a1 = 4'd5; #10;  // negative result
        $display("%4t | %b | %d  | %d  |   %b   |  %d",
                  $time, s, a0, a1, carryOut, result);

        a0 = 4'd0; a1 = 4'd1; #10;  // -1
        $display("%4t | %b | %d  | %d  |   %b   |  %d",
                  $time, s, a0, a1, carryOut, result);

        a0 = 4'd15; a1 = 4'd15; #10; // 0 result
        $display("%4t | %b | %d  | %d  |   %b   |  %d",
                  $time, s, a0, a1, carryOut, result);

        $stop;
    end

endmodule
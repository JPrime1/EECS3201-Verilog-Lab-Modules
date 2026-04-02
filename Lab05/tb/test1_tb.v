//============================================================
// EECS 3201 – Lab 5
// Simulating Circuits with ModelSim
//
// Student Name: James Prime
// Student Number: 215028657
//
// GitHub Repository:
// https://github.com/JPrime1/EECS3201-Verilog-Lab-Modules.git
//
// Description:
// This lab focuses on writing Verilog testbenches to simulate and verify
// the behavior of given combinational and sequential circuits using ModelSim.
//
// Two modules are tested:
// - test1: 3-input combinational logic circuit (simple adder)
// - test2: 4-bit sequential up/down counter with clock input
//
// The testbenches:
// - Exhaustively test all input combinations (test1)
// - Generate clock and timed input stimulus (test2)
// - Monitor outputs during simulation
// - Print a message when outputs transition to zero
//
//============================================================

`timescale 1ns / 10ps

module test1_tb;

    // inputs and output to the circuit
    reg a, b, c;
    wire x, y;

    // meant to provide a way to print only once when we enter the (0,0) state
    // else it repeats for 20 ns while we are in that state
    reg prev_zero;

    // instantiate the module we're testing
    test1 testMod (
        .a(a),
        .b(b),
        .c(c),
        .x(x),
        .y(y)
    );

    // initialize tracking variable
    initial begin
        prev_zero = 0;
    end

    // go through all 8 input combinations
    // each held for 20 ns
    initial begin

        a = 0; b = 0; c = 0;
        #20;

        a = 0; b = 0; c = 1;
        #20;

        a = 0; b = 1; c = 0;
        #20;

        a = 0; b = 1; c = 1;
        #20;

        a = 1; b = 0; c = 0;
        #20;

        a = 1; b = 0; c = 1;
        #20;

        a = 1; b = 1; c = 0;
        #20;

        a = 1; b = 1; c = 1;
        #20;

        // end simulation
        $finish;
    end

    // watch outputs and print ONLY when we ENTER (0,0)
    always @(x or y) begin

        // just entered the zero state
        if ((x == 0 && y == 0) && prev_zero == 0) begin
            $display("All outputs are zero at time = %0t nanoseconds", $time);
            prev_zero = 1;
        end

        // left the zero state
        else if (!(x == 0 && y == 0)) begin
            prev_zero = 0;
        end

    end

endmodule
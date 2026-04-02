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

module test2_tb;

    // inputs
    reg clk;
    reg a;

    // output (4-bit bus)
    wire [3:0] r;

    // tracks previous value of r so we detect transitions properly
    reg [3:0] prev_r;

    // instantiate module under test
    test2 testMod (
        .clk(clk),
        .a(a),
        .r(r)
    );

    // initialize signals
    initial begin
        clk = 0;
        a = 0;
        prev_r = 4'd0;
    end

    // clock generation: 20 ns period (10 ns high / 10 ns low)
    always begin
        #10 clk = ~clk;
    end

    // control input 'a' over time
    initial begin

        // 0–100 ns → a = 0
        a = 0;
        #100;

        // 100–300 ns → a = 1
        a = 1;
        #200;

        // 300 ns onward → a = 0
        a = 0;

        // let it run a bit longer to observe behavior
        #200;

        // end simulation
        $finish;
    end

    // monitor output and print ONLY when r TRANSITIONS into zero
    always @(posedge clk) begin

        // detect transition INTO 0000
        if ((r == 4'b0000) && (prev_r != 4'b0000)) begin
            $display("All outputs are zero at time = %0t nanoseconds", $time);
        end

        // update previous value AFTER checking
        prev_r <= r;

    end

endmodule
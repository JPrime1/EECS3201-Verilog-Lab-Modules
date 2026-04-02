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
module Lab05(
    input wire clk,
    input wire rst
);

    // intentionally empty for simulation-only project
    wire dummy;

    assign dummy = clk ^ rst;

endmodule
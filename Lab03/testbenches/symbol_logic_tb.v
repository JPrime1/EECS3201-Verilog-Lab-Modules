`timescale 1ns/1ps

module symbol_logic_tb;

    // Testbench signals (match module ports)
    reg s;
    reg carryOut;

    wire [7:0] op;
    wire [7:0] eq;
    wire [7:0] prefix;

    // Instantiate DUT (Device Under Test)
    symbol_logic dut (
        .s(s),
        .carryOut(carryOut),
        .op(op),
        .eq(eq),
        .prefix(prefix)
    );

    // Stimulus
    initial begin
        $display("Time\t s\t carryOut\t op\t eq\t prefix");

        // Dump waveform for viewing in GTKWave / Quartus waveform viewer
        $dumpfile("symbol_logic_tb.vcd");
        $dumpvars(0, symbol_logic_tb);

        // Test all combinations

        // Case 1: s=0, carryOut=0
        s = 0; carryOut = 0;
        #10;

        // Case 2: s=0, carryOut=1
        s = 0; carryOut = 1;
        #10;

        // Case 3: s=1, carryOut=0
        s = 1; carryOut = 0;
        #10;

        // Case 4: s=1, carryOut=1
        s = 1; carryOut = 1;
        #10;

        $finish;
    end

    // Optional monitoring
    initial begin
        $monitor("%0t\t %b\t %b\t %h\t %h\t %h",
                 $time, s, carryOut, op, eq, prefix);
    end

endmodule
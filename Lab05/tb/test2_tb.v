`timescale 1ns / 10ps

module test2_tb;

    // inputs
    reg clk;
    reg a;

    // output (4-bit bus)
    wire [3:0] r;

    // meant to provide a way to print only once when we enter r=0000 state
    // else it repeats for 20 ns while we are in that state
    reg prev_zero;

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
        prev_zero = 0;
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

    // monitor output and print ONLY when we ENTER r = 0000
    always @(posedge clk) begin

        // just entered zero state
        if ((r == 4'b0000) && prev_zero == 0) begin
            $display("All outputs are zero at time = %0t nanoseconds", $time);
            prev_zero = 1;
        end

        // left zero state
        else if (r != 4'b0000) begin
            prev_zero = 0;
        end

    end

endmodule
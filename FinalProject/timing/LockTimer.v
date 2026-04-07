// purpose: lockout countdown timer for ATM system
// uses 1ms tick input from TickGenerator instead of raw clock
// triggers 5-second countdown when started (edge detected pulse)
// sets timeout when counter reaches 0

module LockTimer(
    input clk,              // 50 MHz clock input
    input rst,              // synchronous reset
    input tick,             // 1 ms tick from TickGenerator
    input start,            // start countdown signal (should be pulse)

    output reg timeout,     // goes high when timer reaches 0
    output reg [2:0] seconds// remaining seconds (0–5)
);

    // 1000 ms = 1 second
    reg [9:0] ms_count;     // counts 0–999 ms (1 second)
    reg running;            // indicates timer is active

    // used to detect rising edge of start signal
    reg start_d;
    wire start_pulse = start & ~start_d;

    // On every rising edge of the input clock
    always @(posedge clk) begin

        // store previous start value for edge detection
        start_d <= start;

        // synchronous reset: clear everything
        if (rst) begin
            ms_count <= 0;     // reset ms counter
            seconds <= 5;      // reset countdown to 5 seconds
            timeout <= 0;      // clear timeout flag
            running <= 0;      // stop timer
        end

        else begin

            // default: ensure timeout is only 1-cycle pulse
            timeout <= 0;

            // START timer (only on rising edge of start)
            if (start_pulse) begin
                running <= 1;      // activate timer
                timeout <= 0;      // ensure timeout is cleared
                seconds <= 5;      // reset countdown
                ms_count <= 0;     // reset ms counter
            end

            // COUNTDOWN logic (driven by 1ms tick)
            else if (running && tick) begin

                // count milliseconds
                if (ms_count == 999) begin
                    ms_count <= 0;  // reset ms counter each second

                    // decrement seconds each full second
                    if (seconds > 0)
                        seconds <= seconds - 1;
                end
                else begin
                    ms_count <= ms_count + 1;  // increment ms counter
                end

                // timeout condition when countdown reaches zero
                if (seconds == 0 && ms_count == 0) begin
                    timeout <= 1;  // raise timeout pulse
                    running <= 0;  // stop timer
                end
            end
        end
    end

endmodule
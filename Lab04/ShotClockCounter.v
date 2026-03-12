module ShotClockCounter(
    input clk,          // 1 Hz clock
    input pause,        // pause toggle button
    input reset,        // reset button
    input mode,         // SW0 : 0=24 sec, 1=30 sec
    output reg [4:0] count
);

    // Tracks pause state
    reg pauseState;

    // Used to detect when mode changes, and reset the count accordingly
    reg prevMode;

    // Determine maximum time based on mode
    wire [4:0] maxTime;
    assign maxTime = mode ? 5'd30 : 5'd24;  // 30 seconds if mode is 1, otherwise 24 seconds

    always @(posedge clk) begin

        // Detect mode switch change
        if (mode != prevMode) begin
            count <= maxTime;
        end

        // Reset button pressed
        else if (reset) begin
            count <= maxTime;
        end

        // Pause toggle
        else if (pause) begin
            pauseState <= ~pauseState;
        end

        // Countdown logic - only count down if not paused and count is greater than 0
        else if (!pauseState && count > 0) begin
            count <= count - 1;
        end

        // Update the current stored mode
        prevMode <= mode;

    end

endmodule
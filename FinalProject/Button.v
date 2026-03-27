// purpose: Generate a pulse when a button is pressed (transition from 0 to 1)
// The pulse will be high for one clock cycle, which can be used to trigger events

// Module based on Lab04 button module
// Uses tick AND the clock to fix previous issues with button handling
// Includes synchronous reset for startup behavior

module Button(
    input clk,        // Clock input (50 MHz)
    input tick,       // 1 ms tick input
    input rst,        // Synchronous reset
    input btn,        // Button input
    output reg pulse  // 1 cycle pulse output
);

    reg prev;         // Register to hold the previous state of the button

    always @(posedge clk) begin
        // Synchronous reset: Clear previous state and pulse
        if (rst) begin
            prev <= 0;        // Reset previous button state
            pulse <= 0;       // Ensure no pulse on reset
        end

        // Sample button only on tick (debouncing behavior)
        else if (tick) begin
            pulse <= btn & ~prev;   // Pulse when btn is high and prev was low
            prev <= btn;            // Update the previous state of the button
        end

        // Default: no pulse between ticks
        else begin
            pulse <= 0;
        end
    end

endmodule
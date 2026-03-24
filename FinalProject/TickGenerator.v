// Using the lab04's clock divider as foundation to create a 1 ms tick generator
// Converts a 50 MHz clock input to a 1 millisecond TICK PULSE output
// Used for buttons, displays, and timeouts
// Generates a single-cycle tick every 1 ms

module TickGenerator(
    input  cin,         // Clock input (50 MHz)
    input  rst,         // Sync reset
    output reg tick     // Tick pulse
);

    // us too quick, sec too slow, so we need to count to 50,000 for 1 ms
    reg [15:0] count;                // 16-bit counter sufficient for 50,000 cycles
    parameter val = 16'd50_000;      // Number of clock cycles for 1 ms tick

    // On every rising edge of the input clock
    always @(posedge cin) begin
        // Synchronous reset: Clear counter and tick output
        if (rst) begin
            count <= 0;     // Reset counter
            tick <= 0;      // Very important: Ensure tick is low on reset
        end 

        // Count to 50,000 for 1 ms tick generation
        else begin
            if (count >= val - 1) begin
                count <= 0;  // Reset counter
                tick <= 1;   // Output a single-cycle tick pulse
            end

            else begin
                count <= count + 1;  // Increment counter
                tick <= 0;           // Keep tick low until threshold is reached
            end
        end
    end

endmodule
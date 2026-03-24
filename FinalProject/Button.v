// purpose: Generate a pulse when a button is pressed (transition from 0 to 1)
// The pulse will be high for one clock cycle, which can be used to trigger events

// Module based on Lab04 button module
// Uses ticks AND the clock to fix previous issues with button handling

module Button(
    input clk,      // Clock input (50 MHz)
    input tick,     // 1 ms tick input
    input btn,      // Button input
    output reg pulse// 1 cycle pulse output
);

    reg prev;       // Register to hold the previous state of the button

    always @(posedge clk) begin
        // clk and tick
        if (tick) begin
            pulse <= btn & ~prev;   // Pulse when btn is high and was prev was low
            prev <= btn;            // Update the previous state of the button
        end
        else begin
            pulse <= 0;             // default low
        end
    end

endmodule
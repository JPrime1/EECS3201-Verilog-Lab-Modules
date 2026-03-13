// purpose: Generate a pulse when a button is pressed (transition from 0 to 1)
// The pulse will be high for one clock cycle, which can be used to trigger events

module Button(
    input clk,      // Has to be 50 MHz clock input, otherwise the pulse will be too short to be detected by the counter
    input btn,      // Button input
    output pulse    // Output pulse - high for one clock cycle when button is pressed
);

    reg prev;       // Register to hold the previous state of the button

    // Generate a pulse when the button is pressed (transition from 0 to 1)
    // And the previous state is 0 (not pressed)
    assign pulse = btn & ~prev;

    // Update the previous state of the button on every clock cycle
    always @(posedge clk)
    begin
        prev <= btn;
    end

endmodule
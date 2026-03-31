// purpose: compare entered PIN with stored PIN
// outputs high when both values match exactly

module PinComparator(
    input clk,                // system clock
    input enterPulse,         // ENTER button pulse
    input [9:0] enteredPin,   // PIN from InputRegister
    input [9:0] storedPin,    // PIN from PinRegister
    
    output reg pinValidPulse,     // 1-cycle success pulse
    output reg pinFailPulse       // 1-cycle fail pulse
);

    // combinational comparison
    wire match;
    assign match = (enteredPin == storedPin);

    always @(posedge clk) begin

        // default outputs low (1-cycle pulse behavior)
        pinValidPulse <= 1'b0;
        pinFailPulse <= 1'b0;

        // perform comparison only on ENTER press
        if (enterPulse) begin

            // correct PIN
            if (match) begin
                pinValidPulse <= 1'b1;
            end

            // incorrect PIN
            else begin
                pinFailPulse <= 1'b1;
            end

        end

    end

endmodule
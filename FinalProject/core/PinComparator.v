// purpose: compare entered PIN with stored PIN
// outputs high when both values match exactly

module PinComparator(
    input [9:0] enteredPin,   // PIN from InputRegister
    input [9:0] storedPin,    // PIN from PinRegister
    output match              // high if PINs are equal
);

    // combinational comparison
    assign match = (enteredPin == storedPin);

    always @(posedge clk) begin

        // default outputs low (1-cycle pulse behavior)
        pinValidPulse <= 0;
        pinFailPulse <= 0;

        // perform comparison only on ENTER press
        if (enterPulse) begin

            // correct PIN
            if (match) begin
                pinValidPulse <= 1;
            end

            // incorrect PIN
            else begin
                pinFailPulse <= 1;
            end

        end

    end

endmodule
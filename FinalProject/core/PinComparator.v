// purpose: compare entered PIN with stored PIN
// outputs high when both values match exactly

module PinComparator(
    input [9:0] enteredPin,   // PIN from InputRegister
    input [9:0] storedPin,    // PIN from PinRegister
    output match              // high if PINs are equal
);

    // combinational comparison
    assign match = (enteredPin == storedPin);

endmodule
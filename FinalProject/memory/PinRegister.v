// purpose: store the user PIN for authentication
// can be updated after successful login using ENTER

module PinRegister(
    input clk,             // clock input (50 MHz)
    input rst,             // synchronous reset (not used to clear PIN)
    input load,            // load signal (store new PIN)
    input [9:0] newPin,    // new PIN value (from InputRegister)
    output reg [9:0] pin   // stored PIN output
);

    // initialize PIN at power-up
    initial begin
        pin = 10'd0;
    end

    always @(posedge clk) begin

        // no reset for PIN (retain value across system reset)

        // load new PIN when enabled
        if (load) begin
            pin <= newPin;
        end

        // otherwise hold current PIN (implicit)

    end

endmodule
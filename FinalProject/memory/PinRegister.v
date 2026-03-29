// purpose: store the user PIN for authentication
// can be updated after successful login using ENTER

module PinRegister(
    input clk,             // clock input (50 MHz)
    input rst,             // synchronous reset
    input load,            // load signal (store new PIN)
    input [9:0] newPin,    // new PIN value (from InputRegister)
    output reg [9:0] pin   // stored PIN output
);

    always @(posedge clk) begin

        // reset PIN to default value (0)
        if (rst) begin
            pin <= 10'd0;
        end

        // load new PIN when enabled
        else if (load) begin
            pin <= newPin;
        end

        // otherwise hold current PIN (implicit)

    end

endmodule
// purpose: latch switch input when ENTER button is pressed
// holds value until next ENTER, used for PIN and transaction amounts

module InputRegister(
    input clk,              // clock input (50 MHz)
    input rst,              // synchronous reset
    input enterPulse,       // 1-cycle pulse from ENTER button
    input [9:0] sw,         // 10 switches input
    output reg [9:0] value  // latched value output
);

    always @(posedge clk) begin

        // reset register to 0
        if (rst) begin
            value <= 10'd0;
        end

        // latch switches on ENTER
        else if (enterPulse) begin
            value <= sw;
        end

        // otherwise hold previous value (implicit)

    end

endmodule
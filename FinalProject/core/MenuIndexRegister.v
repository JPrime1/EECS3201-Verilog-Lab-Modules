// purpose: store and cycle through ATM menu options
// used to control which operation is selected in the FSM menu state

module MenuIndexRegister(
    input clk,              // clock input (50 MHz)
    input rst,              // synchronous reset
    input nextPulse,        // 1-cycle pulse from NEXT button
    output reg [2:0] index  // need 3 bits to represent up to 8 options
);

    always @(posedge clk) begin

        // reset system state
        if (rst) begin
            index <= 3'd0;
        end

        // cycle menu on next button press
        else if (nextPulse) begin

            if (index === 3'd4) begin
                index <= 3'd0;   // wrap back to first option
            end

            else begin
                index <= index + 1;
            end

        end

    end

endmodule
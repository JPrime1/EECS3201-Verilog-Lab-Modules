// purpose: count failed PIN attempts and trigger lock after 5 tries
// resets on successful authentication or system reset

module AttemptCounter(
    input clk,              // clock input (50 MHz)
    input rst,              // synchronous reset
    input fail,             // increment on failed PIN
    input success,          // reset counter on correct PIN
    output reg [2:0] count, // current attempt count (0–5)
    output reg locked       // high when account is locked
);

    always @(posedge clk) begin

        // reset counter and unlock system
        if (rst) begin
            count <= 3'd0;
            locked <= 0;
        end

        else begin

            // reset attempts on successful login
            if (success) begin
                count <= 3'd0;
                locked <= 0;
            end

            // increment on failed attempt
            else if (fail) begin

                // only increment if below max attempts
                if (count < 3'd5) begin
                    count <= count + 1;
                end

            end

            // lock when reaching 5 failed attempts
            if (count >= 3'd5) begin
                locked <= 1;
            end

        end

    end

endmodule
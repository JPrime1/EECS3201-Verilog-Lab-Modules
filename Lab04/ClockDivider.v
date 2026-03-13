// Converts a 50 MHz clock input to a 1 second TICK PULSE output by counting clock cycles
// New Design due to changes in the way we handle button inputs

module ClockDivider(
    input  cin,         // Clock input
    output reg tick     // Clock output (divided)
);

    reg [25:0] count;               // 26-bit counter to count 50 Million clock cycles
    parameter val = 26'd50_000_000; // 50 million for 1 second output

    // On every rising edge of the input clock, increment the counter
    always @(posedge cin) begin

        if (count >= val - 1) begin
            count <= 0;     // Reset counter
            tick <= 1;      // Output a tick pulse for one "clock" cycle
        end 
        
        else begin
            count <= count + 1; // Increment counter
            tick <= 0;          // Keep tick low until we reach the count threshold
        end
    end

endmodule
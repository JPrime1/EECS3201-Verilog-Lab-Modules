// Converts a 50 MHz clock to a 1 Hz clock for the shot clock counter

module ClockDivider(
    input  cin,         // Clock input
    output reg cout     // Clock output (divided)
);

    reg [24:0] count;               // 25-bit counter to count 25 Million clock cycles
    parameter half = 32'd25_000_000;// Half of 50 million for 1 Hz output

    // On every rising edge of the input clock, increment the counter
    always @(posedge cin) begin

        if (count >= half - 1) begin
            count <= 0;     // Reset counter
            cout <= ~cout;  // Toggle output clock
        end 
        
        else begin
            count <= count + 1; // Increment counter
        end
    end

endmodule
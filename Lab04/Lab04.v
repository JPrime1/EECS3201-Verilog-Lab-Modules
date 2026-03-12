module Lab04 (
    input  CLOCK_50,        // 50 MHz clock input
    input  [0:0] SW,        // SW0: Mode switch (0=24 sec, 1=30 sec)
    input  [0:0] KEY0,      // KEY0: Pause toggle button
    input  [0:0] KEY1,      // KEY1: Reset button
    output [7:0] HEX0, HEX1 // Seven-segment display outputs for ones and tens digits
);

    // Wires to connect modules
    wire clk;               // 1 Hz clock from ClockDivider
    wire [4:0] count;       // 5-bit count from ShotClockCounter
    wire [3:0] bcdTens;     // BCD tens digit
    wire [3:0] bcdOnes;     // BCD ones digit

    // Instantiate ClockDivider to convert 50 MHz to 1 Hz
    ClockDivider clock (
        .cin(CLOCK_50),
        .cout(clk)
    );

    // Instantiate ShotClockCounter to manage the countdown logic
    ShotClockCounter counter (
        .clk(clk),
        .pause(KEY0),
        .reset(KEY1),
        .mode(SW),
        .count(count)
    );

    // Instantiate BinaryToBCD to convert the count to BCD digits
    BinaryToBCD converter (
        .binary_in(count),
        .bcd_tens(bcdTens),
        .bcd_ones(bcdOnes)
    );

    // Instantiate hex_display_decoder for the tens and ones digits
    hex_display_decoder hexTens (
        .in(bcdTens),
        .hex_out(HEX1)
    );

    hex_display_decoder hexOnes (
        .in(bcdOnes),
        .hex_out(HEX0)
    );

endmodule
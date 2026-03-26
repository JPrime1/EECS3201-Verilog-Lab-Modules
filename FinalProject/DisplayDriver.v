// Based on lab03 display logic driver
// Purpose: Connect 10 switches to HEX0 and HEX1
// Remaining HEX displays are blank

module DisplayDriver(
    input [9:0] sw,           // 10 switches input
    output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5  // 6 HEX displays
);

    // HEX0 shows lower 4 bits of switches (sw[3:0])
    hex_display_decoder d0 (
        .in(sw[3:0]),
        .hex_out(HEX0)
    );

    // HEX1 shows upper 4 bits of switches (sw[7:4])
    hex_display_decoder d1 (
        .in(sw[7:4]),
        .hex_out(HEX1)
    );

    // HEX2–HEX5 are blank for Sprint 1
    assign HEX2 = 8'hFF;
    assign HEX3 = 8'hFF;
    assign HEX4 = 8'hFF;
    assign HEX5 = 8'hFF;

endmodule
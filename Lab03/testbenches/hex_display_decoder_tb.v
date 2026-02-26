module hex_display_decoder_tb;

    reg  [3:0] in;
    wire [7:0] hex_out;

    // DUT
    hex_display_decoder dut(
        .in(in),
        .hex_out(hex_out)
    );

    initial begin

        // Initialize
        in = 4'h0;

        // Step through hexadecimal values
        #20 in = 4'h0;
        #20 in = 4'h1;
        #20 in = 4'h2;
        #20 in = 4'h3;
        #20 in = 4'h4;
        #20 in = 4'h5;
        #20 in = 4'h6;
        #20 in = 4'h7;
        #20 in = 4'h8;
        #20 in = 4'h9;

        #20 in = 4'hA;
        #20 in = 4'hB;
        #20 in = 4'hC;
        #20 in = 4'hD;
        #20 in = 4'hE;
        #20 in = 4'hF;

        #50 $stop;

    end

endmodule
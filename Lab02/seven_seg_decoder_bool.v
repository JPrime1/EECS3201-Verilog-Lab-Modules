module seven_seg_decoder_bool(
	input [3:0] in,
	output [7:0] seg);

    //wires for legibility
    wire A = in[3];
    wire B = in[2];
    wire C = in[1];
    wire D = in[0];

    assign seg[7] = 1; //Turn OFF dp

    //based of kmaps for each segment
	assign seg[0] = (~A & ~B & ~C & D) |
                    (~A & B & ~C & ~D) |
                    (A & B & C & D);

    assign seg[1] = (~A & B) &
                    ((~C & D) | (C & ~D))|
                    (A & B & C & D);

    assign seg[2] = (~A & ~B & C & ~D)|
                    (A & B & C & D);

    assign seg[3] = (~B & ~C & D)|
                    (~A & B & ~C & ~D)|
                    (~A & B & C & D)|
                    (A & B & C & D);
    
    assign seg[4] = (~A & B & ~C)|
                    (~A & D)|
                    (~B & ~C & D)|
                    (A & B & C & D);

    assign seg[5] = ((~A & ~B) & (C | D))|                    
                    (~A & C & D)|
                    (A & B & C & D);

    assign seg[6] = (~A & ~B & ~C)|
                    (~A & B & C & D)|
                    (A & B & C & D);
	
endmodule
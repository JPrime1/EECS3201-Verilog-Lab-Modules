module seven_seg_decoder(
	input [3:0] in,
	output reg [7:0] seg);

	always @(*) begin
		case (in)
			4'd0: seg[6:0] = 7'b1000000; // 0
			4'd1: seg[6:0] = 7'b1111001; // 1
			4'd2: seg[6:0] = 7'b0100100; // 2
			4'd3: seg[6:0] = 7'b0110000; // 3
			4'd4: seg[6:0] = 7'b0011001; // 4
			4'd5: seg[6:0] = 7'b0010010; // 5
			4'd6: seg[6:0] = 7'b0000010; // 6
			4'd7: seg[6:0] = 7'b1111000; // 7
			4'd8: seg[6:0] = 7'b0000000; // 8
			4'd9: seg[6:0] = 7'b0010000; // 9
   			default: seg[6:0] = 7'b111_1111; // default: all segments OFF
		endcase

		seg[7] = 1'b1; //dp OFF
	end
	
endmodule
module Lab02 (
    input [8:0] SW,
	output [7:0] HEX0);

    wire [3:0] val; //four bit value conversion for student number

    assign val[0] = (~|SW) | SW[0] | SW[1] | SW[6] | SW[7];
    assign val[1] = (~|SW) | SW[0] | SW[2] | SW[4] | SW[8];
    assign val[2] = (~|SW) | SW[0] | SW[1] | SW[2] | SW[6];
    assign val[3] = (~|SW) | SW[3];

    //Display value onto HEX0 led segmented display
    seven_seg_decoder_bool display(.in(val), .seg(HEX0));

    
endmodule
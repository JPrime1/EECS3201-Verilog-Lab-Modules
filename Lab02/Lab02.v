//============================================================
// EECS 3201 – Lab 2
// 7-Segment Display Driver
//
// Student Name: James Prime
// Student Number: 215028657
//
// GitHub Repository:
// https://github.com/JPrime1/EECS3201-Verilog-Lab-Modules.git
//
// Description:
// This project implements a 7-segment display driver using
// minimized Boolean functions. Switches SW8–SW0 select and
// display the digits of the student number.
//
//============================================================

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
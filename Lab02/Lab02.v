module Lab02 (
    input [8:0] SW,
	output [7:0] HEX0);

    wire [8:0] pr_en; //priority encoded input
    priority_encoder encode(.in(SW), .en(pr_en));

    wire [3:0] val; //four bit value conversion
    /*assign val[0] = pr_en[0] | pr_en[1] | pr_en[6];
    assign val[1] = pr_en[0] | pr_en[2] | pr_en[4] | pr_en[5] | pr_en[7];
    assign val[2] = pr_en[0] | pr_en[1] | pr_en[2] | pr_en[5];
    assign val[3] = pr_en[3];*/

    //test instructions
    assign val = SW[3:0];

    seven_seg_decoder_bool display(.in(val), .seg(HEX0));
    //seven_seg_decoder(.in(val), .seg(HEX0));

    
endmodule
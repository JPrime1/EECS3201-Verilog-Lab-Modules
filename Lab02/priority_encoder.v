/* Convert 9 bit input into 9 bit priority encoded output
With higher significant bits as priority.
*/

module priority_encoder(
    input [8:0] in,
    output [8:0] en
    );

    // priority-encoded intermediate signals
    assign en[8] = in[8];
    assign en[7] = in[7] & ~in[8];
    assign en[6] = in[6] & ~(in[7] | in[8]);
    assign en[5] = in[5] & ~(in[6] | in[7] | in[8]);
    assign en[4] = in[4] & ~(in[5] | in[6] | in[7] | in[8]);
    assign en[3] = in[3] & ~(in[4] | in[5] | in[6] | in[7] | in[8]);
    assign en[2] = in[2] & ~(in[3] | in[4] | in[5] | in[6] | in[7] | in[8]);
    assign en[1] = in[1] & ~(in[2] | in[3] | in[4] | in[5] | in[6] | in[7] | in[8]);
    assign en[0] = in[0] & ~(in[1] | in[2] | in[3] | in[4] | in[5] | in[6] | in[7] | in[8]);


endmodule
// purpose: store and update account balance
// supports deposit and withdrawal operations

module BalanceRegister(
    input clk,               // clock input (50 MHz)
    input rst,               // synchronous reset
    input depositEn,         // enable deposit operation
    input withdrawEn,        // enable withdraw operation
    input [9:0] amount,      // transaction amount (from InputRegister)
    output reg [9:0] balance // current balance value
);

    always @(posedge clk) begin

        // reset balance to default value (0)
        if (rst) begin
            balance <= 10'd0;
        end

        else begin

            // deposit operation
            if (depositEn) begin
                balance <= balance + amount;
            end

            // withdraw operation (assumes valid check done outside)
            else if (withdrawEn) begin
                balance <= balance - amount;
            end

            // otherwise hold value (implicit)

        end

    end

endmodule
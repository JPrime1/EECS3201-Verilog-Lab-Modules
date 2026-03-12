// Convert 5-bit binary input to two BCD digits (tens and ones)
// Implement simple arithmetic: tens = binary_in / 10, ones = binary_in % 10

module BinaryToBCD(
    input [4:0] binary_in,  // 5-bit binary input
    output [3:0] bcd_tens,  // BCD tens digit
    output [3:0] bcd_ones   // BCD ones digit
);
    
    assign bcd_tens = binary_in / 10; // Integer division to get tens digit
    assign bcd_ones = binary_in % 10; // Modulo operation to get ones digit

endmodule
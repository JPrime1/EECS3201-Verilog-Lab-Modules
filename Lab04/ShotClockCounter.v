module ShotClockCounter(
    input clk,
    input pause,
    input reset,    
    input mode,     // 0 for 24 seconds, 1 for 30 seconds
    output reg [5:0] count
);
    
endmodule
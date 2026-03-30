// purpose: top level module for ATM system
// connects all core modules together (no FSM logic in Sprint 2)

module TopLevel(
    input clk,              // 50 MHz system clock

    input [9:0] sw,         // 10 switches input

    input btnEnter,         // ENTER button input
    input btnNext,          // NEXT button input

    output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5  // 6 seven segment displays
);

    // Reset logic: hidden reset when all switches are on and NEXT is pressed
    wire allSwOn = &sw;                 // true when all switches are 1
    wire rst = allSwOn & btnNext;       // hidden reset condition

    // Tick Generator
    wire tick;
    TickGenerator tickGen(
        .cin(clk),
        .rst(rst),
        .tick(tick)
    );


    // Button Modules
    wire enterPulse;
    wire nextPulse;

    Button enterButton(
        .clk(clk),
        .tick(tick),
        .btn(btnEnter),
        .pulse(enterPulse)
    );

    Button nextButton(
        .clk(clk),
        .tick(tick),
        .btn(btnNext),
        .pulse(nextPulse)
    );


    // Input Register (captures switch value)
    wire [9:0] inputValue;

    InputRegister inputReg(
        .clk(clk),
        .rst(rst),
        .enterPulse(enterPulse),
        .sw(sw),
        .value(inputValue)
    );

    // Menu Index Register
    wire [2:0] menuIndex;
    MenuIndexRegister menuReg(
        .clk(clk),
        .rst(rst),
        .nextPulse(nextPulse),
        .index(menuIndex)
    );

    // Balance Register (core storage)
    wire [9:0] balance;
    BalanceRegister balanceReg(
        .clk(clk),
        .depositEn(1'b0),      // Sprint 2 placeholder (FSM will drive later)
        .withdrawEn(1'b0),     // Sprint 2 placeholder
        .amount(inputValue),
        .balance(balance)
    );

    // Display Driver (temporary debug view)
    DisplayDriver display(
        .sw(sw),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

endmodule
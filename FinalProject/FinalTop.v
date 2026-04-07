// purpose: top level module for ATM system
// connects all core modules together (no FSM logic in Sprint 2)

module FinalTop(
    input CLOCK_50,     // 50 MHz system clock
    input [9:0] SW,     // 10 switches input
    input [1:0] KEY,    // 2 buttons input (ENTER, NEXT)

    output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

    // rename inputs for clarity
    wire clk = CLOCK_50;    // 50 MHz clock
    wire [9:0] sw = SW;     // 10 switches
    wire btnEnter = KEY[0]; // ENTER button
    wire btnNext = KEY[1];  // NEXT button

    // Reset logic: hidden reset when switch[9] and NEXT pressed
    wire rst = sw[9] & btnNext;

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

    // Input Register
    wire [9:0] inputValue;
    // NEW: live switch value for real-time display
    wire [9:0] liveAmount;
    assign liveAmount = sw;

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
        .index(menuIndex),
        .inMenuState(inMenuState)
    );

    // Balance Register (moved before FSM usage safety)
    wire [9:0] balance;

    BalanceRegister balanceReg(
        .clk(clk),
        .depositEn(depositEn),
        .withdrawEn(withdrawEn),
        .amount(inputValue),
        .balance(balance)
    );

    // PIN SYSTEM
    wire [9:0] storedPin;
    wire pinValid;
    wire pinFail;
    wire locked;

    // FIX: removed unsafe state comparison in top module
    wire loadPin;

    // FIX: PIN load should depend on FSM state (safe method via state == PIN_SET)
    assign loadPin = enterPulse & (state == 3'd7);

    PinRegister pinReg(
        .clk(clk),
        .rst(rst),
        .load(loadPin),
        .newPin(inputValue),
        .pin(storedPin)
    );

    PinComparator pinComp(
        .clk(clk),
        .enterPulse(enterPulse),
        .enteredPin(inputValue),
        .storedPin(storedPin),
        .pinValidPulse(pinValid),
        .pinFailPulse(pinFail)
    );

    AttemptCounter attemptCounter(
        .clk(clk),
        .rst(rst),
        .fail(pinFail),
        .success(pinValid),
        .locked(locked)
    );

    // FSM wires
    wire [3:0] state;
    wire depositEn;
    wire withdrawEn;
    wire txnSuccess;
    wire txnError;
    wire inMenuState;   // FSM: to indicate when in menu state
    wire timeout = 1'b0;

    ATMStateFSM fsm(
        .clk(clk),
        .rst(rst),
        .enterPulse(enterPulse),
        .nextPulse(nextPulse),
        .pinValid(pinValid),
        .pinFail(pinFail),
        .timeout(timeout),
        .menuIndex(menuIndex),
        .amount(inputValue),
        .balance(balance),

        .depositEn(depositEn),
        .withdrawEn(withdrawEn),
        .txnSuccess(txnSuccess),
        .txnError(txnError),
        .state(state),
        .inMenuState(inMenuState),
        .lastDeposit(lastDeposit),
        .lastWithdraw(lastWithdraw)
    );

    // Display Driver
    wire finalSuccess = txnSuccess | depositEn | withdrawEn;
    wire finalError = txnError | pinFail | locked;
    wire [9:0] lastDeposit;
    wire [9:0] lastWithdraw;

    ATMDisplayDriver display(
        .state(state),
        .menuIndex(menuIndex),
        .lastDeposit(lastDeposit),  
        .lastWithdraw(lastWithdraw),
        .balance(balance),
        .amount(liveAmount), // display live switch value for real-time feedback
        .txnSuccess(finalSuccess),
        .txnError(finalError),

        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

endmodule
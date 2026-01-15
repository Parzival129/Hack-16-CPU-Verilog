module CPU16(

    input[15:0] instruction,
    input[15:0] inM,
    input clk,
    input rst,

    output[15:0] outM,
    output[14:0] addressM,
    output[14:0] pc,
    output writeM

);

    // setup


    wire ALoad;
    wire[15:0] ARegisterOut;
    wire DLoad;
    wire[15:0] DRegisterOut;
    wire[15:0] ARegisterIn;

    register16 registerA(.in(ARegisterIn), .clk(clk), .rst(1'b0), 
        .load(ALoad), .out(ARegisterOut));

    register16 registerD(.in(ALUOut), .clk(clk), .rst(1'b0), 
        .load(DLoad), .out(DRegisterOut));
 
    // THE D Register is a clock cycle ahead for some reason

    wire[15:0] ALUY;
    wire[15:0] ALUOut;
    wire Zero;
    wire Negative;


    mux16 mux16_1(.A(ARegisterOut), .B(inM), .sel(instruction[12]), .out(ALUY));

    // ALU computation

    ALU alu16(
        .X(DRegisterOut),
        .Y(ALUY),
        .zx(instruction[11]),
        .nx(instruction[10]),
        .zy(instruction[9]),
        .ny(instruction[8]),
        .f(instruction[7]),
        .no(instruction[6]),
        .out(ALUOut),
        .zr(Zero),
        .ng(Negative)
        );
    
    // Register Logic


    wire[15:0] ARegisterALUIn;
    wire NotX;
    wire tmp1;
    wire writeMOut;
    wire tmp3;

    mux16 mux16_2(.A(16'b0), .B(ALUOut), .sel(instruction[5]), .out(ARegisterALUIn));
    mux16 mux16_3(.A(instruction), .B(ARegisterALUIn), .sel(instruction[15]), .out(ARegisterIn));

    not notX(NotX, instruction[15]);
    or or1(ALoad, instruction[5], NotX);

    and and0(DLoad, instruction[4], instruction[15]);

    // Extra Outputs

    and and1(writeMOut, instruction[3], instruction[15]);
    assign addressM = ARegisterOut;
    assign writeM = writeMOut;

    mux16 mux16_4(.A(16'b0), .B(ALUOut), .sel(writeMOut), .out(outM));

    // Jump logic

    // Comparison flags from ALU
    wire NotZero, NotNegative, Greater, NotGreater;
    wire GreaterOrZero, LesserOrZero, GreaterOrLesser;

    assign Greater = ~Zero & ~Negative;
    assign Equal = Zero;
    assign Lesser = Negative;
    assign NotZero = ~Zero;
    assign NotNegative = ~Negative;
    assign NotGreater = ~Greater;
    assign GreaterOrZero = Greater | Zero;
    assign LesserOrZero = Negative | Zero;
    assign GreaterOrLesser = Greater | Negative;

    // Decode jump condition patterns
    wire MustGreaterEqual; // 011
    wire MustLesserEqual;  // 110
    wire MustNotEqual;     // 101
    wire MustGreater;      // 001
    wire MustEqual;        // 010
    wire MustLesser;       // 100
    wire NoJump;           // 000

    wire lesser1, greater1, equal1;
    wire not2, not1, not3, not4, not5, not6;
    wire check1, check2, check3;
    wire Andx, Andy, Andz;
    wire j0, j1, j2, oneCheck;

    // MustGreaterEqual (011) - j2'j1j0
    not(lesser1, instruction[2]);
    and(check1, instruction[1], instruction[0]);
    and(MustGreaterEqual, check1, lesser1);

    // MustLesserEqual (110) - j2j1j0'
    not(greater1, instruction[0]);
    and(check2, instruction[2], instruction[1]);
    and(MustLesserEqual, check2, greater1);

    // MustNotEqual (101) - j2j1'j0
    not(equal1, instruction[1]);
    and(check3, instruction[0], instruction[2]);
    and(MustNotEqual, check3, equal1);

    // MustGreater (001) - j2'j1'j0
    not(not2, instruction[2]);
    not(not1, instruction[1]);
    and(Andx, not2, not1);
    and(MustGreater, Andx, instruction[0]);

    // MustEqual (010) - j2'j1j0'
    not(not3, instruction[2]);
    not(not4, instruction[0]);
    and(Andy, not3, not4);
    and(MustEqual, Andy, instruction[1]);

    // MustLesser (100) - j2j1'j0'
    not(not5, instruction[0]);
    not(not6, instruction[1]);
    and(Andz, not5, not6);
    and(MustLesser, Andz, instruction[2]);

    // NoJump (000) - j2'j1'j0'
    not(j0, instruction[0]);
    not(j1, instruction[1]);
    not(j2, instruction[2]);
    and(oneCheck, j0, j1);
    and(NoJump, oneCheck, j2);

    // Multiplexers to select conditions
    wire Mux1, Mux2, Mux3, Mux4, Mux5, Mux6;
    wire And1, And2, And3, And4;
    wire PrePC, NotPrePC, FinalPrePC;

    assign Mux1 = MustGreaterEqual ? GreaterOrZero : 1'b1;
    assign Mux2 = MustLesserEqual ? LesserOrZero : 1'b1;
    assign Mux3 = MustNotEqual ? GreaterOrLesser : 1'b1;
    assign Mux4 = MustGreater ? Greater : 1'b1;
    assign Mux5 = MustEqual ? Zero : 1'b1;
    assign Mux6 = MustLesser ? Negative : 1'b1;

    and(And1, Mux1, Mux2);
    and(And2, Mux3, Mux4);
    and(And3, Mux5, Mux6);
    and(And4, And1, And2);
    and(PrePC, And4, And3);

    not(NotPrePC, PrePC);
    assign FinalPrePC = NoJump ? NotPrePC : PrePC;

    and(PCLoad, instruction[15], FinalPrePC);

    // Program Counter

    pc pc1(.in(ARegisterOut[14:0]), .clk(clk), .load(PCLoad), .inc(1'b1), .rst(rst), .out(pc));


endmodule
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

    // Setup

    wire ALoad;
    wire[15:0] ARegisterOut;
    wire DLoad;
    wire[15:0] DRegisterOut;
    wire[15:0] ARegisterIn;

    register16 registerA(.in(ARegisterIn), .clk(clk), .rst(1'b0), 
        .load(ALoad), .out(ARegisterOut));

    register16 registerD(.in(ALUOut), .clk(clk), .rst(1'b0), 
        .load(DLoad), .out(DRegisterOut));
 
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

    wire JGT;
    wire JEQ;
    wire JLT;
    wire JEQorJLT;
    wire prePC;
    wire PCLoad;

    wire Greater;
    wire Equal;
    wire Lesser;

    assign Greater = ~Zero & ~Negative;
    assign Equal = Zero;
    assign Lesser = Negative;

    and andJGT(JGT, Greater, instruction[0]);
    and andJEQ(JEQ, Equal, instruction[1]);
    and andJLT(JLT, Lesser, instruction[2]);

    or or2(JEQorJLT, JEQ, JLT);
    or or3(prePC, JGT, JEQorJLT);

    and and2(PCLoad, prePC, instruction[15]);

    // Program Counter

    pc pc1(.in(ARegisterOut[14:0]), .clk(clk), .load(PCLoad), .inc(1'b1), .rst(rst), .out(pc));


endmodule
module ALU(
    input[15:0] X,
    input[15:0] Y,
    input zx,
    input nx,
    input f,
    input no,
    input zy,
    input ny,
    
    output[15:0] out,
    output zr,
    output ng 
);

    // PREPROCESSING

    wire[15:0] mux1Out;
    wire[15:0] mux2Out;

    wire[15:0] zeroX;
    wire[15:0] workingX;

    wire[15:0] zeroY;
    wire[15:0] workingY;

    mux16 mux1 (.A(X), .B(16'b0), .sel(zx), .out(mux1Out));
    mux16 mux2 (.A(Y), .B(16'b0), .sel(zy), .out(mux2Out));

    not notX[15:0] (zeroX, mux1Out);
    mux16 mux3 (.A(mux1Out), .B(zeroX), .sel(nx), .out(workingX));

    not notY[15:0] (zeroY, mux2Out);
    mux16 mux4 (.A(mux2Out), .B(zeroY), .sel(ny), .out(workingY));

    // PROCESSING

    wire[15:0] andOut;
    wire[15:0] addOut;
    wire[15:0] mux5Out;
    wire[15:0] not1Out;
    wire[15:0] finalMuxOut;

    and and1[15:0] (andOut, workingX, workingY);
    add16 add16_1 (.A(workingX), .B(workingY), .out(addOut));

    mux16 mux5 (.A(andOut), .B(addOut), .sel(f), .out(mux5Out));
    not not1[15:0] (not1Out, mux5Out);

    mux16 mux6 (.A(mux5Out), .B(not1Out), .sel(no), .out(finalMuxOut));

    // POST-PROCESSING

    assign zr = ~|finalMuxOut;
    assign out = finalMuxOut;
    assign ng = finalMuxOut[15];

endmodule
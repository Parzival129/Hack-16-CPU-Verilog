module inc16(
    input[15:0] in,
    output[15:0] out
);

    add16 incrementer(
        .A(in),
        .B(16'b0000000000000001),
        .out(out)
    );


endmodule // inc16
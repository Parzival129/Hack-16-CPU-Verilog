module mux(
    input A,
    input B,
    input sel,
    output out
);

    not not1(not1Out, sel);
    and and1(and1Out, A, not1Out);
    and and2(and2Out, B, sel);
    or or1(out, and1Out, and2Out);

endmodule // mux
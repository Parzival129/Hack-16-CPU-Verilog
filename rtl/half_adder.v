module half_adder(
    input A,
    input B,
    output carry,
    output sum
);

    and and1(carry, A, B);
    xor xor1(sum, A, B);

endmodule // half_adder
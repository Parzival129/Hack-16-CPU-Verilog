module full_adder(
    input A,
    input B,
    input C,
    output carry,
    output sum
);

    wire sum1;
    wire carry1;
    wire carry2;

    // Instantiate the adder
    half_adder half_adder_1(
        .A(B),
        .B(C),
        .sum(sum1),
        .carry(carry1)
    );

    half_adder half_adder_2(
        .A(A),
        .B(sum1),
        .sum(sum),
        .carry(carry2)
    );

    or or1(carry, carry2, carry1);

endmodule // full_adder
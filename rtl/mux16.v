module mux16(
    input[15:0] A,
    input[15:0] B,
    input sel,
    output[15:0] out
);
    
    assign out = sel ? B : A;

endmodule
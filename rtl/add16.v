module add16(
    input[15:0] A,
    input[15:0] B,
    output[15:0] out
);
    wire out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15;
    full_adder full_adder_0(.A(A[0]), .B(B[0]), .C(1'b0), .sum(out[0]), .carry(out0));
    full_adder full_adder_1(.A(A[1]), .B(B[1]), .C(out0), .sum(out[1]), .carry(out1));
    full_adder full_adder_2(.A(A[2]), .B(B[2]), .C(out1), .sum(out[2]), .carry(out2));
    full_adder full_adder_3(.A(A[3]), .B(B[3]), .C(out2), .sum(out[3]), .carry(out3));
    full_adder full_adder_4(.A(A[4]), .B(B[4]), .C(out3), .sum(out[4]), .carry(out4));
    full_adder full_adder_5(.A(A[5]), .B(B[5]), .C(out4), .sum(out[5]), .carry(out5));
    full_adder full_adder_6(.A(A[6]), .B(B[6]), .C(out5), .sum(out[6]), .carry(out6));
    full_adder full_adder_7(.A(A[7]), .B(B[7]), .C(out6), .sum(out[7]), .carry(out7));
    full_adder full_adder_8(.A(A[8]), .B(B[8]), .C(out7), .sum(out[8]), .carry(out8));
    full_adder full_adder_9(.A(A[9]), .B(B[9]), .C(out8), .sum(out[9]), .carry(out9));
    full_adder full_adder_10(.A(A[10]), .B(B[10]), .C(out9), .sum(out[10]), .carry(out10));
    full_adder full_adder_11(.A(A[11]), .B(B[11]), .C(out10), .sum(out[11]), .carry(out11));
    full_adder full_adder_12(.A(A[12]), .B(B[12]), .C(out11), .sum(out[12]), .carry(out12));
    full_adder full_adder_13(.A(A[13]), .B(B[13]), .C(out12), .sum(out[13]), .carry(out13));
    full_adder full_adder_14(.A(A[14]), .B(B[14]), .C(out13), .sum(out[14]), .carry(out14));
    full_adder full_adder_15(.A(A[15]), .B(B[15]), .C(out14), .sum(out[15]), .carry(out15));


endmodule
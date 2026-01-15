`timescale 1ns / 1ns
`include "../rtl/add16.v"
`include "../rtl/full_adder.v"
`include "../rtl/half_adder.v"

module add16_tb;

reg[15:0] A;
reg[15:0] B;
wire[15:0] out;

add16 uut(A, B, out);

initial begin

    $dumpfile("../sim/add16.vcd");
    $dumpvars(0, add16_tb);

    A= 16'd32768; B=16'd16891; #20;


    $display("test completed!");

end

endmodule // add16_tb
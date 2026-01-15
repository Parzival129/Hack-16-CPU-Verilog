`timescale 1ns / 1ns
`include "../rtl/half_adder.v"

module half_adder_tb;

reg A;
reg B;
wire carry;
wire sum;

half_adder uut(A, B, carry, sum);

initial begin

    $dumpfile("../sim/half_adder.vcd");
    $dumpvars(0, half_adder_tb);

    {A, B} = 2'd0; #20;
    {A, B} = 2'd1; #20;
    {A, B} = 2'd2; #20;
    {A, B} = 2'd3; #20;

    $display("test completed!");

end

endmodule // half_adder
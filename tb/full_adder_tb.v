`timescale 1ns / 1ns
`include "../rtl/full_adder.v"
`include "../rtl/half_adder.v"

module full_adder_tb;

reg A;
reg B;
reg C;
wire carry;
wire sum;

full_adder uut(A, B, C, carry, sum);

initial begin

    $dumpfile("../sim/full_adder.vcd");
    $dumpvars(0, full_adder_tb);

    {A, B, C} = 3'd0; #20;
    {A, B, C} = 3'd1; #20;
    {A, B, C} = 3'd2; #20;
    {A, B, C} = 3'd3; #20;
    {A, B, C} = 3'd4; #20;
    {A, B, C} = 3'd5; #20;
    {A, B, C} = 3'd6; #20;
    {A, B, C} = 3'd7; #20;


    $display("test completed!");

end

endmodule // full_adder
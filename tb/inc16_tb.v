`timescale 1ns / 1ns
`include "../rtl/inc16.v"
`include "../rtl/add16.v"
`include "../rtl/full_adder.v"
`include "../rtl/half_adder.v"

module inc16_tb;

reg[15:0] A;
wire[15:0] out;

inc16 uut(A, out);

initial begin
    
    $dumpfile("../sim/inc16.vcd");
    $dumpvars(0, inc16_tb);

    A[15:0] = 16'd0; #20;
    A[15:0] = 16'd123; #20;
    A[15:0] = 16'd65535; #20;

    $display("test completed!");

end

endmodule //inc16_tb
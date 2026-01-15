`timescale 1ns / 1ns
`include "../rtl/register16.v"

module register16_tb;

    reg clk;
    reg rst;
    reg load;
    reg[15:0] in;
    wire[15:0] out;

    register16 uut(
        .clk(clk),
        .rst(rst),
        .load(load),
        .in(in),
        .out(out)
    );

    always #10 clk = ~clk; //toggle the clock ever 5 ns

    initial begin

        $dumpfile("../sim/register16.vcd");
        $dumpvars(0, register16_tb);

        clk = 0;

        rst = 1; #10;
        rst = 0; #10;

        load = 1; #10;
        in = 16'd123; #10;
        load = 0; #10;
        in = 16'd0; #10;

        rst = 1; #10;
        rst = 0; #10;

        $display("Testing complete!");

        $finish; // need to have this to tell the clock to stop

    end


endmodule // register_tb
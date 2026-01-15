`timescale 1ns / 1ns
`include "../rtl/mux.v"

module mux_tb;

reg A;
reg B;
reg sel;
wire out;

mux uut(A, B, sel, out);

initial begin

    $dumpfile("../sim/mux.vcd");
    $dumpvars(0, mux_tb);

    {A, B, sel} = 3'd0; #20; 
    {A, B, sel} = 3'd1; #20; 
    {A, B, sel} = 3'd2; #20; 
    {A, B, sel} = 3'd3; #20; 
    {A, B, sel} = 3'd4; #20; 
    {A, B, sel} = 3'd5; #20; 
    {A, B, sel} = 3'd6; #20; 
    {A, B, sel} = 3'd7; #20; 
    $display("test completed");

end

endmodule // mux_tb
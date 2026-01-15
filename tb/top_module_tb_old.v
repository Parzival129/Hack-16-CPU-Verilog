`timescale 1ns / 1ns
`include "../rtl/top_module.v"
`include "../rtl/ALU.v"
`include "../rtl/add16.v"
`include "../rtl/full_adder.v"
`include "../rtl/half_adder.v"
`include "../rtl/mux16.v"
`include "../rtl/register16.v"
`include "../rtl/pc.v"


// VERY CLOSE, SOMETHING WRONG WITH OUTM AND PC, MAYBE ADJUST CLOCK TIMING

module cpu16_tb;

    reg[15:0] instruction;
    reg[15:0] inM;
    reg clk;
    reg rst;

    wire[15:0] outM;
    wire[14:0] addressM;
    wire[14:0] pc;
    wire writeM;

    CPU16 uut(
        .instruction(instruction),
        .inM(inM),
        .clk(clk),
        .rst(rst),

        .outM(outM),
        .addressM(addressM),
        .pc(pc),
        .writeM(writeM)
    );

    always #10 clk = ~clk; //toggle the clock ever 10 ns

    initial begin

        $dumpfile("../sim/top_module.vcd");
        $dumpvars(0, cpu16_tb);
            // 1. Initialize
        clk = 0; 
        rst = 1; 
        inM = 0; 
        instruction = 0;

        // 2. Reset Phase
        #5;            // Small offset
        rst = 1; 
        #10;           // First rising edge occurs at #10 while rst is high
        #10;           // Falling edge at #20;
        rst = 0;       // Release reset on a falling edge

            
        #5;

        inM=0; instruction=16'b0011000000111001; #20;
        inM=0; instruction=16'b0011000000111001; #20;
        inM=0; instruction=16'b1110110000010000; #20;
        inM=0; instruction=16'b0101101110100000; #20;
        inM=0; instruction=16'b1110000111010000; #20;
        inM=0; instruction=16'b0000001111101000; #20;
        inM=0; instruction=16'b1110001100001000; #20;
        inM=0; instruction=16'b0000001111101001; #20;
        inM=0; instruction=16'b1110001110011000; #20;
        inM=0; instruction=16'b0000001111101000; #20;
        inM=16'd11111; instruction=16'b1111010011010000; #20;
        inM=16'd11111; instruction=16'b0000000000001110; #20;
        inM=16'd11111; instruction=16'b1110001100000100; #20;
        inM=16'd11111; instruction=16'b0000001111100111; #20;
        inM=16'd11111; instruction=16'b1110110111100000; #20;
        inM=16'd11111; instruction=16'b1110001100001000; #20;
        inM=16'd11111; instruction=16'b0000000000010101; #20;
        inM=16'd11111; instruction=16'b1110011111000010; #20;
        inM=16'd11111; instruction=16'b0000000000000010; #20;
        inM=16'd11111; instruction=16'b1110000010010000; #20;
        inM=16'd11111; instruction=16'b0000001111101000; #20;
        inM=16'd11111; instruction=16'b1110111010010000; #20;
        inM=16'd11111; instruction=16'b1110001100000001; #20;
        inM=16'd11111; instruction=16'b1110001100000010; #20;
        inM=16'd11111; instruction=16'b1110001100000011; #20;
        inM=16'd11111; instruction=16'b1110001100000100; #20;
        inM=16'd11111; instruction=16'b1110001100000101; #20;
        inM=16'd11111; instruction=16'b1110001100000110; #20;
        inM=16'd11111; instruction=16'b1110001100000111; #20;
        inM=16'd11111; instruction=16'b1110101010010000; #20;
        inM=16'd11111; instruction=16'b1110001100000001; #20;
        inM=16'd11111; instruction=16'b1110001100000010; #20;
        inM=16'd11111; instruction=16'b1110001100000011; #20;
        inM=16'd11111; instruction=16'b1110001100000100; #20;
        inM=16'd11111; instruction=16'b1110001100000101; #20;
        inM=16'd11111; instruction=16'b1110001100000110; #20;
        inM=16'd11111; instruction=16'b1110001100000111; #20;
        inM=16'd11111; instruction=16'b1110111111010000; #20;
        inM=16'd11111; instruction=16'b1110001100000001; #20;
        inM=16'd11111; instruction=16'b1110001100000010; #20;
        inM=16'd11111; instruction=16'b1110001100000011; #20;
        inM=16'd11111; instruction=16'b1110001100000100; #20;
        inM=16'd11111; instruction=16'b1110001100000101; #20;
        inM=16'd11111; instruction=16'b1110001100000110; #20;
        inM=16'd11111; instruction=16'b1110001100000111; #20;
        inM=16'd11111; instruction=16'b1110001100000111; rst=1; #20;
        inM=16'd11111; instruction=16'b0111111111111111; rst=0; #20;

        #100;

        $display("Testing complete! :)");
        $finish;

    end

endmodule
`timescale 1ns / 1ns
`include "../rtl/top_module.v"
`include "../rtl/ALU.v"
`include "../rtl/add16.v"
`include "../rtl/full_adder.v"
`include "../rtl/half_adder.v"
`include "../rtl/mux16.v"
`include "../rtl/register16.v"
`include "../rtl/pc.v"

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

    // Clock generation - toggle every 10 ns (50 MHz)
    always #10 clk = ~clk;

    // Test counter for display
    integer test_num;

    initial begin
        $dumpfile("../sim/top_module.vcd");
        $dumpvars(0, cpu16_tb);
        
        // Initialize
        clk = 0; 
        rst = 1; 
        inM = 0; 
        instruction = 0;
        test_num = 0;

        // Reset Phase - hold reset high for first clock edge
        #5;            // Small offset to 5ns
        rst = 1;       // Reset is high
        #10;           // First rising edge at 10ns with reset high
        #10;           // Falling edge at 20ns
        rst = 0;       // Release reset at falling edge
        #5;            // Now at 25ns, next rising edge at 30ns
        
        $display("time| inM  |  instruction   |reset| outM  |writeM |addre| pc  |DRegiste|");
        
        // Test 0: @12345 (0011000000111001)
        inM=16'd0; instruction=16'b0011000000111001; 
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 1: Continue with same instruction to load A
        test_num = 1;
        inM=16'd0; instruction=16'b1110110000010000;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 2: D=A (1110110000010000)
        test_num = 2;
        inM=16'd0; instruction=16'b0101101110100000;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 3: @23456 (0101101110100000)
        test_num = 3;
        inM=16'd0; instruction=16'b1110000111010000;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        
        // Test 5: @1000 (0000001111101000)
        test_num = 5;
        inM=16'd0; instruction=16'b0000001111101000;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 6: M=D (1110001100001000)
        test_num = 6;
        inM=16'd0; instruction=16'b1110001100001000;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 7: @1001 (0000001111101001)
        test_num = 7;
        inM=16'd0; instruction=16'b0000001111101001;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 8: MD=D-1 (1110001110011000)
        test_num = 8;
        inM=16'd0; instruction=16'b1110001110011000;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 9: @1000 (0000001111101000)
        test_num = 9;
        inM=16'd0; instruction=16'b0000001111101000;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 10: D=M-D (1111010011010000) with inM=11111
        test_num = 10;
        inM=16'd11111; instruction=16'b1111010011010000;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 11: @14 (0000000000001110)
        test_num = 11;
        inM=16'd11111; instruction=16'b0000000000001110;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 12: D;JLT (1110001100000100) - should jump to 14
        test_num = 12;
        inM=16'd11111; instruction=16'b1110001100000100;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 13: @999 (0000001111100111) - PC should be 15 now
        test_num = 13;
        inM=16'd11111; instruction=16'b0000001111100111;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 14: A=A+1;JEQ (1110110111100000)
        test_num = 14;
        inM=16'd11111; instruction=16'b1110110111100000;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 15: M=D (1110001100001000)
        test_num = 15;
        inM=16'd11111; instruction=16'b1110001100001000;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 16: @21 (0000000000010101)
        test_num = 16;
        inM=16'd11111; instruction=16'b0000000000010101;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 17: 0;JNE (1110011111000010) - should jump to 21
        test_num = 17;
        inM=16'd11111; instruction=16'b1110011111000010;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 18: @2 (0000000000000010)
        test_num = 18;
        inM=16'd11111; instruction=16'b0000000000000010;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 19: D=A-1 (1110000010010000)
        test_num = 19;
        inM=16'd11111; instruction=16'b1110000010010000;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 20: @1000 (0000001111101000)
        test_num = 20;
        inM=16'd11111; instruction=16'b0000001111101000;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 21: D=-1 (1110111010010000)
        test_num = 21;
        inM=16'd11111; instruction=16'b1110111010010000;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 22-28: Jump condition tests (JGT, JEQ, JGE, JLT, JNE, JLE, JMP)
        // Test 22: D;JGT (1110001100000001)
        test_num = 22;
        inM=16'd11111; instruction=16'b1110001100000001;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 23: D;JEQ (1110001100000010)
        test_num = 23;
        inM=16'd11111; instruction=16'b1110001100000010;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 24: D;JGE (1110001100000011)
        test_num = 24;
        inM=16'd11111; instruction=16'b1110001100000011;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 25: D;JLT (1110001100000100) - should jump to 1000
        test_num = 25;
        inM=16'd11111; instruction=16'b1110001100000100;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 26-28: More jump tests
        test_num = 26;
        inM=16'd11111; instruction=16'b1110001100000101;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        test_num = 27;
        inM=16'd11111; instruction=16'b1110001100000110;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        test_num = 28;
        inM=16'd11111; instruction=16'b1110001100000111;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 29-36: Test with D=0
        test_num = 29;
        inM=16'd11111; instruction=16'b1110101010010000; // D=0
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Repeat jump tests with D=0
        test_num = 30;
        inM=16'd11111; instruction=16'b1110001100000001; // D;JGT
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        test_num = 31;
        inM=16'd11111; instruction=16'b1110001100000010; // D;JEQ - should jump
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        test_num = 32;
        inM=16'd11111; instruction=16'b1110001100000011; // D;JGE - should jump
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        test_num = 33;
        inM=16'd11111; instruction=16'b1110001100000100; // D;JLT
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        test_num = 34;
        inM=16'd11111; instruction=16'b1110001100000101; // D;JNE
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        test_num = 35;
        inM=16'd11111; instruction=16'b1110001100000110; // D;JLE - should jump
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        test_num = 36;
        inM=16'd11111; instruction=16'b1110001100000111; // D;JMP - should jump
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 37-43: Test with D=1
        test_num = 37;
        inM=16'd11111; instruction=16'b1110111111010000; // D=1
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Repeat jump tests with D=1
        test_num = 38;
        inM=16'd11111; instruction=16'b1110001100000001; // D;JGT - should jump
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        test_num = 39;
        inM=16'd11111; instruction=16'b1110001100000010; // D;JEQ
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        test_num = 40;
        inM=16'd11111; instruction=16'b1110001100000011; // D;JGE - should jump
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        test_num = 41;
        inM=16'd11111; instruction=16'b1110001100000100; // D;JLT
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        test_num = 42;
        inM=16'd11111; instruction=16'b1110001100000101; // D;JNE - should jump
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        test_num = 43;
        inM=16'd11111; instruction=16'b1110001100000110; // D;JLE
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        test_num = 44;
        inM=16'd11111; instruction=16'b1110001100000111; // D;JMP - should jump
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 45: Reset test
        test_num = 45;
        inM=16'd11111; instruction=16'b1110001100000111; rst=1;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;
        
        // Test 46: After reset
        test_num = 46;
        inM=16'd11111; instruction=16'b0111111111111111; rst=0;
        #10; $display("%4d|%6d|%b|  %b  |%7d|   %b   |%5d|%5d|%8d|", 
                      $time/20-1, inM, instruction, rst, outM, writeM, addressM, pc, uut.DRegisterOut);
        #10;

        #100;
        $display("\n=== Testing complete! ===");
        $finish;
    end

endmodule
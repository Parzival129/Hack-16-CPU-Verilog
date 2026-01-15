// `timescale 1ns / 1ns
// `include "../rtl/ALU.v"
// `include "../rtl/add16.v"
// `include "../rtl/full_adder.v"
// `include "../rtl/half_adder.v"
// `include "../rtl/mux16.v"

// module ALU_tb;

//     reg[15:0] X;
//     reg[15:0] Y;
//     reg zx;
//     reg nx;
//     reg f;
//     reg no;
//     reg zy;
//     reg ny;

//     wire zr;
//     wire ng;
//     wire[15:0] out;

// ALU uut(X, Y, zx, nx, f, no, zy, ny, out, zr, ng);

// // |        x         |        y         |zx |nx |zy |ny | f |no |       out        |zr |ng |
// // | 0000000000010001 | 0000000000000011 | 0 | 1 | 1 | 1 | 1 | 1 | 0000000000010010 | 0 | 0 |

// initial begin

//     $dumpfile("../sim/ALU.vcd");
//     $dumpvars(0, ALU_tb);

//     X= 16'b0000000000010001; 
//     Y= 16'b0000000000000011; 
//     {zx, nx, zy, ny, f, no} = 5'b011111;

//     #20;


// end

// endmodule


`timescale 1ns / 1ns
`include "../rtl/ALU.v"
`include "../rtl/add16.v"
`include "../rtl/full_adder.v"
`include "../rtl/half_adder.v"
`include "../rtl/mux16.v"


module ALU_tb;

    // Inputs
    reg [15:0] X;
    reg [15:0] Y;
    reg zx;
    reg nx;
    reg f;
    reg no;
    reg zy;
    reg ny;

    // Outputs
    wire [15:0] out;
    wire zr;
    wire ng;

    // Error Counter
    integer errors;

    // Instantiate the Unit Under Test (UUT)
    // Note: Mapped by name because your port order in ALU.v 
    // (zx, nx, f, no, zy, ny) differs from the table order.
    ALU uut (
        .X(X), 
        .Y(Y), 
        .zx(zx), 
        .nx(nx), 
        .f(f), 
        .no(no), 
        .zy(zy), 
        .ny(ny), 
        .out(out), 
        .zr(zr), 
        .ng(ng)
    );

    initial begin
        // Initialize Inputs
        X = 0; Y = 0;
        zx = 0; nx = 0; zy = 0; ny = 0; f = 0; no = 0;
        errors = 0;

        // Setup for GTKWave
        $dumpfile("../sim/ALU.vcd");
        $dumpvars(0, ALU_tb);

        // Wait for global reset
        #10;

        // --- TEST VECTORS FROM YOUR TABLE ---
        // Order: X, Y, zx, nx, zy, ny, f, no, expected_out, expected_zr, expected_ng
        
        // Row 1
        check(16'b0000000000000000, 16'b1111111111111111, 1, 0, 1, 0, 1, 0, 16'b0000000000000000, 1, 0);
        // Row 2
        check(16'b0000000000000000, 16'b1111111111111111, 1, 1, 1, 1, 1, 1, 16'b0000000000000001, 0, 0);
        // Row 3
        check(16'b0000000000000000, 16'b1111111111111111, 1, 1, 1, 0, 1, 0, 16'b1111111111111111, 0, 1);
        // Row 4
        check(16'b0000000000000000, 16'b1111111111111111, 0, 0, 1, 1, 0, 0, 16'b0000000000000000, 1, 0);
        // Row 5
        check(16'b0000000000000000, 16'b1111111111111111, 1, 1, 0, 0, 0, 0, 16'b1111111111111111, 0, 1);
        // Row 6
        check(16'b0000000000000000, 16'b1111111111111111, 0, 0, 1, 1, 0, 1, 16'b1111111111111111, 0, 1);
        // Row 7
        check(16'b0000000000000000, 16'b1111111111111111, 1, 1, 0, 0, 0, 1, 16'b0000000000000000, 1, 0);
        // Row 8
        check(16'b0000000000000000, 16'b1111111111111111, 0, 0, 1, 1, 1, 1, 16'b0000000000000000, 1, 0);
        // Row 9
        check(16'b0000000000000000, 16'b1111111111111111, 1, 1, 0, 0, 1, 1, 16'b0000000000000001, 0, 0);
        // Row 10
        check(16'b0000000000000000, 16'b1111111111111111, 0, 1, 1, 1, 1, 1, 16'b0000000000000001, 0, 0);
        // Row 11
        check(16'b0000000000000000, 16'b1111111111111111, 1, 1, 0, 1, 1, 1, 16'b0000000000000000, 1, 0);
        // Row 12
        check(16'b0000000000000000, 16'b1111111111111111, 0, 0, 1, 1, 1, 0, 16'b1111111111111111, 0, 1);
        // Row 13
        check(16'b0000000000000000, 16'b1111111111111111, 1, 1, 0, 0, 1, 0, 16'b1111111111111110, 0, 1);
        // Row 14
        check(16'b0000000000000000, 16'b1111111111111111, 0, 0, 0, 0, 1, 0, 16'b1111111111111111, 0, 1);
        // Row 15
        check(16'b0000000000000000, 16'b1111111111111111, 0, 1, 0, 0, 1, 1, 16'b0000000000000001, 0, 0);
        // Row 16
        check(16'b0000000000000000, 16'b1111111111111111, 0, 0, 0, 1, 1, 1, 16'b1111111111111111, 0, 1);
        // Row 17
        check(16'b0000000000000000, 16'b1111111111111111, 0, 0, 0, 0, 0, 0, 16'b0000000000000000, 1, 0);
        // Row 18
        check(16'b0000000000000000, 16'b1111111111111111, 0, 1, 0, 1, 0, 1, 16'b1111111111111111, 0, 1);
        
        // --- SECOND BATCH OF TESTS ---
        // Row 19
        check(16'b0000000000010001, 16'b0000000000000011, 1, 0, 1, 0, 1, 0, 16'b0000000000000000, 1, 0);
        // Row 20
        check(16'b0000000000010001, 16'b0000000000000011, 1, 1, 1, 1, 1, 1, 16'b0000000000000001, 0, 0);
        // Row 21
        check(16'b0000000000010001, 16'b0000000000000011, 1, 1, 1, 0, 1, 0, 16'b1111111111111111, 0, 1);
        // Row 22
        check(16'b0000000000010001, 16'b0000000000000011, 0, 0, 1, 1, 0, 0, 16'b0000000000010001, 0, 0);
        // Row 23
        check(16'b0000000000010001, 16'b0000000000000011, 1, 1, 0, 0, 0, 0, 16'b0000000000000011, 0, 0);
        // Row 24
        check(16'b0000000000010001, 16'b0000000000000011, 0, 0, 1, 1, 0, 1, 16'b1111111111101110, 0, 1);
        // Row 25
        check(16'b0000000000010001, 16'b0000000000000011, 1, 1, 0, 0, 0, 1, 16'b1111111111111100, 0, 1);
        // Row 26
        check(16'b0000000000010001, 16'b0000000000000011, 0, 0, 1, 1, 1, 1, 16'b1111111111101111, 0, 1);
        // Row 27
        check(16'b0000000000010001, 16'b0000000000000011, 1, 1, 0, 0, 1, 1, 16'b1111111111111101, 0, 1);
        // Row 28
        check(16'b0000000000010001, 16'b0000000000000011, 0, 1, 1, 1, 1, 1, 16'b0000000000010010, 0, 0);
        // Row 29
        check(16'b0000000000010001, 16'b0000000000000011, 1, 1, 0, 1, 1, 1, 16'b0000000000000100, 0, 0);
        // Row 30
        check(16'b0000000000010001, 16'b0000000000000011, 0, 0, 1, 1, 1, 0, 16'b0000000000010000, 0, 0);
        // Row 31
        check(16'b0000000000010001, 16'b0000000000000011, 1, 1, 0, 0, 1, 0, 16'b0000000000000010, 0, 0);
        // Row 32
        check(16'b0000000000010001, 16'b0000000000000011, 0, 0, 0, 0, 1, 0, 16'b0000000000010100, 0, 0);
        // Row 33
        check(16'b0000000000010001, 16'b0000000000000011, 0, 1, 0, 0, 1, 1, 16'b0000000000001110, 0, 0);
        // Row 34
        check(16'b0000000000010001, 16'b0000000000000011, 0, 0, 0, 1, 1, 1, 16'b1111111111110010, 0, 1);
        // Row 35
        check(16'b0000000000010001, 16'b0000000000000011, 0, 0, 0, 0, 0, 0, 16'b0000000000000001, 0, 0);
        // Row 36
        check(16'b0000000000010001, 16'b0000000000000011, 0, 1, 0, 1, 0, 1, 16'b0000000000010011, 0, 0);

        if (errors == 0)
            $display("ALL TESTS PASSED SUCCESSFULLY.");
        else
            $display("Finished with %d errors.", errors);
            
        $finish;
    end

    // Task to apply inputs and verify outputs
    task check;
        input [15:0] in_x;
        input [15:0] in_y;
        input i_zx, i_nx, i_zy, i_ny, i_f, i_no; // Match table order
        input [15:0] exp_out;
        input exp_zr, exp_ng;
        begin
            // 1. Apply Inputs
            X = in_x; Y = in_y;
            zx = i_zx; nx = i_nx; 
            zy = i_zy; ny = i_ny;
            f = i_f; no = i_no;

            // 2. Wait for propagation
            #10;

            // 3. Compare Outputs (using !== to catch unknowns/logic errors)
            if (out !== exp_out || zr !== exp_zr || ng !== exp_ng) begin
                $display("ERROR at time %t", $time);
                $display("Inputs: X=%b Y=%b zx=%b nx=%b zy=%b ny=%b f=%b no=%b", 
                         X, Y, zx, nx, zy, ny, f, no);
                $display("Expected: out=%b zr=%b ng=%b", exp_out, exp_zr, exp_ng);
                $display("Actual:   out=%b zr=%b ng=%b", out, zr, ng);
                errors = errors + 1;
            end
        end
    endtask

endmodule
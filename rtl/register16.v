module register16 (
    input wire clk,         
    input wire rst,    
    input wire load,      
    input wire [15:0] in,   
    output reg [15:0] out  // register since it holds state
);

    // Trigger on the rising edge of the clock or the reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Asynchronous Reset: Clear output to 0
            out <= 16'b0;
        end 
        else if (load) begin
            // If load is high, update output with input data
            out <= in;
        end
        // If load is low, d_out maintains its previous value automatically
    end

endmodule
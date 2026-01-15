module pc (
    input wire clk,           
    input wire rst,        
    input wire load,    
    input wire inc,      
    input wire [14:0] in,
    output reg [14:0] out  
);

    // Logic: Reset > Load > Increment > Hold
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 1. Reset: Clear PC to 0
            out <= 15'h0000;
        end 
        else if (load) begin
            // 2. Load: Jump to the address provided in pc_in
            out <= in;
        end 
        else if (inc) begin
            // 3. Increment: Move to the next instruction
            out <= out + 15'd1;
        end
        // 4. Default: If nothing is asserted, hold the current value.
    end

endmodule
# 16-Bit CPU in Verilog

This is a CPU designed using Verilog that follows the Hack cpu architecture and the instruction set illustrated in the book "Elements of Computing Systems" By Noam Nisan and Shimon Schocken.

Almost the entire CPU was designed using the structural modeling style where each gate and component was instantiated seperately. The instruction set is made up of A-instructions, instructions that write a 15-bit value to the A register and C instructions that handle all other computational tasks.

![CPU Specification](assets/cpu_specification.png)
![Instruction Specification](assets/instruction_specification.jpg)

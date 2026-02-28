# 16-Bit HACK CPU
![Verilog](https://img.shields.io/badge/Language-Verilog-orange)
![License](https://img.shields.io/badge/License-MIT-blue)
![Build](https://img.shields.io/badge/Build-Passing-brightgreen)

A modular, single-cycle 16-bit RISC processor implemented in Verilog HDL, based off the Hack architecture. This project demonstrates the fundamental principles of computer architecture, including instruction decoding, ALU operations, and memory management.

## Design Process

You can find a document of some of my notes during the design of this CPU here: [Google Drive](https://drive.google.com/file/d/1Qx1WprU1iW-c92LSJh5ZjYJF1c26F71X/view?usp=sharing).
My primary resource was the book *The Elements of Computing Systems: Building a Modern Computer from First Principles by Noam Nisan and Shimon Schocken*, to see the steps I took for the design I would recommend looking there: [nand2tetris website](https://www.nand2tetris.org/)

![CPU Specification](assets/cpu_specification.png)

## 📌 Features

* **16-bit Fixed-Width Design:** Operates on 16-bit data words and instructions throughout the entire datapath.
* **Hack ISA Implementation:** Full support for **A-instructions** (set A register) and **C-instructions** (computation/jump).
* **Unified ALU & Control Logic:** A hardwired control unit that decodes 16-bit instructions to drive the Hack ALU and register gates.
* **Harvard Architecture:** Dedicated interfaces for the **Instruction Memory (ROM)** and **Data Memory (RAM)**, allowing simultaneous instruction fetching and data access.
* **HDL Verified:** Built using Hardware Description Language (HDL) and validated against the standard *Nand2Tetris* test scripts (`CPU.tst`).

---

## Architecture Overview

The CPU follows a **Single-Cycle architecture**, executing one instruction per clock pulse by coordinating the ALU, registers, and program counter.

### Key Components:

1. **Program Counter (PC):** A 16-bit register with reset, load, and increment logic to fetch the next instruction from ROM32K.
2. **Registers (A, D, and M):**
* **A-Register:** Stores either a 15-bit address or a 16-bit data constant.
* **D-Register:** A dedicated 16-bit data register for storing intermediate computation results.
* **M-Register:** A "virtual" register representing the RAM value at the current address held by the A-register.
3. **Hack ALU:** Processes two 16-bit inputs (D and either A or M) to produce 18 possible functions including `ADD`, `AND`, `NOT`, and bitwise negation.
4. **Control Unit:** Decodes the 16-bit C-instruction to set the `a`, `c`, `d`, and `j` bits, managing routing and write-enable signals.
5. **Memory Mapping:** Directly interfaces with 16-bit addressable RAM and Memory-Mapped I/O for the Screen and Keyboard.

---

## 📜 Instruction Set Architecture (ISA)
Each instruction is 16 bits wide. Below is the encoding format:

![Instruction Specification](assets/instruction_specification.jpg)

---

## Getting Started

### Prerequisites
- **Simulation:** [Icarus Verilog](http://iverilog.icarus.com/) or **Vivado** / **ModelSim**.
- **Waveform Viewer:** [GTKWave](http://gtkwave.sourceforge.net/).

### Running the Simulation
1. **Clone the repo:**
   ```bash
   git clone https://github.com/Parzival129/16-Bit-Verilog-CPU.git
   cd 16-Bit-Verilog-CPU

2. **Compile and test top module with my vsim script**

```bash
vsim ../tb/top_module_tb.v
```
or for testing any other module with a testbenchh
```bash
vsim ../tb/[testbench file]
```

---


## 🗺️ Roadmap

* [ ] Implement a 3-stage pipeline to increase clock frequency.
* [ ] Add support for hardware interrupts.
* [ ] Expand the ISA to include floating-point operations.
* [ ] Deploy on a physical FPGA (e.g., Basys 3 or DE10-Lite).

## 🤝 Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.

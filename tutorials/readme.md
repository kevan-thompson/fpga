# Tutorials
---

This folder contains a basic VHDL files, TestBenches, and FPGA projects used to teach co-ops to write VHDL.

[Link to Free Version of Modelsim](https://www.intel.com/content/www/us/en/software-kit/750368/modelsim-intel-fpgas-standard-edition-software-version-18-1.html)

[Link to Vivado 2024.1](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2024-1.html)

## 1) Basic Gates

The file **gates.vhd** will show you how to create all the basic logic gates in VHDL. (NOT, AND, OR, XOR, NAND, NOR, and XNOR) as well as explain some of the basics of a VHDL file.

The testbench **gates_tb.vhd** is a basic testbench that can be used to simulate gates.vhd in your simulator of choice. (Modelsim etc) and explains some of the basics of a TestBenches

These files will show you how to:   
- Create a basic VDHL file
- Basic Logic operators
- How to use std_logic
- A simple testbench

## 2) Adders

The file **full_adder.vhd** implements a full adder. The circuit for a full adder is shown below:

![full_adder](./.images/full_adder.png)

A testbench for the full adder is found in **full_adder_tb.vhd**

The full adder is then used as a component in **ripple_carry_adder.vhd** to create an 8 bit ripple carry adder. The circuit for an 8 bit ripple carry adder is shown below.

![ripple_carry_adder](./.images/ripple_carry_adder_8_bit.jpg)

The testbench for the ripple carry adder can be found in **ripple_carry_adder_tb.vhd**

These files will show you how to:   
- Use an std_logic_vector
- Instantiate components
- Create a gatelevel implementation of an adder
- A testbench with loops

## 3) Multiplexers

The file **multiplexers.vhd** contains five different implementations of a 2x1 multiplexer. (Shown  below) The implementations include a gate level implementation, a "when/else" implementation, a "with/select" implementation, an implementation using a process and if/else statements, and an implementation using a process and a case statement.

![2x1 Multiplexers](./.images/mux.png)

A testbench is implemented in **multiplexers_tb.vhd**. This testbench will show that each implementation has the same output for the same inputs.

These files will show you how to:   
- Do concurrent conditional assignments (When/Else and With/Select)
- Do sequential conditional assignments (If/Else, and Case)

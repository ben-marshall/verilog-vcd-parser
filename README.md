
# Verilog VCD Parser

This project implements a no-frills *Value Change Dump* (VCD) file parser, as described
in the IEEE System Verilog 1800-2012 standard. It can be used to write custom tools
which need to read signal traces dumped out by Verilog (or VHDL) simulators.

---


## Tools

- The parser and lexical analyser are written using Bison and Flex respectively.
- The data structures and other functions are written using C++ 2011.
- The build system is GNU Make.
- The codebase is documented using Doxygen.

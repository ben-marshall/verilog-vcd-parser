
# Verilog Coverage

This project aims to implement a no-frills coverage collection tool for the
IEEE System Verilog 1800-2012 standard.

---

## Scope

- This tool implements a parser and coverage engine for the SV2012 coverage
  collection specification. It will not parse the entire SV2012 language.
- Initially, the tool supports only limited coverage collection in order
  create a minimum viable tool. Other complex features will be added at a
  later date / as the need arrises.
- The initial input format for the tool is a Value Change Dump (VCD)
  file, which most open (and closed) source verilog simulators can output.
- The initial output format for the tool will be a simple YAML file which
  reports the coverage metrics for each defined coverage group over a VCD
  file.

## Design Choices

- The parser and lexical analyser for the VCD and SV2012 parsers are
  written using Bison and Flex.
- The coverage engine is written using C++ 2011.
- The build system is GNU Make.
- The codebase is documented using Doxygen.

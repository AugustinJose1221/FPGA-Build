This folder contains all the testbench files to test the design modules.

To execute a testbench
  + Go to the FPGA-Build directory
  + Run iverilog -o outfiles/output_filename design/design_filename.v testbenches/testbench_name.v
  + Run vvp outfiles/output_filename
  + Run gtkwave vcd/vcd_filename.vcd

  Note:
    + Add all the design files used in the testbench while compiling the testbenchusing iverilog
    + The name of the vcd file (vcd_filename.vcd) generated is given in the testbench file

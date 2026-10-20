# FPGA pin planning

The supplied screenshot [Cyclone IV Pin Planner](../assets/screenshots/cyclone-iv-pin-planner.png) identifies the **Cyclone IV E EP4CE115F29C7** FPGA and shows example mappings for time inputs and outputs, including `H_in0`, `H_in1`, `H_out0`, and `H_out1`.

This repository does **not** contain a machine-readable original `.qsf` file, a validated board pin mapping, or a full original Quartus project. A screenshot is insufficient to reproduce all device pin constraints safely. In addition, signal naming/widths shown in the pictured symbols differ from the uploaded HDL interfaces in places.

## Before deploying

- Confirm the physical FPGA marking, board revision, I/O bank voltages, and Terasic DE2-115 pinout.
- Implement the real board-level top entity and reconcile pin names/widths with your actual HDL.
- Import or author a validated `.qsf` based on a board-specific authoritative reference, then compile.
- Confirm LEDs, switches, buttons, clock input, and seven-segment digit wiring, including active-low polarity.

The screenshot documents that pin planning was performed in Quartus; it is **not** a substitute for executable board constraints or evidence of a successful hardware test.

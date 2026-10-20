# Quartus project setup notes

## Available inputs

The repository includes original Verilog files and screenshot evidence, but **not** the original Quartus `.qpf`, `.qsf`, `.bdf`, `.vwf`, `.sof`, or a ready-to-program DE2-115 project.

## Rebuild workflow

1. Install a Quartus version that supports the exact Cyclone IV E device on your hardware and obtain the appropriate Terasic DE2-115 board reference materials.
2. Create a new Quartus project and select the exact FPGA part and speed grade shown on your board. The Pin Planner screenshot refers to `EP4CE115F29C7`; the Programmer screenshot uses a shortened `EP4CE115F29`-family display.
3. Add `rtl/*.v` as source files, reviewing their differences. `Clock`, `AlarmClock`, `Alarm`, and `SSegDisplay` are distinct modules, **not** a finished single top-level entity for the pictured hardware.
4. For an integrated design, implement or recover a top-level wrapper, a proper one-second clock-enable scheme, time-button debouncing, time-to-decimal-digit conversion, and six-digit seven-segment mapping.
5. Create Quartus pin assignments for the specific DE2-115 revision using the board manual; do not infer or copy arbitrary pins from a screenshot without verification.
6. Compile, address warnings, verify timing and I/O assignments, and simulate the intended top-level.
7. Attach the actual DE2-115 board and verify the programmer's JTAG hardware detection and target device before downloading a configuration image.

## Programming evidence

The supplied Quartus Programmer screenshot displays **No Hardware** near the hardware setup selector. A configuration file is listed, but that visual state does not establish a successful JTAG operation. Do not claim demonstrated physical-board programming on this evidence alone.

## Clock frequency

One image shows a 50 MHz waveform clock setting. The Verilog comments refer to 1 Hz signals, but there is no corresponding clock divider in the provided HDL. A 50 MHz input connected directly to the current state machine will not provide autonomous human-scale timekeeping.

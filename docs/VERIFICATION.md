# Verification and evidence matrix

| Item | Supplied evidence | What can be concluded | What is not established |
|---|---|---|---|
| Clock source code | `rtl/Clock.v` | Source includes set/reset and manual increment logic | Autonomous timekeeping, correct 12-hour formatting |
| Integrated alarm clock | `rtl/AlarmClock.v` | Source includes comparison, activity flag, and LED pattern logic | End-to-end alarm timing/correct blinking on a physical board |
| Standalone alarm | `rtl/Alarm.v` | Additional alarm design provided | Integration into `AlarmClock` |
| Seven-segment decode | `rtl/SSegDisplay.v` | Decimal-digit segment encodings are present | Complete six-digit top-level display wiring |
| Stimulus testbenches | `sim/*.v` | Reproducible stimulus source is supplied | Self-checking verification or a passing simulation run |
| Waveform images | `assets/screenshots/*waveform*`, `*simulation*` | Captured digital traces are shown | Exact matching run of submitted RTL and testbenches |
| Diagram captures | `assets/screenshots/*symbol*`, `*diagram*`, `*schematic*` | Schematic/symbol development was undertaken | Complete original editable `.bdf`/Quartus project supplied |
| FPGA pin-planning | `assets/screenshots/cyclone-iv-pin-planner.png` | Quartus device/pin planning screenshot exists | Complete validated `.qsf` |
| Programmer setup | `assets/screenshots/quartus-programmer-no-hardware.png` | Quartus Programmer setup shown | Successful board detection or FPGA programming (`No Hardware` displayed) |

This matrix describes artifacts included in the archive and static observations. Neither Quartus compilation nor a Verilog simulator run was performed while creating the repository package.

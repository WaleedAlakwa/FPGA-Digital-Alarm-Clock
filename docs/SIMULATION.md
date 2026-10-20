# Simulation guide

## Requirements

A locally installed Verilog simulator such as Icarus Verilog. No simulator executable or generated waveforms are included.

## Run the original testbenches

Run from the root of the repository:

```bash
mkdir -p build
iverilog -g2012 -s ClockTestBench -o build/clock_tb rtl/Clock.v sim/ClockTestBench.v
vvp -n build/clock_tb
iverilog -g2012 -s AlarmClockTestBench -o build/alarm_clock_tb rtl/AlarmClock.v sim/AlarmClockTestBench.v
vvp -n build/alarm_clock_tb
```

Use `vvp -n` to make `$stop` terminate instead of entering the simulator's interactive prompt. If you wish to inspect generated VCD waveforms in GTKWave, add explicit `$dumpfile` and `$dumpvars` calls to a local copy of the testbench; those calls are not in the original submissions.

## Interpreting the testbenches

- `ClockTestBench.v` drives basic resets, format selection, and a time-load sequence; it has no automatic pass/fail assertions.
- `AlarmClockTestBench.v` loads 00:00:00 and sets the alarm to 00:00:10, but never asserts `increment_sec`, so under the provided RTL stimulus the clock does not advance to the alarm match. It also loads 23:59:50 later without driving the increment controls.
- Both benches use a 10 ns full clock period (`#5` toggles), which compresses demonstration timing and is not an actual 1 Hz test or a simulation of a 50 MHz-to-1 Hz divider.
- Supplied waveform screenshots may come from related Quartus versions/schematic variants; they are not independently correlated to a run of the included six `.v` files.

## Recommended future assertions

1. Verify reset behavior in both formats, then that `set_time` loads the requested values.
2. Pulse `increment_sec` and assert 59→00 second rollover; verify minute and hour carry.
3. Test 23:59:59 rollover in 24-hour mode.
4. Check 12-hour display at 00, 12, and 23 after fixing `Clock.v`'s `12+1` defect.
5. Exercise alarm enable, match, duration, repeated match, and reset using known clock cycles.
6. Validate 7-segment patterns for digits 0–9, and blanking for invalid nibbles.

No such assertion-based regression is claimed as complete in this package.

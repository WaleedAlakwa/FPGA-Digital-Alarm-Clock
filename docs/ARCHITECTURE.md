# Architecture and signal notes

## Provided modules

| Module | Clocking | Inputs / outputs | Notes |
|---|---|---|---|
| `Clock` | `posedge main_clk` for state; separate display register block | Time set, reset, manual increments, 12/24 switch; 8-bit hours/minutes/seconds | Does not contain autonomous second ticker or seven-segment outputs |
| `AlarmClock` | `posedge main_clk` for state; separate display register block | Clock inputs plus alarm set/enable; `alarm_active`, `leds[17:0]` | Combines clock and alarm control; does not instantiate standalone `Alarm` |
| `Alarm` | `posedge clk` with asynchronous high reset | Current and alarm time, enable, active state, LEDs | Separate standalone module; 5-bit hour inputs and 6-bit minutes/seconds |
| `SSegDisplay` | Combinational look-up table | `digit[3:0]` to `seg[6:0]` | Active-low segment patterns for decimal digits 0–9 |

## Timekeeping behavior

The `Clock` and `AlarmClock` modules register time updates on `main_clk`. A `set_time` pulse loads user-provided hour/minute/second bytes. The `increment_sec`, `increment_min`, and `increment_hr` signals request updates. When seconds roll past 59, the corresponding code calls the minute increment helper; minutes likewise roll into hours.

There is **no unconditional `current_seconds <= current_seconds + 1` step on every tick**. Therefore a nominal 1 Hz input alone does not automatically count elapsed time, and feeding a 50 MHz board clock straight to `main_clk` is not sufficient to turn the delivered design into a wall clock.

The `format_switch` selects a 12- or 24-hour display conversion based on the hour storage. The `Clock.v` branch converts multiples of 12 into **13** instead of 12 (`12+1`), a known source defect. Both clock modules update `current_hours` in a separate clocked block, so display-hour updates and alarm comparisons require careful verification for cycle latency and mode switches. Neither model includes an explicit AM/PM output.

## Alarm behavior

`AlarmClock.v` compares `current_hours`, `current_minutes`, and `current_seconds` with the configured alarm time while `enable_alarm` is high. On a match, it asserts `alarm_active` and initializes a 10-count blink counter. The LED pattern alternates as the counter runs. As written, remaining at the matching time can reload this counter on every cycle; clearing and retrigger policies have not been fully validated.

`Alarm.v` implements a separate edge-triggered comparator and blink counter, but is not connected to `AlarmClock.v`. Users reconstructing the photographed top-level must decide which alarm architecture to use.

## Seven-segment output

`SSegDisplay.v` accepts one BCD-like hexadecimal nibble; for values 0–9 it drives seven-bit **active-low** segment patterns, otherwise outputs all 1s (blank). It does **not** extract decimal tens and ones from an 8-bit hour/minute/second value, perform multiplexing, or connect six digits on its own. The schematic pictures show additional wiring that is not present as a delivered HDL top-level.

## Source-versus-screenshot boundary

The photographs show a `seven seq displ`, `Aclock`, and other symbol/block variants. Their port names/widths do not match all the provided `.v` files. Therefore the photos are useful **historical design evidence**, not proof that the exact pictured Quartus block diagram can be reconstructed and built from this archive without additional files.

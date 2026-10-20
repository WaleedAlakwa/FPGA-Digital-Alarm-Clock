# Known limitations and engineering caveats

The uploaded HDL and imagery are preserved as historical project material. They are not represented as a production-ready wall clock.

1. **No autonomous one-second tick:** `Clock.v` and `AlarmClock.v` only change time when their increment inputs are asserted; the HDL has no frequency divider or one-second enable generator.
2. **Incorrect 12-hour conversion in `Clock.v`:** The expression `(hr_storage % 12 == 0) ? 12+1 : hr_storage % 12` returns **13** at multiples of 12, rather than 12.
3. **Hour-display update latency / sensitivity:** `current_hours` is assigned in a separate block sensitive to `posedge main_clk` and `posedge format_switch`. Its relation to `hr_storage` and behavior when format switching low warrant redesign and testing.
4. **Alarm test stimulus does not reach its target:** `AlarmClockTestBench.v` configures an alarm at 00:00:10 but does not drive `increment_sec`; therefore the expected elapsed-time match is not exercised by the provided stimulus alone.
5. **Repeated alarm triggering:** In `AlarmClock.v`, an equality match can reload the blink counter repeatedly if time remains at the alarm setting. Trigger duration and one-shot behavior need verification.
6. **Alarm functionality is duplicated:** `Alarm.v` and the embedded logic in `AlarmClock.v` are separate implementations; the standalone module is not instantiated in the integrated module.
7. **No source board-level top:** Pictured schematics/ports are not completely reproduced by an editable supplied top-level HDL or `.bdf`, and signals vary across screenshots.
8. **Seven-segment display integration missing:** `SSegDisplay.v` maps one 4-bit decimal digit, but no supplied HDL implements digit extraction, multiplexing, or six-digit board wiring.
9. **No validated physical build:** A Quartus project file, `.qsf` constraints, bitstream, full synthesis reports, and successful hardware verification are not supplied. The Programmer screenshot displays **No Hardware**.
10. **Simulation not independently reproduced:** The testbenches are stimulus-only, without assertions or pass/fail output. The waveforms shown are supplied screenshots, not newly generated from this release.
11. **Button conditioning absent:** Real mechanical inputs typically require synchronization/debouncing; such logic was not included.
12. **Reset semantics differ:** `Clock.v`/`AlarmClock.v` use synchronous reset in their main state blocks, while `Alarm.v` has asynchronous reset; integration requires explicit design decisions.

## Suggested improvements (not silently applied)

Implement a stable timebase with a one-cycle clock enable, correct time format handling, unify alarm logic, add a synthesizable integrated top with board constraints, and create assertion-based testbenches before claiming physical deployment. These changes would constitute a new revision and should be separated from the historical code preserved here.

// SPDX-FileCopyrightText: 2026 Waleed Alakwa
// SPDX-License-Identifier: MIT



`timescale 1ns / 1ps

module AlarmClockTestBench;

    // Inputs
    reg main_clk;
    reg reset;
    reg set_time;
    reg increment_hr;
    reg increment_min;
    reg increment_sec;
    reg format_switch;
    reg enable_alarm;
    reg [7:0] init_hours;
    reg [7:0] init_minutes;
    reg [7:0] init_seconds;
    reg [7:0] alarm_hours;
    reg [7:0] alarm_minutes;
    reg [7:0] alarm_seconds;

    // Outputs
    wire [7:0] current_hours;
    wire [7:0] current_minutes;
    wire [7:0] current_seconds;
    wire alarm_active;
    wire [17:0] leds;

    // Instantiate the Unit Under Test (UUT)
    AlarmClock uut (
        .main_clk(main_clk),
        .reset(reset),
        .set_time(set_time),
        .increment_hr(increment_hr),
        .increment_min(increment_min),
        .increment_sec(increment_sec),
        .format_switch(format_switch),
        .enable_alarm(enable_alarm),
        .init_hours(init_hours),
        .init_minutes(init_minutes),
        .init_seconds(init_seconds),
        .alarm_hours(alarm_hours),
        .alarm_minutes(alarm_minutes),
        .alarm_seconds(alarm_seconds),
        .current_hours(current_hours),
        .current_minutes(current_minutes),
        .current_seconds(current_seconds),
        .alarm_active(alarm_active),
        .leds(leds)
    );

    // Clock generation
    initial begin
        main_clk = 0;
        forever #5 main_clk = ~main_clk; // Simulate a 1Hz clock (100ns period for simplicity)
    end

    // Test stimulus
    initial begin
        // Initialize Inputs
        reset = 1;
        set_time = 0;
        increment_hr = 0;
        increment_min = 0;
        increment_sec = 0;
        format_switch = 0;
        enable_alarm = 0;
        init_hours = 0;
        init_minutes = 0;
        init_seconds = 0;
        alarm_hours = 0;
        alarm_minutes = 0;
        alarm_seconds = 0;

        // Wait for global reset to finish
        #100;
        reset = 0;

        // Set alarm time to 00:00:10
        alarm_hours = 0;
        alarm_minutes = 0;
        alarm_seconds = 10;
        enable_alarm = 1;  // Enable the alarm
        
        // Load initial time 00:00:00 in 24-hour format
        set_time = 1;
        init_hours = 0;
        init_minutes = 0;
        init_seconds = 0;
        #10;
        set_time = 0;

        // Run clock until alarm should trigger
        #100;

        // Check LED blink for 10 seconds
        #200; // Wait 10 seconds to observe LED behavior

        // Reset to check system response
        reset = 1;
        #10;
        reset = 0;

        // Set time to 23:59:50 to test midnight crossing in 24-hour format
        set_time = 1;
        init_hours = 23;
        init_minutes = 59;
        init_seconds = 50;
        #10;
        set_time = 0;

        // Observe midnight crossing
        #20;

        // Stop simulation
        #1000;
        $stop;
    end

endmodule

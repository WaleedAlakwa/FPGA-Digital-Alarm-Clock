// SPDX-FileCopyrightText: 2026 Waleed Alakwa
// SPDX-License-Identifier: MIT



`timescale 1ns / 1ps

module ClockTestBench;

    // Inputs to the Clock module
    reg main_clk;
    reg reset;
    reg set_time;
    reg increment_hr;
    reg increment_min;
    reg increment_sec;
    reg format_switch;
    reg [7:0] init_hours;
    reg [7:0] init_minutes;
    reg [7:0] init_seconds;

    // Outputs from the Clock module
    wire [7:0] current_hours;
    wire [7:0] current_minutes;
    wire [7:0] current_seconds;

    // Instantiate the Clock module
    Clock uut (
        .main_clk(main_clk),
        .reset(reset),
        .set_time(set_time),
        .increment_hr(increment_hr),
        .increment_min(increment_min),
        .increment_sec(increment_sec),
        .format_switch(format_switch),
        .init_hours(init_hours),
        .init_minutes(init_minutes),
        .init_seconds(init_seconds),
        .current_hours(current_hours),
        .current_minutes(current_minutes),
        .current_seconds(current_seconds)
    );

    // Clock generation
    initial begin
        main_clk = 0;
        forever #5 main_clk = ~main_clk;  // 100 Hz clock, period = 10 ns
    end

    // Initialize inputs and perform tests
    initial begin
        // Initialize all inputs
        reset = 0;
        set_time = 0;
        increment_hr = 0;
        increment_min = 0;
        increment_sec = 0;
        format_switch = 0; // Start in 24-hour format
        init_hours = 0;
        init_minutes = 0;
        init_seconds = 0;

        // Wait for a few clock cycles
        #100;

        // Test default time at power-up in 24-hour format
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        // Check initial time for 12-hour format
        format_switch = 1;
        reset = 1;  // Trigger reset to load default 12-hour time
        #10;
        reset = 0;
        #10;

        // Manually setting time to 01:15:30 in 12-hour format
        format_switch = 1;
        set_time = 1;
        init_hours = 1;
        init_minutes = 15;
        init_seconds = 30;
        #10;
        set_time = 0;
        #10;

        // Toggle format to 24-hour and see the effect
        format_switch = 0;
        #10;

        // End of simulation
        #100;
        $stop;
    end

endmodule

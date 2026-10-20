// SPDX-FileCopyrightText: 2026 Waleed Alakwa
// SPDX-License-Identifier: MIT



module AlarmClock(
    input wire main_clk,                  // 1 Hz clock input
    input wire reset,                     // Reset the clock to a default time
    input wire set_time,                  // Trigger to load new time values
    input wire increment_hr,              // Button to increase hours
    input wire increment_min,             // Button to increase minutes
    input wire increment_sec,             // Button to increase seconds
    input wire format_switch,             // Toggle between 24h and 12h formats
    input wire enable_alarm,              // Enable alarm functionality
    input wire [7:0] init_hours,          // Initial hours setting
    input wire [7:0] init_minutes,        // Initial minutes setting
    input wire [7:0] init_seconds,        // Initial seconds setting
    input wire [7:0] alarm_hours,         // Preset alarm hours
    input wire [7:0] alarm_minutes,       // Preset alarm minutes
    input wire [7:0] alarm_seconds,       // Preset alarm seconds
    output reg [7:0] current_hours,       // Output current hours
    output reg [7:0] current_minutes,     // Output current minutes
    output reg [7:0] current_seconds,     // Output current seconds
    output reg alarm_active,              // Alarm active indication
    output reg [17:0] leds                // LED outputs for alarm indication
);

// Time boundary definitions
parameter HOURS_24_MAX = 24;
parameter HOURS_12_MAX = 12;
parameter MINUTES_MAX = 60;
parameter SECONDS_MAX = 60;

reg [7:0] hr_storage;                    // Stores the internal hours
reg [9:0] blink_counter = 0;             // Counter for controlling LED blinking during alarm

// Time updating logic
always @(posedge main_clk) begin
    if (reset) begin
        // Default time setting based on format switch
        hr_storage <= format_switch ? 0 : 23;
        current_minutes <= format_switch ? 0 : 59;
        current_seconds <= format_switch ? 0 : 59;
        blink_counter <= 0;
        alarm_active <= 0;
        leds <= 0;
    end else if (set_time) begin
        // Set new time
        hr_storage <= init_hours;
        current_minutes <= init_minutes;
        current_seconds <= init_seconds;
    end else begin
        // Handle time incrementation
        if (increment_sec) begin
            if (current_seconds < SECONDS_MAX - 1) current_seconds <= current_seconds + 1;
            else handle_minute_increment();
        end else if (increment_min) handle_minute_increment();
        else if (increment_hr) handle_hour_increment();
        
        // Check for alarm time match
        if (enable_alarm && current_hours == alarm_hours && current_minutes == alarm_minutes && current_seconds == alarm_seconds) begin
            alarm_active <= 1;
            blink_counter <= 10; // Start blink counter for 10 seconds
        end
    end

    // Handle blinking logic
    if (blink_counter > 0) begin
        blink_counter <= blink_counter - 1;
        leds <= (blink_counter % 2) ? 18'h3FFFF : 0; // Alternate LED pattern
    end else if (blink_counter == 0 && alarm_active) begin
        alarm_active <= 0;
        leds <= 0;
    end
end

// Helper tasks for readability and modular code
task handle_minute_increment;
begin
    if (current_minutes < MINUTES_MAX - 1) current_minutes <= current_minutes + 1;
    else begin
        current_minutes <= 0;
        handle_hour_increment();
    end
end
endtask

task handle_hour_increment;
begin
    if (hr_storage < (format_switch ? HOURS_12_MAX : HOURS_24_MAX) - 1) hr_storage <= hr_storage + 1;
    else hr_storage <= 0;
end
endtask

// Manage format display logic
always @(posedge main_clk or posedge format_switch) begin
    if (format_switch) begin
        // Handle 12-hour format adjustments
        current_hours <= (hr_storage % 12 == 0) ? 12 : hr_storage % 12;
    end else begin
        // In 24-hour mode, direct mapping
        current_hours <= hr_storage;
    end
end

endmodule

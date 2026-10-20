// SPDX-FileCopyrightText: 2026 Waleed Alakwa
// SPDX-License-Identifier: MIT

module Alarm(
    input wire clk,                // Assume 1Hz clock for simplicity
    input wire rst,                // Reset signal
    input wire enable_alarm,       // Signal to enable the alarm
    input wire [4:0] current_hours,        // Current hours from the clock
    input wire [5:0] current_minutes,      // Current minutes from the clock
    input wire [5:0] current_seconds,      // Current seconds from the clock
    input wire [4:0] alarm_hours,          // Preset alarm hours
    input wire [5:0] alarm_minutes,        // Preset alarm minutes
    input wire [5:0] alarm_seconds,        // Preset alarm seconds
    output reg alarm_active,               // Signal to show alarm is active
    output reg [17:0] leds                 // Output LEDs
);

// Use a different approach to handle alarm triggering and LED blinking
integer i;
reg [9:0] blink_counter = 0;  // Counter to control the LED blinking

always @(posedge clk or posedge rst) begin
    if (rst) begin
        alarm_active <= 0;
        leds <= 0;
        blink_counter <= 0;
    end
    else if (enable_alarm && 
             current_hours == alarm_hours && 
             current_minutes == alarm_minutes && 
             current_seconds == alarm_seconds) begin
        alarm_active <= 1;  // Activate the alarm
        blink_counter <= 10;  // Start blink counter for 10 seconds
    end
    else if (blink_counter > 0) begin
        blink_counter <= blink_counter - 1;
        leds <= (blink_counter % 2) ? 18'h3FFFF : 0;  // Alternate LED pattern
    end
    else begin
        alarm_active <= 0;  // Deactivate the alarm
    end
end

endmodule

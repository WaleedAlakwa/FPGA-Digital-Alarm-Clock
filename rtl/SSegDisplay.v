// SPDX-FileCopyrightText: 2026 Waleed Alakwa
// SPDX-License-Identifier: MIT

module SSegDisplay(
    input [3:0] digit,
    output reg [6:0] seg
);
    // Define segment patterns using a different encoding style
    reg [6:0] seg_patterns[0:9];  // Array holding the segment values for digits 0-9

    initial begin
        seg_patterns[0] = 7'b1000000; // 0
        seg_patterns[1] = 7'b1111001; // 1
        seg_patterns[2] = 7'b0100100; // 2
        seg_patterns[3] = 7'b0110000; // 3
        seg_patterns[4] = 7'b0011001; // 4
        seg_patterns[5] = 7'b0010010; // 5
        seg_patterns[6] = 7'b0000010; // 6
        seg_patterns[7] = 7'b1111000; // 7
        seg_patterns[8] = 7'b0000000; // 8
        seg_patterns[9] = 7'b0010000; // 9
    end

    always @ (digit) begin
        if (digit <= 4'h9)
            seg <= seg_patterns[digit];  // Map directly using array index for digits
        else
            seg <= 7'b1111111;  // Turn all segments off for invalid input
    end
endmodule


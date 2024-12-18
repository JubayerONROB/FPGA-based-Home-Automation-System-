// Main Module
module fan_light_pass (
    input ir1, ir2, ntc,             // IR sensors and temperature sensor
    input clk, reset,                // Clock and reset signals
    input [3:0] password,            // 4-bit password input
    output reg fan, led,             // Fan and LED outputs
    output reg [3:0] an,             // Digit enable for 7-segment displays
    output reg [6:0] seg,
    output reg dp, 
    inout LED_COM,                   // Common for 7-segment display
    output reg gate_open,            // Gate control
    output reg corridor_light        // Corridor light control
);
    assign LED_COM = 1; // Keep LED_COM high

    // Define the correct password
    parameter [3:0] CORRECT_PASSWORD = 4'b1010;

    // Timer for gate and light control
    reg [19:0] timer; // Reduced width to save resources
    reg [3:0] seconds_remaining;

    // Fan control logic simplified
    always @(*) begin
        case (ntc ? count_net : 4'd0)
            4'd0: fan = 0;             // Fan off if no one is present
            4'd1, 4'd2, 4'd3: fan = clk_div[6];  // Low speed (25%)
            4'd4, 4'd5, 4'd6: fan = clk_div[5];  // Medium speed (50%)
            default: fan = 1;          // Maximum speed (100%)
        endcase
    end

    // Entry logic state machine
    reg [1:0] entry_state;
    reg [3:0] count_in;
    reg [3:0] count_net;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            entry_state <= 0;
            count_in <= 0;
        end else begin
            case (entry_state)
                0: if (~ir1 && ir2) entry_state <= 1;
                1: if (~ir1 && ~ir2) entry_state <= 2;
                2: if (ir1 && ~ir2) begin
                        count_in <= count_in + 1;
                        entry_state <= 0;
                    end
            endcase
        end
    end

    // Exit logic state machine
    reg [1:0] exit_state;
    reg [3:0] count_out;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            exit_state <= 0;
            count_out <= 0;
        end else begin
            case (exit_state)
                0: if (ir1 && ~ir2) exit_state <= 1;
                1: if (~ir1 && ~ir2) exit_state <= 2;
                2: if (~ir1 && ir2) begin
                        count_out <= count_out + 1;
                        exit_state <= 0;
                    end
            endcase
        end
    end

    // Calculate net count of people in the room
    always @(*) begin
        count_net = count_in - count_out;
    end

    // Gate and corridor light control with password check
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            gate_open <= 0;
            corridor_light <= 0;
            timer <= 0;
            seconds_remaining <= 0;
        end else begin
            if (password == CORRECT_PASSWORD) begin
                gate_open <= 1;
                corridor_light <= 1;
                timer <= 20'd5000000; // Reduced timer to fit resources
                seconds_remaining <= 10; // Start countdown
            end else if (timer >= 0) begin
                timer <= timer - 1;
                if (timer[19:0] % 100000 == 0 && seconds_remaining > 0)
                    seconds_remaining <= seconds_remaining - 1;
                if (timer == 0) begin
                    gate_open <= 0;
                    corridor_light <= 0;
                end
            end
        end
    end

    // Simplified 7-segment control and digit multiplexing
    reg [3:0] current_digit;
    reg [1:0] mux_sel;        // Selector for multiplexing

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mux_sel <= 0;
            an <= 4'b1111; // Disable all digits
        end else begin
            mux_sel <= mux_sel + 1; // Cycle through the displays
            case (mux_sel)
                2'b00: begin
                    an <= 4'b1110; // Activate first digit of people count
                    current_digit <= count_net; // Display people count
                end
                2'b01: begin
                    an <= 4'b1101; // Activate second digit for timer
                    current_digit <= seconds_remaining; // Display timer
                end
                default: an <= 4'b1111; // Disable all digits (fallback)
            endcase
        end
    end

    // Segment decoding (BCD to seven-segment logic)
    always @(*) begin
        case (current_digit)
            4'b0000: seg = 7'b1111110; // 0
            4'b0001: seg = 7'b0110000; // 1
            4'b0010: seg = 7'b1101101; // 2
            4'b0011: seg = 7'b1111001; // 3
            4'b0100: seg = 7'b0110011; // 4
            4'b0101: seg = 7'b1011011; // 5
            4'b0110: seg = 7'b1011111; // 6
            4'b0111: seg = 7'b1110000; // 7
            4'b1000: seg = 7'b1111111; // 8
            4'b1001: seg = 7'b1111011; // 9
            default: seg = 7'b0000000; // Blank
        endcase
    end

    // Decimal point control (optional)
    always @(*) dp = 1'b0; // Turn off decimal point

    // Simplified clock divider for 7-segment multiplexing
    reg [15:0] clk_div;
    wire slow_clk = clk_div[15];

    always @(posedge clk or posedge reset) begin
        if (reset)
            clk_div <= 16'b0;
        else
            clk_div <= clk_div + 1;
    end
endmodule

// Simple PWM Modules for Different Speeds
module simple_pwm25 (input clk, output reg pwm_out);
    reg [7:0] cnt; // 8-bit counter
    always @(posedge clk) begin
        cnt <= cnt + 1;
        pwm_out <= (cnt < 64); // 25% duty cycle
    end
endmodule

module simple_clk_div (input clk, output reg clk_out);
    reg [24:0] cnt; // 25-bit counter
    always @(posedge clk) begin
        cnt <= cnt + 1;
        clk_out <= cnt[24]; // Divide frequency by 2^25
    end
endmodule

module simple_pwm75 (input clk, output reg pwm_out);
    reg [7:0] cnt; // 8-bit counter
    always @(posedge clk) begin
        cnt <= cnt + 1;
        pwm_out <= (cnt < 192); // 75% duty cycle
    end
endmodule

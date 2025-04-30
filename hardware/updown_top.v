`timescale 1ns / 1ps

module updown_top(
    input wire clk,                 // 125 MHz clock
    input wire start_btn,          // Start button
    input wire rst_btn,            // Reset button
    input wire sw,                 // Mode switch (0 = up, 1 = down)
    output wire [6:0] seg,         // 7-segment display segments
    output reg [1:0] an            // Anode control for 2-digit SSD
);

    // -----------------------------
    // Signal Declarations
    // -----------------------------
    reg [7:0] count = 0;
    reg [3:0] ones, tens;
    reg [3:0] current_digit;

    reg [15:0] refresh_cnt = 0;
    wire refresh_clk = refresh_cnt[15];

    wire rst_debounced;
    wire start_debounced;

    reg [1:0] start_shift;
    wire start_rise;
    wire [6:0] seg_out;

    // Debounce Inputs
    DeBounce #(.clk_freq(50000000), .stable_time(10)) debounce_rst (
        .clk(clk), .reset_n(rst), .button(rst_btn), .result(rst_debounced)
    );

    DeBounce #(.clk_freq(50000000), .stable_time(10)) debounce_start (
        .clk(clk), .reset_n(rst), .button(start_btn), .result(start_debounced)
    );

    // Rising Edge Detector

    always @(posedge clk)
        start_shift <= {start_shift[0], start_debounced};

    assign start_rise = (start_shift == 2'b01);

always @(posedge clk) begin
    if (rst_debounced) begin
        // Reset depending on mode
        count <= (sw == 1'b0) ? 8'd0 : 8'd99;
    end else if (start_rise) begin
        if (sw == 1'b0) begin
            // UP MODE: increment with rollover
            count <= (count == 8'd99) ? 8'd0 : count + 1;
        end else begin
            // DOWN MODE: decrement with rollover
            count <= (count == 8'd0) ? 8'd99 : count - 1;
        end
    end
end

    // SSD Digit Split
    always @* begin
        ones = count % 10;
        tens = count / 10;
    end

    // SSD Refresh Clock Divider
    always @(posedge clk)
        refresh_cnt <= refresh_cnt + 1;

    // SSD Digit Multiplexing
    always @(posedge refresh_clk) begin
        if (an == 2'b01) begin
            an <= 2'b10;
            current_digit <= ones;
        end else begin
            an <= 2'b01;
            current_digit <= tens;
        end
    end

    // SSD Segment Mapping

    ssd_driver ssd_inst (
        .dig(current_digit),
        .segment(seg_out)
    );

    assign seg = seg_out;

endmodule
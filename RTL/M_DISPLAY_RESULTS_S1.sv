module M_DISPLAY_RESULTS_S1 (
    input  logic        clk,              // Clock signal
    input  logic [4:0]  write_reg,        // Register being written
    input  logic [31:0] write_data,       // Data to write
    output logic [6:0]  segment0,         // Segment 0 display output
    output logic [6:0]  segment1,         // Segment 1 display output
    output logic [6:0]  segment2,         // Segment 2 display output
    output logic [6:0]  segment3,         // Segment 3 display output
    output logic [6:0]  segment4,         // Segment 4 display output
    output logic [6:0]  segment5          // Segment 5 display output
);

    // Hexadecimal digits to display
    typedef struct packed {
        logic [3:0] hex_0;
        logic [3:0] hex_1;
        logic [3:0] hex_2;
        logic [3:0] hex_3;
        logic [3:0] hex_4;
        logic [3:0] hex_5;
    } hex_display_t;

    hex_display_t hex_display;

    // Sequential logic: Update hex digits on negative clock edge
    always_ff @(negedge clk) begin
        if (write_reg == 5'b10001) begin
            $display("----------------------------------------------------------");
            $display("Data is being written to S1: %d", write_data);
            $display("----------------------------------------------------------");

            // Assign values to hex digits
            hex_display.hex_0 <= write_data[3:0];
            hex_display.hex_1 <= write_data[7:4];
            hex_display.hex_2 <= write_data[11:8];
            hex_display.hex_3 <= write_data[15:12];
            hex_display.hex_4 <= write_data[19:16];
            hex_display.hex_5 <= write_data[23:20];
        end
    end

    // Instantiate 7-segment decoders
    M_7SEG_DECODER display_0 (.hex_num(hex_display.hex_0), .segment(segment0));
    M_7SEG_DECODER display_1 (.hex_num(hex_display.hex_1), .segment(segment1));
    M_7SEG_DECODER display_2 (.hex_num(hex_display.hex_2), .segment(segment2));
    M_7SEG_DECODER display_3 (.hex_num(hex_display.hex_3), .segment(segment3));
    M_7SEG_DECODER display_4 (.hex_num(hex_display.hex_4), .segment(segment4));
    M_7SEG_DECODER display_5 (.hex_num(hex_display.hex_5), .segment(segment5));

endmodule

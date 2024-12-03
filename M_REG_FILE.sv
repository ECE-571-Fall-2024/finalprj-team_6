module M_REG_FILE (
    input  logic        clk,             // Clock signal
    input  logic        reg_write,       // Write enable signal
    input  logic [4:0]  read_reg1,       // Read register 1 address
    input  logic [4:0]  read_reg2,       // Read register 2 address
    input  logic [4:0]  write_reg,       // Write register address
    input  logic [31:0] write_data,      // Data to write
    output logic [31:0] read_data1,      // Data from read register 1
    output logic [31:0] read_data2,      // Data from read register 2
    output logic [6:0]  segment0,        // Segment 0 display output
    output logic [6:0]  segment1,        // Segment 1 display output
    output logic [6:0]  segment2,        // Segment 2 display output
    output logic [6:0]  segment3,        // Segment 3 display output
    output logic [6:0]  segment4,        // Segment 4 display output
    output logic [6:0]  segment5         // Segment 5 display output
);

    // 32 x 32-bit register file
    logic [31:0] rf[31:0];
    logic [3:0] hex_num_0, hex_num_1, hex_num_2, hex_num_3, hex_num_4, hex_num_5;

    // Sequential write to register file (negative edge-triggered)
    always_ff @(negedge clk) begin
        if (reg_write) begin
            rf[write_reg] <= write_data;

            // Debugging: Display content when writing to $s1
            if (write_reg == 5'b10001) begin
                $display("----------------------------------------------------------");
                $display("Data is being written to S1: %h", write_data);
                $display("HEX number 0: %h", hex_num_0);
                $display("HEX number 1: %h", hex_num_1);
                $display("HEX number 2: %h", hex_num_2);
                $display("HEX number 3: %h", hex_num_3);
                $display("HEX number 4: %h", hex_num_4);
                $display("HEX number 5: %h", hex_num_5);
                $display("----------------------------------------------------------");

                // Assign hexadecimal values for display
                hex_num_0 <= write_data[3:0];
                hex_num_1 <= write_data[7:4];
                hex_num_2 <= write_data[11:8];
                hex_num_3 <= write_data[15:12];
                hex_num_4 <= write_data[19:16];
                hex_num_5 <= write_data[23:20];
            end

            // Debugging: Display content of specific registers
            case (write_reg)
                5'b10000: $display("content of $s0 = %h", write_data);
                5'b10001: $display("content of $s1 = %h", write_data);
                5'b10010: $display("content of $s2 = %h", write_data);
                5'b10011: $display("content of $s3 = %h", write_data);
                5'b10100: $display("content of $s4 = %h", write_data);
                5'b01000: $display("content of $t0 = %h", write_data);
                5'b01001: $display("content of $t1 = %h", write_data);
                5'b01010: $display("content of $t2 = %h", write_data);
                default:  $display("no data written to register file");
            endcase
        end
    end

    // Combinational read logic for register file
    assign read_data1 = (read_reg1 != 0) ? rf[read_reg1] : 32'b0;
    assign read_data2 = (read_reg2 != 0) ? rf[read_reg2] : 32'b0;

    // Instantiate 7-segment display decoders
    M_7SEG_DECODER display_0 (.hex_num(hex_num_0), .segment(segment0));
    M_7SEG_DECODER display_1 (.hex_num(hex_num_1), .segment(segment1));
    M_7SEG_DECODER display_2 (.hex_num(hex_num_2), .segment(segment2));
    M_7SEG_DECODER display_3 (.hex_num(hex_num_3), .segment(segment3));
    M_7SEG_DECODER display_4 (.hex_num(hex_num_4), .segment(segment4));
    M_7SEG_DECODER display_5 (.hex_num(hex_num_5), .segment(segment5));

endmodule

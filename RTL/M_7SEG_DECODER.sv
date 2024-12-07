module M_7SEG_DECODER (
    input  logic [3:0] hex_num,   // 4-bit hexadecimal input
    output logic [6:0] segment    // 7-segment output
);

    // Combinational logic: Decode hex_num to 7-segment display pattern
    always_comb begin
        case (hex_num)
            4'b0000: segment = 7'b100_0000;  // 0
            4'b0001: segment = 7'b111_1001;  // 1
            4'b0010: segment = 7'b010_0100;  // 2
            4'b0011: segment = 7'b011_0000;  // 3
            4'b0100: segment = 7'b001_1001;  // 4
            4'b0101: segment = 7'b001_0010;  // 5
            4'b0110: segment = 7'b000_0010;  // 6
            4'b0111: segment = 7'b111_1000;  // 7
            4'b1000: segment = 7'b000_0000;  // 8
            4'b1001: segment = 7'b001_0000;  // 9
            4'b1010: segment = 7'b100_1000;  // A
            4'b1011: segment = 7'b000_0011;  // B
            4'b1100: segment = 7'b100_0110;  // C
            4'b1101: segment = 7'b010_0001;  // D
            4'b1110: segment = 7'b000_0110;  // E
            4'b1111: segment = 7'b000_1110;  // F
            default: segment = 7'b111_1111;  // Default (all segments off)
        endcase
    end

endmodule

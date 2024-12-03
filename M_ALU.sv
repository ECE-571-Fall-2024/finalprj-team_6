module M_ALU(
    input logic [31:0] a, b,                 // ALU operands
    input logic [2:0] alucontrol,           // ALU control signals
    output logic [31:0] result              // ALU result
);

    logic [31:0] condinvb, sum;             // Conditional inverted `b` and sum
    logic [31:0] product;                   // Product of multiplication

    // Conditional inversion of `b`
    assign condinvb = alucontrol[2] ? ~b : b;

    // Instantiation of the 32-bit adder
    M_ADDER #(.N(32)) adder(
        .a(a), 
        .b(condinvb), 
        .c(alucontrol[2]), 
        .sum(sum), 
        .carry() // Carry is not used
    );

    // Instantiation of the 32-bit multiplier
    M_MULT #(.N(32)) multiplier(
        .a(a), 
        .b(b), 
        .product(product)
    );

    // ALU operation based on `alucontrol`
    always_comb begin
        case (alucontrol[1:0])
            2'b00: result = a & b;                          // AND operation
            2'b01: result = a | b;                          // OR operation
            2'b10: result = sum;                            // Addition/Subtraction
            2'b11: result = alucontrol[2] ? sum[31] : product[31:0]; // SRA or Product
            default: result = 32'b0;                        // Default case
        endcase
    end

endmodule
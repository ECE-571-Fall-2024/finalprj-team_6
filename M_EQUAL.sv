module M_EQUAL(
    input logic [31:0] srca,        // First operand
    input logic [31:0] writedata,  // Second operand
    output logic equalD            // Equality result
);

    assign equalD = (srca == writedata); // Check if operands are equal

endmodule
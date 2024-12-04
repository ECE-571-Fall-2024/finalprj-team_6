module M_MULT #(
    parameter int N = 3 // Parameterized bit width
) (
    input logic [N-1:0] a,  // Multiplier input
    input logic [N-1:0] b,  // Multiplicand input
    output logic [N-1:0] product // Output product
);

    // Multiplication operation
    assign product = a*b;
endmodule
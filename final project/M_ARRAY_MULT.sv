`include "M_ADDER.sv"

module M_ARRAY_MULT #(
    parameter int N = 3 // Explicit parameter type declaration
) (
    input logic [N-1:0] a, b,           // Inputs
    output logic [2*N-1:0] product      // Output for the product
);

    logic [N*N-1:0] w_partial_prod;     // Partial products
    logic [N-1:0] w_partial_carry;     // Partial carries
    genvar g_i;                        // Generate index variable

    generate
        assign w_partial_carry[0] = 1'b0; // Initialize first carry bit
        assign w_partial_prod[N-1:0] = a & {N{b[0]}}; // First partial product

        // Loop to generate partial products and carry bits
        for (g_i = 1; g_i < N; g_i = g_i + 1) begin: L_G_PARTIAL_PROD
            M_ADDER #(.N(N)) fa_i(
                .a(a & {N{b[g_i]}}), 
                .b({w_partial_carry[g_i-1], w_partial_prod[N*g_i-1:N*(g_i-1)+1]}),
                .sum(w_partial_prod[N*(g_i+1)-1:N*g_i]),
                .carry(w_partial_carry[g_i])
            );

            assign product[g_i-1] = w_partial_prod[N*(g_i-1)];
        end

        // Assign the final part of the product
        assign product[2*N-1:N-1] = {w_partial_carry[N-1], w_partial_prod[N*N-1:N*(N-1)]};
    endgenerate

endmodule

module M_MUX_2_DONTCARE #(
    parameter int WIDTH = 32 // Explicitly specify the type of the parameter
)(
    input logic [WIDTH-1:0] d0, d1, // Inputs are declared as logic
    input logic s,                  // Select signal as logic
    output logic [WIDTH-1:0] y      // Output declared as logic
);

    always_comb begin
        case (s)
            1'b0, 1'bx: y = d0; // Combine cases for 1'b0 and 1'bx
            1'b1: y = d1;
            default: y = 'x;   // Optional: Handle any unanticipated cases
        endcase
    end

endmodule
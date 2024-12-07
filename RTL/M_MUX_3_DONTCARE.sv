module M_MUX_3_DONTCARE (
    input  logic [31:0] d0,   // Input data 0
    input  logic [31:0] d1,   // Input data 1
    input  logic [31:0] d2,   // Input data 2
    input  logic [1:0]  s,    // Selector signal
    output logic [31:0] y     // Output data
);

    // Combinational logic: Select output based on selector
    always_comb begin
        case (s)
            2'b00, 2'bxx: y = d0;  // Default or don't care case
            2'b01:        y = d1;
            2'b10:        y = d2;
            default:      y = d0;  // Safety fallback to d0
        endcase
    end

endmodule

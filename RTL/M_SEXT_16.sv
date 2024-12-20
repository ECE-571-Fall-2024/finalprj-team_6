module M_SEXT_16(
    input logic [15:0] a,
    output logic [31:0] y
);

    assign y = {{16{a[15]}}, a}; // Sign-extend the 16-bit input to 32 bits

endmodule
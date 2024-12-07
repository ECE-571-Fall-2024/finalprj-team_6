module M_MUX_2 #(
    parameter int WIDTH = 8 // Parameter for data width
)(
    input  logic [WIDTH-1:0] d0,   // Input data 0
    input  logic [WIDTH-1:0] d1,   // Input data 1
    input  logic             s,    // Selector signal
    output logic [WIDTH-1:0] y     // Output data
);

    // Combinational logic: Select output based on selector
    assign y = s ? d1 : d0;

endmodule

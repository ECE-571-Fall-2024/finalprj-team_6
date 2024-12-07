module M_ADDER #(
    parameter int N = 3
) (
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    input  logic         c,
    output logic [N-1:0] sum,
    output logic         carry
);
    assign {carry, sum} = a + b + c;
    
endmodule

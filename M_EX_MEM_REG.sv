//SV CODE - M_EX_MEM_REG

module M_EX_MEM_REG(
    input logic clk,
    input logic [31:0] instrE,
    input logic regwriteE, memtoregE, memwriteE,
    // input logic zero, 
    input logic [31:0] aluout, writedataE,
    input logic [4:0] writeregE,
    // input logic [31:0] pcbranch,
    output logic regwriteM, memtoregM, memwriteM,
    // output logic zeroM, 
    output logic [31:0] aluoutM, writedataM,
    output logic [4:0] writeregM,
    // output logic [31:0] pcbranchM,
    output logic [31:0] instrM
);

    always_ff @(posedge clk) begin
        //$display("EX to MEM");
        regwriteM <= regwriteE;
        memtoregM <= memtoregE;
        memwriteM <= memwriteE;
        // branchM <= branchE;
        // zeroM <= zero;
        aluoutM <= aluout;
        writedataM <= writedataE;
        writeregM <= writeregE;
        // pcbranchM <= pcbranch;
        instrM <= instrE;
        
        if (instrM != 8'hx)
            $display("Instruction %h is in MEM stage", instrM);
    end

endmodule
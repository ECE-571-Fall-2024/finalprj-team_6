//SV CODE - M_MEM_WB_REG

module M_MEM_WB_REG(
    input logic clk,
    input logic [31:0] instrM,
    input logic regwriteM,
    input logic memtoregM,
    input logic [31:0] aluoutM, readdata,
    input logic [4:0] writeregM,
    output logic regwriteW,
    output logic memtoregW,
    output logic [31:0] aluoutW, readdataW,
    output logic [4:0] writeregW,
    output logic [31:0] instrW
);

    always_ff @(posedge clk) begin
        //$display("MEM to WB");
        regwriteW <= regwriteM;
        memtoregW <= memtoregM;
        aluoutW <= aluoutM;
        readdataW <= readdata;
        writeregW <= writeregM;
        instrW <= instrM;

        if (instrW != 8'hx)
            $display("Instruction %h is in WB stage", instrW);
    end

endmodule
module M_ID_EX_REG(
    input logic flushE,                     // Flush signal for the EX stage
    input logic clk,                        // Clock signal
    input logic [4:0] rsD,                  // Source register D
    input logic [31:0] instrD,              // Instruction in D stage
    input logic regwrite, memtoreg, memwrite, // Control signals
    input logic [2:0] alucontrol,           // ALU control signals
    input logic alusrc, regdst,             // Control signals
    input logic [31:0] srca, writedata,     // Source data
    input logic [4:0] rtD, rdD,             // Destination registers
    input logic [31:0] signimmD,            // Sign-extended immediate value
    output logic regwriteE, memtoregE, memwriteE, // Control signals in EX stage
    output logic [2:0] alucontrolE,         // ALU control signals in EX stage
    output logic alusrcE, regdstE,          // Control signals in EX stage
    output logic [31:0] srcaMUX, writedataMUX, // Data in EX stage
    output logic [4:0] rtE, rdE,            // Destination registers in EX stage
    output logic [31:0] signimmE,           // Immediate value in EX stage
    output logic [31:0] instrE,             // Instruction in EX stage
    output logic [4:0] rsE                  // Source register in EX stage
);

    always_ff @(posedge clk) begin
        if (flushE) begin
            regwriteE   <= 1'b0;
            memtoregE   <= 1'b0;
            memwriteE   <= 1'b0;
            alucontrolE <= 3'b0;
            alusrcE     <= 1'b0;
            regdstE     <= 1'b0;
            srcaMUX     <= 32'b0;
            writedataMUX <= 32'b0;
            rtE         <= 5'b0;
            rdE         <= 5'b0;
            signimmE    <= 32'b0;
            instrE      <= 32'b0;
            rsE         <= 5'b0;
        end else begin
            regwriteE   <= regwrite;
            memtoregE   <= memtoreg;
            memwriteE   <= memwrite;
            alucontrolE <= alucontrol;
            alusrcE     <= alusrc;
            regdstE     <= regdst;
            srcaMUX     <= srca;
            writedataMUX <= writedata;
            rtE         <= rtD;
            rdE         <= rdD;
            signimmE    <= signimmD;
            instrE      <= instrD;
            rsE         <= rsD;
            if (instrE != 32'hx)
                $display("Instruction %h is in EX stage", instrE);
        end
    end

endmodule

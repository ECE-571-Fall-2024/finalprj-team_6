module M_EX_MEM_REG (
    input  logic          clk,             // Clock signal
    input  logic [31:0]   instrE,          // Instruction from EX stage
    input  logic          regwriteE,       // Write enable from EX stage
    input  logic          memtoregE,       // MemToReg control from EX stage
    input  logic          memwriteE,       // Memory write control from EX stage
    input  logic [31:0]   aluout,          // ALU result from EX stage
    input  logic [31:0]   writedataE,      // Data to write to memory
    input  logic [4:0]    writeregE,       // Write register from EX stage
    output logic          regwriteM,       // Write enable to MEM stage
    output logic          memtoregM,       // MemToReg control to MEM stage
    output logic          memwriteM,       // Memory write control to MEM stage
    output logic [31:0]   aluoutM,         // ALU result to MEM stage
    output logic [31:0]   writedataM,      // Data to write to memory in MEM stage
    output logic [4:0]    writeregM,       // Write register to MEM stage
    output logic [31:0]   instrM           // Instruction to MEM stage
);

    // Sequential logic: Update pipeline registers on clock edge
    always_ff @(posedge clk) begin
        // Pass signals from EX to MEM stage
        regwriteM   <= regwriteE;
        memtoregM   <= memtoregE;
        memwriteM   <= memwriteE;
        aluoutM     <= aluout;
        writedataM  <= writedataE;
        writeregM   <= writeregE;
        instrM      <= instrE;

        // Debugging output for simulation
        if (instrM != 8'hx) begin
            $display("Instruction %h is in MEM stage", instrM);
        end
    end

endmodule

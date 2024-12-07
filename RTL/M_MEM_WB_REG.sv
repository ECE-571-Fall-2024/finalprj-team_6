module M_MEM_WB_REG (
    input logic                  clk,            // Clock signal
    input logic [31:0]           instrM,         // Instruction from MEM stage
    input logic                  regwriteM,      // Write enable from MEM stage
    input logic                  memtoregM,      // MemToReg control from MEM stage
    input logic [31:0]           aluoutM,        // ALU output from MEM stage
    input logic [31:0]           readdata,       // Read data from memory
    input logic [4:0]            writeregM,      // Write register from MEM stage
    output logic                 regwriteW,      // Write enable to WB stage
    output logic                 memtoregW,      // MemToReg control to WB stage
    output logic [31:0]          aluoutW,        // ALU output to WB stage
    output logic [31:0]          readdataW,      // Read data to WB stage
    output logic [4:0]           writeregW,      // Write register to WB stage
    output logic [31:0]          instrW          // Instruction to WB stage
);

    // Sequential logic: Update output registers on clock edge
    always_ff @(posedge clk) begin
        // Transfer data from MEM to WB stage
        regwriteW  <= regwriteM;
        memtoregW  <= memtoregM;
        aluoutW    <= aluoutM;
        readdataW  <= readdata;
        writeregW  <= writeregM;
        instrW     <= instrM;

        // Debugging output for simulation
        if (instrW != 8'hx) begin
            $display("Instruction %h is in WB stage", instrW);
        end
    end

endmodule

module M_HAZARD_UNIT (
    input  logic        branch,
    input  logic        memtoregE,
    input  logic        memtoregM,
    input  logic [4:0]  rsD,
    input  logic [4:0]  rtD,
    input  logic        regwriteE,
    input  logic        regwriteM,
    input  logic        regwriteW,
    input  logic [4:0]  rsE,
    input  logic [4:0]  rtE,
    input  logic [4:0]  writeregE,
    input  logic [4:0]  writeregM,
    input  logic [4:0]  writeregW,
    output logic [1:0]  forwardAE,
    output logic [1:0]  forwardBE,
    output logic        stallF,
    output logic        stallD,
    output logic        flushE,
    output logic        forwardAD,
    output logic        forwardBD
);

    logic lwstall;
    logic branchstall;

    always_comb begin
        // Forwarding logic for source A
        if ((rsE != 5'b00000) && (rsE == writeregM) && regwriteM)
            forwardAE = 2'b10; // Forward from MEM stage
        else if ((rsE != 5'b00000) && (rsE == writeregW) && regwriteW)
            forwardAE = 2'b01; // Forward from WB stage
        else
            forwardAE = 2'b00; // No forwarding

        // Forwarding logic for source B
        if ((rtE != 5'b00000) && (rtE == writeregM) && regwriteM)
            forwardBE = 2'b10; // Forward from MEM stage
        else if ((rtE != 5'b00000) && (rtE == writeregW) && regwriteW)
            forwardBE = 2'b01; // Forward from WB stage
        else
            forwardBE = 2'b00; // No forwarding

        // Detecting load-use hazard (memory delay stall)
        lwstall = ((rsD == rtE) || (rtD == rtE)) && memtoregE;

        // Forwarding to ID stage for branch comparison
        forwardAD = (rsD != 5'd0) && (rsD == writeregM) && regwriteM;
        forwardBD = (rtD != 5'd0) && (rtD == writeregM) && regwriteM;

        // Detecting branch hazard (branch delay stall)
        branchstall = (branch && regwriteE && ((writeregE == rsD) || (writeregE == rtD))) ||
                      (branch && memtoregM && ((writeregM == rsD) || (writeregM == rtD)));

        // Stall and flush signals
        stallF = lwstall || branchstall;
        stallD = lwstall || branchstall;
        flushE = lwstall || branchstall;
    end

    // Display load-use stall information
    always @(lwstall) begin
        if (lwstall == 1'b1)
            $display("lwstall=%b", lwstall);
    end

    // Display branch stall information
    always @(branchstall) begin
        if (branchstall == 1'b1)
            $display("branchstall=%b", branchstall);
    end

endmodule

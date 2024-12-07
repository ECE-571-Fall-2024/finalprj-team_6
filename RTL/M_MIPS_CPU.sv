`include "M_MEM_ASYNC.sv"
`include "M_MEM_SYNC.sv"
`include "M_CONTROLLER.sv"
`include "M_ALU_CONTROLLER.sv"
`include "M_IF_ID_REG.sv"
`include "M_ID_EX_REG.sv"
`include "M_EX_MEM_REG.sv"
`include "M_MEM_WB_REG.sv"
`include "M_PC_REG.sv"
`include "M_PC_ADDER.sv"
`include "M_SLL2.sv"
`include "M_MUX_2_DONTCARE.sv"
`include "M_REG_FILE.sv"
`include "M_MUX_2.sv"
`include "M_SEXT_16.sv"
`include "M_MUX_3_DONTCARE.sv"
`include "M_ALU.sv"
`include "M_HAZARD_UNIT.sv"
`include "M_EQUAL.sv"

module M_MIPS_CPU(
    input logic clk, 
    input logic reset,
    output logic [31:0] writedataM,
    output logic [31:0] aluoutM,
    output logic memwriteM,
    output logic [6:0] segment0,
    output logic [6:0] segment1,
    output logic [6:0] segment2,
    output logic [6:0] segment3,
    output logic [6:0] segment4,
    output logic [6:0] segment5
    );

    logic [31:0] count = 1;

    always_ff @(posedge clk) begin
        count <= count + 1;
        $display("**********************************************************");
        $display("Clock cycle: %10d", count);
    end

    logic [31:0] pc, instr, readdata;
    logic [2:0] alucontrol;
    logic [5:0] op, funct;

    logic [1:0] aluop;
    logic branch;

    logic [4:0] writereg, writeregE;
    logic [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
    logic [31:0] signimmD, signimmsh;
    logic [31:0] srca, srcb;
    logic [31:0] result;
    logic [31:0] instrD, instrE, instrM, instrW, pcplus4D;
    logic memtoreg, alusrc, regdst, regwrite, jump, zero;

    logic regwriteE, memtoregE, memwriteE, branchE;
    logic [2:0] alucontrolE;
    logic alusrcE, regdstE;
    logic [31:0] srcaE, writedataE, srcbE;
    logic [31:0] srcaMUX, writedataMUX;
    logic [4:0] rtE, rdE, rsE;
    logic [31:0] signimmE, pcplus4E;

    logic regwriteM, memtoregM, memwrite, branchM;
    logic zeroM;
    logic [31:0] aluout, writedata;
    logic [4:0] writeregM;
    logic [31:0] pcbranchM, pcbranchD;

    logic regwriteW;
    logic memtoregW;
    logic [31:0] aluoutW, readdataW;
    logic [4:0] writeregW;

    logic [1:0] forwardAE, forwardBE;
    logic forwardAD, forwardBD;

    logic stallF, stallD, flushE;

    logic equalD, pcsrcD;
    logic [31:0] srcaEQ, writedataEQ;

    // Instantiate memories
    M_MEM_ASYNC #(.RAM_SIZE(64)) imem(clk, pc[7:2], instr);
    M_MEM_SYNC #(.RAM_SIZE(64)) dmem(clk, memwriteM, aluoutM, writedataM, readdata);

    // Controller
    assign op = instrD[31:26];
    assign funct = instrD[5:0];
    M_CONTROLLER controller(op, memtoreg, memwrite, branch, alusrc, regdst, regwrite, jump, aluop);
    M_ALU_CONTROLLER aluController(funct, aluop, alucontrol);

    // Pipeline registers
    M_IF_ID_REG ifIdReg(
        pcsrcD,
        stallD,
        clk,
        instr,
        pcplus4,
        instrD,
        pcplus4D
    );

    M_ID_EX_REG idExReg(
        flushE, 
        clk, 
        instrD[25:21], 
        instrD, 
        regwrite, 
        memtoreg, 
        memwrite, 
        alucontrol, 
        alusrc,
        regdst, 
        srca, 
        writedata, 
        instrD[20:16], 
        instrD[15:11], 
        signimmD,
        regwriteE, 
        memtoregE, 
        memwriteE, 
        alucontrolE,
        alusrcE,
        regdstE, 
        srcaMUX, 
        writedataMUX, 
        rtE, 
        rdE, 
        signimmE, 
        instrE, 
        rsE
    );

    M_EX_MEM_REG exMemReg(
        clk, 
        instrE, 
        regwriteE, 
        memtoregE, 
        memwriteE,
        aluout, 
        writedataE, 
        writeregE,
        regwriteM, 
        memtoregM, 
        memwriteM,
        aluoutM, 
        writedataM, 
        writeregM, 
        instrM
    );

    M_MEM_WB_REG memWbReg(
        clk, 
        instrM, 
        regwriteM, 
        memtoregM, 
        aluoutM, 
        readdata, 
        writeregM,
        regwriteW, 
        memtoregW, 
        aluoutW, 
        readdataW,
        writeregW, 
        instrW
    );

    // PC logic
    assign pcsrcD = equalD & branch;

    M_PC_REG #(32) pcreg(stallF, clk, reset, pcnext, pc);
    M_PC_ADDER pcadd1(pc, 32'b100, pcplus4);

    always_ff @(negedge clk) 
        $display("current pc: %h", pc);

    // Display branch prediction output for debugging
    always @(pcsrcD, branch) begin
        if (pcsrcD == 1'b1) 
            $display("Branch is taken! Squashing instruction %h", instr);
        else if ((pcsrcD != 1'b1) && (branch == 1'b1)) 
            $display("Branch not taken");
    end

    M_SLL2 immsh(signimmD, signimmsh);
    M_PC_ADDER pcadd2(pcplus4D, signimmsh, pcbranchD);

    M_MUX_2_DONTCARE pcbrmux(pcplus4, pcbranchD, pcsrcD, pcnextbr);
    M_MUX_2_DONTCARE pcmux(pcnextbr, {pcplus4[31:28], instrD[25:0], 2'b00}, jump, pcnext);

    // Register file logic
    M_REG_FILE rf(
        clk,
        regwriteW,
        instrD[25:21],
        instrD[20:16],
        writeregW,
        result,
        srca,
        writedata,
        segment0,
        segment1,
        segment2,
        segment3,
        segment4,
        segment5
    );

    M_MUX_2 #(5) wrmux(rtE, rdE, regdstE, writeregE);
    M_MUX_2 #(32) resmux(aluoutW, readdataW, memtoregW, result);
    M_SEXT_16 se(instrD[15:0], signimmD);

    // ALU logic
    M_MUX_3_DONTCARE muxsrca(srcaMUX, result, aluoutM, forwardAE, srcaE);
    M_MUX_3_DONTCARE muxwritedata(writedataMUX, result, aluoutM, forwardBE, writedataE);

    M_MUX_2 #(32) srcbmux(writedataE, signimmE, alusrcE, srcbE);
    M_ALU alu(srcaE, srcbE, alucontrolE, aluout);

    // Hazard logic
    M_HAZARD_UNIT hazardunit(
        branch, 
        memtoregE, 
        memtoregM, 
        instrD[25:21], 
        instrD[20:16],
        regwriteE, 
        regwriteM, 
        regwriteW, 
        rsE, 
        rtE, 
        writeregE, 
        writeregM, 
        writeregW,
        forwardAE, 
        forwardBE,
        stallF, 
        stallD, 
        flushE,
        forwardAD, 
        forwardBD
    );

    // Early branch logic 
    M_EQUAL equal(srcaEQ, writedataEQ, equalD);

    M_MUX_2_DONTCARE srcsEQMUX(srca, aluoutM, forwardAD, srcaEQ);
    M_MUX_2_DONTCARE writedataEQMUX(writedata, aluoutM, forwardBD, writedataEQ);

    // Display stall and flush signals when they change and have valid values
    always @(stallF , stallD , flushE) begin
       
            $display("stallF:%b", stallF);
            $display("stallD:%b", stallD);
            $display("flushE:%b", flushE);
        
    end

    // Display forwarding information for srcaE when forwardAE changes
    always @(forwardAE) begin
        if (^forwardAE !== 1'bx) begin
            case(forwardAE)
                2'b01: $display("Forwarded %h to srcaE from MEM/WB stage", result);
                2'b10: $display("Forwarded %h to srcaE from EX/MEM stage", aluoutM);
            endcase
        end
    end

    // Display forwarding information for writedataE when forwardBE changes
    always @(forwardBE) begin
        if (^forwardBE !== 1'bx) begin
            case(forwardBE)
                2'b01: $display("Forwarded %h to writedataE from MEM/WB stage", result);
                2'b10: $display("Forwarded %h to writedataE from EX/MEM stage", aluoutM);
            endcase
        end
    end

endmodule

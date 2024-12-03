module M_CONTROLLER(
    input logic [5:0] opcode,        // Input opcode
    output logic memtoreg,          // Memory to register control
    output logic memwrite,          // Memory write control
    output logic branch,            // Branch control
    output logic alusrc,            // ALU source control
    output logic regdst,            // Register destination control
    output logic regwrite,          // Register write control
    output logic jump,              // Jump control
    output logic [1:0] aluop        // ALU operation control
);

    logic [8:0] controls;           // Combined control signals

    // Decode `controls` into individual control signals
    assign {regwrite, regdst, alusrc, branch, memwrite, memtoreg, jump, aluop} = controls;

    always_comb begin
        case (opcode)
            6'b000000: controls = 9'b110000010; // RTYPE
            6'b100011: controls = 9'b101001000; // LW
            6'b101011: controls = 9'b001010000; // SW
            6'b000100: controls = 9'b000100001; // BEQ
            6'b001000: controls = 9'b101000000; // ADDI
            6'b000010: controls = 9'b000000100; // J
            6'b011100: controls = 9'b110000010; // MUL
            default:   controls = 9'bxxxxxxxxx; // Illegal opcode
        endcase
    end

endmodule

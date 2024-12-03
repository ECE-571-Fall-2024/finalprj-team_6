module M_IF_ID_REG(
    input logic pcsrcD,
    input logic stallD,
    input logic clk,
    input logic[31:0] instr,
    input logic[31:0] pcplus4,
    output logic[31:0] instrD,
    output logic[31:0] pcplus4D
);

    always_ff @(posedge clk) begin
        if (pcsrcD == 1'b1) begin
            instrD <= 32'b0; // Clear values when pcsrcD is active
            pcplus4D <= 32'b0;
        end else begin
            case (stallD)
                1'bx, 1'b0: begin // Both cases (don't care and 0) perform the same actions
                    instrD <= instr;
                    pcplus4D <= pcplus4;
                    if (instrD != 32'hx) begin
                        $display("Instruction %h is in ID stage", instrD);
                    end
                end
            endcase
        end
    end

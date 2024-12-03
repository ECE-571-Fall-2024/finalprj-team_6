module alu(
    input logic [5:0] funct,        // Function code
    input logic [1:0] aluop,        // ALU operation selector
    output logic [2:0] alucontrol   // ALU control signals
);

    always_comb begin
        case (aluop)
            2'b00: alucontrol = 3'b010; // add (for lw/sw/addi)
            2'b01: alucontrol = 3'b110; // sub (for beq)
            default: begin
                case (funct) // R-type instructions
                    6'b100100: alucontrol = 3'b000; // and
                    6'b100101: alucontrol = 3'b001; // or
                    6'b100000: alucontrol = 3'b010; // add
                    6'b000010: alucontrol = 3'b011; // mul
                    6'b100010: alucontrol = 3'b110; // sub
                    6'b101010: alucontrol = 3'b111; // slt
                    default:   alucontrol = 3'bxxx; // Undefined
                endcase
            end
        endcase
    end

endmodule

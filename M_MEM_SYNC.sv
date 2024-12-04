//SV CODE - M_MEM_SYNC

module M_MEM_SYNC#(
    parameter int RAM_SIZE = 256
)(
    input logic clk,
    input logic mem_write,
    input logic [31:0] address,
    input logic [31:0] write_data,
    output logic [31:0] read_data
);

    logic [31:0] RAM[RAM_SIZE-1:0];

    // Continuous assignment for read_data
    assign read_data = RAM[address[31:2]]; // Word-aligned memory access

    // Initialize memory from file
    initial $readmemh("memdata.dat", RAM);

    // Write logic on positive clock edge
    always_ff @(posedge clk) begin
        if (mem_write) begin
            RAM[address[31:2]] <= write_data;
            $display("Address %h now has data %h", address, write_data);
        end
    end

endmodule
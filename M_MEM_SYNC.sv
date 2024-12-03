module M_MEM_SYNC #(
    parameter int RAM_SIZE = 256 // Parameter for RAM size
)(
    input  logic         clk,         // Clock signal
    input  logic         mem_write,   // Write enable signal
    input  logic [31:0]  address,     // Address for read/write
    input  logic [31:0]  write_data,  // Data to write
    output logic [31:0]  read_data    // Data read from memory
);

    // Memory declaration: 256 x 32-bit memory (word-aligned)
    logic [31:0] RAM[RAM_SIZE-1:0];

    // Read data: Synchronous read operation, word-aligned
    assign read_data = RAM[address[31:2]];

    // Initialize memory from an external file
    initial begin
        $readmemh("memdata.dat", RAM);
    end

    // Synchronous memory write operation
    always_ff @(posedge clk) begin
        if (mem_write) begin
            RAM[address[31:2]] <= write_data;
            $display("address %h now has data %h", address, write_data);
        end
    end

endmodule

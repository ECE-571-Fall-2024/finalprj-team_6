module M_MEM_ASYNC#(
    parameter int RAM_SIZE = 256  // SystemVerilog-style parameter declaration
)(
    input  logic                        clk,      // Use `logic` for signals
    input  logic [$clog2(RAM_SIZE)-1:0] address,  // Logic array for address
    output logic [31:0]                 instruction // Logic array for instruction
);

    // Define the RAM as a packed array with logic
    logic [31:0] RAM [RAM_SIZE-1:0];

    // Initialize RAM from a file
    initial $readmemh("meminstr.dat", RAM);  

    // Assign instruction asynchronously from RAM
    assign instruction = RAM[address]; // Word aligned

    // Use an always block to monitor instruction fetch
    always_comb begin
        if (instruction !== 32'hx)  // Check if instruction is not undefined
            $display("Fetched instruction: %h", instruction);
    end

endmodule

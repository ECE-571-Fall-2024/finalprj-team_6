`timescale 1ns/1ps

module TB_MIPS_CPU;
    // CPU testbench

    // Declare logic types for signals
    logic clk;
    logic res;

    // Declare logic for DUT outputs
    logic [31:0] writedataM;
    logic [31:0] aluoutM;
    logic memwriteM;
    logic [6:0] segment0, segment1, segment2, segment3, segment4, segment5;

    // Instantiate the DUT (Device Under Test)
    M_MIPS_CPU MIPS_DUT (
        .clk(clk),
        .reset(res),
        .writedataM(writedataM),
        .aluoutM(aluoutM),
        .memwriteM(memwriteM),
        .segment0(segment0),
        .segment1(segment1),
        .segment2(segment2),
        .segment3(segment3),
        .segment4(segment4),
        .segment5(segment5)
    );

    // Clock generation: Toggle the clock every 5ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Initial block for reset and simulation control
    initial begin
        res = 1;        // Apply reset
        #10 res = 0;    // Release reset after 10ns

        #500 $finish;   // End simulation after 500ns
    end

    // Dump variables for waveform analysis (optional, uncomment if needed)
     initial begin
         $dumpfile("MIPS_DUT.vcd");
         $dumpvars(0, MIPS_DUT);
     end

    // Monitor memory writes (optional, uncomment if needed)
    // always @(posedge clk) begin
    //     if (memwriteM) begin
    //         $display("----------------------------------------------------------");
    //         $display("Data is being written to Memory @%h: %h", aluoutM, writedataM);
    //         $display("----------------------------------------------------------");
    //     end
    // end

endmodule

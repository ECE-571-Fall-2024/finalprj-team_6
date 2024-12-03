module M_MEM_SYNC#(
    parameter int RAM_SIZE = 256 
)(
    input logic clk,
    input logic mem_write,
    input logic[31:0] address,
    input logic[31:0] write_data,
    output logic[31:0] read_data
);

    logic[31:0] RAM[RAM_SIZE-1:0];
	
    assign read_data = RAM[address[31:2]]; 
	
    initial begin
        $readmemh("memdata.dat", RAM);  
    end

    always_ff @(posedge clk) begin
        if (mem_write) begin
            RAM[address[31:2]] <= write_data;
            $display("address %h now has data %h", address, write_data);
        end
    end
endmodule

module data_mem (
    input wire clk,
    input wire MemRead,
    input wire MemWrite,
    input wire [31:0] addr,
    input wire [31:0] write_data,
    output wire [31:0] read_data
);
    reg [31:0] mem [0:255]; // 1KB data memory (256 words)

    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 0;
    end

    always @(posedge clk) begin
        if (MemWrite)
            mem[addr[9:2]] <= write_data;
    end

    assign read_data = (MemRead) ? mem[addr[9:2]] : 32'b0;
endmodule

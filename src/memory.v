module memory (
    input wire clk,
    input wire MemRead,
    input wire MemWrite,
    input wire [31:0] addr,
    input wire [31:0] write_data,
    output wire [31:0] read_data
);
    data_mem dmem (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );
endmodule

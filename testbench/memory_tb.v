`timescale 1ns / 1ps

module memory_tb;

    reg clk, MemRead, MemWrite;
    reg [31:0] addr, write_data;
    wire [31:0] read_data;

    memory uut (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    initial begin
        $dumpfile("sim/memory.vcd");
        $dumpvars(0, memory_tb);

        clk = 0; MemRead = 0; MemWrite = 0;
        addr = 0; write_data = 0;

        // Store 0xDEADBEEF at address 0
        #5; write_data = 32'hDEADBEEF; MemWrite = 1;
        #5; clk = 1; #5; clk = 0; MemWrite = 0;

        // Load from address 0
        #5; MemRead = 1;
        #5; $display("Read data = %h", read_data);
        MemRead = 0;

        // Store 0x12345678 at address 4
        addr = 4; write_data = 32'h12345678; MemWrite = 1;
        #5; clk = 1; #5; clk = 0; MemWrite = 0;

        // Load from address 4
        #5; MemRead = 1;
        #5; $display("Read data = %h", read_data);
        MemRead = 0;

        #10 $finish;
    end

endmodule

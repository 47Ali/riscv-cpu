module execute (
    input wire clk,
    input wire we,                     // Write enable for register file
    input wire MemRead,
    input wire MemWrite,
    input wire MemtoReg,
    input wire [1:0] alu_op,          // ALUOp from control unit
    input wire [4:0] rs1, rs2, rd,    // Register addresses
    input wire [31:0] imm,            // Immediate value
    input wire alu_src,               // Select between register or immediate
    input wire [2:0] funct3,
    input wire funct7_5,
    output wire [31:0] alu_result,
    output wire [31:0] mem_read_data,
    output wire zero,
    output wire [31:0] rd1, rd2
);

    wire [31:0] op2;
    wire [3:0] alu_control;
    wire [31:0] mem_out;
    wire [31:0] write_back_data;

    // Register file
    regfile rf (
        .clk(clk),
        .we(we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(write_back_data),
        .rd1(rd1),
        .rd2(rd2)
    );

    // ALU control
    alu_control alu_ctl (
        .ALUOp(alu_op),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .alu_control(alu_control)
    );

    // ALU second operand selection
    assign op2 = (alu_src) ? imm : rd2;

    // ALU
    alu alu_core (
        .a(rd1),
        .b(op2),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );

    // Memory stage
    memory mem_stage (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(alu_result),
        .write_data(rd2),
        .read_data(mem_out)
    );

    assign write_back_data = (MemtoReg) ? mem_out : alu_result;
    assign mem_read_data = mem_out;

endmodule

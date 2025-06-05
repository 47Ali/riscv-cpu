module cpu(
    input wire clk,
    input wire reset
);
    wire [31:0] instr;
    wire [31:0] pc_out;

    // Fetch stage - branch/jump not yet implemented
    cpu_fetch fetch_unit(
        .clk(clk),
        .reset(reset),
        .jal(1'b0),
        .jalr(1'b0),
        .branch(1'b0),
        .branch_taken(1'b0),
        .branch_target(32'b0),
        .jalr_target(32'b0),
        .instr(instr),
        .pc_out(pc_out)
    );

    // Decode fields
    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];
    wire [4:0] rd  = instr[11:7];
    wire [4:0] rs1 = instr[19:15];
    wire [4:0] rs2 = instr[24:20];

    // Control signals
    wire [1:0] ALUOp;
    wire RegWrite, MemRead, MemWrite, Branch, Jump, ALUSrc;

    control_unit cu(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUOp(ALUOp),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Jump(Jump),
        .ALUSrc(ALUSrc)
    );

    // MemtoReg signal: only true for load instructions
    wire MemtoReg = (opcode == 7'b0000011);

    wire [31:0] alu_result;
    wire [31:0] mem_read_data;
    wire zero;

    execute exec_unit(
        .clk(clk),
        .we(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .alu_op(ALUOp),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .instr(instr),
        .alu_src(ALUSrc),
        .funct3(funct3),
        .funct7_5(funct7[5]),
        .alu_result(alu_result),
        .mem_read_data(mem_read_data),
        .zero(zero),
        .rd1(),
        .rd2()
    );

    // TODO: branch/jump handling not integrated yet
endmodule

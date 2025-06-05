module cpu (
    input wire clk,
    input wire reset
);
    wire [31:0] instr, pc_out;

    // Fetch stage
    cpu_fetch fetch_stage (
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .pc_out(pc_out)
    );

    // Instruction fields
    wire [6:0] opcode  = instr[6:0];
    wire [4:0] rd      = instr[11:7];
    wire [2:0] funct3  = instr[14:12];
    wire [4:0] rs1     = instr[19:15];
    wire [4:0] rs2     = instr[24:20];
    wire [6:0] funct7  = instr[31:25];

    wire [31:0] imm_i = {{20{instr[31]}}, instr[31:20]};
    wire [31:0] imm_s = {{20{instr[31]}}, instr[31:25], instr[11:7]};

    // Control signals
    reg we;
    reg MemRead, MemWrite, MemtoReg;
    reg alu_src;
    reg [1:0] alu_op;

    always @(*) begin
        // defaults
        we = 0; MemRead = 0; MemWrite = 0; MemtoReg = 0;
        alu_src = 0; alu_op = 2'b10;
        case (opcode)
            7'b0000011: begin // lw
                we = 1; MemRead = 1; MemWrite = 0; MemtoReg = 1;
                alu_src = 1; alu_op = 2'b00;
            end
            7'b0100011: begin // sw
                we = 0; MemRead = 0; MemWrite = 1; MemtoReg = 0;
                alu_src = 1; alu_op = 2'b00;
            end
            7'b0110011: begin // R-type
                we = 1; MemRead = 0; MemWrite = 0; MemtoReg = 0;
                alu_src = 0; alu_op = 2'b10;
            end
            default: begin
                we = 0; MemRead = 0; MemWrite = 0; MemtoReg = 0;
                alu_src = 0; alu_op = 2'b10;
            end
        endcase
    end

    wire [31:0] alu_result, mem_read_data;
    wire [31:0] rd1, rd2;
    wire zero;

    // Execute + Memory
    execute exe_stage (
        .clk(clk),
        .we(we),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .alu_op(alu_op),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm((opcode == 7'b0100011) ? imm_s : imm_i),
        .alu_src(alu_src),
        .funct3(funct3),
        .funct7_5(funct7[5]),
        .alu_result(alu_result),
        .mem_read_data(mem_read_data),
        .zero(zero),
        .rd1(rd1),
        .rd2(rd2)
    );

endmodule

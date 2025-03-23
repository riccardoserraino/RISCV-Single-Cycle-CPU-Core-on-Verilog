`include "pc.v" 
`include "operations.v" 
`include "instruction_memory.v" 
`include "register_file.v" 
`include "alu.v" 
`include "instruction_decoder.v" 
`include "data_memory.v" 
`include "main_decoder.v" 
`include "extend.v" 





module topmodule(
    input                   clk,
    input                   rst
);




//wires--------------------------------------------------------------------------------------------------------------
//the comments are made with respect to the output connection of each of the 15 blocks of the cpu

//pc 
wire [31:0] pc_top; //pc and pc_plus4, instruction memory, pc target 

//plus4 
wire [31:0] pc_plus_four_top; //plus4 and mux2 aft. dmem, mux1 bef. pc

//mux1 before pc
wire [31:0] pc_next_top; //mux1 before pc and pc

//pc target
wire [31:0] pc_target_top;

//instruction memory
wire [31:0] instr_top; //imem and reg file, imem and alu control, imem and main decoder, imem and extend unit

//extend unit or immediate generator
wire [31:0] imm_ext_top;

//register file
wire [31:0] srca_top; //reg file and alu
wire [31:0] rd2_top; //reg file and mux1 before alu, dmem

//mux1 before alu
wire [31:0] srcb_top;

//alu
wire [31:0] alu_result_top; //alu and dmem, mux2 after dmem
wire zero_top; //alu and and(branch)

//data memory
wire [31:0] read_data_top; //dmem and mux2 after dmem

//mux2 after dmem
wire [31:0] result_top; //mux2 after dmem and register file 

//control unit
//instruction decoder
wire [5:0] control_top; //alu control and alu, dmem, reg file

//main decoder
wire branch_top; //branch flag and and 
wire jump_top; //jump flag and or
wire [2:0] result_src_top; //result_src selector and mux2 after dmem
wire mem_write_top; //mem_write flag and dmem
wire alu_src_top; //alu_src flag and mux1 before alu
wire [2:0] imm_src_top; //imm_src selector and extend unit
wire reg_write_top; //reg_write_top and reg file
wire [3:0] alu_op_top; //main decoder and alu control
wire jalr_src_top; //jump type selector for mux1 after pc target

//logic operations
wire logicandout_top;
wire pc_src_top; //between or and mux1 before pc

//mux after pc target 
wire [31:0] mux_pctrgt_top;




//instantiae--------------------------------------------------------------------------------------------------------





//Program Counter
program_counter pc(
    .clk(clk),
    .rst(rst),
    .pc_next(pc_next_top),
    .pc_out(pc_top)
);

//PC+4
pc_plus_4 pc4(
    .from_pc(pc_top),
    .to_pc(pc_plus_four_top)
);

//mux2 after dmem
mux3 muxaftdmem(
    .S(result_src_top),
    .A(alu_result_top),
    .B(read_data_top), 
    .C(pc_plus_four_top),
    .D(imm_ext_top),
    .E(pc_target_top),
    .mux_out(result_top)
);

//mux1 before pc
mux1 muxbefpc(
    .S(pc_src_top),
    .A(pc_plus_four_top),
    .B(mux_pctrgt_top),
    .mux_out(pc_next_top)
);

//PC Target
pc_target pctargt(
    .A(pc_top),
    .B(imm_ext_top),
    .Y(pc_target_top)
);

//mux1 after pc target
mux1 muxaftpctrg(
    .S(jalr_src_top),
    .A(pc_target_top),
    .B(alu_result_top),
    .mux_out(mux_pctrgt_top)
);

//Instruction Memory
instruction_memory imem(
    .rst(rst),
    .A(pc_top), 
    .RD(instr_top)
);

//Registers
reg_file regfile(
    .clk(clk),
    .rst(rst),
    .A1(instr_top[19:15]),
    .A2(instr_top[24:20]),
    .A3(instr_top[11:7]),
    .WD3(result_top),
    .WE3(reg_write_top),
    .control(control_top),
    .RD1(srca_top),
    .RD2(rd2_top)
);

//Main decoder
main_decoder maindecoder(
    .opcode(instr_top[6:0]),
    .branch(branch_top),
    .jump(jump_top),
    .result_src(result_src_top),
    .mem_write(mem_write_top),
    .alu_src(alu_src_top),
    .imm_src(imm_src_top),
    .reg_write(reg_write_top),
    .jalr_src(jalr_src_top),
    .alu_op(alu_op_top)
);

//ALU decoder
instruction_decoder instrdecoder(
    .alu_op(alu_op_top),
    .func7(instr_top[31:25]),
    .func3(instr_top[14:12]),
    .control_signal(control_top)
);

//extend unit or immediate generator
extend extenddata(
    .instruction(instr_top),
    .imm_src(imm_src_top),
    .imm_ext(imm_ext_top)
);

//mux1 before alu
mux1 muxbefalu(
    .S(alu_src_top),
    .A(rd2_top),
    .B(imm_ext_top),
    .mux_out(srcb_top)
);

//ALU
alu alu(
    .A(srca_top),
    .B(srcb_top),
    .alu_control(control_top),
    .zero(zero_top),
    .alu_result(alu_result_top)
);

//and logic between branch flag and zero flag alu
logicand andlogic(
    .A(zero_top),
    .B(branch_top),
    .Y(logicandout_top)
);

//Data Memory
data_memory dmem(
    .clk(clk),
    .rst(rst),
    .A(alu_result_top),
    .WD(rd2_top),
    .WE(mem_write_top),
    .control(control_top),
    .RD(read_data_top)
);

//or logic between and output and jump flag 
logicor orlogic(
    .A(logicandout_top),
    .B(jump_top),
    .Y(pc_src_top)
);

endmodule
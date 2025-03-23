//Instruction Memory

module instruction_memory(
    input                   rst,
    input       [31:0]      A, 
    output      [31:0]      RD 
);

//creating instruction memory
reg [7:0] imem [2047:0]; 

//creating instruction register for a verification purpose
reg [31:0] instruction [36:0];

//directing the correct read input
assign RD = {imem[A+3], imem[A+2], imem[A+1], imem[A]};

/*logic for incrementing a counter everytime the input changes, 
so that  can verify each instruction one after another*/
integer k=0;

always @(A)begin
    if(~rst)begin 
        k <= k + 1;
    end
end

//reset logic
always @(*) begin
    if(~rst)begin
        //R-type
        instruction[0] <= ADD;
        instruction[1] <= SUB;
        instruction[2] <= SLL;
        instruction[3] <= SLT;
        instruction[4] <= SLTU;
        instruction[5] <= XOR;
        instruction[6] <= SRL;
        instruction[7] <= SRA;
        instruction[8] <= OR;
        instruction[9] <= AND; 
        /*for this AND operation we have to note that register 26 is different 
        from the value assigned after the rst because it was a destination 
        register for SLL instruction*/

        //I-type
        instruction[10] <= ADDI;
        instruction[11] <= SLTI;
        instruction[12] <= SLTIU;
        instruction[13] <= XORI;
        instruction[14] <= ORI;
        instruction[15] <= ANDI;
        instruction[16] <= SLLI;
        instruction[17] <= SRLI;
        instruction[18] <= SRAI;

        //L-type
        instruction[19] <= LB;
        instruction[20] <= LH;
        instruction[21] <= LW;
        instruction[22] <= LBU;
        instruction[23] <= LHU;

        //S-type
        instruction[24] <= SB;
        instruction[25] <= SH;
        instruction[26] <= SW;

        //B-type
        instruction[27] <= BEQ;
        instruction[28] <= BNE;
        instruction[29] <= BLT;
        instruction[30] <= BGE;
        instruction[31] <= BLTU;
        instruction[32] <= BGEU;

        //LUI
        instruction[33] <= LUI;

        //AUIPC
        instruction[34] <= AUIPC;

        //JAL
        instruction[35] <= JAL;

        //JALR
        instruction[36] <= JALR;

    end
end

//casual instruction parameters setup (32-bit) for testing one instruction type-set at time
//R-type
parameter [31:0] ADD   = {7'b0000000, 5'b01010, 5'b00011, 3'b000, 5'b00101, 7'b0110011}; // rd: 5, rs1: 3, rs2: 10
parameter [31:0] SUB   = {7'b0100000, 5'b01100, 5'b10001, 3'b000, 5'b00010, 7'b0110011}; // rd: 2, rs1: 17, rs2: 12
parameter [31:0] SLL   = {7'b0000000, 5'b10101, 5'b11100, 3'b001, 5'b11010, 7'b0110011}; // rd: 26, rs1: 28, rs2: 21
parameter [31:0] SLT   = {7'b0000000, 5'b01110, 5'b00001, 3'b010, 5'b10100, 7'b0110011}; // rd: 20, rs1: 1, rs2: 14
parameter [31:0] SLTU  = {7'b0000000, 5'b10010, 5'b01101, 3'b011, 5'b01011, 7'b0110011}; // rd: 11, rs1: 13, rs2: 18
parameter [31:0] XOR   = {7'b0000000, 5'b11001, 5'b10110, 3'b100, 5'b11101, 7'b0110011}; // rd: 29, rs1: 22, rs2: 25
parameter [31:0] SRL   = {7'b0000000, 5'b00111, 5'b10011, 3'b101, 5'b11011, 7'b0110011}; // rd: 27, rs1: 19, rs2: 7
parameter [31:0] SRA   = {7'b0100000, 5'b01000, 5'b01111, 3'b101, 5'b00110, 7'b0110011}; // rd: 6, rs1: 15, rs2: 8
parameter [31:0] OR    = {7'b0000000, 5'b11111, 5'b10111, 3'b110, 5'b01001, 7'b0110011}; // rd: 9, rs1: 23, rs2: 31
parameter [31:0] AND   = {7'b0000000, 5'b10000, 5'b11010, 3'b111, 5'b11100, 7'b0110011}; // rd: 28, rs1: 26, rs2: 16

//I-type 
parameter [31:0] ADDI  = {12'b000000010101, 5'b00110, 3'b000, 5'b01000, 7'b0010011}; // imm: 21, rs1: 6, rd: 8
parameter [31:0] SLTI  = {12'b111111110100, 5'b00001, 3'b010, 5'b01111, 7'b0010011}; // imm: -12, rs1: 1, rd: 15
parameter [31:0] SLTIU = {12'b000000011000, 5'b10010, 3'b011, 5'b10101, 7'b0010011}; // imm: 24, rs1: 18, rd: 21
parameter [31:0] XORI  = {12'b000000001010, 5'b01011, 3'b100, 5'b01101, 7'b0010011}; // imm: 10, rs1: 11, rd: 13
parameter [31:0] ORI   = {12'b000000001110, 5'b01100, 3'b110, 5'b10100, 7'b0010011}; // imm: 14, rs1: 12, rd: 20
parameter [31:0] ANDI  = {12'b000000001101, 5'b00100, 3'b111, 5'b01010, 7'b0010011}; // imm: 13, rs1: 4, rd: 10
parameter [31:0] SLLI  = {12'b000000000011, 5'b10001, 3'b001, 5'b00010, 7'b0010011}; // imm: 3, rs1: 17, rd: 2
parameter [31:0] SRLI  = {12'b000000000101, 5'b01100, 3'b101, 5'b10001, 7'b0010011}; // imm: 5, rs1: 12, rd: 17
parameter [31:0] SRAI  = {12'b000000000100, 5'b10100, 3'b101, 5'b11000, 7'b0010011}; // imm: 4, rs1: 20, rd: 24

//L-type
parameter [31:0] LB    = {12'b000000001000, 5'b00101, 3'b000, 5'b10110, 7'b0000011}; // imm: 8, rs1: 5, rd: 22
parameter [31:0] LH    = {12'b000000000011, 5'b10101, 3'b001, 5'b01011, 7'b0000011}; // imm: 3, rs1: 21, rd: 11
parameter [31:0] LW    = {12'b000000001100, 5'b00110, 3'b010, 5'b10000, 7'b0000011}; // imm: 12, rs1: 6, rd: 16
parameter [31:0] LBU   = {12'b000000000111, 5'b01101, 3'b100, 5'b11111, 7'b0000011}; // imm: 7, rs1: 17, rd: 31
parameter [31:0] LHU   = {12'b000000001010, 5'b00000, 3'b101, 5'b10001, 7'b0000011}; // imm: 10, rs1: 0, rd: 17

//S-type
parameter [31:0] SB    = {7'b0000000, 5'b01111, 5'b00111, 3'b000, 5'b00010, 7'b0100011}; // imm: 2, rs2: 15, rs1: 7
parameter [31:0] SH    = {7'b0000000, 5'b01110, 5'b00000, 3'b001, 5'b10100, 7'b0100011}; // imm: 20, rs2: 14, rs1: 0
parameter [31:0] SW    = {7'b0000000, 5'b11110, 5'b10111, 3'b010, 5'b00111, 7'b0100011}; // imm: 7, rs2: 30, rs1: 23

//B-type
parameter [31:0] BEQ   = {1'b0, 6'b000000, 5'b01000, 5'b00100, 3'b000, 4'b0010, 1'b0, 7'b1100011}; // imm: 5, rs1: 4, rs2: 8
parameter [31:0] BNE   = {1'b0, 6'b000000, 5'b01101, 5'b10001, 3'b001, 4'b1101, 1'b0, 7'b1100011}; // imm: 7, rs1: 17, rs2: 13
parameter [31:0] BLT   = {1'b0, 6'b000001, 5'b01111, 5'b00000, 3'b100, 4'b1100, 1'b0, 7'b1100011}; // imm: 5, rs1: 0, rs2: 15
parameter [31:0] BGE   = {1'b0, 6'b000000, 5'b10110, 5'b11010, 3'b101, 4'b0110, 1'b0, 7'b1100011}; // imm: 10, rs1: 26, rs2: 22
parameter [31:0] BLTU  = {1'b0, 6'b000001, 5'b10111, 5'b11000, 3'b110, 4'b0001, 1'b0, 7'b1100011}; // imm: 5, rs1: 24, rs2: 23
parameter [31:0] BGEU  = {1'b0, 6'b000011, 5'b10101, 5'b11111, 3'b111, 4'b0010, 1'b0, 7'b1100011}; // imm: 1, rs1: 31, rs1: 21

//LUI
parameter [31:0] LUI   = {20'b1111111110000011001, 5'b00011, 7'b0110111}; // imm: -256, rd: 3

//AUIPC
parameter [31:0] AUIPC = {20'b1111111111000110110, 5'b00111, 7'b0010111}; // imm: -458, rd: 7

//JAL
parameter [31:0] JAL   = {1'b0, 10'b000010110, 1'b0, 8'b0, 5'b10010, 7'b1101111}; // imm: 4, rd: 18

//JALR
parameter [31:0] JALR  = {12'b000000011010, 5'b01011, 3'b000, 5'b10100, 7'b1100111}; // imm: 52, rd: 20, rs1: 11

//instructions assignment to imem registers (8-bit at time) for verifying one instruction at time
always @(*)begin
        imem[A] <= instruction [k][7:0];
        imem[A+1] <= instruction [k][15:8];
        imem[A+2] <= instruction [k][23:16];
        imem[A+3] <= instruction [k][31:24];
end
endmodule
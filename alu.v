//Aritmethic Logic Unit 

module alu(
    input           [31:0]      A,
    input           [31:0]      B,
    input           [5:0]       alu_control,
    output reg                  zero,
    output reg      [31:0]      alu_result
);

reg [31:0] alu_out;

//initializing operations control parameters
//R type
parameter [5:0] ADD =  6'b000000;
parameter [5:0] SUB =  6'b000001;
parameter [5:0] SLL =  6'b000010;
parameter [5:0] SLT =  6'b000011;
parameter [5:0] SLTU = 6'b000100;
parameter [5:0] XOR =  6'b000101;
parameter [5:0] SRL =  6'b000110;
parameter [5:0] SRA =  6'b000111;
parameter [5:0] OR =   6'b001000;
parameter [5:0] AND =  6'b001001;
//I type
parameter [5:0] ADDI =  6'b001010;
parameter [5:0] SLTI =  6'b001011;
parameter [5:0] SLTIU = 6'b001100;
parameter [5:0] XORI =  6'b001101;
parameter [5:0] ORI =   6'b001110;
parameter [5:0] ANDI =  6'b001111;
parameter [5:0] SLLI =  6'b010000;
parameter [5:0] SRLI =  6'b010001;
parameter [5:0] SRAI =  6'b010010;
//L type
parameter [5:0] LB =  6'b010011;
parameter [5:0] LH =  6'b010100;
parameter [5:0] LW =  6'b010101;
parameter [5:0] LBU = 6'b010110;
parameter [5:0] LHU = 6'b010111;
//S type
parameter [5:0] SB = 6'b011000;
parameter [5:0] SH = 6'b011001;
parameter [5:0] SW = 6'b011010;
//B type
parameter [5:0] BEQ =  6'b011011;
parameter [5:0] BNE =  6'b011100;
parameter [5:0] BLT =  6'b011101;
parameter [5:0] BGE =  6'b011110;
parameter [5:0] BLTU = 6'b011111;
parameter [5:0] BGEU = 6'b100000;
//LUI
parameter [5:0] LUI = 6'b100001; //do not compute operations in the alu
//AUIPC
parameter [5:0] AUIPC = 6'b100010; //do not compute operations in the alu
//JAL
parameter [5:0] JAL = 6'b100011; //do not compute operations in the alu
//JALR
parameter [5:0] JALR = 6'b100100;


//jalr instruction 
reg [31:0] jalr_result;


//zero flag
always @(*)begin  
  zero <= (alu_result == 32'd1); 
end


//assign alu result
always @(*)begin
  alu_result <= alu_out;
end

always @(*)begin
  case(alu_control)
    //R type, I type
    ADD: alu_out <= A + B;
    SUB: alu_out <= A - B;
    SLL: alu_out <= A << B;
    SLT: alu_out <= ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
    SLTU: alu_out <= (A < B) ? 32'd1 : 32'd0;
    XOR: alu_out <= A ^ B;
    SRL: alu_out <= A >> B;
    SRA: alu_out <= $signed(A) >>> B;
    OR: alu_out <=  A | B;
    AND: alu_out <= A & B;

    //I type
    ADDI: alu_out <= A + B;
    SLTI: alu_out <= ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
    SLTIU: alu_out <= (A < B) ? 32'd1 : 32'd0;
    XORI: alu_out <= A ^ B;
    ORI: alu_out <=  A | B;
    ANDI: alu_out <= A & B;
    SLLI: alu_out <= A << B;
    SRLI: alu_out <= A >> B;
    SRAI: alu_out <= $signed(A) >>> B;

    //L type
    LB, LH, LW, LBU, LHU: alu_out <= A + B;

    //S type
    SB, SH, SW: alu_out <= A + B;

    //B type
    BEQ: alu_out <= (A == B) ? 32'd1 : 32'd0;
    BNE: alu_out <= (A != B) ? 32'd1 : 32'd0;
    BLT: alu_out <= ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
    BGE: alu_out <= ($signed(A) >= $signed(B)) ? 32'd1 : 32'd0;
    BLTU: alu_out <= (A < B) ? 32'd1 : 32'd0;
    BGEU: alu_out <= (A >= B) ? 32'd1 : 32'd0;

    //JALR
    JALR: begin 
      jalr_result <= A + B;
      alu_out <= {jalr_result[31:1], 1'b0};
    end

    //default
    default: alu_out <= 32'hxxxxxxxx;
  endcase
end

endmodule
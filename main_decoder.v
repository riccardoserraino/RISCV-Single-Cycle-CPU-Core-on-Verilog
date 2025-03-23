//Control unit

module main_decoder(
    input       [6:0]       opcode,     //opcode from instruction
    output reg              branch,     //indicates a branch instruction
    output reg              jump,       //indicates jump instruction
    output reg  [2:0]       result_src, //select the source for the result
    output reg              mem_write,  //enables writing to memory
    output reg              alu_src,    //selects the second operand for the alu (register or immediate)
    output reg  [2:0]       imm_src,    //selects the immediate type (I, S, B)
    output reg              reg_write,  //enables writing to register file
    output reg              jalr_src,   //indicates wheter the instruction is jalr
    output reg  [3:0]       alu_op      //selects the alu instruction type
);

reg [5:0] control_signals; //jump_src, branch, jump, mem_write, alu_src, reg_write

//opcode parameters                  //instructions //alu_opcode
parameter [6:0] R     = 7'b0110011;  //add, sub, sll, slt, sltu, xor, srl, sra, or, and //0000
parameter [6:0] I     = 7'b0010011;  //addi, slti, sltiu, xori, ori, andi, slli, srli, srai //0001
parameter [6:0] L     = 7'b0000011;  //lb, lh, lw, lbu, lhu //0010
parameter [6:0] S     = 7'b0100011;  //sb, sh, sw //0011
parameter [6:0] B     = 7'b1100011;  //beq, bne, blt, bge, bltu, bgeu //0100
parameter [6:0] LUI   = 7'b0110111;  //load upper immediate //0101
parameter [6:0] AUIPC = 7'b0010111;  //add upper immediate to pc //0110
parameter [6:0] JAL   = 7'b1101111;  //jal //0111
parameter [6:0] JALR  = 7'b1100111;  //jalr //1000

//alu_op parameters
parameter [3:0] Rop     = 4'b0000;     
parameter [3:0] Iop     = 4'b0001;     
parameter [3:0] Lop     = 4'b0010;     
parameter [3:0] Sop     = 4'b0011;     
parameter [3:0] Bop     = 4'b0100;     
parameter [3:0] LUIop   = 4'b0101;   
parameter [3:0] AUIPCop = 4'b0110; 
parameter [3:0] JALop   = 4'b0111;   
parameter [3:0] JALRop  = 4'b1000;  

//control_signals parameters          //jalr_src, branch, jump, mem_write, alu_src, reg_write
parameter [5:0] Rctr     = 6'b000001; // reg_write = 1
parameter [5:0] Ictr     = 6'b000011; // reg_write = 1, alu_src = 1
parameter [5:0] Lctr     = 6'b000011; // reg_write = 1, alu_src = 1
parameter [5:0] Sctr     = 6'b000110; // alu_src = 1, mem_write = 1
parameter [5:0] Bctr     = 6'b010000; // branch = 1
parameter [5:0] LUIctr   = 6'b000001; // reg_write = 1
parameter [5:0] AUIPCctr = 6'b000001; // reg_write = 1
parameter [5:0] JALctr   = 6'b001001; // reg_write = 1, jump = 1
parameter [5:0] JALRctr  = 6'b101011; // alu_src = 1, jump = 1, reg_write = 1, jump_src = 1;

//result_src parameters
parameter [2:0] Rrsrc     = 3'b000; 
parameter [2:0] Irsrc     = 3'b000; 
parameter [2:0] Lrsrc     = 3'b001; 
parameter [2:0] Srsrc     = 3'bxxx; 
parameter [2:0] Brsrc     = 3'bxxx; 
parameter [2:0] LUIrsrc   = 3'b011; 
parameter [2:0] AUIPCrsrc = 3'b100; 
parameter [2:0] JALrsrc   = 3'b010; 
parameter [2:0] JALRrsrc  = 3'b010; 

//imm_src parameters
parameter [2:0] Risrc     = 3'bxxx; 
parameter [2:0] Iisrc     = 3'b000; 
parameter [2:0] Lisrc     = 3'b000; 
parameter [2:0] Sisrc     = 3'b001; 
parameter [2:0] Bisrc     = 3'b010; 
parameter [2:0] LUIisrc   = 3'b011; 
parameter [2:0] AUIPCisrc = 3'b101; 
parameter [2:0] JALisrc   = 3'b100; 
parameter [2:0] JALRisrc  = 3'b000; 

always @(*)begin
    
    {jalr_src, branch, jump, mem_write, alu_src, reg_write} <= control_signals;

    


    case(opcode)
        //R type
        R: begin
            control_signals <= Rctr; 
            alu_op <= Rop;
            result_src <= Rrsrc;
            imm_src <= Risrc;
        end
        //I type
        I: begin
            control_signals <= Ictr; 
            alu_op <= Iop;
            result_src <= Irsrc;
            imm_src <= Iisrc;
        end
        //L type
        L: begin
            control_signals <= Lctr; 
            alu_op <= Lop;
            result_src <= Lrsrc;
            imm_src <= Lisrc;
        end
        //S type
        S: begin
            control_signals <= Sctr; 
            alu_op <= Sop;
            result_src <= Srsrc;
            imm_src <= Sisrc;
        end
        //B type
        B: begin
            control_signals <= Bctr; 
            alu_op <= Bop;
            result_src <= Brsrc;
            imm_src <= Bisrc;
        end
        //LUI 
        LUI: begin
            control_signals <= LUIctr; 
            alu_op <= LUIop;
            result_src <= LUIrsrc;
            imm_src <= LUIisrc;
        end
        //AUIPC 
        AUIPC: begin
            control_signals <= AUIPCctr; 
            alu_op <= AUIPCop;
            result_src <= AUIPCrsrc;
            imm_src <= AUIPCisrc;
        end
        //JAL 
        JAL: begin
            control_signals <= JALctr; 
            alu_op <= JALop;
            result_src <= JALRrsrc;
            imm_src <= JALisrc;
        end
        //JALR 
        JALR: begin
            control_signals <= JALRctr; 
            alu_op <= JALRop;
            result_src <= JALRrsrc;
            imm_src <= JALRisrc;
        end
        default: begin
            control_signals <= 6'b000000;
            alu_op <= 4'bxxxx;
            result_src <= 3'bxxx;
            imm_src <= 3'bxxx;
        end
    endcase 
end
endmodule




























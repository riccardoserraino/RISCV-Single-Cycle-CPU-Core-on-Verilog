//Instruction Control

module instruction_decoder(
    input       [3:0]       alu_op,
    input       [6:0]       func7,
    input       [2:0]       func3,
    output reg  [5:0]       control_signal
); 

reg [5:0] control_out;

//aluop parameters
parameter [3:0] Rop = 4'b0000; //add, sub, sll, slt, sltu, xor, srl, sra, or, and
parameter [3:0] Iop = 4'b0001; //addi, slti, sltiu, xori, ori, andi, slli, srli, srai
parameter [3:0] Lop = 4'b0010; //lb, lh, lw, lbu, lhu
parameter [3:0] Sop = 4'b0011; //sb, sh, sw
parameter [3:0] Bop = 4'b0100; //beq, bne, blt, bge, bltu, bgeu
parameter [3:0] LUIop = 4'b0101; //load upper immediate
parameter [3:0] AUIPCop = 4'b0110; //add upper immediate to pc
parameter [3:0] JALop = 4'b0111; //jal
parameter [3:0] JALRop = 4'b1000; //jalr

always @(*)begin
    //directing output
    control_signal <= control_out;

    case(alu_op)
    Rop : begin
        case(func7)
            7'b0000000: begin
                case(func3)
                    //add
                    3'b000: control_out <= 6'b000000;
                    //sll
                    3'b001: control_out <= 6'b000010;
                    //slt
                    3'b010: control_out <= 6'b000011;
                    //sltu
                    3'b011: control_out <= 6'b000100;
                    //xor
                    3'b100: control_out <= 6'b000101;
                    //srl
                    3'b101: control_out <= 6'b000110;
                    //or
                    3'b110: control_out <= 6'b001000;
                    //and
                    3'b111: control_out <= 6'b001001;
                    //default
                    default: control_out <= 6'bxxxxxx;
                endcase
            end
            7'b0100000: begin
                case (func3)
                    //sub
                    3'b000: control_out <= 6'b000001;
                    //sra
                    3'b101: control_out <= 6'b000111;
                    //default
                    default: control_out <= 6'bxxxxxx;
                endcase
            end
            //default
            default: control_out <= 6'bxxxxxx;
        endcase
    end
    Iop : begin
        case(func3)
            //addi
            3'b000: control_out <= 6'b001010;
            //slti
            3'b010: control_out <= 6'b001011;
            //sltiu
            3'b011: control_out <= 6'b001100;
            //xori
            3'b100: control_out <= 6'b001101;
            //ori
            3'b110: control_out <= 6'b001110;
            //andi
            3'b111: control_out <= 6'b001111;
            //slli
            3'b001: control_out <= 6'b010000;
            //srli, srai
            3'b101: begin
                if (func7 == 7'b0000000) control_out <= 6'b010001;
                else if (func7 == 7'b0100000) control_out <= 6'b010001;
            end
            default: control_out <=6'bxxxxxx;
        endcase   
    end
    Lop : begin
        case(func3)
            //lb
            3'b000: control_out <= 6'b010011;
            //lh
            3'b001: control_out <= 6'b010100;
            //lw
            3'b010: control_out <= 6'b010101;
            //lbu
            3'b100: control_out <= 6'b010110;
            //lhu
            3'b101: control_out <= 6'b010111;
            //default
            default: control_out <= 6'bxxxxxx;
        endcase
    end
    Sop : begin
        case(func3)
            //sb
            3'b000: control_out <= 6'b011000;
            //sh
            3'b001: control_out <= 6'b011001;
            //sw
            3'b010: control_out <= 6'b011010;
            //default
            default: control_out <= 6'bxxxxxx;
        endcase
    end
    Bop : begin
        case(func3)
            //beq
            3'b000: control_out <= 6'b011011;
            //bne
            3'b001: control_out <= 6'b011100;
            //blt
            3'b100: control_out <= 6'b011101;
            //bge
            3'b101: control_out <= 6'b011110;
            //bltu
            3'b110: control_out <= 6'b011111;
            //bgeu
            3'b111: control_out <= 6'b100000;
            //default
            default: control_out <= 6'bxxxxxx;
        endcase
    end
    LUIop : control_out <= 6'b100001;
    AUIPCop : control_out <= 6'b100010;
    JALop : control_out <= 6'b100011;
    JALRop : control_out <= 6'b100100;
    default: control_out <= 6'bxxxxxx;
    endcase
end
endmodule






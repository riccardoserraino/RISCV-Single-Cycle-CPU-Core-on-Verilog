//Immediate generator

module extend(
    input           [31:0]      instruction,
    input           [2:0]       imm_src,
    output reg      [31:0]      imm_ext
);


//imm_src parameters
parameter [2:0] Risrc     = 3'bxxx; //r type does not have immediate
parameter [2:0] Iisrc     = 3'b000; 
parameter [2:0] Lisrc     = 3'b000; 
parameter [2:0] Sisrc     = 3'b001; 
parameter [2:0] Bisrc     = 3'b010; 
parameter [2:0] LUIisrc   = 3'b011; 
parameter [2:0] AUIPCisrc = 3'b101; 
parameter [2:0] JALisrc   = 3'b100; 
parameter [2:0] JALRisrc  = 3'b000; 

//extracting instruction fields and sign extending immediate values
always @(*)begin
    case(imm_src)
        //I, L, JALR
        Iisrc, Lisrc, JALRisrc: begin 
            imm_ext = {{21{instruction[31]}}, instruction[30:25], instruction[24:21], instruction[20]}; 
        end
        //S
        Sisrc: begin 
            imm_ext = {{21{instruction[31]}}, instruction[30:25], instruction[11:7]}; 
        end
        //B
        Bisrc: begin
            imm_ext = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; 
        end
        //AUIPC, LUI
        AUIPCisrc, LUIisrc: begin
            imm_ext <= {instruction[31], instruction[30:20], instruction[19:12], 12'b0};
        end
        //JAL
        JALisrc: begin 
            imm_ext = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0}; 
        end
        //default
        default: begin
            imm_ext = 32'd0; 
        end
    endcase
end
endmodule


















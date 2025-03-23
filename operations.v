//Program Counter Adder

module pc_plus_4(
    input       [31:0]      from_pc,
    output      [31:0]      to_pc
);
assign to_pc = from_pc + 32'd4;
endmodule


//--------------------------------------------------------------------------------------------------


//Multiplexers

//(used before pc, before alu, after pc target)
module mux1(
    input                   S,
    input       [31:0]      A,
    input       [31:0]      B,
    output      [31:0]      mux_out
);
reg [31:0] out;
assign mux_out = out;
always @(*)begin
    case(S)
        1'b0: out <= A;
        1'b1: out <= B;
        default: out <= A;
    endcase
end
endmodule


//(used after dmem)
module mux3(
    input       [2:0]       S, //result_src 
    input       [31:0]      A, //alu_result
    input       [31:0]      B, //dmem
    input       [31:0]      C, //pc_plus_4
    input       [31:0]      D, //imm_ext
    input       [31:0]      E, //pc_target
    output reg  [31:0]      mux_out
);

//result_src parameters
parameter [2:0] Rrsrc =     3'b000; 
parameter [2:0] Irsrc =     3'b000; 
parameter [2:0] Lrsrc =     3'b001; 
parameter [2:0] Srsrc =     3'bxxx; //stores do not write back
parameter [2:0] Brsrc =     3'bxxx; //branches do not write back
parameter [2:0] LUIrsrc =   3'b011; 
parameter [2:0] AUIPCrsrc = 3'b100; 
parameter [2:0] JALrsrc =   3'b010; 
parameter [2:0] JALRrsrc =  3'b010; 

always @(*)begin
    case(S)
        //R, I
        3'b000: mux_out <= A; 
        //L
        Lrsrc: mux_out <= B;
        //JAL, JALR
        JALrsrc, JALRrsrc: mux_out <= C;
        //LUI
        LUIrsrc: mux_out <= D;
        //AUIPC
        AUIPCrsrc: mux_out <= E;
        //default
        default: mux_out <= 32'hxxxxxxxx;
    endcase
end
endmodule


//--------------------------------------------------------------------------------------------------


//adder pc target
module pc_target(
    input       [31:0]      A,
    input       [31:0]      B,
    output      [31:0]      Y
);
assign Y = A + B;
endmodule


//--------------------------------------------------------------------------------------------------


//And logic
module logicand(
    input A,
    input B,
    output Y
);
assign Y = A & B;
endmodule


//--------------------------------------------------------------------------------------------------


//Or logic
module logicor(
    input A,
    input B,
    output Y
);
assign Y = A | B;
endmodule
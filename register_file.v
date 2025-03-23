//Register File

module reg_file(
    input                   clk,
    input                   rst,
    input       [4:0]       A1,
    input       [4:0]       A2,
    input       [4:0]       A3,
    input       [31:0]      WD3,
    input                   WE3,
    input       [5:0]       control,
    output reg  [31:0]      RD1,
    output reg  [31:0]      RD2
);


//initializing register file registers
reg [31:0] register [31:0];
reg [31:0] register_new [31:0]; 
/*"register_new" set of registers contains the same values of "register", with 
the only difference that it is not written on after the posedge of the clock, 
but as soon as WD3 gets the result of that instruction, hence it changes every time 
the instruction changes, showing earlier the result that will be put in "register[A3] after
the next clock posedge".

For this reason the wire connected to "register" will show the value of the destinatination 
register before it changes, instead the wire connected to "regiter_new" will show the value 
that is going to be written in "register[A3]" after the posedge of the clock (or the value 
of the current instruction result).*/

reg [31:0] write_data;


//store parameters
parameter [5:0] SB = 6'b011000;
parameter [5:0] SH = 6'b011001;
parameter [5:0] SW = 6'b011010;


//reset logic
always @(posedge clk)begin
    if(rst)begin
        register[0]  <= 0;
		register[1]  <= 1;
		register[2]  <= 6;
		register[3]  <= 34;
		register[4]  <= 16;
		register[5]  <= 8;
		register[6]  <= 2;
		register[7]  <= 3;
		register[8]  <= 5;
		register[9]  <= 45;
		register[10] <= 50;
		register[11] <= 41;
		register[12] <= 56;
		register[13] <= 23;
		register[14] <= -24;
		register[15] <= -135;
		register[16] <= 2094;
		register[17] <= 24;
		register[18] <= 68;
		register[19] <= 1856;
		register[20] <= 30;
		register[21] <= 7;
		register[22] <= 52;
		register[23] <= 21;
		register[24] <= 44;
		register[25] <= 917;
		register[26] <= 56;
		register[27] <= 57;
		register[28] <= 48;
		register[29] <= 39;
		register[30] <= -800;
		register[31] <= 83;  
    end
end

//register set for a verification purpose
always @(posedge clk)begin
    if(rst)begin
        register_new[0]  <= 0;
		register_new[1]  <= 1;
		register_new[2]  <= 6;
		register_new[3]  <= 34;
		register_new[4]  <= 16;
		register_new[5]  <= 8;
		register_new[6]  <= 2;
		register_new[7]  <= 3;
		register_new[8]  <= 5;
		register_new[9]  <= 45;
		register_new[10] <= 50;
		register_new[11] <= 41;
		register_new[12] <= 56;
		register_new[13] <= 23;
		register_new[14] <= -24;
		register_new[15] <= -135;
		register_new[16] <= 2094;
		register_new[17] <= 24;
		register_new[18] <= 68;
		register_new[19] <= 1856;
		register_new[20] <= 30;
		register_new[21] <= 7;
		register_new[22] <= 52;
		register_new[23] <= 21;
		register_new[24] <= 44;
		register_new[25] <= 917;
		register_new[26] <= 56;
		register_new[27] <= 57;
		register_new[28] <= 48;
		register_new[29] <= 39;
		register_new[30] <= -800;
		register_new[31] <= 83;  
    end
end

//write logic 
always @(posedge clk)begin
    if(WE3)begin        
        register[A3] <= WD3;
    end
end

//wire for testing data written into register[A3] before the computation
wire [31:0] reg_value_bef_posedgeclk = register[A3];

//wire for testing data written into register[A3] after the computation
wire [31:0] reg_value_aft_posedgeclk = register_new[A3];

//wire for verying that the value selected by the store instruction will actually be divided in one or two byte if needed
wire [31:0] write_bef_store = register[A2];

//directing the correct read input
always @(*)begin
    //instantaneous change of the destination register for a verification purpose
    register_new[A3] <= WD3;

    //store instruction implementation
    //copying a value from register to register wd3
    case(control)
        //SB
        SB: write_data <= {24'b0, register[A2][7:0]};
        //SH
        SH: write_data <= {16'b0, register[A2][15:0]};
        //SW
        SW: write_data <= register[A2];
        //default mode is used for usual writing
        default: write_data <= register[A2];
    endcase
end

always @(*)begin
    case(control)
        SB, SH, SW: begin
            RD1 <= register[A1];
            RD2 <= write_data;
        end
        //usual output generation
        default: begin
            RD1 <= register[A1];
            RD2 <= register[A2];
        end
    endcase
end 
endmodule







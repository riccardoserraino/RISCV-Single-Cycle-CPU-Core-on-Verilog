//Data Memory

module data_memory(
    input                   clk,
    input                   rst,
    input       [31:0]      A,
    input       [31:0]      WD,
    input                   WE,
    input       [5:0]       control,
    output reg  [31:0]      RD
);

//creating data memory registers
reg [7:0] dmem [2047:0];
reg [7:0] dmem_new [2047:0];
/*"dmem_new" set of memory contains the same values of "dmem", with the only
difference that it is not written on after the posedge of the clock, but as soon as 
WD gets the value from reg file, hence it changes every time the instruction changes, showing, 
earlier, the data that will be put in dmem[A], ..., dmem[A+3] after the next clock posedge. 

For this reason the wire connected to "dmem[A], ..., dmem[A+3]" will show the value of 
the destinatination register before it changes, instead the wire connected to 
"dmem_new[A], ..., dmem[A+3]" will show the value that is going to be written in 
"dmem[A], ..., dmem[A+3]" after the posedge of the clock (or the value of the current 
instruction result).*/

//initializing data memory registers with casual values
always @(posedge clk)begin
    if(rst)begin
        dmem[0]  <= 8'b10010101;
		dmem[1]  <= 8'b01101000;
		dmem[2]  <= 8'b11001101;
		dmem[3]  <= 8'b00110110;
		dmem[4]  <= 8'b10111010;
		dmem[5]  <= 8'b11101011;
		dmem[6]  <= 8'b01000111;
		dmem[7]  <= 8'b00011001;
		dmem[8]  <= 8'b01110001;
		dmem[9]  <= 8'b00101011;
		dmem[10] <= 8'b01011000;
		dmem[11] <= 8'b11011101;
		dmem[12] <= 8'b00000110;
		dmem[13] <= 8'b10001111;
		dmem[14] <= 8'b11010000;
		dmem[15] <= 8'b10001111;
		dmem[16] <= 8'b10101100;
		dmem[17] <= 8'b01110101;
		dmem[18] <= 8'b11001010;
		dmem[19] <= 8'b00111011;
		dmem[20] <= 8'b01001100;
		dmem[21] <= 8'b01100010;
		dmem[22] <= 8'b10010111;
		dmem[23] <= 8'b11011101;
		dmem[24] <= 8'b00100110;
		dmem[25] <= 8'b01101110;
		dmem[26] <= 8'b00010011;
		dmem[27] <= 8'b01011011;
		dmem[28] <= 8'b10110001;
		dmem[29] <= 8'b01001110;
		dmem[30] <= 8'b10001001;
		dmem[31] <= 8'b01111000;  
    end
end

//dmem set for a verification purpose
always @(posedge clk)begin
    if(rst)begin
        dmem_new[0]  <= 8'b10010101;
		dmem_new[1]  <= 8'b01101000;
		dmem_new[2]  <= 8'b11001101;
		dmem_new[3]  <= 8'b00110110;
		dmem_new[4]  <= 8'b10111010;
		dmem_new[5]  <= 8'b11101011;
		dmem_new[6]  <= 8'b01000111;
		dmem_new[7]  <= 8'b00011001;
		dmem_new[8]  <= 8'b01110001;
		dmem_new[9]  <= 8'b00101011;
		dmem_new[10] <= 8'b01011000;
		dmem_new[11] <= 8'b11011101;
		dmem_new[12] <= 8'b00000110;
		dmem_new[13] <= 8'b10001111;
		dmem_new[14] <= 8'b11010000;
		dmem_new[15] <= 8'b10001111;
		dmem_new[16] <= 8'b10101100;
		dmem_new[17] <= 8'b01110101;
		dmem_new[18] <= 8'b11001010;
		dmem_new[19] <= 8'b00111011;
		dmem_new[20] <= 8'b01001100;
		dmem_new[21] <= 8'b01100010;
		dmem_new[22] <= 8'b10010111;
		dmem_new[23] <= 8'b11011101;
		dmem_new[24] <= 8'b00100110;
		dmem_new[25] <= 8'b01101110;
		dmem_new[26] <= 8'b00010011;
		dmem_new[27] <= 8'b01011011;
		dmem_new[28] <= 8'b10110001;
		dmem_new[29] <= 8'b01001110;
		dmem_new[30] <= 8'b10001001;
		dmem_new[31] <= 8'b01111000;  
    end
end

reg [31:0] read_data;

integer k=0;

//load parameters
parameter [5:0] LB = 6'b010011;
parameter [5:0] LH = 6'b010100;
parameter [5:0] LW = 6'b010101;
parameter [5:0] LBU = 6'b010110;
parameter [5:0] LHU = 6'b010111;

//write logic (used by store instructions)
always @(posedge clk)begin
    if(WE)begin        
        dmem[A] <= write_data[0];
        dmem[A+1] <= write_data[1];
        dmem[A+2] <= write_data[2];
        dmem[A+3] <= write_data[3];
    end
end

//wire for testing data written into dmem[A], dmem[A+1], dmem[A+2], dmem[A+3] before the computation
wire [31:0] dmem_value_bef_posedgeclk = {dmem[A+3], dmem[A+2], dmem[A+1], dmem[A]};

//wire for testing data written into dmem[A], dmem[A+1], dmem[A+2], dmem[A+3] after the computation
wire [31:0] dmem_value_aft_posedgeclk = {dmem_new[A+3], dmem_new[A+2], dmem_new[A+1], dmem_new[A]};

//written data 32 bit needs to be slipped in blocks of 4 to be put into dmem registers
reg [7:0] write_data [3:0]; 

always @(*)begin
    write_data[0] <= WD[7:0];
    write_data[1] <= WD[15:8];
    write_data[2] <= WD[23:16];
    write_data[3] <= WD[31:24];
end

//read logic
always @(*)begin
    //directing output
    RD <= read_data;

    //instantaneous change of the destination register for a verification purpose
    dmem_new[A] <= write_data[0];
    dmem_new[A+1] <= write_data[1];
    dmem_new[A+2] <= write_data[2];
    dmem_new[A+3] <= write_data[3];

    //load instruction implementation
    case(control) 
        //LB
        LB: read_data <= {{24{dmem[A][7]}},  dmem[A]};
        //LH
        LH: read_data <= {{16{dmem[A+1][7]}}, dmem[A+1], dmem[A]};
        //LW
        LW: read_data <= {dmem[A+3], dmem[A+2], dmem[A+1], dmem[A]};
        //LBU
        LBU: read_data <= {24'b0, dmem[A]};
        //LHU
        LHU: read_data <= {12'b0, dmem[A+1], dmem[A]};
        //default mode 
        default: read_data <= {dmem[A+3], dmem[A+2], dmem[A+1], dmem[A]};
    endcase
end

endmodule
`timescale 1ns/100ps

module topmodule_testbench();

reg clk=0;
reg rst=1;


initial begin 
    $dumpfile("waveout.vcd");
    $dumpvars(0, topmodule_testbench);
end

initial begin 
    #50;
    $finish;
end

always begin 
    #0.25 clk <= ~clk;
end

initial begin
    #1;
    rst<=0;
end


topmodule uut(
    .clk(clk),
    .rst(rst)
);


endmodule
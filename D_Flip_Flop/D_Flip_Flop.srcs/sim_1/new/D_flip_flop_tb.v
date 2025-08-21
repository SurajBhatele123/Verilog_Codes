`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2025 10:20:15
// Design Name: 
// Module Name: D_flip_flop_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module D_flip_flop_tb();
reg clk,d,rst;
wire q;

D_Flip_Flop dut(.clk(clk),.d(d),.rst(rst),.q(q));

always #5 clk = ~clk;
initial begin
rst = 0;    
clk = 0;
d =0; 

// Apply Reset Values 
rst = 1;#10;
rst = 0;#10;
// test Sequence 
 d = 1; #10;
 d = 0; #10;
 d = 1; #10;
 d = 0; #10;      
// Again Apply Reset 
rst = 1;#10;
rst = 0;#10;
// Again Apply input values
 d = 1; #10;
 d = 0; #10;
 $finish;
end
endmodule

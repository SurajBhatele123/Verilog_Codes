`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.01.2025 09:58:14
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb();

reg [15:0]x,y;
wire [15:0]sum;
reg s,carry,zero,parity,overflow;
integer n;

ALU dut(x,y,sum,s,zero,carry,parity,overflow);
initial
begin
//$dumpfile("ALU.vcd");$monitor($time,"x=%h,y=%h,sum=%h,sum=%h,sign=%h,carry=%h,zero=%h,parity=%h,overflow=%h",
//x,y,sum,sign,carry,zero,parity,overflow);
         
#5 x=16'h8fff; y = 16'h8000;
#5 x=16'hfffe; y = 16'h0002;
#5 x=16'haaaa; y = 16'h5555;

end
endmodule


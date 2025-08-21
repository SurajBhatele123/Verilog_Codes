`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.02.2025 10:21:46
// Design Name: 
// Module Name: HA_tb
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


module HA_tb();

reg a,b;
wire sum,carry;

HA dut(.a(a),.b(b),.sum(sum),.carry(carry));
initial
begin

    a=1'b0; b=1'b0;
#10 a=1'b0; b=1'b0;
#10 a=1'b0; b=1'b0;
#10 a=1'b0; b=1'b0;

end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.01.2025 09:38:50
// Design Name: 
// Module Name: ALU
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


module ALU(
input[15:0]x,y,
output[15:0]sum,
output s,zero,carry,parity,overflow

);

assign {carry,sum}=x+y;
assign s = sum[15]; // whether the sum is negative and postive MSB Bit
assign zero = ~|sum;  // All the bit be zero means zero set at 1 
assign parity = ~^sum; // Exclucive NOR if it is even parity it will be 1 and vice versa
assign overflow = (x[15]&y[15]&~sum[15])|(~x[15]&~y[15]&sum[15]); 

endmodule

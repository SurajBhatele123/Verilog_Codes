`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.01.2025 12:49:59
// Design Name: 
// Module Name: D_Flip_Flop
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
module D_Flip_Flop(clk,d,rst,q);  // Sychronous Active High Flip Flop 
input  clk,d,rst;
output reg q;

always @(posedge clk or posedge rst) // sensitivity list
begin
if(rst) begin
q  <= 1'b0;        //  rest the output when rest is high
end
else begin
 q <= d;  // set the output of data line 
 end
end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2025 10:38:40
// Design Name: 
// Module Name: decoder_2x4_tb
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


module decoder_2x4_tb();

reg a,b,en;
wire [3:0]d;

decoder_2x4 dut(.a(a),.b(b),.enable(en),.d(d));
initial
begin
    en=1'b0; a=1'b0; b=1'b0;
#50 en=1'b1; a=1'b0; b=1'b0;
#50 en=1'b1; a=1'b0; b=1'b1;
#50 en=1'b1; a=1'b1; b=1'b0;
#50 en=1'b1; a=1'b1; b=1'b1;

end 
endmodule

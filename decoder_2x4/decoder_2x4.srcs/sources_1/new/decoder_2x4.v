`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2025 07:26:29
// Design Name: 
// Module Name: decoder_2x4
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


module decoder_2x4(a,b,enable,d);
input a,b,enable;
output [3:0]d;

wire w1,w2,w3,w4;

not n1(w1,a);
not n2(w2,b);

and a1(d[0],enable,w1,w2);
and a2(d[1],enable,w1,b);
and a3(d[2],enable,a,w2);
and a4(d[3],enable,a,b);

endmodule

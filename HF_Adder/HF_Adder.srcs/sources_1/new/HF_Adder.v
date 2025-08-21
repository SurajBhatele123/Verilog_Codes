`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.01.2025 15:10:50
// Design Name: 
// Module Name: HF_Adder
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


module HF_Adder(
    input a,b,
    output sum,carry
    );
    assign sum = a^b;
    assign carry = a&b;
    
endmodule

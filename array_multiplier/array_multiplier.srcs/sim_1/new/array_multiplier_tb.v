`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.10.2024 15:11:07
// Design Name: 
// Module Name: array_multiplier_tb
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


module array_multplier_tb;
  reg [3:0] A, B;
  wire [7:0] P;

  // Instantiate the array multiplier
  array_multiplier am(A, B, P);
  
  initial begin
    // Monitor signal changes
    $monitor("A = %b: B = %b --> P = %b, P(dec) = %0d", A, B, P, P);
    
    // Test cases
    A = 4'b0001; B = 4'b0000; #3;  // A = 1, B = 0 -> P = 0
    A = 4'b0111; B = 4'b0101; #3;  // A = 7, B = 5 -> P = 35
    A = 4'b1111; B = 4'b1111; #3;  // A = 8, B = 9 -> P = 72

    
    // End simulation
    $finish;
  end
endmodule
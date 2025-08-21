`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2025 12:18:59
// Design Name: 
// Module Name: mulipler_16_bit
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

module karatsuba_mul_16bit(
    input [15:0] a,
    input [15:0] b,
    output [31:0] out
    );
    
    wire [15:0] ac,bc,ad,bd;
    wire [31:0] t1,t2;
    wire [24:0] psum;
    
  karatsuba_mul_8bit i1(.a(a[15:8]),.b(b[15:8]),.out(ac));
  karatsuba_mul_8bit i2(.a(a[7:0]),.b(b[15:8]),.out(bc));
  karatsuba_mul_8bit i3(.a(a[15:8]),.b(b[7:0]),.out(ad));
  karatsuba_mul_8bit i4(.a(a[7:0]),.b(b[7:0]),.out(bd));
  assign t2= bd;
  assign psum = (bc+ad) << 8;
  assign t1=ac << 16;
  assign out= t1+t2+psum;
endmodule

module karatsuba_mul_8bit(
    input [7:0] a,
    input [7:0] b,
    output [15:0] out
    );
wire [7:0] ac,bc,ad,bd;
    wire [15:0] t1,t2;
    wire [12:0] psum;
    
  karatsuba_mul_4bit m1(.a(a[7:4]),.b(b[7:4]),.out(ac));
  karatsuba_mul_4bit m2(.a(a[3:0]),.b(b[7:4]),.out(bc));
  karatsuba_mul_4bit m3(.a(a[7:4]),.b(b[3:0]),.out(ad));
  karatsuba_mul_4bit m4(.a(a[3:0]),.b(b[3:0]),.out(bd));
  assign t2= bd;
  assign psum = (bc+ad) << 4;
  assign t1=ac << 8;
  assign out= t1+t2+psum;
endmodule

module karatsuba_mul_4bit(
    input [3:0] a,
    input [3:0] b,
    output [7:0] out
    );
    wire [3:0] ac,bc,ad,bd;
    wire [7:0] t1,t2;
    wire [6:0] psum;
    
  karatsuba_mul_2bit m1(.a(a[3:2]),.b(b[3:2]),.out(ac));
  karatsuba_mul_2bit m2(.a(a[1:0]),.b(b[3:2]),.out(bc));
  karatsuba_mul_2bit m3(.a(a[3:2]),.b(b[1:0]),.out(ad));
  karatsuba_mul_2bit m4(.a(a[1:0]),.b(b[1:0]),.out(bd));
  assign t2= bd;
  assign psum = (bc+ad) << 2;
  assign t1= ac << 4;
  assign out= t1+t2+psum;
endmodule

module karatsuba_mul_2bit(
    input [1:0] a,
    input [1:0] b,
    output [3:0] out
    );
    wire temp;
    assign out[0]= a[0]&b[0];
    assign out[1]= (a[1]&b[0])^(a[0]&b[1]);
    assign temp =  (a[1]&b[0])&(a[0]&b[1]);
    assign out[2]= temp ^(a[1]&b[1]);
    assign out[3]= temp &(a[1]&b[1]);
endmodule


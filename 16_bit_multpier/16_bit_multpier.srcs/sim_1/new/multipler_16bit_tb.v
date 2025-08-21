`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2025 12:22:12
// Design Name: 
// Module Name: multipler_16bit_tb
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

module karatsuba_mul_16bit_tb;
	// Inputs
	reg [15:0] a;
	reg [15:0] b;

	// Outputs
	wire [31:0] out;

	// Instantiate the Unit Under Test (UUT)
	karatsuba_mul_16bit uut (
		.a(a), 
		.b(b), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;

		// Wait 100 ns for global reset to finish
		#100;
		// Add stimulus here
		a = 16'd50000;
		b = 16'd45000;
		#100;
		a = 16'd65000;
		b = 16'd8500;
		#100;
		
		a = 16'd65535;
		b = 16'd65535;
		#100;
		
		a = 16'd65535;
		b = 16'd65534;
		#100;
		
		a = 16'd43445;
		b = 16'd64305;
		#100; 
		$stop;
        
	end     
endmodule


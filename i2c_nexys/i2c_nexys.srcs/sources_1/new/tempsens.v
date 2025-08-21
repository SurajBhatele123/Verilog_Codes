`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 17.04.2025 11:13:37
// Design Name: Shubham_Vats_242221023
// Module Name: tempsens
//////////////////////////////////////////////////////////////////////////////////
module top(
    input         CLK100MHZ,        // nexys clk signal
    input         reset,            // btnC on nexys
    inout         TMP_SDA,          // i2c sda on temp sensor - bidirectional
    output        TMP_SCL,          // i2c scl on temp sensor
    output [6:0]  SEG,              // 7 segments of each display
    output [3:0]  AN,               // 4 anodes of 4 displays
    output [3:0]  NAN,              // 4 anodes always OFF
    output [7:0]  LED,               // nexys leds = binary temp in deg C
    output occ1,
    inout occ2
    );
    
    wire sda_dir;                   // direction of SDA signal - to or from master
    wire w_200kHz;                  // 200kHz SCL
    wire [7:0] w_data;              // 8 bits of temperature data

    // Instantiate i2c master
    i2c_master master(
        .clk_200kHz(w_200kHz),
        .reset(reset),
        .temp_data(w_data),
        .SDA(TMP_SDA),
        .SDA_dir(sda_dir),
        .SCL(TMP_SCL)
    );
    
    // Instantiate 200kHz clock generator
    clkgen_200kHz cgen(
        .clk_100MHz(CLK100MHZ),
        .clk_200kHz(w_200kHz)
    );
    
    // Instantiate 7 segment control
    seg7 seg(
        .clk_100MHz(CLK100MHZ),
        .temp_data(w_data),
        .SEG(SEG),
        .NAN(NAN),
        .AN(AN)
    );
    
    // Set LED value to temp data
    assign LED = w_data;
    assign occ1= TMP_SCL;
    assign occ2= TMP_SDA;

endmodule

module clkgen_200kHz(
    input clk_100MHz,
    output clk_200kHz
    );
    
    // 100 x 10^6 / 200 x 10^3 / 2 = 250 <-- 8 bit counter
    reg [7:0] counter = 8'h00;
    reg clk_reg = 1'b1;
    
    always @(posedge clk_100MHz) begin
        if(counter == 249) begin
            counter <= 8'h00;
            clk_reg <= ~clk_reg;
        end
        else
            counter <= counter + 1;
    end
    
    assign clk_200kHz = clk_reg;
    
endmodule
/*module tempsens(

    );
endmodule*/

module i2c_master(
    input clk_200kHz,               // i_clk
    input reset,                    // btnC on nexys
    inout SDA,                      // i2c standard interface signal
    output [7:0] temp_data,         // 8 bits binary representation of deg C
    output SDA_dir,                 // direction of inout signal on SDA - to/from master 
    output SCL                      // i2c standard interface signal - 10KHZ
    );
    
    // *** GENERATE 10kHz SCL clock from 200kHz ***************************
    // 200 x 10^3 / 10 x 10^3 / 2 = 10
    reg [3:0] counter = 4'b0;  // count up to 9
    reg clk_reg = 1'b1; 
    
    always @(posedge clk_200kHz or posedge reset)
        if(reset) begin
            counter = 4'b0;
            clk_reg = 1'b0;
        end
        else 
            if(counter == 9) begin
                counter <= 4'b0;
                clk_reg <= ~clk_reg;    // toggle reg
            end
            else
                counter <= counter + 1;
      
    // Set value of i2c SCL signal to the sensor - 10kHz            
    assign SCL = clk_reg;   
    // ********************************************************************     

    // Signal Declarations               
    parameter [7:0] sensor_address_plus_read = 8'b1001_0111;// 0x97
    reg [7:0] tMSB = 8'b0;                                  // Temp data MSB
    reg [7:0] tLSB = 8'b0;                                  // Temp data LSB
    reg o_bit = 1'b1;                                       // output bit to SDA - starts HIGH
    reg [11:0] count = 12'b0;                               // State Machine Synchronizing Counter
    reg [7:0] temp_data_reg;					            // Temp data buffer register			

    // State Declarations - need 28 states
    localparam [4:0] POWER_UP   = 5'h00,
                     START      = 5'h01,
                     SEND_ADDR6 = 5'h02,
					 SEND_ADDR5 = 5'h03,
					 SEND_ADDR4 = 5'h04,
					 SEND_ADDR3 = 5'h05,
					 SEND_ADDR2 = 5'h06,
					 SEND_ADDR1 = 5'h07,
					 SEND_ADDR0 = 5'h08,
					 SEND_RW    = 5'h09,
                     REC_ACK    = 5'h0A,
                     REC_MSB7   = 5'h0B,
					 REC_MSB6	= 5'h0C,
					 REC_MSB5	= 5'h0D,
					 REC_MSB4	= 5'h0E,
					 REC_MSB3	= 5'h0F,
					 REC_MSB2	= 5'h10,
					 REC_MSB1	= 5'h11,
					 REC_MSB0	= 5'h12,
                     SEND_ACK   = 5'h13,
                     REC_LSB7   = 5'h14,
					 REC_LSB6	= 5'h15,
					 REC_LSB5	= 5'h16,
					 REC_LSB4	= 5'h17,
					 REC_LSB3	= 5'h18,
					 REC_LSB2	= 5'h19,
					 REC_LSB1	= 5'h1A,
					 REC_LSB0	= 5'h1B,
                     NACK       = 5'h1C;
      
    reg [4:0] state_reg = POWER_UP;                         // state register
                       
    always @(posedge clk_200kHz or posedge reset) begin
        if(reset) begin
            state_reg <= START;
			count <= 12'd2000;
        end
        else begin
			count <= count + 1;
            case(state_reg)
                POWER_UP    : begin
                                if(count == 12'd1999)
                                    state_reg <= START;
                end
                START       : begin
                                if(count == 12'd2004)
                                    o_bit <= 1'b0;   // send START condition     
                                if(count == 12'd2013) //1/4 clock after SCL goes high
                                    state_reg <= SEND_ADDR6; 
                end
                SEND_ADDR6  : begin
                                o_bit <= sensor_address_plus_read[7];
                                if(count == 12'd2033)
                                    state_reg <= SEND_ADDR5;
                end
				SEND_ADDR5  : begin
                                o_bit <= sensor_address_plus_read[6];
                                if(count == 12'd2053)
                                    state_reg <= SEND_ADDR4;
                end
				SEND_ADDR4  : begin
                                o_bit <= sensor_address_plus_read[5];
                                if(count == 12'd2073)
                                    state_reg <= SEND_ADDR3;
                end
				SEND_ADDR3  : begin
                                o_bit <= sensor_address_plus_read[4];
                                if(count == 12'd2093)
                                    state_reg <= SEND_ADDR2;
                end
				SEND_ADDR2  : begin
                                o_bit <= sensor_address_plus_read[3];
                                if(count == 12'd2113)
                                    state_reg <= SEND_ADDR1;
                end
				SEND_ADDR1  : begin
                                o_bit <= sensor_address_plus_read[2];
                                if(count == 12'd2133)
                                    state_reg <= SEND_ADDR0;
                end
				SEND_ADDR0  : begin
                                o_bit <= sensor_address_plus_read[1];
                                if(count == 12'd2153)
                                    state_reg <= SEND_RW;
                end
				SEND_RW     : begin
                                o_bit <= sensor_address_plus_read[0];
				if(count == 12'd2169)
                                    state_reg <= REC_ACK;
                end
                REC_ACK     : begin
                                if(count == 12'd2189)
                                    state_reg <= REC_MSB7;
                end
                REC_MSB7     : begin
                                tMSB[7] <= i_bit;
                                if(count == 12'd2209)
                                    state_reg <= REC_MSB6;
                                
                end
				REC_MSB6     : begin
                                tMSB[6] <= i_bit;
                                if(count == 12'd2229)
                                    state_reg <= REC_MSB5;
                                
                end
				REC_MSB5     : begin
                                tMSB[5] <= i_bit;
                                if(count == 12'd2249)
                                    state_reg <= REC_MSB4;
                                
                end
				REC_MSB4     : begin
                                tMSB[4] <= i_bit;
                                if(count == 12'd2269)
                                    state_reg <= REC_MSB3;
                                
                end
				REC_MSB3     : begin
                                tMSB[3] <= i_bit;
                                if(count == 12'd2289)
                                    state_reg <= REC_MSB2;
                                
                end
				REC_MSB2     : begin
                                tMSB[2] <= i_bit;
                                if(count == 12'd2309)
                                    state_reg <= REC_MSB1;
                                
                end
				REC_MSB1     : begin
                                tMSB[1] <= i_bit;
                                if(count == 12'd2329)
                                    state_reg <= REC_MSB0;
                                
                end
				REC_MSB0     : begin
								o_bit <= 1'b0;
                                tMSB[0] <= i_bit;
                                if(count == 12'd2349)
                                    state_reg <= SEND_ACK;
                                
                end
                SEND_ACK   : begin
                                if(count == 12'd2369)
                                    state_reg <= REC_LSB7;
                end
                REC_LSB7    : begin
                                tLSB[7] <= i_bit;
                                if(count == 12'd2389)
									state_reg <= REC_LSB6;
                end
                REC_LSB6    : begin
                                tLSB[6] <= i_bit;
                                if(count == 12'd2409)
									state_reg <= REC_LSB5;
                end
				REC_LSB5    : begin
                                tLSB[5] <= i_bit;
                                if(count == 12'd2429)
									state_reg <= REC_LSB4;
                end
				REC_LSB4    : begin
                                tLSB[4] <= i_bit;
                                if(count == 12'd2449)
									state_reg <= REC_LSB3;
                end
				REC_LSB3    : begin
                                tLSB[3] <= i_bit;
                                if(count == 12'd2469)
									state_reg <= REC_LSB2;
                end
				REC_LSB2    : begin
                                tLSB[2] <= i_bit;
                                if(count == 12'd2489)
									state_reg <= REC_LSB1;
                end
				REC_LSB1    : begin
                                tLSB[1] <= i_bit;
                                if(count == 12'd2509)
									state_reg <= REC_LSB0;
                end
				REC_LSB0    : begin
								o_bit <= 1'b1;
                                tLSB[0] <= i_bit;
                                if(count == 12'd2529)
									state_reg <= NACK;
                end
                NACK        : begin
                                if(count == 12'd2559) begin
									count <= 12'd2000;
                                    state_reg <= START;
								end
                end
            endcase     
        end
    end       
    
    // Buffer for temperature data
    always @(posedge clk_200kHz)
        if(state_reg == NACK)
            temp_data_reg <= { tMSB[6:0], tLSB[7] };
    
    
    // Control direction of SDA bidirectional inout signal
    assign SDA_dir = (state_reg == POWER_UP || state_reg == START || state_reg == SEND_ADDR6 || state_reg == SEND_ADDR5 ||
					  state_reg == SEND_ADDR4 || state_reg == SEND_ADDR3 || state_reg == SEND_ADDR2 || state_reg == SEND_ADDR1 ||
                      state_reg == SEND_ADDR0 || state_reg == SEND_RW || state_reg == SEND_ACK || state_reg == NACK) ? 1 : 0;
    // Set the value of SDA for output - from master to sensor
    assign SDA = SDA_dir ? o_bit : 1'bz;
    // Set value of input wire when SDA is used as an input - from sensor to master
    assign i_bit = SDA;
    // Outputted temperature data
    assign temp_data = temp_data_reg;
 
endmodule


module seg7(
    input clk_100MHz,               // Nexys A7 clock
    input [7:0] temp_data,          // Temp data from i2c master
    output reg [6:0] SEG,           // 7 Segments of Displays
    output reg [3:0] NAN = 4'hF,    // 4 Anodes of 8 turned OFF
    output reg [3:0] AN             // 4 Anodes of 8 to display Temp
    );
    
    // Binary to BCD conversion of temperature data
    wire [3:0] tens, ones;
    assign tens = temp_data / 10;           // Tens value of temp data
    assign ones = temp_data % 10;           // Ones value of temp data
    
    // Parameters for segment patterns
    parameter ZERO  = 7'b000_0001;  // 0
    parameter ONE   = 7'b100_1111;  // 1
    parameter TWO   = 7'b001_0010;  // 2 
    parameter THREE = 7'b000_0110;  // 3
    parameter FOUR  = 7'b100_1100;  // 4
    parameter FIVE  = 7'b010_0100;  // 5
    parameter SIX   = 7'b010_0000;  // 6
    parameter SEVEN = 7'b000_1111;  // 7
    parameter EIGHT = 7'b000_0000;  // 8
    parameter NINE  = 7'b000_0100;  // 9
    parameter DEG   = 7'b001_1100;  // degrees symbol
    parameter C     = 7'b011_0001;  // C
    
    // To select each digit in turn
    reg [1:0] anode_select;         // 2 bit counter for selecting each of 4 digits
    reg [16:0] anode_timer;         // counter for digit refresh
    
    // Logic for controlling digit select and digit timer
    always @(posedge clk_100MHz) begin
        // 1ms x 4 displays = 4ms refresh period
        if(anode_timer == 99_999) begin         // The period of 100MHz clock is 10ns (1/100,000,000 seconds)
            anode_timer <= 0;                   // 10ns x 100,000 = 1ms
            anode_select <=  anode_select + 1;
        end
        else
            anode_timer <=  anode_timer + 1;
    end
    
    // Logic for driving the 4 bit anode output based on digit select
    always @(anode_select) begin
        case(anode_select) 
            2'b00 : AN = 4'b1110;   // Turn on ones digit
            2'b01 : AN = 4'b1101;   // Turn on tens digit
            2'b10 : AN = 4'b1011;   // Turn on hundreds digit
            2'b11 : AN = 4'b0111;   // Turn on thousands digit
        endcase
    end
    
    always @*
        case(anode_select)
            2'b00 : SEG = C;    // Set to C for Celsuis
                        
            2'b01 : SEG = DEG;  // Set to degrees symbol
                    
            2'b10 : begin       // TEMPERATURE ONES DIGIT
                        case(ones)
                            4'b0000 : SEG = ZERO;
                            4'b0001 : SEG = ONE;
                            4'b0010 : SEG = TWO;
                            4'b0011 : SEG = THREE;
                            4'b0100 : SEG = FOUR;
                            4'b0101 : SEG = FIVE;
                            4'b0110 : SEG = SIX;
                            4'b0111 : SEG = SEVEN;
                            4'b1000 : SEG = EIGHT;
                            4'b1001 : SEG = NINE;
                        endcase
                    end
                    
            2'b11 : begin       // TEMPERATURE TENS DIGIT
                        case(tens)
                            4'b0000 : SEG = ZERO;
                            4'b0001 : SEG = ONE;
                            4'b0010 : SEG = TWO;
                            4'b0011 : SEG = THREE;
                            4'b0100 : SEG = FOUR;
                            4'b0101 : SEG = FIVE;
                            4'b0110 : SEG = SIX;
                            4'b0111 : SEG = SEVEN;
                            4'b1000 : SEG = EIGHT;
                            4'b1001 : SEG = NINE;
                        endcase
                    end
        endcase
    
endmodule

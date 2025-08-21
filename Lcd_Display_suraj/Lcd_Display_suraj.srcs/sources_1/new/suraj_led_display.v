`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2025 12:14:05
// Design Name: 
// Module Name: suraj_led_display
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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2025 11:40:53
// Design Name: 
// Module Name: display_lcd
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

/* LCD control instruction and data signal generate FSM */
module lcd_driver(clk, rst, en_clk, data_char, index_char,
                  lcd_rs, lcd_rw,lcd_e, lcd_data); 
input clk;
input rst;
input en_clk;
input [7:0] data_char; 
output [4:0] index_char; 
output lcd_rs, lcd_rw, lcd_e; 
output [7:0] lcd_data;

// Define the state of FSM
parameter IDLE=4'h0; 
parameter FUNC_SET=4'h1; 
parameter DISP_OFF=4'h2; 
parameter DISP_CLEAR=4'h3; 
parameter DISP_ON=4'h4; 
parameter MODE_SET=4'h5; 
parameter PRINT_STRING=4'h6; 
parameter LINE2=4'h7;
parameter RETURN_HOME=4'h8;

parameter T_PW = 2499999; 

wire [7:0] data_char;
reg [4:0] index_char;
reg lcd_rs,lcd_rw,lcd_e;
wire [7:0] lcd_data;
reg [3:0] state;
reg [3:0] next_state;
reg [7:0] data_bus;
reg [21:0] cnt_init;  
reg dly_en_clk;
reg [9:0] cnt_en_clk; 

assign lcd_data = (lcd_rw?8'b00000000:data_bus);  

// Counter to wait 50 ms after powering on the LCD module
always@(posedge clk or negedge rst) begin
 if(!rst)
  cnt_init <=0;
 else begin
  if(cnt_init >= T_PW)
   cnt_init<= T_PW; 
 else
 cnt_init <= cnt_init+1'b1;
end
end

// FSM for LCD: sequential State Logic
always@ (posedge clk or negedge rst) begin
 if(!rst)
 state<=IDLE; 
 else if(en_clk)
 state<=next_state; 
 else
 state<=state;
end

// FSM for LCD: combinational State Logic 
always@(*) begin
 case(state) 
 IDLE: if(cnt_init>=T_PW) 
      next_state<=FUNC_SET;
      else
      next_state<=IDLE;
 FUNC_SET:       next_state<=DISP_OFF;
 DISP_OFF:       next_state<=DISP_CLEAR;
 DISP_CLEAR:     next_state<=DISP_ON;
 DISP_ON:        next_state<=MODE_SET;
 MODE_SET:       next_state<=PRINT_STRING;
 PRINT_STRING:  if(index_char == 15) 
                   next_state <= LINE2;
                else if (index_char == 31)
                   next_state <= RETURN_HOME;
                else
                   next_state <= PRINT_STRING;
 LINE2:          next_state<=PRINT_STRING;
 RETURN_HOME:    next_state<=PRINT_STRING;
 default:        next_state<=IDLE;
endcase
end

/*Counter for pulse width control of lcd_e signal */
always@(posedge clk or negedge rst) begin
 if(!rst)
  cnt_en_clk<=0;          
 else if(en_clk)
 cnt_en_clk<=0;         
else if(&cnt_en_clk) 
  cnt_en_clk<=cnt_en_clk; 
else
   cnt_en_clk<=cnt_en_clk+1'b1; 
end

// Counters for specifying 32 character positions to output to the LCD
always@(posedge clk or negedge rst) begin
 if(!rst)
  index_char <= 1'b0;   
 else begin
  if(state==PRINT_STRING && en_clk == 1) begin 
    if(index_char<31)
      index_char<=index_char+1'b1; 
       else
           index_char<=0; 
       end
     else
           index_char<=index_char;
end
end


always@(posedge clk or negedge rst) begin
 if(!rst)
  dly_en_clk<=0;
 else
  dly_en_clk<=en_clk; 
end

/* Generate enable pulse signal for command/character data output */
always @(posedge clk or negedge rst) begin
 if(!rst)
  lcd_e<=0;
 else if(state==IDLE)
  lcd_e<=0;
 else
  if(dly_en_clk)          
   lcd_e<=1;              
   else if(&cnt_en_clk)   
   lcd_e<=0;            
 else
   lcd_e<=lcd_e;
end

// FSM state specific output for Instruction/Data for LCD operation.
always@(posedge clk or negedge rst) begin
 if(!rst) begin
  lcd_rs <= 1'b0;
  lcd_rw <= 1'b0;
  data_bus <= 8'h00;
 end
 else begin
  case(state)
    IDLE:begin
     lcd_rs <= 1'b0;
     lcd_rw <= 1'b0;
     data_bus <= 8'h01;  
  end
    FUNC_SET:begin
     lcd_rs <= 1'b0;
     lcd_rw <= 1'b0;
     data_bus <= 8'h38;  
  end
    DISP_OFF:begin
     lcd_rs <= 1'b0;
     lcd_rw <= 1'b0;
     data_bus <= 8'h08;   
  end
    DISP_CLEAR:begin
     lcd_rs <= 1'b0;
     lcd_rw <= 1'b0;
     data_bus <= 8'h01;   
  end
    DISP_ON:begin
     lcd_rs <= 1'b0;
     lcd_rw <= 1'b0;
     data_bus <= 8'h0C;   
  end
    MODE_SET:begin
     lcd_rs <= 1'b0;
     lcd_rw <= 1'b0;
     data_bus <= 8'h06;  
  end
     PRINT_STRING:begin
     lcd_rs <= 1'b1;    
     lcd_rw <= 1'b0;
     data_bus <= data_char;   
  end
    LINE2:begin
     lcd_rs <= 1'b0;
     lcd_rw <= 1'b0;
     data_bus <= 8'hC0;   
  end
    RETURN_HOME:begin
     lcd_rs <= 1'b0;
     lcd_rw <= 1'b0;
     data_bus <= 8'h80;   
  end
    default: begin
     lcd_rs <= 1'b0;
     lcd_rw <= 1'b0;
     data_bus <= 8'h00;   
  end
  endcase
end
end


// sysnopsys translate_off(Not synthesized as a simulation status check)
reg [18*8-1:0] STATE;  
always@(*)begin
 case(state)
   IDLE: STATE<="IDLE";
   FUNC_SET: STATE<="FUNC_SET";
   DISP_OFF: STATE<="DISP_OFF";
   DISP_CLEAR: STATE<="DISP_CLEAR";
   DISP_ON: STATE<="DISP_ON";
   MODE_SET: STATE<="MODE_SET";
   PRINT_STRING: STATE<="PRINT_STRING";
   LINE2: STATE<="LINE2"; 
   RETURN_HOME: STATE<="RETURN_HOME";
   default: STATE<="ERROR"; 
 endcase
end
// synopsys translate_on
endmodule

/////////////////////////////////////
module en_clk_lcd (clk, rst, en_clk); 
input clk,rst;
output en_clk;

reg [24:0] cnt_en; 
reg en_clk;

always@(posedge clk or negedge rst) begin
 if(!rst) begin 
  cnt_en<=0;
  en_clk<=0;
end
else begin
 if(cnt_en == 199999) begin 
   cnt_en<=0; 
   en_clk<=1'b1; 
 end
 else begin
  cnt_en<=cnt_en+1'b1; 
  en_clk<=0; 
end
end
end
endmodule
//////////////////////////////////////
module lcd_display_string(clk,rst, index, out);
input clk,rst;
input [4:0] index;
output [7:0] out;

wire [4:0] index; // 5bit:0-31??
reg [7:0] out;

always @(posedge clk or negedge rst) begin
if(!rst)
out<=8'h00; // NULL
else
 case(index)
 00: out <= 8'h4E; // N
 01: out <= 8'h49; // I
 02: out <= 8'h54; // T
 03: out <= 8'h20; 
 04: out <= 8'h44; // D
 05: out <= 8'h45; // E
 06: out <= 8'h4C; // L
 07: out <= 8'h48; // H
 08: out <= 8'h49; // I
 09: out <= 8'h20; 
 10: out <= 8'h20; 
 11: out <= 8'h20;  
 12: out <= 8'h20;  
 13: out <= 8'h20; 
 14: out <= 8'h20; 
 15: out <= 8'h20; 
 16: out <= 8'h53; // S
 17: out <= 8'h55; // U
 18: out <= 8'h52; // R
 19: out <= 8'h41; // A
 20: out <= 8'h4A; // J
 21: out <= 8'h20; // 
 22: out <= 8'h20;
 23: out <= 8'h20; // 
 24: out <= 8'h20; // 
 25: out <= 8'h20; // 
 26: out <= 8'h20; // 
 27: out <= 8'h20; // 
 28: out <= 8'h20; 
 29: out <= 8'h20; 
 30: out <= 8'h20; 
 31: out <= 8'h20; 
default: out<=8'h00; //NULL
endcase
end
endmodule
/////////////////////////////////
module lcd_display_test(clk, rst,lcd_rs, lcd_rw, lcd_e, lcd_data); 
input clk;
input rst;
output lcd_rs,lcd_rw,lcd_e;
output [7:0] lcd_data;

wire [4:0] index_char; 
wire [7:0] data_char;
wire en_clk;

en_clk_lcd LCLK(
.clk(clk),
.rst(rst),
.en_clk(en_clk) 
);

lcd_display_string STR(
.clk(clk),
.rst(rst),
.index(index_char),
.out(data_char)
);

lcd_driver DRV(
.clk(clk),
.rst(rst),
.en_clk(en_clk),
.data_char(data_char),
.index_char(index_char),
.lcd_rs(lcd_rs),
.lcd_rw(lcd_rw),
.lcd_e(lcd_e),
.lcd_data(lcd_data)
);
endmodule

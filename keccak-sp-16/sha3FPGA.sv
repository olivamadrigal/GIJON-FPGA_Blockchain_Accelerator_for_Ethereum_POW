module sha3Top( input  [7:0]byte1,byte2,
				input  clk, RST, ctbtn,tbtn2, tbtn3, 
				output [7:0]LEDSEL,LEDOUT,
				output [1:0]s,
				output [5:0]halfLaneAddress);

wire[63:0]state[4:0][4:0];
wire[63:0]thetaOut[4:0][4:0];
wire[63:0]rhoOut[4:0][4:0];
wire[63:0]piOut[4:0][4:0];
wire[63:0]chiOut[4:0][4:0];
wire[31:0]displayOutput;//8 hex digits

wire[7:0] digit0;
wire[7:0] digit1;
wire[7:0] digit2;
wire[7:0] digit3;
wire[7:0] digit4;
wire[7:0] digit5;
wire[7:0] digit6;
wire[7:0] digit7;				
wire	btn;
wire	clk_5KHz, clksec;

/*************************************************************************/
// SHA3-TEST
register INPUTreg(byte1,byte2,state);//initialize state matrix
theta	TRANSFORMATION1(state,thetaOut);
rho  	TRANSFORMATION2(thetaOut,rhoOut);
pi   	TRANSFORMATION3(rhoOut,piOut);
chi  	TRANSFORMATION4(piOut,chiOut);

Mux4to1W mux1(s,halfLaneAddress,thetaOut, rhoOut, piOut, chiOut, displayOutput);
controlUnit controller(RST,btn,btn2,btn3,s,halfLaneAddress);

//to 7-seg LEDs -- MSB hex digits from half the lane of state[2][0]
bcd_to_7seg bcd0 (displayOutput[31:28], digit0);
bcd_to_7seg bcd1 (displayOutput[27:24], digit1);
bcd_to_7seg bcd2 (displayOutput[23:20], digit2);
bcd_to_7seg bcd3 (displayOutput[19:16], digit3);
bcd_to_7seg bcd4 (displayOutput[15:12], digit4);
bcd_to_7seg bcd5 (displayOutput[11:8], digit5);
bcd_to_7seg bcd6 (displayOutput[7:4], digit6);
bcd_to_7seg bcd7 (displayOutput[3:0], digit7);

		
clk_gen top_clk(clk, RST, clksec, clk_5KHz);				
debounce U1 (btn, ctbtn, clk_5KHz);
debounce U4 (btn2, tbtn2, clk_5KHz);//jump down button    
debounce U3 (btn3, tbtn3, clk_5KHz);//jump down button    
   
LED_MUX disp_unit (clk_5KHz, RST, digit0, digit1, digit2, digit3,
                                  digit4, digit5, digit6, digit7, LEDOUT, LEDSEL);

endmodule

/*-------------------------------------------------------------------
	Input bytes for state A input for theta (0-bit input message for
	SHA3-256).
-------------------------------------------------------------------*/
module register(byte1,byte2,A);

input  [7:0] byte1, byte2;
output [63:0] A[4:0][4:0];

assign A[0][0] = {56'h00000000000000,byte1};
assign A[1][0] = 64'h0000000000000000;
assign A[2][0] = 64'h0000000000000000;
assign A[3][0] = 64'h0000000000000000;
assign A[4][0] = 64'h0000000000000000;
assign A[0][1] = 64'h0000000000000000;
assign A[1][1] = 64'h0000000000000000;
assign A[2][1] = 64'h0000000000000000;
assign A[3][1] = 64'h0000000000000000;
assign A[4][1] = 64'h0000000000000000;
assign A[0][2] = 64'h0000000000000000;
assign A[1][2] = 64'h0000000000000000;
assign A[2][2] = 64'h0000000000000000;
assign A[3][2] = 64'h0000000000000000;
assign A[4][2] = 64'h0000000000000000;
assign A[0][3] = 64'h0000000000000000;
assign A[1][3] = {byte2,56'h00000000000000};
assign A[2][3] = 64'h0000000000000000;
assign A[3][3] = 64'h0000000000000000;
assign A[4][3] = 64'h0000000000000000;
assign A[0][4] = 64'h0000000000000000;
assign A[1][4] = 64'h0000000000000000;
assign A[2][4] = 64'h0000000000000000;
assign A[3][4] = 64'h0000000000000000;
assign A[4][4] = 64'h0000000000000000;

endmodule

/*-------------------------------------------------------------------------
	4 to 1 mux
	assigns hald a lane from selected output matrix (4 bytes total)
	with each LED displaying one hex digit...
	displays the MSBs of lane: state[2][0]
    
-------------------------------------------------------------------------*/
module Mux4to1W(s,halfLaneAddress, A, B, C, D, E);

input  [1:0]  s;
input  [5:0] halfLaneAddress;
input  [63:0] A[4:0][4:0];//theta output
input  [63:0] B[4:0][4:0];//rho output
input  [63:0] C[4:0][4:0];//pi output
input  [63:0] D[4:0][4:0];//chi output
output reg [31:0] E;

reg [63:0] T[4:0][4:0];
integer x, y;

//select transformation
always@(*)
begin
    if( s == 2'b00)
            T <= A;
    else if( s == 2'b01)
            T <= B;
    else if( s == 2'b10)
            T <= C;
    else // s == 11
            T <= D;
end
        

always@(*)
begin

    x <= (halfLaneAddress / 2) % 5;
    y <= (halfLaneAddress / 2) / 5;
    
    if(halfLaneAddress[0])// if address = 1 .: ODD
        E <= T[x][y][63:32];//assign upper bits of lane
    else
        E <= T[x][y][31:0];//assign lower bits of lane
end
        
                   
endmodule

//===============controlUnit module===================================================
module controlUnit(RST,btn,btn2,btn3,i,halfLaneAddress);

input   RST,btn,btn2,btn3;
output  reg [1:0] i;
output  reg [5:0]halfLaneAddress;

always@(posedge RST, posedge btn)
begin
    if(RST)
       i <= 2'd0;
    else if(btn)
       i <= i + 2'd1;
    else
       i <= i;
end

always@(posedge RST, posedge btn2, posedge btn3)
begin
    if(RST)
       halfLaneAddress <= 6'd0;
    else if(btn3)
    begin
        if (halfLaneAddress == 0)
        begin   halfLaneAddress <= 6'd49; end
        else
        begin   halfLaneAddress <= halfLaneAddress - 6'd1; end
    end
    else if(btn2)
    begin
        if (halfLaneAddress == 49)
        begin   halfLaneAddress <= 6'd0; end
        else
        begin   halfLaneAddress <= halfLaneAddress + 6'd1; end   
    end
    else
    begin
       halfLaneAddress <= halfLaneAddress;
    end
end

endmodule


//bcd_to_7seg-------------------------------------
/* 7-segment values */
`define D0 8'b10001000 /* 0 */
`define D1 8'b11101101 /* 1 */
`define D2 8'b10100010 /* 2 */
`define D3 8'b10100100 /* 3 */
`define D4 8'b11000101 /* 4 */
`define D5 8'b10010100 /* 5 */
`define D6 8'b10010000 /* 6 */
`define D7 8'b10101101 /* 7 */
`define D8 8'b10000000 /* 8 */
`define D9 8'b10000100 /* 9 */
`define DA 8'b10100000 /* A */
`define DB 8'b11010000 /* B */
`define DC 8'b11110010 /* C */
`define DD 8'b11100000 /* D */
`define DE 8'b10010010 /* E */
`define DF 8'b10010011 /* F */
`define DX 8'b01111111 /* All segments off except decimal point */

/* Generate one decimal digits from a 4-bit number */
module bcd_to_7seg(input [3:0] num, output reg [7:0] out);
always @ (num)
begin
    case (num)
   	 4'h0: begin out=`D0; end
   	 4'h1: begin out=`D1; end
   	 4'h2: begin out=`D2; end
   	 4'h3: begin out=`D3; end
   	 4'h4: begin out=`D4; end
   	 4'h5: begin out=`D5; end
   	 4'h6: begin out=`D6; end
   	 4'h7: begin out=`D7; end
   	 4'h8: begin out=`D8; end
   	 4'h9: begin out=`D9; end
   	 4'hA: begin out=`DA; end
   	 4'hB: begin out=`DB; end
   	 4'hC: begin out=`DC; end
   	 4'hD: begin out=`DD; end
   	 4'hE: begin out=`DE; end
   	 4'hF: begin out=`DF; end   	 
   default: begin out=`DX; end
   endcase
end
endmodule


//clk_gen-------------------------------------
module clk_gen(input clk100MHz, input rst, output reg clk_sec, output reg clk_5KHz);

integer count, count1;

always@(posedge clk100MHz)
	begin
    	if(rst)
    	begin
        	count = 0;
        	count1 = 0;
        	clk_sec = 0;
        	clk_5KHz =0;
    	end
    	else
    	begin
        	if(count == 50000000) /* 50e6 x 10ns = 1/2sec, toggle twice for 1sec */
        	begin
        	clk_sec = ~clk_sec;
        	count = 0;
        	end
        	if(count1 == 10000)
        	begin
        	clk_5KHz = ~clk_5KHz;
        	count1 = 0;
        	end
        	count = count + 1;
        	count1 = count1 + 1;
    	end
	end
endmodule // end clk_gen

//----------------------------------------------------------------------
//   Copyright 1999-2010 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
module debounce(pb_debounced, pb, clk);
input  pb, clk;
output pb_debounced;
reg [7:0] shift;
reg pb_debounced;
always @ (posedge clk) begin
   	shift[6:0] <= shift[7:1];
   	shift[7] <= pb;
   	if (shift==8'b11111111)
        	pb_debounced <= 1'b1;
   	else
        	pb_debounced <= 1'b0;
end
endmodule

module LED_MUX (
    input wire clk,
    input wire rst,
    input wire [7:0] LED0, // leftmost digit
    input wire [7:0] LED1,
    input wire [7:0] LED2,
    input wire [7:0] LED3,
    input wire [7:0] LED4,
    input wire [7:0] LED5,
    input wire [7:0] LED6,
    input wire [7:0] LED7, // rightmost digit
    output wire [7:0] LEDSEL,
    output wire [7:0] LEDOUT
    );
    
reg [2:0] index;
reg [15:0] led_ctrl;

assign {LEDOUT, LEDSEL} = led_ctrl;

always@(posedge clk)
begin
	index <= (rst) ? 3'd0 : (index + 3'd1);
end    

always @(index, LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7)
begin
    case(index)
    	3'd0: led_ctrl <= {8'b11111110, LED7};
    	3'd1: led_ctrl <= {8'b11111101, LED6};
    	3'd2: led_ctrl <= {8'b11111011, LED5};
    	3'd3: led_ctrl <= {8'b11110111, LED4};
    	3'd4: led_ctrl <= {8'b11101111, LED3};
    	3'd5: led_ctrl <= {8'b11011111, LED2};
    	3'd6: led_ctrl <= {8'b10111111, LED1};
    	3'd7: led_ctrl <= {8'b01111111, LED0};
 	 default: led_ctrl <= {8'b11111111, 8'hFF};
	endcase
end
endmodule
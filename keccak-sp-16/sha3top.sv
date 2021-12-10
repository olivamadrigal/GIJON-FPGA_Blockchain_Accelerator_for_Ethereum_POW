`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineers: Sang Nguyen, Samira C. Oliva Madrigal
// 
// Create Date: 05/01/2016 05:33:42 AM
// Design Name: 
// Module Name: sha3
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


/*------------------------------------------------------------------
 XORs each bit of state array with the parities of two columns in
 the array.
-------------------------------------------------------------------*/
module theta(A, Aprime);
//      z       x    y
input [63:0] A[4:0][4:0];//state array 5 x 5 x 64 A[x,y,z]
output [63:0] Aprime[4:0][4:0];

wire [63:0]C[4:0];
wire [63:0]D[4:0];

genvar x, y, z;

//for all pairs (x,z)
for(x = 0; x < 5; x = x + 1)
begin
    for(z = 0; z < 64; z = z +1)
    begin
    
        assign C[x][z] = A[x][0][z] ^ A[x][1][z] ^ A[x][2][z] ^ A[x][3][z] ^ A[x][4][z];        
    end
    
end

//for all pairs (x,z)

//Problem with (x-1)%5 and (z-1)%64 when x = 0 and z = 0
//for(x = 0; x < 5; x = x + 1)
//begin
//    for( z = 0; z < 64; z = z +1)
//    begin
//            assign D[x][z] = C[(x-1)%5][z] ^ C[(x+1)%5][(z-1)%64];
//    end
//end

//regular case x and z without x=0 and z=0
for(x = 1; x < 5; x = x + 1)
begin
    for( z = 1; z < 64; z = z +1)
    begin
            assign D[x][z] = C[(x-1)%5][z] ^ C[(x+1)%5][(z-1)%64];
    end
end

//case: x= 0 and z != 0
for( z = 1; z < 64; z = z +1)
begin
    assign D[0][z] = C[4][z] ^ C[1][(z-1)%64];
end

//case z = 0
for(x = 1; x < 5; x = x + 1)
begin
    assign D[x][0] = C[(x-1)%5][0] ^ C[(x+1)%5][63];   
end

//case z=0 and x=0
assign D[0][0] = C[4][0] ^ C[1][63];

//for all triples (x,y,z)
for(x = 0; x < 5; x = x + 1)
begin
    for( y = 0; y < 5; y = y + 1)
    begin
        for( z = 0; z < 64; z = z + 1)
        begin
            assign Aprime[x][y][z] = A[x][y][z] ^ D[x][z];
        end
    end
end

endmodule


/*------------------------------------------------------------------
The effect of Ï? is to rotate the bits of each lane by a length, called 
the offset, which depends on the fixed x and y coordinates of the lane. 
Equivalently, for each bit in the lane, the z coordinate is modified by 
adding the offset, modulo the lane size.
-------------------------------------------------------------------*/
module rho(A,Aprime);
//      z       x    y
input  [63:0] A[4:0][4:0];//state array 5 x 5 x 64 A[x,y,z]
output [63:0] Aprime[4:0][4:0];

//wire [63:0]C[4:0];
//wire [63:0]D[4:0];

//genvar i;
//reg x, y, t, z;


//for(i = 0; i < 64; i = i + 1)
//begin    
//        assign Aprime[0][0][i] = A[0][0][i];
//end

//    always@(*)
//    begin
//        x = 1;
//        y = 0;
//        for(t = 0; t < 23; t = t + 1)
//        begin 
//               for(z = 0; z < 64; z = z + 1)
//               begin
//                    Aprime[x][y][z] = A[z][y][((z-((t+1)*(t+2)))/2)%64];
//                    x = y;
//                    y = (2*x + 3*y)%5;
//               end
        
//        end
//    end

assign Aprime[0][0] = A[0][0];
assign Aprime[0][1] = {A[0][1][27:0],A[0][1][63:28]};
assign Aprime[0][2] = {A[0][2][60:0],A[0][2][63:61]};
assign Aprime[0][3] = {A[0][3][22:0],A[0][3][63:23]};
assign Aprime[0][4] = {A[0][4][45:0],A[0][4][63:46]};
assign Aprime[1][0] = {A[1][0][62:0],A[1][0][63]};
assign Aprime[1][1] = {A[1][1][19:0],A[1][1][63:20]};
assign Aprime[1][2] = {A[1][2][53:0],A[1][2][63:54]};
assign Aprime[1][3] = {A[1][3][18:0],A[1][3][63:19]};
assign Aprime[1][4] = {A[1][4][61:0],A[1][4][63:62]};
assign Aprime[2][0] = {A[2][0][1:0], A[2][0][63:2]};
assign Aprime[2][1] = {A[2][1][57:0],A[2][1][63:58]};
assign Aprime[2][2] = {A[2][2][20:0],A[2][2][63:21]};
assign Aprime[2][3] = {A[2][3][48:0],A[2][3][63:49]};
assign Aprime[2][4] = {A[2][4][2:0], A[2][4][63:3]};
assign Aprime[3][0] = {A[3][0][35:0],A[3][0][63:36]};
assign Aprime[3][1] = {A[3][1][8:0], A[3][1][63:9]};
assign Aprime[3][2] = {A[3][2][38:0],A[3][2][63:39]};
assign Aprime[3][3] = {A[3][3][42:0],A[3][3][63:43]};
assign Aprime[3][4] = {A[3][4][7:0], A[3][4][63:8]};
assign Aprime[4][0] = {A[4][0][36:0],A[4][0][63:37]};
assign Aprime[4][1] = {A[4][1][43:0],A[4][1][63:44]};
assign Aprime[4][2] = {A[4][2][24:0],A[4][2][63:25]};
assign Aprime[4][3] = {A[4][3][55:0],A[4][3][63:56]};
assign Aprime[4][4] = {A[4][4][49:0],A[4][4][63:50]};

endmodule

/*------------------------------------------------------------------
Pi Steps:
1. For all triples (x, y, z) such that 0 ? x < 5, 0 ? y < 5, and 0 ? z < w, let
A?[x, y, z]= A[(x + 3y) mod 5, x, z].
2. Return A?.
The effect of ? is to rearrange the positions of the lanes,.
-------------------------------------------------------------------*/
module pi(A,Aprime);
//      z       x    y
input  [63:0] A[4:0][4:0];//state array 5 x 5 x 64 A[x,y,z]
output [63:0] Aprime[4:0][4:0];

genvar x,y,z;

for(z = 0; z < 64; z = z+1)
begin
    for(x = 0; x< 5; x = x+1)
    begin
        for(y = 0; y<5; y = y+1)
            assign Aprime[x][y][z] = A[(x+(3*y))%5][x][z];    
    end    
end

endmodule

/*------------------------------------------------------------------
Chi Steps:
1. For all triples (x, y, z) such that 0 ? x < 5, 0 ? y < 5, and 0 ? z < w, let
A? [x, y, z] = A[x, y, z] ? ((A[(x+1) mod 5, y, z] ? 1) ? A[(x+2) mod 5, y, z]).
2. Return A?.
The effect of ? is to XOR each bit with a non-linear function of two other bits in its row, as illustrated in Figure 6 below.
-------------------------------------------------------------------*/
module chi(A,Aprime);
//      z       x    y
input  [63:0] A[4:0][4:0];//state array 5 x 5 x 64 A[x,y,z]
output [63:0] Aprime[4:0][4:0];

genvar x,y,z;

for(z=0; z <64; z=z+1)
begin
    for(x=0; x<5; x=x+1)
    begin
        for(y=0; y<5; y=y+1)
        begin
            assign   Aprime[x][y][z] = A[x][y][z]^((~(A[(x+1)%5][y][z]))& A[(x+2)%5][y][z]);
        end
    end
end

endmodule





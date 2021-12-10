`timescale 1ns / 1ps

module sha3_tb;

//----------------- for SHA3-512
//testbench for sha3-1600bit input
//      z       x    y
reg  [63:0]  A1[4:0][4:0];             //state array 5 x 5 x 64 A[x,y,z]
wire [63:0]  A1prime[4:0][4:0];
wire [63:0]  A1prime1[4:0][4:0];
wire [63:0]  A1prime2[4:0][4:0];
wire [63:0]  A1prime3[4:0][4:0];
reg  [63:0]  expectedt1[4:0][4:0];
reg  [63:0]  expected01[4:0][4:0];
reg  [63:0]  expected02[4:0][4:0];
reg  [63:0]  expected03[4:0][4:0];//expected: theta, expected1:rho, expected2: pi, expected2: chi

//---------------- for SHA3-256
//      z       x    y
reg  [63:0] A[4:0][4:0];              //state array 5 x 5 x 64 A[x,y,z]
wire [63:0] Aprime[4:0][4:0];         //theta output
wire [63:0] Aprime2[4:0][4:0];        //rho output
wire [63:0] Aprime3[4:0][4:0];        //pi
wire [63:0] Aprime4[4:0][4:0];        //chi output
reg  [63:0] expected[4:0][4:0];  //expected output from theta, input for rho
reg  [63:0] expected1[4:0][4:0]; //expected output from rho, input for pi
reg  [63:0] expected2[4:0][4:0]; //expected output from pi, input for chi
reg  [63:0] expected3[4:0][4:0]; //expected output from chi


reg  [1599:0] str1, str2, str3; //to format NIST test vector string into state array format
reg  clk;

genvar x,y,z;

//SHA3-512 submodules
theta DUTt1(A1,A1prime);
rho   DUTt2(expectedt1,A1prime1);
pi    DUTt3(expected01,A1prime2);
chi   DUTt4(expected02,A1prime3);
//SHA3-256 submodules
theta DUT1(A,Aprime);
rho   DUT2(expected,Aprime2);
pi    DUT3(expected1,Aprime3);
chi   DUT4(expected2,Aprime4);


//current state of A prior to theta transformation
initial 
begin


//*******************************
//** INI DATA FOR SHA3-512 ******
//*******************************
//Example from SHA3-512_1600
A1[0][0] = 64'ha3a3a3a3a3a3a3a3;
A1[1][0] = 64'ha3a3a3a3a3a3a3a3; 
A1[2][0] = 64'ha3a3a3a3a3a3a3a3;
A1[3][0] = 64'ha3a3a3a3a3a3a3a3;
A1[4][0] = 64'ha3a3a3a3a3a3a3a3;
A1[0][1] = 64'ha3a3a3a3a3a3a3a3;
A1[1][1] = 64'ha3a3a3a3a3a3a3a3;
A1[2][1] = 64'ha3a3a3a3a3a3a3a3;
A1[3][1] = 64'ha3a3a3a3a3a3a3a3;
A1[4][1] = 64'h0000000000000000;
A1[0][2] = 64'h0000000000000000;
A1[1][2] = 64'h0000000000000000;
A1[2][2] = 64'h0000000000000000;
A1[3][2] = 64'h0000000000000000;
A1[4][2] = 64'h0000000000000000;
A1[0][3] = 64'h0000000000000000;
A1[1][3] = 64'h0000000000000000;
A1[2][3] = 64'h0000000000000000;
A1[3][3] = 64'h0000000000000000;
A1[4][3] = 64'h0000000000000000;
A1[0][4] = 64'h0000000000000000;
A1[1][4] = 64'h0000000000000000;
A1[2][4] = 64'h0000000000000000;
A1[3][4] = 64'h0000000000000000;
A1[4][4] = 64'h0000000000000000;

//Round #0 expected state of A after theta:
expectedt1[0][0] = 64'h0000000000000000;
expectedt1[1][0] = 64'hA3A3A3A3A3A3A3A3;
expectedt1[2][0] = 64'hA3A3A3A3A3A3A3A3;
expectedt1[3][0] = 64'hE4E4E4E4E4E4E4E4;
expectedt1[4][0] = 64'hA3A3A3A3A3A3A3A3;
expectedt1[0][1] = 64'h0000000000000000;
expectedt1[1][1] = 64'hA3A3A3A3A3A3A3A3;
expectedt1[2][1] = 64'hA3A3A3A3A3A3A3A3;
expectedt1[3][1] = 64'hE4E4E4E4E4E4E4E4;
expectedt1[4][1] = 64'h0000000000000000;
expectedt1[0][2] = 64'hA3A3A3A3A3A3A3A3;
expectedt1[1][2] = 64'h0000000000000000;
expectedt1[2][2] = 64'h0000000000000000;
expectedt1[3][2] = 64'h4747474747474747;
expectedt1[4][2] = 64'h0000000000000000;
expectedt1[0][3] = 64'hA3A3A3A3A3A3A3A3;
expectedt1[1][3] = 64'h0000000000000000;
expectedt1[2][3] = 64'h0000000000000000;
expectedt1[3][3] = 64'h4747474747474747;
expectedt1[4][3] = 64'h0000000000000000;
expectedt1[0][4] = 64'hA3A3A3A3A3A3A3A3;
expectedt1[1][4] = 64'h0000000000000000;
expectedt1[2][4] = 64'h0000000000000000;
expectedt1[3][4] = 64'h4747474747474747;
expectedt1[4][4] = 64'h0000000000000000;

//Round #0 expected state of A after rho:
expected01[0][0] = 64'h0000000000000000;
expected01[1][0] = 64'h4747474747474747;
expected01[2][0] = 64'hE8E8E8E8E8E8E8E8;
expected01[3][0] = 64'h4E4E4E4E4E4E4E4E;
expected01[4][0] = 64'h1D1D1D1D1D1D1D1D;
expected01[0][1] = 64'h0000000000000000;
expected01[1][1] = 64'h3A3A3A3A3A3A3A3A;
expected01[2][1] = 64'hE8E8E8E8E8E8E8E8;
expected01[3][1] = 64'h7272727272727272;
expected01[4][1] = 64'h0000000000000000;
expected01[0][2] = 64'h1D1D1D1D1D1D1D1D;
expected01[1][2] = 64'h0000000000000000;
expected01[2][2] = 64'h0000000000000000;
expected01[3][2] = 64'h8E8E8E8E8E8E8E8E;
expected01[4][2] = 64'h0000000000000000;
expected01[0][3] = 64'h4747474747474747;
expected01[1][3] = 64'h0000000000000000;
expected01[2][3] = 64'h0000000000000000;
expected01[3][3] = 64'hE8E8E8E8E8E8E8E8;
expected01[4][3] = 64'h0000000000000000;
expected01[0][4] = 64'h8E8E8E8E8E8E8E8E;
expected01[1][4] = 64'h0000000000000000;
expected01[2][4] = 64'h0000000000000000;
expected01[3][4] = 64'h4747474747474747;
expected01[4][4] = 64'h0000000000000000;

//Round #0 expected state of A after pi:
expected02[0][0] = 64'h0000000000000000;
expected02[1][0] = 64'h3A3A3A3A3A3A3A3A;
expected02[2][0] = 64'h0000000000000000;
expected02[3][0] = 64'hE8E8E8E8E8E8E8E8;
expected02[4][0] = 64'h0000000000000000;
expected02[0][1] = 64'h4E4E4E4E4E4E4E4E;
expected02[1][1] = 64'h0000000000000000;
expected02[2][1] = 64'h1D1D1D1D1D1D1D1D;
expected02[3][1] = 64'h0000000000000000;
expected02[4][1] = 64'h0000000000000000;
expected02[0][2] = 64'h4747474747474747;
expected02[1][2] = 64'hE8E8E8E8E8E8E8E8;
expected02[2][2] = 64'h8E8E8E8E8E8E8E8E;
expected02[3][2] = 64'h0000000000000000;
expected02[4][2] = 64'h8E8E8E8E8E8E8E8E;
expected02[0][3] = 64'h1D1D1D1D1D1D1D1D;
expected02[1][3] = 64'h0000000000000000;
expected02[2][3] = 64'h0000000000000000;
expected02[3][3] = 64'h0000000000000000;
expected02[4][3] = 64'h4747474747474747;
expected02[0][4] = 64'hE8E8E8E8E8E8E8E8;
expected02[1][4] = 64'h7272727272727272;
expected02[2][4] = 64'h0000000000000000;
expected02[3][4] = 64'h4747474747474747;
expected02[4][4] = 64'h0000000000000000;

//Round #0 expected state of A after chi:
expected03[0][0] = 64'h0000000000000000;
expected03[1][0] = 64'hD2D2D2D2D2D2D2D2;
expected03[2][0] = 64'h0000000000000000;
expected03[3][0] = 64'hE8E8E8E8E8E8E8E8;
expected03[4][0] = 64'h3A3A3A3A3A3A3A3A;
expected03[0][1] = 64'h5353535353535353;
expected03[1][1] = 64'h0000000000000000;
expected03[2][1] = 64'h1D1D1D1D1D1D1D1D;
expected03[3][1] = 64'h4E4E4E4E4E4E4E4E;
expected03[4][1] = 64'h0000000000000000;
expected03[0][2] = 64'h4141414141414141;
expected03[1][2] = 64'hE8E8E8E8E8E8E8E8;
expected03[2][2] = 64'h0000000000000000;
expected03[3][2] = 64'h4141414141414141;
expected03[4][2] = 64'h2626262626262626;
expected03[0][3] = 64'h1D1D1D1D1D1D1D1D;
expected03[1][3] = 64'h0000000000000000;
expected03[2][3] = 64'h4747474747474747;
expected03[3][3] = 64'h1818181818181818;
expected03[4][3] = 64'h4747474747474747;
expected03[0][4] = 64'hE8E8E8E8E8E8E8E8;
expected03[1][4] = 64'h3535353535353535;
expected03[2][4] = 64'h0000000000000000;
expected03[3][4] = 64'hAFAFAFAFAFAFAFAF;
expected03[4][4] = 64'h1212121212121212;
//==================end of initial SHA3-512_1600

//*******************************
//** INI DATA FOR SHA3-256 ******
//*******************************

//current state of A prior to theta transformation
//Example from 0-bit stream input for SHA3-256 --- FOR THETA
//lane format inputs --- in little endian already
A[0][0] = 64'h0000000000000006;
A[1][0] = 64'h0000000000000000; 
A[2][0] = 64'h0000000000000000;
A[3][0] = 64'h0000000000000000;
A[4][0] = 64'h0000000000000000;
A[0][1] = 64'h0000000000000000;
A[1][1] = 64'h0000000000000000;
A[2][1] = 64'h0000000000000000;
A[3][1] = 64'h0000000000000000;
A[4][1] = 64'h0000000000000000;
A[0][2] = 64'h0000000000000000;
A[1][2] = 64'h0000000000000000;
A[2][2] = 64'h0000000000000000;
A[3][2] = 64'h0000000000000000;
A[4][2] = 64'h0000000000000000;
A[0][3] = 64'h0000000000000000;
A[1][3] = 64'h8000000000000000;
A[2][3] = 64'h0000000000000000;
A[3][3] = 64'h0000000000000000;
A[4][3] = 64'h0000000000000000;
A[0][4] = 64'h0000000000000000;
A[1][4] = 64'h0000000000000000;
A[2][4] = 64'h0000000000000000;
A[3][4] = 64'h0000000000000000;
A[4][4] = 64'h0000000000000000;

//Round #0 Expected state after theta: & input for RHO
expected[0][0] = 64'h0000000000000007;
expected[1][0] = 64'h0000000000000006;
expected[2][0] = 64'h8000000000000000;
expected[3][0] = 64'h0000000000000000;
expected[4][0] = 64'h000000000000000C;
expected[0][1] = 64'h0000000000000001;
expected[1][1] = 64'h0000000000000006;
expected[2][1] = 64'h8000000000000000;
expected[3][1] = 64'h0000000000000000;
expected[4][1] = 64'h000000000000000C;
expected[0][2] = 64'h0000000000000001;
expected[1][2] = 64'h0000000000000006;
expected[2][2] = 64'h8000000000000000;
expected[3][2] = 64'h0000000000000000;
expected[4][2] = 64'h000000000000000C;
expected[0][3] = 64'h0000000000000001;
expected[1][3] = 64'h8000000000000006;
expected[2][3] = 64'h8000000000000000;
expected[3][3] = 64'h0000000000000000;
expected[4][3] = 64'h000000000000000C;
expected[0][4] = 64'h0000000000000001;
expected[1][4] = 64'h0000000000000006;
expected[2][4] = 64'h8000000000000000;
expected[3][4] = 64'h0000000000000000;
expected[4][4] = 64'h000000000000000C;#10;

end //end_of_initial_begin


//Expected output FOR RHO & input for PI
assign str1 = 1600'h07000000000000000C0000000000000000000000000000200000000000000000000000600000000000000000100000000000000000600000200000000000000000000000000000000000C000000000000800000000000000001800000000000000000000000400000000000000000000000000000006000000000000000200000000000000D0000000400000000000000000000000000000000C00000000000000000400000000001800000000000000000000000000001000000000000000000000030000000000;

//format inputs - Convert big Endian string to little endian state array
for(y = 0; y < 5; y = y+1)
begin
    for(x =0; x<5; x= x+1)
    begin
        for(z =0; z< 8; z = z+1 )
        begin
            assign expected1[x][y][(63-(8*z)):(64-(8*(z+1)))] = str1[((320*(4-y))+(64*(4-x))+((8*(z+1))-1)):((320*(4-y))+(64*(4-x))+(8*z))];
        end
    end
end

//Expected output for SHA3-256 --- FOR PI and input for CHI
assign str2 = 1600'h0700000000000000000000000060000000000000000400000000000000000000000003000000000000000000000000000000C0000000000008000000000000000000000000D0000000000000000000100C0000000000000020000000000000000000000000000000000C00000000000000000400000000000000006000000000000000001000000000180000000000000040000000000000000000000000000000000000000000200000000000000000000000000006000000000000000200001800000000000000;

//format inputs - Convert big Endian string to little endian state array
for(y = 0; y < 5; y = y+1)
begin
    for(x =0; x<5; x= x+1)
    begin
        for(z =0; z< 8; z = z+1 )
        begin
            assign expected2[x][y][(63-(8*z)):(64-(8*(z+1)))] = str2[((320*(4-y))+(64*(4-x))+((8*(z+1))-1)):((320*(4-y))+(64*(4-x))+(8*z))];
        end
    end
end

//Expected output for SHA3-256 --- expexted CHI output 
assign str3 = 1600'h0700000000040000000000000060000000000300000400000700000000000000000003000060000008000000000000000000C00000D0000008000000000000100000000000D000000000C000000000100C00000000000000200C00000000000000000400000000000C0C00000000000020000400000000000018006000000000004000001000000000180000000000000040006000000000000000001000000000000000000600200000000000000000180000000006000000000000000200201800000000000000;


//format inputs - Convert big Endian string to little endian state array
for(y = 0; y < 5; y = y+1)
begin
    for(x =0; x<5; x= x+1)
    begin
        for(z =0; z< 8; z = z+1 )
        begin
            assign expected3[x][y][(63-(8*z)):(64-(8*(z+1)))] = str3[((320*(4-y))+(64*(4-x))+((8*(z+1))-1)):((320*(4-y))+(64*(4-x))+(8*z))];
        end
    end
end

//clock
always
begin
     clk <= 1'b1; #10;
     clk <= 1'b0; #10;
end

//verify result
always@(negedge clk)
begin
    if((A1prime == expectedt1) && (A1prime1 == expected01) && (A1prime2 == expected02) && (A1prime3 == expected03)
       && (Aprime == expected) && (Aprime2 == expected1) && (Aprime3 == expected2) && (Aprime4 == expected3))
    begin
        $display("successful SHA3-512 and SHA3-256 theta, rho, phi, & transformations!\n");
        $stop;
    end
    else
    begin
        $display("results != expected\n");
        $stop;
    end
end

endmodule

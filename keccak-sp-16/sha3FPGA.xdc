# Based on Digilent's Nexys 4 DDR reference XDC,
# with extra pins not used in the labs removed.

# Clock signal (100 MHz)
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk}];

# Slide switches
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { byte1[0] }]; #Switch 0
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { byte1[1] }]; #Switch 1
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { byte1[2] }]; #Switch 2
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { byte1[3] }]; #Switch 3
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { byte1[4] }]; #Switch 4
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { byte1[5] }]; #Switch 5
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { byte1[6] }]; #Switch 6
set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { byte1[7] }]; #Switch 7
set_property -dict { PACKAGE_PIN T8    IOSTANDARD LVCMOS33 } [get_ports { byte2[0] }]; #Switch 8
set_property -dict { PACKAGE_PIN U8    IOSTANDARD LVCMOS33 } [get_ports { byte2[1] }]; #Switch 9
set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { byte2[2] }]; #Switch 10
set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { byte2[3] }]; #Switch 11
set_property -dict { PACKAGE_PIN H6    IOSTANDARD LVCMOS33 } [get_ports { byte2[4] }]; #Switch 12
set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { byte2[5] }]; #Switch 13
set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { byte2[6] }]; #Switch 14
set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { byte2[7] }]; #Switch 15
# LEDs
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { halfLaneAddress[0] }]; #LED0
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { halfLaneAddress[1] }]; #LED1
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { halfLaneAddress[2] }]; #LED2
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { halfLaneAddress[3] }]; #LED3
set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { halfLaneAddress[4] }]; #LED4
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { halfLaneAddress[5] }]; #LED5
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { s[0] }]; #LED14
set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { s[1] }]; #LED15

# Pushbuttons

# Active low
set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { RST   }]; #left button
set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33 } [get_ports { tbtn3   }]; #left button
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { ctbtn }]; #center button
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { tbtn2 }]; #up button

# 7-segment display

# Segment cathodes (common to all digits) 
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { LEDOUT[0] }]; #IO_L17P_T2_A26_15 Sch=cd
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { LEDOUT[1] }]; #IO_25_15 Sch=cc
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { LEDOUT[2] }]; #IO_L13P_T2_MRCC_14 Sch=ce
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports { LEDOUT[3] }]; #IO_L4P_T0_D04_14 Sch=cg
set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports { LEDOUT[4] }]; #IO_25_14 Sch=cb
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { LEDOUT[5] }]; #IO_L19P_T3_A10_D26_14 Sch=cf
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { LEDOUT[6] }]; #IO_L24N_T3_A00_D16_14 Sch=ca
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { LEDOUT[7] }]; #IO_L19N_T3_A21_VREF_15 Sch=dp

# Anodes per digit
set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { LEDSEL[0] }]; #IO_L23P_T3_FOE_B_15 Sch=an[0]
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { LEDSEL[1] }]; #IO_L23N_T3_FWE_B_15 Sch=an[1]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { LEDSEL[2] }]; #IO_L24P_T3_A01_D17_14 Sch=an[2]
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { LEDSEL[3] }]; #IO_L19P_T3_A22_15 Sch=an[3]
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { LEDSEL[4] }]; #IO_L8N_T1_D12_14 Sch=an[4]
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { LEDSEL[5] }]; #IO_L14P_T2_SRCC_14 Sch=an[5]
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { LEDSEL[6] }]; #IO_L23P_T3_35 Sch=an[6]
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { LEDSEL[7] }]; #IO_L23N_T3_A02_D18_14 Sch=an[7]



#=============================================================================


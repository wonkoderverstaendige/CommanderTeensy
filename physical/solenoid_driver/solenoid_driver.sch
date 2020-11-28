EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev "1"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Transistor_BJT:TIP120 Q1
U 1 1 5FC00AED
P 5600 2500
F 0 "Q1" H 5807 2546 50  0000 L CNN
F 1 "TIP120" H 5807 2455 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-220-3_Vertical" H 5800 2425 50  0001 L CIN
F 3 "https://www.onsemi.com/pub/Collateral/TIP120-D.PDF" H 5600 2500 50  0001 L CNN
	1    5600 2500
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x02_Male J3
U 1 1 5FC04111
P 5100 5150
F 0 "J3" H 5208 5331 50  0000 C CNN
F 1 "12V Input" H 5100 4950 50  0000 C CNN
F 2 "TerminalBlock_MetzConnect:TerminalBlock_MetzConnect_Type055_RT01502HDWU_1x02_P5.00mm_Horizontal" H 5100 5150 50  0001 C CNN
F 3 "~" H 5100 5150 50  0001 C CNN
	1    5100 5150
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x02_Male J2
U 1 1 5FC0524C
P 6200 2050
F 0 "J2" H 6308 2231 50  0000 C CNN
F 1 "Solenoid A" H 6308 2140 50  0000 C CNN
F 2 "Connector_JST:JST_EH_B2B-EH-A_1x02_P2.50mm_Vertical" H 6200 2050 50  0001 C CNN
F 3 "~" H 6200 2050 50  0001 C CNN
	1    6200 2050
	-1   0    0    1   
$EndComp
$Comp
L Diode:1N4004 D1
U 1 1 5FC07612
P 5700 1900
F 0 "D1" V 5700 1650 50  0000 L CNN
F 1 "1N4004" V 5800 1550 50  0000 L CNN
F 2 "Diode_THT:D_DO-41_SOD81_P10.16mm_Horizontal" H 5700 1725 50  0001 C CNN
F 3 "http://www.vishay.com/docs/88503/1n4001.pdf" H 5700 1900 50  0001 C CNN
	1    5700 1900
	0    1    1    0   
$EndComp
$Comp
L Device:R R1
U 1 1 5FC0A550
P 5250 2500
F 0 "R1" V 5043 2500 50  0000 C CNN
F 1 "2.2k" V 5134 2500 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P5.08mm_Horizontal" V 5180 2500 50  0001 C CNN
F 3 "~" H 5250 2500 50  0001 C CNN
	1    5250 2500
	0    1    1    0   
$EndComp
$Comp
L Connector:Conn_01x04_Male J1
U 1 1 5FC14A45
P 2150 1100
F 0 "J1" H 1950 850 50  0000 C CNN
F 1 "Input Header" H 2150 750 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 2150 1100 50  0001 C CNN
F 3 "~" H 2150 1100 50  0001 C CNN
	1    2150 1100
	1    0    0    -1  
$EndComp
$Comp
L power:+12V #PWR01
U 1 1 5FC16164
P 5650 5150
F 0 "#PWR01" H 5650 5250 50  0001 C CNN
F 1 "+12V" H 5665 5323 50  0000 C CNN
F 2 "" H 5650 5150 50  0001 C CNN
F 3 "" H 5650 5150 50  0001 C CNN
	1    5650 5150
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG01
U 1 1 5FC17D25
P 6000 5150
F 0 "#FLG01" H 6000 5225 50  0001 C CNN
F 1 "PWR_FLAG" H 6000 5323 50  0000 C CNN
F 2 "" H 6000 5150 50  0001 C CNN
F 3 "~" H 6000 5150 50  0001 C CNN
	1    6000 5150
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 5150 5300 5150
Wire Wire Line
	5300 5250 5650 5250
Wire Wire Line
	6000 5150 5650 5150
Connection ~ 5650 5150
Wire Wire Line
	5700 2300 5700 2050
Wire Wire Line
	6000 2050 5700 2050
Connection ~ 5700 2050
Wire Wire Line
	5700 1750 6000 1750
Wire Wire Line
	6000 1750 6000 1950
Wire Wire Line
	5700 1750 5700 1600
Connection ~ 5700 1750
$Comp
L Transistor_BJT:TIP120 Q2
U 1 1 5FC22891
P 5600 3950
F 0 "Q2" H 5807 3996 50  0000 L CNN
F 1 "TIP120" H 5807 3905 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-220-3_Vertical" H 5800 3875 50  0001 L CIN
F 3 "https://www.onsemi.com/pub/Collateral/TIP120-D.PDF" H 5600 3950 50  0001 L CNN
	1    5600 3950
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x02_Male J4
U 1 1 5FC2289D
P 6200 3500
F 0 "J4" H 6308 3681 50  0000 C CNN
F 1 "Solenoid B" H 6308 3590 50  0000 C CNN
F 2 "Connector_JST:JST_EH_B2B-EH-A_1x02_P2.50mm_Vertical" H 6200 3500 50  0001 C CNN
F 3 "~" H 6200 3500 50  0001 C CNN
	1    6200 3500
	-1   0    0    1   
$EndComp
$Comp
L Diode:1N4004 D2
U 1 1 5FC228A3
P 5700 3350
F 0 "D2" V 5700 3100 50  0000 L CNN
F 1 "1N4004" V 5800 3000 50  0000 L CNN
F 2 "Diode_THT:D_DO-41_SOD81_P10.16mm_Horizontal" H 5700 3175 50  0001 C CNN
F 3 "http://www.vishay.com/docs/88503/1n4001.pdf" H 5700 3350 50  0001 C CNN
	1    5700 3350
	0    1    1    0   
$EndComp
$Comp
L Device:R R2
U 1 1 5FC228A9
P 5250 3950
F 0 "R2" V 5043 3950 50  0000 C CNN
F 1 "2.2k" V 5134 3950 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P5.08mm_Horizontal" V 5180 3950 50  0001 C CNN
F 3 "~" H 5250 3950 50  0001 C CNN
	1    5250 3950
	0    1    1    0   
$EndComp
Wire Wire Line
	5700 3750 5700 3500
Wire Wire Line
	6000 3500 5700 3500
Connection ~ 5700 3500
Wire Wire Line
	5700 3200 6000 3200
Wire Wire Line
	6000 3200 6000 3400
Wire Wire Line
	5700 3200 5700 3050
Connection ~ 5700 3200
$Comp
L 74xGxx:74LVC2G32 U1
U 1 1 5FC0E8AD
P 3350 2300
F 0 "U1" H 3325 2567 50  0000 C CNN
F 1 "74LVC2G32" H 3325 2476 50  0000 C CNN
F 2 "Package_SO:SSOP-8_2.95x2.8mm_P0.65mm" H 3350 2300 50  0001 C CNN
F 3 "http://www.ti.com/lit/sg/scyt129e/scyt129e.pdf" H 3350 2300 50  0001 C CNN
	1    3350 2300
	1    0    0    -1  
$EndComp
$Comp
L 74xGxx:74LVC2G32 U1
U 2 1 5FC10322
P 3350 3750
F 0 "U1" H 3325 4017 50  0000 C CNN
F 1 "74LVC2G32" H 3325 3926 50  0000 C CNN
F 2 "Package_SO:SSOP-8_2.95x2.8mm_P0.65mm" H 3350 3750 50  0001 C CNN
F 3 "http://www.ti.com/lit/sg/scyt129e/scyt129e.pdf" H 3350 3750 50  0001 C CNN
	2    3350 3750
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0103
U 1 1 5FC124D5
P 2450 900
F 0 "#PWR0103" H 2450 750 50  0001 C CNN
F 1 "+3.3V" H 2465 1073 50  0000 C CNN
F 2 "" H 2450 900 50  0001 C CNN
F 3 "" H 2450 900 50  0001 C CNN
	1    2450 900 
	1    0    0    -1  
$EndComp
Text Notes 4650 6150 0    118  ~ 24
High power solenoid side
$Comp
L Isolator:ILD74 U2
U 1 1 5FC2F252
P 4450 2400
F 0 "U2" H 4250 2750 50  0000 C CNN
F 1 "ILD74" H 4300 2650 50  0000 C CNN
F 2 "Package_DIP:DIP-8_W7.62mm" H 4250 2200 50  0001 L CIN
F 3 "https://www.vishay.com/docs/83640/ild74.pdf" H 4450 2400 50  0001 L CNN
	1    4450 2400
	1    0    0    -1  
$EndComp
$Comp
L Isolator:ILD74 U2
U 2 1 5FC2FEC7
P 4450 3850
F 0 "U2" H 4250 4200 50  0000 C CNN
F 1 "ILD74" H 4300 4100 50  0000 C CNN
F 2 "Package_DIP:DIP-8_W7.62mm" H 4250 3650 50  0001 L CIN
F 3 "https://www.vishay.com/docs/83640/ild74.pdf" H 4450 3850 50  0001 L CNN
	2    4450 3850
	1    0    0    -1  
$EndComp
Wire Wire Line
	5700 3200 4750 3200
Wire Wire Line
	4750 3200 4750 3750
Wire Wire Line
	4750 3950 5100 3950
Wire Wire Line
	5700 1750 4750 1750
Wire Wire Line
	4750 1750 4750 2300
Wire Wire Line
	4750 2500 5100 2500
$Comp
L Device:R R7
U 1 1 5FC4F4AB
P 3900 2300
F 0 "R7" V 3693 2300 50  0000 C CNN
F 1 "220" V 3784 2300 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 3830 2300 50  0001 C CNN
F 3 "~" H 3900 2300 50  0001 C CNN
	1    3900 2300
	0    1    1    0   
$EndComp
Wire Wire Line
	3600 2300 3750 2300
Wire Wire Line
	4050 2300 4150 2300
$Comp
L Device:R R8
U 1 1 5FC50BCD
P 3900 3750
F 0 "R8" V 3693 3750 50  0000 C CNN
F 1 "220" V 3784 3750 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 3830 3750 50  0001 C CNN
F 3 "~" H 3900 3750 50  0001 C CNN
	1    3900 3750
	0    1    1    0   
$EndComp
Wire Wire Line
	3600 3750 3750 3750
Wire Wire Line
	4050 3750 4150 3750
$Comp
L Connector:Conn_01x02_Male J5
U 1 1 5FC5B103
P 2050 2000
F 0 "J5" H 2158 2181 50  0000 C CNN
F 1 "Solenoid A Override" V 2850 1900 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 2050 2000 50  0001 C CNN
F 3 "~" H 2050 2000 50  0001 C CNN
	1    2050 2000
	0    1    1    0   
$EndComp
$Comp
L Connector:Conn_01x02_Male J6
U 1 1 5FC5BD29
P 2050 3450
F 0 "J6" H 2158 3631 50  0000 C CNN
F 1 "Solenoid B Override" V 2950 3400 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 2050 3450 50  0001 C CNN
F 3 "~" H 2050 3450 50  0001 C CNN
	1    2050 3450
	0    1    1    0   
$EndComp
$Comp
L Device:R R3
U 1 1 5FC66B38
P 1650 2350
F 0 "R3" V 1750 2500 50  0000 C CNN
F 1 "1k" V 1750 2350 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 1580 2350 50  0001 C CNN
F 3 "~" H 1650 2350 50  0001 C CNN
	1    1650 2350
	0    1    1    0   
$EndComp
$Comp
L Device:R R4
U 1 1 5FC671CD
P 1650 3800
F 0 "R4" V 1800 3950 50  0000 C CNN
F 1 "1k" V 1800 3800 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 1580 3800 50  0001 C CNN
F 3 "~" H 1650 3800 50  0001 C CNN
	1    1650 3800
	0    1    1    0   
$EndComp
Wire Wire Line
	4150 2500 4100 2500
Wire Wire Line
	5700 4150 5700 4250
Wire Wire Line
	5700 2700 6050 2700
Wire Wire Line
	5700 4250 6050 4250
$Comp
L Switch:SW_Push SW1
U 1 1 5FC75DBA
P 2000 2550
F 0 "SW1" H 2000 2835 50  0000 C CNN
F 1 "SW_Push" H 2000 2744 50  0000 C CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm" H 2000 2750 50  0001 C CNN
F 3 "~" H 2000 2750 50  0001 C CNN
	1    2000 2550
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push SW2
U 1 1 5FC76C95
P 2000 4000
F 0 "SW2" H 2000 4285 50  0000 C CNN
F 1 "SW_Push" H 2000 4194 50  0000 C CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm" H 2000 4200 50  0001 C CNN
F 3 "~" H 2000 4200 50  0001 C CNN
	1    2000 4000
	1    0    0    -1  
$EndComp
Wire Wire Line
	1950 2200 1800 2200
Wire Wire Line
	1800 2200 1800 2350
Wire Wire Line
	2050 2200 2200 2200
Wire Wire Line
	2200 2200 2200 2350
Connection ~ 2200 2350
Wire Wire Line
	2200 2350 2200 2550
Connection ~ 1800 2350
Wire Wire Line
	1800 2350 1800 2550
Wire Wire Line
	1500 2350 1450 2350
Wire Wire Line
	1950 3650 1800 3650
Wire Wire Line
	1800 3650 1800 3800
Wire Wire Line
	2050 3650 2200 3650
Wire Wire Line
	2200 3650 2200 3800
Connection ~ 1800 3800
Wire Wire Line
	1800 3800 1800 4000
Wire Wire Line
	1500 3800 1450 3800
Connection ~ 2200 3800
Wire Wire Line
	2200 3800 2200 4000
$Comp
L Device:R R5
U 1 1 5FC96289
P 2600 2600
F 0 "R5" V 2700 2750 50  0000 C CNN
F 1 "10k" V 2700 2600 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 2530 2600 50  0001 C CNN
F 3 "~" H 2600 2600 50  0001 C CNN
	1    2600 2600
	-1   0    0    1   
$EndComp
$Comp
L Device:R R6
U 1 1 5FC97308
P 2600 4000
F 0 "R6" V 2700 4150 50  0000 C CNN
F 1 "10k" V 2700 4000 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 2530 4000 50  0001 C CNN
F 3 "~" H 2600 4000 50  0001 C CNN
	1    2600 4000
	-1   0    0    1   
$EndComp
Wire Wire Line
	2200 3800 2600 3800
Wire Wire Line
	2600 3850 2600 3800
Wire Wire Line
	2200 2350 2600 2350
Wire Wire Line
	2600 2450 2600 2350
Text Notes 4950 4300 0    31   ~ 0
smoothing cap on solenoid?
Text Notes 2100 6150 0    118  ~ 24
Low voltage Teensy side
Wire Notes Line width 39
	4450 550  4450 6450
Text GLabel 2600 1000 2    50   Input ~ 0
3.3V
Text GLabel 2350 1200 2    50   Input ~ 0
InputA
Text GLabel 2350 1100 2    50   Input ~ 0
InputB
Text GLabel 2600 1300 2    50   Input ~ 0
TeensyGND
Wire Wire Line
	2350 1000 2450 1000
Wire Wire Line
	2450 900  2450 1000
Connection ~ 2450 1000
Wire Wire Line
	2450 1000 2600 1000
Text GLabel 2950 2250 0    50   Input ~ 0
InputA
Text GLabel 2950 3700 0    50   Input ~ 0
InputB
Text GLabel 1450 2350 0    50   Input ~ 0
3.3V
Text GLabel 1450 3800 0    50   Input ~ 0
3.3V
Wire Wire Line
	2600 2750 2600 2850
Wire Wire Line
	2600 4250 2600 4150
Wire Wire Line
	4150 3950 4150 4250
Wire Wire Line
	2600 2350 3050 2350
Connection ~ 2600 2350
Wire Wire Line
	2950 2250 3050 2250
Wire Wire Line
	2950 3700 3050 3700
Wire Wire Line
	2600 3800 3050 3800
Connection ~ 2600 3800
Text Notes 3650 2500 0    50   ~ 0
If = 7mA
Text Notes 4750 2650 0    50   ~ 0
max. Ibe = 6mA
Text Notes 1600 2650 0    50   ~ 0
Ibtn = 3.3mA
Text GLabel 3350 1850 2    50   Input ~ 0
3.3V
Wire Wire Line
	3350 1850 3350 2200
Text GLabel 3500 4550 2    50   Input ~ 0
TeensyGND
Wire Wire Line
	2600 4250 3350 4250
Wire Wire Line
	3500 4250 3500 4550
Wire Wire Line
	4150 4250 3500 4250
Connection ~ 3500 4250
Text GLabel 3450 3050 2    50   Input ~ 0
TeensyGND
Wire Wire Line
	2600 2850 3350 2850
Wire Wire Line
	3450 2850 3450 3050
Wire Wire Line
	3450 2850 4100 2850
Connection ~ 3450 2850
Text GLabel 3350 3350 2    50   Input ~ 0
3.3V
Wire Wire Line
	3350 3350 3350 3650
Wire Wire Line
	3350 3850 3350 4250
Connection ~ 3350 4250
Wire Wire Line
	3350 4250 3500 4250
Wire Wire Line
	4100 2500 4100 2850
Wire Wire Line
	3350 2400 3350 2850
Connection ~ 3350 2850
Wire Wire Line
	3350 2850 3450 2850
Wire Wire Line
	2350 1300 2450 1300
$Comp
L power:GNDPWR #PWR?
U 1 1 5FD49F96
P 5650 5400
F 0 "#PWR?" H 5650 5200 50  0001 C CNN
F 1 "GNDPWR" H 5654 5246 50  0000 C CNN
F 2 "" H 5650 5350 50  0001 C CNN
F 3 "" H 5650 5350 50  0001 C CNN
	1    5650 5400
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 5400 5650 5250
Text GLabel 6250 5150 2    50   Input ~ 0
12V
Wire Wire Line
	6000 5150 6250 5150
Connection ~ 6000 5150
Text GLabel 6250 5250 2    50   Input ~ 0
GNDPWR
Wire Wire Line
	6250 5250 5650 5250
Connection ~ 5650 5250
Text GLabel 6050 4250 2    50   Input ~ 0
GNDPWR
Text GLabel 6050 2700 2    50   Input ~ 0
GNDPWR
Text GLabel 5700 3050 2    50   Input ~ 0
12V
Text GLabel 5700 1600 2    50   Input ~ 0
12V
$Comp
L power:GND #PWR?
U 1 1 5FD51680
P 2450 1500
F 0 "#PWR?" H 2450 1250 50  0001 C CNN
F 1 "GND" H 2455 1327 50  0000 C CNN
F 2 "" H 2450 1500 50  0001 C CNN
F 3 "" H 2450 1500 50  0001 C CNN
	1    2450 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	2450 1500 2450 1300
Connection ~ 2450 1300
Wire Wire Line
	2450 1300 2600 1300
$EndSCHEMATC

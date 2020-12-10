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
L Connector:Conn_01x02_Male J8
U 1 1 5FC04111
P 7450 1250
F 0 "J8" H 7558 1431 50  0000 C CNN
F 1 "12V Input" H 7450 1050 50  0000 C CNN
F 2 "TerminalBlock_MetzConnect:TerminalBlock_MetzConnect_Type055_RT01502HDWU_1x02_P5.00mm_Horizontal" H 7450 1250 50  0001 C CNN
F 3 "~" H 7450 1250 50  0001 C CNN
	1    7450 1250
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x02_Male J5
U 1 1 5FC0524C
P 6800 2650
F 0 "J5" H 6650 2600 50  0000 C CNN
F 1 "Solenoid A" H 6800 2750 50  0000 C CNN
F 2 "Connector_JST:JST_EH_B2B-EH-A_1x02_P2.50mm_Vertical" H 6800 2650 50  0001 C CNN
F 3 "~" H 6800 2650 50  0001 C CNN
	1    6800 2650
	-1   0    0    1   
$EndComp
$Comp
L Diode:1N4004 D7
U 1 1 5FC07612
P 5750 2350
F 0 "D7" V 5750 2100 50  0000 L CNN
F 1 "1N4004" V 5850 2000 50  0000 L CNN
F 2 "Diode_THT:D_DO-41_SOD81_P10.16mm_Horizontal" H 5750 2175 50  0001 C CNN
F 3 "http://www.vishay.com/docs/88503/1n4001.pdf" H 5750 2350 50  0001 C CNN
	1    5750 2350
	0    1    1    0   
$EndComp
$Comp
L Device:R R9
U 1 1 5FC0A550
P 5300 3100
F 0 "R9" V 5350 2900 50  0000 C CNN
F 1 "2.2k" V 5184 3100 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 5230 3100 50  0001 C CNN
F 3 "~" H 5300 3100 50  0001 C CNN
	1    5300 3100
	0    1    1    0   
$EndComp
$Comp
L Connector:Conn_01x04_Male J1
U 1 1 5FC14A45
P 1250 1400
F 0 "J1" H 1050 1150 50  0000 C CNN
F 1 "Input Header" H 1250 1050 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Horizontal" H 1250 1400 50  0001 C CNN
F 3 "~" H 1250 1400 50  0001 C CNN
	1    1250 1400
	1    0    0    1   
$EndComp
$Comp
L power:+12V #PWR03
U 1 1 5FC16164
P 8000 1250
F 0 "#PWR03" H 8000 1350 50  0001 C CNN
F 1 "+12V" H 8015 1423 50  0000 C CNN
F 2 "" H 8000 1250 50  0001 C CNN
F 3 "" H 8000 1250 50  0001 C CNN
	1    8000 1250
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG03
U 1 1 5FC17D25
P 8350 1250
F 0 "#FLG03" H 8350 1325 50  0001 C CNN
F 1 "PWR_FLAG" H 8350 1423 50  0000 C CNN
F 2 "" H 8350 1250 50  0001 C CNN
F 3 "~" H 8350 1250 50  0001 C CNN
	1    8350 1250
	1    0    0    -1  
$EndComp
Wire Wire Line
	8000 1250 7650 1250
Wire Wire Line
	7650 1350 8000 1350
Wire Wire Line
	8350 1250 8000 1250
Connection ~ 8000 1250
$Comp
L Connector:Conn_01x02_Male J7
U 1 1 5FC2289D
P 6800 4350
F 0 "J7" H 6650 4300 50  0000 C CNN
F 1 "Solenoid B" H 6800 4450 50  0000 C CNN
F 2 "Connector_JST:JST_EH_B2B-EH-A_1x02_P2.50mm_Vertical" H 6800 4350 50  0001 C CNN
F 3 "~" H 6800 4350 50  0001 C CNN
	1    6800 4350
	-1   0    0    1   
$EndComp
$Comp
L Diode:1N4004 D8
U 1 1 5FC228A3
P 5750 4200
F 0 "D8" V 5750 3950 50  0000 L CNN
F 1 "1N4004" V 5850 3850 50  0000 L CNN
F 2 "Diode_THT:D_DO-41_SOD81_P10.16mm_Horizontal" H 5750 4025 50  0001 C CNN
F 3 "http://www.vishay.com/docs/88503/1n4001.pdf" H 5750 4200 50  0001 C CNN
	1    5750 4200
	0    1    1    0   
$EndComp
$Comp
L Device:R R10
U 1 1 5FC228A9
P 5300 4800
F 0 "R10" V 5093 4800 50  0000 C CNN
F 1 "2.2k" V 5184 4800 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 5230 4800 50  0001 C CNN
F 3 "~" H 5300 4800 50  0001 C CNN
	1    5300 4800
	0    1    1    0   
$EndComp
Wire Wire Line
	5750 4600 5750 4350
Connection ~ 5750 4350
$Comp
L power:+3.3V #PWR01
U 1 1 5FC124D5
P 1600 1100
F 0 "#PWR01" H 1600 950 50  0001 C CNN
F 1 "+3.3V" H 1550 1300 50  0000 C CNN
F 2 "" H 1600 1100 50  0001 C CNN
F 3 "" H 1600 1100 50  0001 C CNN
	1    1600 1100
	1    0    0    -1  
$EndComp
Text Notes 4650 6150 0    118  ~ 24
High power solenoid side
$Comp
L Isolator:ILD74 U1
U 1 1 5FC2F252
P 4500 4400
F 0 "U1" H 4300 4750 50  0000 C CNN
F 1 "MCT62H" H 4300 4650 50  0000 C CNN
F 2 "Package_DIP:DIP-8_W7.62mm" H 4300 4200 50  0001 L CIN
F 3 "https://www.vishay.com/docs/83640/ild74.pdf" H 4500 4400 50  0001 L CNN
	1    4500 4400
	1    0    0    -1  
$EndComp
$Comp
L Isolator:ILD74 U1
U 2 1 5FC2FEC7
P 4500 2650
F 0 "U1" H 4300 3000 50  0000 C CNN
F 1 "MCT62H" H 4300 2900 50  0000 C CNN
F 2 "Package_DIP:DIP-8_W7.62mm" H 4300 2450 50  0001 L CIN
F 3 "https://www.vishay.com/docs/83640/ild74.pdf" H 4500 2650 50  0001 L CNN
	2    4500 2650
	1    0    0    -1  
$EndComp
$Comp
L Device:R R1
U 1 1 5FC4F4AB
P 2550 2150
F 0 "R1" V 2343 2150 50  0000 C CNN
F 1 "220" V 2434 2150 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 2480 2150 50  0001 C CNN
F 3 "~" H 2550 2150 50  0001 C CNN
	1    2550 2150
	0    1    1    0   
$EndComp
$Comp
L Device:R R5
U 1 1 5FC50BCD
P 2500 4500
F 0 "R5" V 2293 4500 50  0000 C CNN
F 1 "220" V 2384 4500 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 2430 4500 50  0001 C CNN
F 3 "~" H 2500 4500 50  0001 C CNN
	1    2500 4500
	0    1    1    0   
$EndComp
$Comp
L Connector:Conn_01x02_Male J3
U 1 1 5FC5B103
P 2950 2350
F 0 "J3" H 3058 2531 50  0000 C CNN
F 1 "Solenoid A Override" V 3750 2250 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 2950 2350 50  0001 C CNN
F 3 "~" H 2950 2350 50  0001 C CNN
	1    2950 2350
	0    1    1    0   
$EndComp
Wire Wire Line
	5750 5000 5750 5100
Wire Wire Line
	5750 5100 6100 5100
$Comp
L Switch:SW_Push SW2
U 1 1 5FC75DBA
P 2900 2900
F 0 "SW2" H 2900 3185 50  0000 C CNN
F 1 "SW_Push" H 2900 3094 50  0000 C CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm" H 2900 3100 50  0001 C CNN
F 3 "~" H 2900 3100 50  0001 C CNN
	1    2900 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	2850 2550 2700 2550
Wire Wire Line
	2950 2550 3100 2550
Wire Wire Line
	2400 2700 2350 2700
$Comp
L Device:R R3
U 1 1 5FC96289
P 3850 2750
F 0 "R3" V 3950 2750 50  0000 C CNN
F 1 "10k" V 4050 2750 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 3780 2750 50  0001 C CNN
F 3 "~" H 3850 2750 50  0001 C CNN
	1    3850 2750
	0    1    1    0   
$EndComp
$Comp
L Device:R R6
U 1 1 5FC97308
P 3850 4500
F 0 "R6" V 3750 4600 50  0000 C CNN
F 1 "10k" V 3750 4400 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 3780 4500 50  0001 C CNN
F 3 "~" H 3850 4500 50  0001 C CNN
	1    3850 4500
	0    -1   -1   0   
$EndComp
Text Notes 2150 6150 0    118  ~ 24
Low voltage Teensy side
Wire Notes Line width 39
	4500 750  4500 6650
Text GLabel 1950 1200 2    50   Input ~ 0
3.3V
Text GLabel 1450 1400 2    50   Input ~ 0
InputA
Text GLabel 1450 1300 2    50   Input ~ 0
InputB
Text GLabel 1950 1500 2    50   Input ~ 0
TeensyGND
Text GLabel 2350 2150 0    50   Input ~ 0
InputA
Text GLabel 2300 3950 0    50   Input ~ 0
InputB
Text GLabel 2350 2700 0    50   Input ~ 0
3.3V
Text Notes 4000 2250 0    50   ~ 0
If = 5 mA
Text Notes 2650 3050 0    50   ~ 0
Ibtn = 3.3mA
Text GLabel 4100 4800 3    50   Input ~ 0
TeensyGND
Text GLabel 4100 3100 3    50   Input ~ 0
TeensyGND
$Comp
L power:GNDPWR #PWR04
U 1 1 5FD49F96
P 8000 1500
F 0 "#PWR04" H 8000 1300 50  0001 C CNN
F 1 "GNDPWR" H 8004 1346 50  0000 C CNN
F 2 "" H 8000 1450 50  0001 C CNN
F 3 "" H 8000 1450 50  0001 C CNN
	1    8000 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	8000 1500 8000 1350
Text GLabel 8600 1250 2    50   Input ~ 0
12V
Wire Wire Line
	8350 1250 8600 1250
Connection ~ 8350 1250
Text GLabel 8600 1350 2    50   Input ~ 0
GNDPWR
Wire Wire Line
	8600 1350 8350 1350
Connection ~ 8000 1350
Text GLabel 6100 5100 2    50   Input ~ 0
GNDPWR
Text GLabel 6100 3300 2    50   Input ~ 0
GNDPWR
Text GLabel 5750 3650 0    50   Input ~ 0
12V
Text GLabel 5750 1950 1    50   Input ~ 0
12V
$Comp
L power:GND #PWR02
U 1 1 5FD51680
P 1600 1650
F 0 "#PWR02" H 1600 1400 50  0001 C CNN
F 1 "GND" H 1600 1500 50  0000 C CNN
F 2 "" H 1600 1650 50  0001 C CNN
F 3 "" H 1600 1650 50  0001 C CNN
	1    1600 1650
	1    0    0    -1  
$EndComp
Connection ~ 5750 2650
$Comp
L Device:LED D5
U 1 1 5FC9FC75
P 5150 2500
F 0 "D5" V 5189 2382 50  0000 R CNN
F 1 "LED" V 5098 2382 50  0000 R CNN
F 2 "LED_THT:LED_D5.0mm" H 5150 2500 50  0001 C CNN
F 3 "~" H 5150 2500 50  0001 C CNN
	1    5150 2500
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R7
U 1 1 5FCA3368
P 5150 2200
F 0 "R7" H 5080 2154 50  0000 R CNN
F 1 "680" H 5080 2245 50  0000 R CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 5080 2200 50  0001 C CNN
F 3 "~" H 5150 2200 50  0001 C CNN
	1    5150 2200
	-1   0    0    1   
$EndComp
Wire Wire Line
	5750 2650 5750 2900
Wire Wire Line
	4800 2050 5150 2050
Wire Wire Line
	5750 2050 5750 1950
Connection ~ 5750 2050
Wire Wire Line
	6050 2050 5750 2050
Connection ~ 5150 2050
Wire Wire Line
	5150 2050 5750 2050
Wire Wire Line
	5150 2650 5750 2650
$Comp
L Device:R R8
U 1 1 5FCB430B
P 5150 3900
F 0 "R8" H 5400 3850 50  0000 R CNN
F 1 "680" H 5400 3950 50  0000 R CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 5080 3900 50  0001 C CNN
F 3 "~" H 5150 3900 50  0001 C CNN
	1    5150 3900
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D6
U 1 1 5FCB6DE8
P 5150 4200
F 0 "D6" V 5200 4400 50  0000 R CNN
F 1 "LED" V 5050 4400 50  0000 R CNN
F 2 "LED_THT:LED_D5.0mm" H 5150 4200 50  0001 C CNN
F 3 "~" H 5150 4200 50  0001 C CNN
	1    5150 4200
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5150 4350 5750 4350
Wire Wire Line
	5750 3650 5750 3750
Wire Wire Line
	5150 3750 5750 3750
Connection ~ 5750 3750
Wire Wire Line
	5750 3750 5750 4050
Wire Wire Line
	4800 3750 5150 3750
Connection ~ 5150 3750
Wire Wire Line
	5750 3750 6050 3750
$Comp
L Device:R RsenseA1
U 1 1 5FCA57F7
P 6050 2200
F 0 "RsenseA1" H 6120 2246 50  0000 L CNN
F 1 "1" H 6120 2155 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 5980 2200 50  0001 C CNN
F 3 "~" H 6050 2200 50  0001 C CNN
	1    6050 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	6050 2350 6600 2350
$Comp
L Device:R RsenseB1
U 1 1 5FCA8408
P 6050 3900
F 0 "RsenseB1" H 6120 3946 50  0000 L CNN
F 1 "1" H 6120 3855 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 5980 3900 50  0001 C CNN
F 3 "~" H 6050 3900 50  0001 C CNN
	1    6050 3900
	1    0    0    -1  
$EndComp
Text Notes 6200 1950 0    50   ~ 0
Isense = 1V/1A
Wire Wire Line
	5750 2650 6600 2650
$Comp
L Connector:Conn_01x02_Male J4
U 1 1 5FCBC7C0
P 6800 2250
F 0 "J4" H 6650 2250 50  0000 C CNN
F 1 "SenseA" H 6750 2350 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 6800 2250 50  0001 C CNN
F 3 "~" H 6800 2250 50  0001 C CNN
	1    6800 2250
	-1   0    0    1   
$EndComp
Wire Wire Line
	6050 2050 6600 2050
Wire Wire Line
	6600 2050 6600 2150
Connection ~ 6050 2050
Wire Wire Line
	6600 2350 6600 2250
Wire Wire Line
	6050 2350 6050 2550
Wire Wire Line
	6050 2550 6600 2550
Connection ~ 6050 2350
Wire Wire Line
	5750 4350 6600 4350
$Comp
L Connector:Conn_01x02_Male J6
U 1 1 5FCC6B54
P 6800 3950
F 0 "J6" H 6650 3950 50  0000 C CNN
F 1 "SenseB" H 6750 4050 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 6800 3950 50  0001 C CNN
F 3 "~" H 6800 3950 50  0001 C CNN
	1    6800 3950
	-1   0    0    1   
$EndComp
Wire Wire Line
	6050 3750 6600 3750
Wire Wire Line
	6600 3750 6600 3850
Connection ~ 6050 3750
Wire Wire Line
	6600 3950 6600 4050
Wire Wire Line
	6600 4050 6050 4050
Wire Wire Line
	6050 4050 6050 4250
Wire Wire Line
	6050 4250 6600 4250
Connection ~ 6050 4050
$Comp
L Transistor_BJT:TIP120 Q1
U 1 1 5FCD1BB7
P 5650 3100
F 0 "Q1" H 5857 3146 50  0000 L CNN
F 1 "TIP120" H 5857 3055 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-220-3_Vertical" H 5850 3025 50  0001 L CIN
F 3 "https://www.onsemi.com/pub/Collateral/TIP120-D.PDF" H 5650 3100 50  0001 L CNN
	1    5650 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	5750 3300 6100 3300
$Comp
L Transistor_BJT:TIP120 Q2
U 1 1 5FCD3E5E
P 5650 4800
F 0 "Q2" H 5857 4846 50  0000 L CNN
F 1 "TIP120" H 5857 4755 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-220-3_Vertical" H 5850 4725 50  0001 L CIN
F 3 "https://www.onsemi.com/pub/Collateral/TIP120-D.PDF" H 5650 4800 50  0001 L CNN
	1    5650 4800
	1    0    0    -1  
$EndComp
Text Notes 5000 3300 0    50   ~ 0
Ibe = 5 mA
Wire Wire Line
	5750 2050 5750 2200
Wire Wire Line
	5750 2500 5750 2650
Text Notes 6100 2500 0    50   ~ 0
50 Ohm
Text Notes 5250 2750 0    50   ~ 0
680 Ohm
Text GLabel 2300 4500 0    50   Input ~ 0
3.3V
Wire Wire Line
	2350 4500 2300 4500
Wire Wire Line
	2900 4350 3050 4350
Wire Wire Line
	2800 4350 2650 4350
$Comp
L Switch:SW_Push SW1
U 1 1 5FC76C95
P 2850 4700
F 0 "SW1" H 2850 4985 50  0000 C CNN
F 1 "SW_Push" H 2850 4894 50  0000 C CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm" H 2850 4900 50  0001 C CNN
F 3 "~" H 2850 4900 50  0001 C CNN
	1    2850 4700
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x02_Male J2
U 1 1 5FC5BD29
P 2900 4150
F 0 "J2" H 3008 4331 50  0000 C CNN
F 1 "Solenoid B Override" V 3600 4050 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 2900 4150 50  0001 C CNN
F 3 "~" H 2900 4150 50  0001 C CNN
	1    2900 4150
	0    1    1    0   
$EndComp
Wire Wire Line
	3050 4350 3050 4500
Wire Wire Line
	3100 2550 3100 2750
$Comp
L Device:LED D4
U 1 1 5FD0B301
P 3350 4500
F 0 "D4" H 3343 4245 50  0000 C CNN
F 1 "LED" H 3343 4336 50  0000 C CNN
F 2 "LED_THT:LED_D5.0mm" H 3350 4500 50  0001 C CNN
F 3 "~" H 3350 4500 50  0001 C CNN
	1    3350 4500
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D3
U 1 1 5FD0FEA3
P 3350 3950
F 0 "D3" H 3343 3695 50  0000 C CNN
F 1 "LED" H 3343 3786 50  0000 C CNN
F 2 "LED_THT:LED_D5.0mm" H 3350 3950 50  0001 C CNN
F 3 "~" H 3350 3950 50  0001 C CNN
	1    3350 3950
	-1   0    0    1   
$EndComp
Wire Wire Line
	3200 4500 3050 4500
Connection ~ 3050 4500
Wire Wire Line
	3050 4500 3050 4700
$Comp
L Device:LED D1
U 1 1 5FD2214D
P 3350 2150
F 0 "D1" H 3350 1950 50  0000 C CNN
F 1 "LED" H 3350 2050 50  0000 C CNN
F 2 "LED_THT:LED_D5.0mm" H 3350 2150 50  0001 C CNN
F 3 "~" H 3350 2150 50  0001 C CNN
	1    3350 2150
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D2
U 1 1 5FD23002
P 3350 2750
F 0 "D2" H 3350 2550 50  0000 C CNN
F 1 "LED" H 3350 2650 50  0000 C CNN
F 2 "LED_THT:LED_D5.0mm" H 3350 2750 50  0001 C CNN
F 3 "~" H 3350 2750 50  0001 C CNN
	1    3350 2750
	-1   0    0    1   
$EndComp
Wire Wire Line
	3100 2750 3200 2750
Connection ~ 3100 2750
Wire Wire Line
	3100 2750 3100 2900
Wire Wire Line
	4800 4500 4800 4800
Wire Wire Line
	4800 4800 5150 4800
Wire Wire Line
	4800 3750 4800 4300
Wire Wire Line
	4800 2050 4800 2550
Wire Wire Line
	4800 2750 4800 3100
Wire Wire Line
	4800 3100 5150 3100
Wire Wire Line
	1600 1100 1600 1200
Connection ~ 1600 1200
Wire Wire Line
	1600 1200 1450 1200
Wire Wire Line
	1450 1500 1600 1500
Wire Wire Line
	1600 1500 1600 1650
Connection ~ 1600 1500
Wire Wire Line
	4100 3100 4100 2750
Wire Wire Line
	4100 2750 4200 2750
Wire Wire Line
	4100 4800 4100 4500
Wire Wire Line
	4100 4500 4200 4500
Text Notes 700  5350 0    50   ~ 10
Note:\nDue to the low voltage of the teensy, the series forward voltages\nof the diodes must stay low. I.e. only use red LEDs to keep Vf of\nD5/D6+optocoupler diode close to or below 3.3V.
$Comp
L power:PWR_FLAG #FLG04
U 1 1 5FD1B56E
P 8350 1350
F 0 "#FLG04" H 8350 1425 50  0001 C CNN
F 1 "PWR_FLAG" H 8350 1523 50  0000 C CNN
F 2 "" H 8350 1350 50  0001 C CNN
F 3 "~" H 8350 1350 50  0001 C CNN
	1    8350 1350
	-1   0    0    1   
$EndComp
Connection ~ 8350 1350
Wire Wire Line
	8350 1350 8000 1350
$Comp
L power:PWR_FLAG #FLG01
U 1 1 5FD1BB0E
P 1900 1100
F 0 "#FLG01" H 1900 1175 50  0001 C CNN
F 1 "PWR_FLAG" H 1900 1273 50  0000 C CNN
F 2 "" H 1900 1100 50  0001 C CNN
F 3 "~" H 1900 1100 50  0001 C CNN
	1    1900 1100
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG02
U 1 1 5FD1CEE5
P 1900 1650
F 0 "#FLG02" H 1900 1725 50  0001 C CNN
F 1 "PWR_FLAG" H 1900 1823 50  0000 C CNN
F 2 "" H 1900 1650 50  0001 C CNN
F 3 "~" H 1900 1650 50  0001 C CNN
	1    1900 1650
	-1   0    0    1   
$EndComp
Wire Wire Line
	1600 1200 1900 1200
Wire Wire Line
	1600 1500 1900 1500
Wire Wire Line
	1900 1100 1900 1200
Connection ~ 1900 1200
Wire Wire Line
	1900 1200 1950 1200
Wire Wire Line
	1900 1650 1900 1500
Connection ~ 1900 1500
Wire Wire Line
	1900 1500 1950 1500
Wire Wire Line
	2700 2550 2700 2700
$Comp
L Device:R R2
U 1 1 5FCE7F06
P 2550 2700
F 0 "R2" V 2343 2700 50  0000 C CNN
F 1 "220" V 2434 2700 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 2480 2700 50  0001 C CNN
F 3 "~" H 2550 2700 50  0001 C CNN
	1    2550 2700
	0    1    1    0   
$EndComp
Connection ~ 2700 2700
Wire Wire Line
	2700 2700 2700 2900
Wire Wire Line
	2700 2150 3200 2150
Wire Wire Line
	3600 2150 3600 2550
Wire Wire Line
	2350 2150 2400 2150
Wire Wire Line
	3500 2150 3600 2150
Wire Wire Line
	3500 2750 3600 2750
Connection ~ 3600 2750
Wire Wire Line
	4200 2550 3600 2550
Connection ~ 3600 2550
Wire Wire Line
	3600 2550 3600 2750
Wire Wire Line
	3600 2750 3700 2750
Wire Wire Line
	4000 2750 4100 2750
Connection ~ 4100 2750
Wire Wire Line
	2650 4350 2650 4500
Connection ~ 2650 4500
Wire Wire Line
	2650 4500 2650 4700
$Comp
L Device:R R4
U 1 1 5FD13306
P 2500 3950
F 0 "R4" V 2293 3950 50  0000 C CNN
F 1 "220" V 2384 3950 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 2430 3950 50  0001 C CNN
F 3 "~" H 2500 3950 50  0001 C CNN
	1    2500 3950
	0    1    1    0   
$EndComp
Wire Wire Line
	2300 3950 2350 3950
Wire Wire Line
	2650 3950 3200 3950
Wire Wire Line
	3500 3950 3600 3950
Wire Wire Line
	3600 3950 3600 4300
Wire Wire Line
	3600 4500 3500 4500
Wire Wire Line
	3600 4500 3700 4500
Connection ~ 3600 4500
Wire Wire Line
	3600 4300 4200 4300
Connection ~ 3600 4300
Wire Wire Line
	3600 4300 3600 4500
Wire Wire Line
	4000 4500 4100 4500
Connection ~ 4100 4500
$EndSCHEMATC

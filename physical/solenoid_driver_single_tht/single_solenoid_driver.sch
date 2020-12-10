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
L Connector:Conn_01x02_Male J5
U 1 1 5FC04111
P 7450 1250
F 0 "J5" H 7558 1431 50  0000 C CNN
F 1 "12V Input" H 7450 1050 50  0000 C CNN
F 2 "TerminalBlock_MetzConnect:TerminalBlock_MetzConnect_Type055_RT01502HDWU_1x02_P5.00mm_Horizontal" H 7450 1250 50  0001 C CNN
F 3 "~" H 7450 1250 50  0001 C CNN
	1    7450 1250
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x02_Male J4
U 1 1 5FC0524C
P 6800 2650
F 0 "J4" H 6650 2600 50  0000 C CNN
F 1 "Solenoid" H 6800 2750 50  0000 C CNN
F 2 "Connector_JST:JST_EH_B2B-EH-A_1x02_P2.50mm_Vertical" H 6800 2650 50  0001 C CNN
F 3 "~" H 6800 2650 50  0001 C CNN
	1    6800 2650
	-1   0    0    1   
$EndComp
$Comp
L Diode:1N4004 D4
U 1 1 5FC07612
P 5750 2350
F 0 "D4" V 5750 2100 50  0000 L CNN
F 1 "1N4004" V 5850 2000 50  0000 L CNN
F 2 "Diode_THT:D_DO-41_SOD81_P10.16mm_Horizontal" H 5750 2175 50  0001 C CNN
F 3 "http://www.vishay.com/docs/88503/1n4001.pdf" H 5750 2350 50  0001 C CNN
	1    5750 2350
	0    1    1    0   
$EndComp
$Comp
L Device:R R5
U 1 1 5FC0A550
P 5300 3100
F 0 "R5" V 5350 2900 50  0000 C CNN
F 1 "2.2k" V 5184 3100 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 5230 3100 50  0001 C CNN
F 3 "~" H 5300 3100 50  0001 C CNN
	1    5300 3100
	0    1    1    0   
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
L Connector:Conn_01x02_Male J2
U 1 1 5FC5B103
P 2750 2350
F 0 "J2" H 2858 2531 50  0000 C CNN
F 1 "Manual/External Trigger" V 3300 1450 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 2750 2350 50  0001 C CNN
F 3 "~" H 2750 2350 50  0001 C CNN
	1    2750 2350
	0    1    1    0   
$EndComp
$Comp
L Device:R R2
U 1 1 5FC66B38
P 2350 2700
F 0 "R2" V 2150 2700 50  0000 C CNN
F 1 "220" V 2250 2700 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 2280 2700 50  0001 C CNN
F 3 "~" H 2350 2700 50  0001 C CNN
	1    2350 2700
	0    1    1    0   
$EndComp
$Comp
L Switch:SW_Push SW1
U 1 1 5FC75DBA
P 2700 2900
F 0 "SW1" H 2700 3185 50  0000 C CNN
F 1 "SW_Push" H 2700 3094 50  0000 C CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm" H 2700 3100 50  0001 C CNN
F 3 "~" H 2700 3100 50  0001 C CNN
	1    2700 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	2650 2550 2500 2550
Wire Wire Line
	2500 2550 2500 2700
Wire Wire Line
	2750 2550 2900 2550
Connection ~ 2500 2700
Wire Wire Line
	2500 2700 2500 2900
Wire Wire Line
	2200 2700 2150 2700
$Comp
L Device:R R3
U 1 1 5FC96289
P 3800 2750
F 0 "R3" V 3900 2750 50  0000 C CNN
F 1 "10k" V 4000 2750 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 3730 2750 50  0001 C CNN
F 3 "~" H 3800 2750 50  0001 C CNN
	1    3800 2750
	0    1    1    0   
$EndComp
Text Notes 2150 6150 0    118  ~ 24
Low voltage Teensy side
Wire Notes Line width 39
	4500 750  4500 6650
Text GLabel 1950 1200 2    50   Input ~ 0
3.3V
Text GLabel 1450 1300 2    50   Input ~ 0
InputA
Text GLabel 1950 1400 2    50   Input ~ 0
TeensyGND
Text GLabel 2150 2200 0    50   Input ~ 0
InputA
Text GLabel 2150 2700 0    50   Input ~ 0
3.3V
Text Notes 4000 2250 0    50   ~ 0
If = 5 mA
Text Notes 2450 3050 0    50   ~ 0
Ibtn = 3.3mA
Text GLabel 4100 3000 3    50   Input ~ 0
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
Text GLabel 5750 3400 3    50   Input ~ 0
GNDPWR
Text GLabel 5750 1950 1    50   Input ~ 0
12V
$Comp
L power:GND #PWR02
U 1 1 5FD51680
P 1600 1550
F 0 "#PWR02" H 1600 1300 50  0001 C CNN
F 1 "GND" H 1600 1400 50  0000 C CNN
F 2 "" H 1600 1550 50  0001 C CNN
F 3 "" H 1600 1550 50  0001 C CNN
	1    1600 1550
	1    0    0    -1  
$EndComp
Connection ~ 5750 2650
$Comp
L Device:LED D3
U 1 1 5FC9FC75
P 5150 2500
F 0 "D3" V 5189 2382 50  0000 R CNN
F 1 "LED" V 5098 2382 50  0000 R CNN
F 2 "LED_THT:LED_D5.0mm" H 5150 2500 50  0001 C CNN
F 3 "~" H 5150 2500 50  0001 C CNN
	1    5150 2500
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R4
U 1 1 5FCA3368
P 5150 2200
F 0 "R4" H 5080 2154 50  0000 R CNN
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
L Device:R Rsense1
U 1 1 5FCA57F7
P 6050 2200
F 0 "Rsense1" H 6120 2246 50  0000 L CNN
F 1 "1" H 6120 2155 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 5980 2200 50  0001 C CNN
F 3 "~" H 6050 2200 50  0001 C CNN
	1    6050 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	6050 2350 6600 2350
Text Notes 6200 1950 0    50   ~ 0
Isense = 1V/1A
Wire Wire Line
	5750 2650 6600 2650
$Comp
L Connector:Conn_01x02_Male J3
U 1 1 5FCBC7C0
P 6800 2250
F 0 "J3" H 6650 2250 50  0000 C CNN
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
Wire Wire Line
	2900 2550 2900 2750
$Comp
L Device:LED D1
U 1 1 5FD2214D
P 3150 2200
F 0 "D1" H 3150 2000 50  0000 C CNN
F 1 "LED" H 3150 2100 50  0000 C CNN
F 2 "LED_THT:LED_D5.0mm" H 3150 2200 50  0001 C CNN
F 3 "~" H 3150 2200 50  0001 C CNN
	1    3150 2200
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D2
U 1 1 5FD23002
P 3150 2750
F 0 "D2" H 3150 2550 50  0000 C CNN
F 1 "LED" H 3150 2650 50  0000 C CNN
F 2 "LED_THT:LED_D5.0mm" H 3150 2750 50  0001 C CNN
F 3 "~" H 3150 2750 50  0001 C CNN
	1    3150 2750
	-1   0    0    1   
$EndComp
Wire Wire Line
	2900 2750 3000 2750
Connection ~ 2900 2750
Wire Wire Line
	2900 2750 2900 2900
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
	1450 1400 1600 1400
Wire Wire Line
	1600 1400 1600 1550
Connection ~ 1600 1400
Text Notes 650  3600 0    50   ~ 0
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
P 1900 1550
F 0 "#FLG02" H 1900 1625 50  0001 C CNN
F 1 "PWR_FLAG" H 1900 1723 50  0000 C CNN
F 2 "" H 1900 1550 50  0001 C CNN
F 3 "~" H 1900 1550 50  0001 C CNN
	1    1900 1550
	-1   0    0    1   
$EndComp
Wire Wire Line
	1600 1200 1900 1200
Wire Wire Line
	1600 1400 1900 1400
Wire Wire Line
	1900 1100 1900 1200
Connection ~ 1900 1200
Wire Wire Line
	1900 1200 1950 1200
Wire Wire Line
	1900 1550 1900 1400
Connection ~ 1900 1400
Wire Wire Line
	1900 1400 1950 1400
$Comp
L Isolator:TLP785 U1
U 1 1 5FCD9CDB
P 4500 2650
F 0 "U1" H 4350 2950 50  0000 C CNN
F 1 "TLP785" H 4250 2850 50  0000 C CNN
F 2 "Package_DIP:DIP-4_W7.62mm" H 4300 2450 50  0001 L CIN
F 3 "https://toshiba.semicon-storage.com/info/docget.jsp?did=10569&prodName=TLP785" H 4500 2650 50  0001 L CNN
	1    4500 2650
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x03_Male J1
U 1 1 5FCE089A
P 1250 1300
F 0 "J1" H 1222 1232 50  0000 R CNN
F 1 "Input" H 1222 1323 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Horizontal" H 1250 1300 50  0001 C CNN
F 3 "~" H 1250 1300 50  0001 C CNN
	1    1250 1300
	1    0    0    1   
$EndComp
$Comp
L Transistor_BJT:PN2222A Q1
U 1 1 5FCE56C0
P 5650 3100
F 0 "Q1" H 5840 3146 50  0000 L CNN
F 1 "PN2222A" H 5840 3055 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 5850 3025 50  0001 L CIN
F 3 "https://www.onsemi.com/pub/Collateral/PN2222-D.PDF" H 5650 3100 50  0001 L CNN
	1    5650 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	5750 3400 5750 3300
$Comp
L Device:R R1
U 1 1 5FCE8316
P 2350 2200
F 0 "R1" V 2143 2200 50  0000 C CNN
F 1 "220" V 2234 2200 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 2280 2200 50  0001 C CNN
F 3 "~" H 2350 2200 50  0001 C CNN
	1    2350 2200
	0    1    1    0   
$EndComp
Wire Wire Line
	3500 2200 3500 2550
Wire Wire Line
	3500 2750 3650 2750
Wire Wire Line
	4200 2550 3500 2550
Connection ~ 3500 2550
Wire Wire Line
	3500 2550 3500 2750
Wire Wire Line
	3300 2200 3500 2200
Wire Wire Line
	3300 2750 3500 2750
Connection ~ 3500 2750
Wire Wire Line
	3950 2750 4100 2750
Wire Wire Line
	4100 2750 4100 3000
Connection ~ 4100 2750
Wire Wire Line
	4100 2750 4200 2750
Wire Wire Line
	2500 2200 3000 2200
Wire Wire Line
	2150 2200 2200 2200
$EndSCHEMATC

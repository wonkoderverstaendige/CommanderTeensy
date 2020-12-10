EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector:Conn_01x04_Male J1
U 1 1 5FC93F78
P 2300 1650
F 0 "J1" H 2400 1350 50  0000 C CNN
F 1 "Input Header" H 2400 1250 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Horizontal" H 2300 1650 50  0001 C CNN
F 3 "~" H 2300 1650 50  0001 C CNN
	1    2300 1650
	1    0    0    -1  
$EndComp
Text GLabel 2950 1550 2    50   UnSpc ~ 0
3.3V
Text GLabel 2700 1650 2    50   Input ~ 0
InputA
Text GLabel 2700 1750 2    50   Input ~ 0
InputB
Text GLabel 2950 1850 2    50   UnSpc ~ 0
TeensyGND
Wire Wire Line
	2950 1550 2700 1550
Wire Wire Line
	2500 1850 2700 1850
$Comp
L power:GND #PWR0101
U 1 1 5FC950D1
P 2700 2050
F 0 "#PWR0101" H 2700 1800 50  0001 C CNN
F 1 "GND" H 2705 1877 50  0000 C CNN
F 2 "" H 2700 2050 50  0001 C CNN
F 3 "" H 2700 2050 50  0001 C CNN
	1    2700 2050
	1    0    0    -1  
$EndComp
Wire Wire Line
	2700 2050 2700 2000
Connection ~ 2700 1850
Wire Wire Line
	2700 1850 2950 1850
$Comp
L power:+3.3V #PWR0102
U 1 1 5FC95739
P 2700 1350
F 0 "#PWR0102" H 2700 1200 50  0001 C CNN
F 1 "+3.3V" H 2715 1523 50  0000 C CNN
F 2 "" H 2700 1350 50  0001 C CNN
F 3 "" H 2700 1350 50  0001 C CNN
	1    2700 1350
	1    0    0    -1  
$EndComp
Wire Wire Line
	2700 1350 2700 1400
Connection ~ 2700 1550
Wire Wire Line
	2700 1550 2500 1550
Wire Wire Line
	2700 1650 2500 1650
Wire Wire Line
	2500 1750 2700 1750
$Comp
L Switch:SW_Push SW1
U 1 1 5FC95FF1
P 2550 3350
F 0 "SW1" H 2550 3150 50  0000 C CNN
F 1 "man_trig_A" H 2550 3250 50  0000 C CNN
F 2 "Button_Switch_SMD:SW_SPST_TL3305A" H 2550 3550 50  0001 C CNN
F 3 "~" H 2550 3550 50  0001 C CNN
	1    2550 3350
	1    0    0    -1  
$EndComp
$Comp
L Device:R R1
U 1 1 5FC97670
P 2050 3350
F 0 "R1" V 1843 3350 50  0000 C CNN
F 1 "1k" V 1934 3350 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric" V 1980 3350 50  0001 C CNN
F 3 "~" H 2050 3350 50  0001 C CNN
	1    2050 3350
	0    1    1    0   
$EndComp
Wire Wire Line
	1800 3350 1900 3350
Text GLabel 1800 3350 0    50   UnSpc ~ 0
3.3V
$Comp
L Connector:Conn_01x02_Male J2
U 1 1 5FC98385
P 2600 2700
F 0 "J2" V 2662 2744 50  0000 L CNN
F 1 "ext_trig_A" V 2753 2744 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 2600 2700 50  0001 C CNN
F 3 "~" H 2600 2700 50  0001 C CNN
	1    2600 2700
	0    1    1    0   
$EndComp
Wire Wire Line
	2600 2900 2750 2900
Wire Wire Line
	2750 2900 2750 3350
Wire Wire Line
	2200 3350 2350 3350
Wire Wire Line
	2500 2900 2350 2900
Wire Wire Line
	2350 2900 2350 3350
Connection ~ 2350 3350
Text Notes 2150 3500 2    50   ~ 0
Itb = 3.3mA
$Comp
L Device:R R3
U 1 1 5FC9A0FC
P 2950 3600
F 0 "R3" H 3020 3646 50  0000 L CNN
F 1 "10k" H 3020 3555 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric" V 2880 3600 50  0001 C CNN
F 3 "~" H 2950 3600 50  0001 C CNN
	1    2950 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	2750 3350 2950 3350
Wire Wire Line
	2950 3350 2950 3450
Connection ~ 2750 3350
Wire Wire Line
	2950 3350 3500 3350
Connection ~ 2950 3350
Text GLabel 3350 3250 0    50   Input ~ 0
InputA
Wire Wire Line
	3350 3250 3500 3250
Text GLabel 3800 2850 1    50   UnSpc ~ 0
3.3V
Wire Wire Line
	3800 2850 3800 3200
Wire Wire Line
	3800 3800 2950 3800
Wire Wire Line
	2950 3800 2950 3750
Wire Wire Line
	3800 3400 3800 3800
Text GLabel 3650 4000 0    50   UnSpc ~ 0
TeensyGND
Wire Wire Line
	3800 3800 3800 4000
Connection ~ 3800 3800
Wire Wire Line
	3650 4000 3800 4000
$Comp
L Device:R R5
U 1 1 5FC9E7F9
P 4300 3300
F 0 "R5" V 4093 3300 50  0000 C CNN
F 1 "220" V 4184 3300 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric" V 4230 3300 50  0001 C CNN
F 3 "~" H 4300 3300 50  0001 C CNN
	1    4300 3300
	0    1    1    0   
$EndComp
Wire Wire Line
	4050 3300 4150 3300
Wire Wire Line
	4450 3300 4550 3300
Wire Wire Line
	4550 3500 4550 3800
Wire Wire Line
	4550 3800 3800 3800
$Comp
L Switch:SW_Push SW2
U 1 1 5FCA78E1
P 2550 5100
F 0 "SW2" H 2550 4900 50  0000 C CNN
F 1 "man_trig_B" H 2550 5000 50  0000 C CNN
F 2 "Button_Switch_SMD:SW_SPST_TL3305A" H 2550 5300 50  0001 C CNN
F 3 "~" H 2550 5300 50  0001 C CNN
	1    2550 5100
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5FCA78E7
P 2050 5100
F 0 "R2" V 1843 5100 50  0000 C CNN
F 1 "1k" V 1934 5100 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric" V 1980 5100 50  0001 C CNN
F 3 "~" H 2050 5100 50  0001 C CNN
	1    2050 5100
	0    1    1    0   
$EndComp
Wire Wire Line
	1800 5100 1900 5100
Text GLabel 1800 5100 0    50   UnSpc ~ 0
3.3V
$Comp
L Connector:Conn_01x02_Male J3
U 1 1 5FCA78EF
P 2600 4450
F 0 "J3" V 2662 4494 50  0000 L CNN
F 1 "ext_trig_B" V 2753 4494 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 2600 4450 50  0001 C CNN
F 3 "~" H 2600 4450 50  0001 C CNN
	1    2600 4450
	0    1    1    0   
$EndComp
Wire Wire Line
	2600 4650 2750 4650
Wire Wire Line
	2750 4650 2750 5100
Wire Wire Line
	2200 5100 2350 5100
Wire Wire Line
	2500 4650 2350 4650
Wire Wire Line
	2350 4650 2350 5100
Connection ~ 2350 5100
$Comp
L Device:R R4
U 1 1 5FCA78FC
P 2950 5350
F 0 "R4" H 3020 5396 50  0000 L CNN
F 1 "10k" H 3020 5305 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric" V 2880 5350 50  0001 C CNN
F 3 "~" H 2950 5350 50  0001 C CNN
	1    2950 5350
	1    0    0    -1  
$EndComp
Wire Wire Line
	2750 5100 2950 5100
Wire Wire Line
	2950 5100 2950 5200
Connection ~ 2750 5100
Wire Wire Line
	2950 5100 3500 5100
Connection ~ 2950 5100
Wire Wire Line
	3350 5000 3500 5000
Text GLabel 3800 4600 1    50   UnSpc ~ 0
3.3V
Wire Wire Line
	3800 4600 3800 4950
Wire Wire Line
	3800 5550 2950 5550
Wire Wire Line
	2950 5550 2950 5500
Wire Wire Line
	3800 5150 3800 5550
Text GLabel 3650 5750 0    50   UnSpc ~ 0
TeensyGND
Wire Wire Line
	3800 5550 3800 5750
Connection ~ 3800 5550
Wire Wire Line
	3650 5750 3800 5750
$Comp
L Device:R R6
U 1 1 5FCA7918
P 4300 5050
F 0 "R6" V 4093 5050 50  0000 C CNN
F 1 "220" V 4184 5050 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric" V 4230 5050 50  0001 C CNN
F 3 "~" H 4300 5050 50  0001 C CNN
	1    4300 5050
	0    1    1    0   
$EndComp
Wire Wire Line
	4050 5050 4150 5050
Wire Wire Line
	4450 5050 4550 5050
Wire Wire Line
	4550 5250 4550 5550
Wire Wire Line
	4550 5550 3800 5550
$Comp
L 74xGxx:74LVC2G32 U1
U 1 1 5FC9B6D6
P 3800 3300
F 0 "U1" H 3775 3567 50  0000 C CNN
F 1 "74LVC2G32" H 3775 3476 50  0000 C CNN
F 2 "Package_SO:SSOP-8_2.95x2.8mm_P0.65mm" H 3800 3300 50  0001 C CNN
F 3 "http://www.ti.com/lit/sg/scyt129e/scyt129e.pdf" H 3800 3300 50  0001 C CNN
	1    3800 3300
	1    0    0    -1  
$EndComp
$Comp
L Isolator:ILD74 U2
U 2 1 5FCA8553
P 4850 5150
F 0 "U2" H 4700 5500 50  0000 C CNN
F 1 "MCT62H" H 4700 5400 50  0000 C CNN
F 2 "Package_DIP:DIP-8_W8.89mm_SMDSocket_LongPads" H 4650 4950 50  0001 L CIN
F 3 "" H 4850 5150 50  0001 L CNN
	2    4850 5150
	1    0    0    -1  
$EndComp
$Comp
L 74xGxx:74LVC2G32 U1
U 2 1 5FCA908D
P 3800 5050
F 0 "U1" H 3775 5317 50  0000 C CNN
F 1 "74LVC2G32" H 3775 5226 50  0000 C CNN
F 2 "Package_SO:SSOP-8_2.95x2.8mm_P0.65mm" H 3800 5050 50  0001 C CNN
F 3 "http://www.ti.com/lit/sg/scyt129e/scyt129e.pdf" H 3800 5050 50  0001 C CNN
	2    3800 5050
	1    0    0    -1  
$EndComp
$Comp
L Isolator:ILD74 U2
U 1 1 5FC9F95A
P 4850 3400
F 0 "U2" H 4700 3750 50  0000 C CNN
F 1 "MCT62H" H 4700 3650 50  0000 C CNN
F 2 "Package_DIP:DIP-8_W8.89mm_SMDSocket_LongPads" H 4650 3200 50  0001 L CIN
F 3 "" H 4850 3400 50  0001 L CNN
	1    4850 3400
	1    0    0    -1  
$EndComp
$Comp
L Device:R R9
U 1 1 5FCABBDA
P 5650 2650
F 0 "R9" H 5720 2696 50  0000 L CNN
F 1 "680" H 5720 2605 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric" V 5580 2650 50  0001 C CNN
F 3 "~" H 5650 2650 50  0001 C CNN
	1    5650 2650
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D1
U 1 1 5FCAC85B
P 5650 2950
F 0 "D1" V 5689 2832 50  0000 R CNN
F 1 "LED" V 5598 2832 50  0000 R CNN
F 2 "LED_SMD:LED_1206_3216Metric" H 5650 2950 50  0001 C CNN
F 3 "~" H 5650 2950 50  0001 C CNN
	1    5650 2950
	0    -1   -1   0   
$EndComp
$Comp
L Diode:1N4004 D3
U 1 1 5FCADB4F
P 6150 2800
F 0 "D3" V 6104 2880 50  0000 L CNN
F 1 "1N4004" V 6195 2880 50  0000 L CNN
F 2 "Diode_THT:D_DO-41_SOD81_P10.16mm_Horizontal" H 6150 2625 50  0001 C CNN
F 3 "http://www.vishay.com/docs/88503/1n4001.pdf" H 6150 2800 50  0001 C CNN
	1    6150 2800
	0    1    1    0   
$EndComp
$Comp
L Connector:Conn_01x02_Male J5
U 1 1 5FCB01DA
P 6950 2850
F 0 "J5" H 6922 2732 50  0000 R CNN
F 1 "SolenoidA" H 6922 2823 50  0000 R CNN
F 2 "Connector_JST:JST_EH_B2B-EH-A_1x02_P2.50mm_Vertical" H 6950 2850 50  0001 C CNN
F 3 "~" H 6950 2850 50  0001 C CNN
	1    6950 2850
	-1   0    0    1   
$EndComp
Wire Wire Line
	6150 2650 6750 2650
Wire Wire Line
	6750 2650 6750 2750
Wire Wire Line
	6150 2950 6750 2950
Wire Wire Line
	6750 2950 6750 2850
Wire Wire Line
	6150 2500 6150 2650
Connection ~ 6150 2650
Wire Wire Line
	6150 2950 6150 3200
Wire Wire Line
	6150 3200 5950 3200
Wire Wire Line
	5650 3200 5650 3100
Connection ~ 6150 2950
Wire Wire Line
	5150 2500 5650 2500
Connection ~ 5650 2500
Wire Wire Line
	5150 2500 5150 3300
$Comp
L Connector:Conn_01x02_Male J4
U 1 1 5FCBCB45
P 5850 1650
F 0 "J4" H 5958 1831 50  0000 C CNN
F 1 "PWR12V" H 5958 1740 50  0000 C CNN
F 2 "TerminalBlock_MetzConnect:TerminalBlock_MetzConnect_Type055_RT01502HDWU_1x02_P5.00mm_Horizontal" H 5850 1650 50  0001 C CNN
F 3 "~" H 5850 1650 50  0001 C CNN
	1    5850 1650
	1    0    0    -1  
$EndComp
$Comp
L power:+12V #PWR0103
U 1 1 5FCBE162
P 6500 1300
F 0 "#PWR0103" H 6500 1150 50  0001 C CNN
F 1 "+12V" H 6515 1473 50  0000 C CNN
F 2 "" H 6500 1300 50  0001 C CNN
F 3 "" H 6500 1300 50  0001 C CNN
	1    6500 1300
	1    0    0    -1  
$EndComp
$Comp
L power:GNDPWR #PWR0104
U 1 1 5FCBEC4C
P 6500 1900
F 0 "#PWR0104" H 6500 1700 50  0001 C CNN
F 1 "GNDPWR" H 6504 1746 50  0000 C CNN
F 2 "" H 6500 1850 50  0001 C CNN
F 3 "" H 6500 1850 50  0001 C CNN
	1    6500 1900
	1    0    0    -1  
$EndComp
Wire Wire Line
	6050 1750 6500 1750
Wire Wire Line
	6500 1750 6500 1850
Wire Wire Line
	6050 1650 6500 1650
Wire Wire Line
	6500 1650 6500 1450
Text GLabel 6750 1650 2    50   UnSpc ~ 0
12V
Text GLabel 6750 1750 2    50   UnSpc ~ 0
GNDPWR
Wire Wire Line
	6750 1650 6500 1650
Connection ~ 6500 1650
Wire Wire Line
	6500 1750 6750 1750
Connection ~ 6500 1750
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 5FCC4283
P 6500 1450
F 0 "#FLG0101" H 6500 1525 50  0001 C CNN
F 1 "PWR_FLAG" V 6500 1578 50  0000 L CNN
F 2 "" H 6500 1450 50  0001 C CNN
F 3 "~" H 6500 1450 50  0001 C CNN
	1    6500 1450
	0    1    1    0   
$EndComp
Connection ~ 6500 1450
Wire Wire Line
	6500 1450 6500 1300
Wire Notes Line width 24 rgb(0, 0, 255)
	4850 1300 4850 6350
$Comp
L Transistor_FET:2N7002K Q1
U 1 1 5FCC70B1
P 5850 3500
F 0 "Q1" H 6054 3546 50  0000 L CNN
F 1 "2N7002K" H 6054 3455 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 6050 3425 50  0001 L CIN
F 3 "https://www.diodes.com/assets/Datasheets/ds30896.pdf" H 5850 3500 50  0001 L CNN
	1    5850 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 2500 6150 2500
Wire Wire Line
	5950 3200 5950 3300
Connection ~ 5950 3200
Wire Wire Line
	5950 3200 5650 3200
Text GLabel 6050 3800 2    50   UnSpc ~ 0
GNDPWR
Wire Wire Line
	5950 3700 5950 3800
Wire Wire Line
	5950 3800 6050 3800
$Comp
L Device:R R7
U 1 1 5FCD0680
P 5400 3800
F 0 "R7" V 5193 3800 50  0000 C CNN
F 1 "10k" V 5284 3800 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric" V 5330 3800 50  0001 C CNN
F 3 "~" H 5400 3800 50  0001 C CNN
	1    5400 3800
	0    1    1    0   
$EndComp
Wire Wire Line
	5250 3800 5200 3800
Wire Wire Line
	5200 3800 5200 3500
Connection ~ 5200 3500
Wire Wire Line
	5200 3500 5150 3500
Wire Wire Line
	5550 3800 5950 3800
Connection ~ 5950 3800
Wire Wire Line
	5200 3500 5650 3500
$Comp
L Device:R R10
U 1 1 5FCDF065
P 5650 4400
F 0 "R10" H 5720 4446 50  0000 L CNN
F 1 "680" H 5720 4355 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric" V 5580 4400 50  0001 C CNN
F 3 "~" H 5650 4400 50  0001 C CNN
	1    5650 4400
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D2
U 1 1 5FCDF06B
P 5650 4700
F 0 "D2" V 5689 4582 50  0000 R CNN
F 1 "LED" V 5598 4582 50  0000 R CNN
F 2 "LED_SMD:LED_1206_3216Metric" H 5650 4700 50  0001 C CNN
F 3 "~" H 5650 4700 50  0001 C CNN
	1    5650 4700
	0    -1   -1   0   
$EndComp
$Comp
L Diode:1N4004 D4
U 1 1 5FCDF071
P 6150 4550
F 0 "D4" V 6104 4630 50  0000 L CNN
F 1 "1N4004" V 6195 4630 50  0000 L CNN
F 2 "Diode_THT:D_DO-41_SOD81_P10.16mm_Horizontal" H 6150 4375 50  0001 C CNN
F 3 "http://www.vishay.com/docs/88503/1n4001.pdf" H 6150 4550 50  0001 C CNN
	1    6150 4550
	0    1    1    0   
$EndComp
$Comp
L Connector:Conn_01x02_Male J6
U 1 1 5FCDF077
P 6950 4600
F 0 "J6" H 6922 4482 50  0000 R CNN
F 1 "SolenoidB" H 6922 4573 50  0000 R CNN
F 2 "Connector_JST:JST_EH_B2B-EH-A_1x02_P2.50mm_Vertical" H 6950 4600 50  0001 C CNN
F 3 "~" H 6950 4600 50  0001 C CNN
	1    6950 4600
	-1   0    0    1   
$EndComp
Wire Wire Line
	6150 4400 6750 4400
Wire Wire Line
	6750 4400 6750 4500
Wire Wire Line
	6150 4700 6750 4700
Wire Wire Line
	6750 4700 6750 4600
Wire Wire Line
	6150 4250 6150 4400
Connection ~ 6150 4400
Wire Wire Line
	6150 4700 6150 4950
Wire Wire Line
	6150 4950 5950 4950
Wire Wire Line
	5650 4950 5650 4850
Connection ~ 6150 4700
Wire Wire Line
	5150 4250 5650 4250
Connection ~ 5650 4250
$Comp
L Transistor_FET:2N7002K Q2
U 1 1 5FCDF089
P 5850 5250
F 0 "Q2" H 6054 5296 50  0000 L CNN
F 1 "2N7002K" H 6054 5205 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 6050 5175 50  0001 L CIN
F 3 "https://www.diodes.com/assets/Datasheets/ds30896.pdf" H 5850 5250 50  0001 L CNN
	1    5850 5250
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 4250 6150 4250
Wire Wire Line
	5950 4950 5950 5050
Connection ~ 5950 4950
Wire Wire Line
	5950 4950 5650 4950
Text GLabel 6050 5550 2    50   UnSpc ~ 0
GNDPWR
Wire Wire Line
	5950 5450 5950 5550
Wire Wire Line
	5950 5550 6050 5550
$Comp
L Device:R R8
U 1 1 5FCDF096
P 5400 5550
F 0 "R8" V 5193 5550 50  0000 C CNN
F 1 "10k" V 5284 5550 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric" V 5330 5550 50  0001 C CNN
F 3 "~" H 5400 5550 50  0001 C CNN
	1    5400 5550
	0    1    1    0   
$EndComp
Wire Wire Line
	5550 5550 5950 5550
Connection ~ 5950 5550
Wire Wire Line
	5150 5250 5200 5250
Wire Wire Line
	5150 5050 5150 4250
Wire Wire Line
	5250 5550 5200 5550
Wire Wire Line
	5200 5550 5200 5250
Connection ~ 5200 5250
Wire Wire Line
	5200 5250 5650 5250
Text GLabel 3350 5000 0    50   Input ~ 0
InputB
Text GLabel 5650 2200 1    50   UnSpc ~ 0
12V
Wire Wire Line
	5650 2200 5650 2500
Text GLabel 5650 4050 1    50   UnSpc ~ 0
12V
Wire Wire Line
	5650 4050 5650 4250
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 5FD04DED
P 6500 1850
F 0 "#FLG0102" H 6500 1925 50  0001 C CNN
F 1 "PWR_FLAG" V 6500 1978 50  0000 L CNN
F 2 "" H 6500 1850 50  0001 C CNN
F 3 "~" H 6500 1850 50  0001 C CNN
	1    6500 1850
	0    1    1    0   
$EndComp
Connection ~ 6500 1850
Wire Wire Line
	6500 1850 6500 1900
$Comp
L power:PWR_FLAG #FLG0103
U 1 1 5FD0594F
P 2700 2000
F 0 "#FLG0103" H 2700 2075 50  0001 C CNN
F 1 "PWR_FLAG" V 2700 2128 50  0000 L CNN
F 2 "" H 2700 2000 50  0001 C CNN
F 3 "~" H 2700 2000 50  0001 C CNN
	1    2700 2000
	0    1    1    0   
$EndComp
Connection ~ 2700 2000
Wire Wire Line
	2700 2000 2700 1850
$Comp
L power:PWR_FLAG #FLG0104
U 1 1 5FD05D58
P 2700 1400
F 0 "#FLG0104" H 2700 1475 50  0001 C CNN
F 1 "PWR_FLAG" V 2700 1528 50  0000 L CNN
F 2 "" H 2700 1400 50  0001 C CNN
F 3 "~" H 2700 1400 50  0001 C CNN
	1    2700 1400
	0    1    1    0   
$EndComp
Connection ~ 2700 1400
Wire Wire Line
	2700 1400 2700 1550
$EndSCHEMATC

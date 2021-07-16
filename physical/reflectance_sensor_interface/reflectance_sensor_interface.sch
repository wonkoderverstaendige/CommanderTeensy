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
L Sensor_Proximity:QRE1113 #U1
U 1 1 5FD564F5
P 4750 3550
F 0 "#U1" H 4750 3867 50  0000 C CNN
F 1 "QRE1113" H 4750 3776 50  0000 C CNN
F 2 "OptoDevice:OnSemi_CASE100AQ" H 4750 3350 50  0001 C CNN
F 3 "http://www.onsemi.com/pub/Collateral/QRE1113-D.PDF" H 4750 3650 50  0001 C CNN
	1    4750 3550
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5FD56FA2
P 5200 3150
F 0 "R2" H 5270 3196 50  0000 L CNN
F 1 "100" H 5270 3105 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric" V 5130 3150 50  0001 C CNN
F 3 "~" H 5200 3150 50  0001 C CNN
	1    5200 3150
	1    0    0    -1  
$EndComp
$Comp
L Device:R R1
U 1 1 5FD577AD
P 4300 3150
F 0 "R1" H 4370 3196 50  0000 L CNN
F 1 "47" H 4370 3105 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric" V 4230 3150 50  0001 C CNN
F 3 "~" H 4300 3150 50  0001 C CNN
	1    4300 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	4300 3300 4300 3450
Wire Wire Line
	4300 3450 4450 3450
Wire Wire Line
	5200 3300 5200 3450
Wire Wire Line
	5200 3450 5050 3450
$Comp
L Device:R_POT RV1
U 1 1 5FD580C8
P 4300 2850
F 0 "RV1" V 4093 2850 50  0000 C CNN
F 1 "1k" V 4184 2850 50  0000 C CNN
F 2 "Potentiometer_THT:Potentiometer_Bourns_3339P_Vertical" H 4300 2850 50  0001 C CNN
F 3 "~" H 4300 2850 50  0001 C CNN
	1    4300 2850
	0    1    1    0   
$EndComp
$Comp
L power:+3.3V #PWR01
U 1 1 5FD59742
P 4750 2700
F 0 "#PWR01" H 4750 2550 50  0001 C CNN
F 1 "+3.3V" H 4765 2873 50  0000 C CNN
F 2 "" H 4750 2700 50  0001 C CNN
F 3 "" H 4750 2700 50  0001 C CNN
	1    4750 2700
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR02
U 1 1 5FD59E97
P 4750 4000
F 0 "#PWR02" H 4750 3750 50  0001 C CNN
F 1 "GND" H 4755 3827 50  0000 C CNN
F 2 "" H 4750 4000 50  0001 C CNN
F 3 "" H 4750 4000 50  0001 C CNN
	1    4750 4000
	1    0    0    -1  
$EndComp
Wire Wire Line
	4450 3650 4450 4000
Wire Wire Line
	4450 4000 4750 4000
Wire Wire Line
	5050 3650 5050 4000
Wire Wire Line
	5050 4000 4750 4000
Connection ~ 4750 4000
$Comp
L Device:R_POT RV2
U 1 1 5FD5B32D
P 5200 2850
F 0 "RV2" V 4993 2850 50  0000 C CNN
F 1 "20k" V 5084 2850 50  0000 C CNN
F 2 "Potentiometer_THT:Potentiometer_Bourns_3339P_Vertical" H 5200 2850 50  0001 C CNN
F 3 "~" H 5200 2850 50  0001 C CNN
	1    5200 2850
	0    -1   1    0   
$EndComp
Wire Wire Line
	4750 2850 4450 2850
Wire Wire Line
	4750 2850 5050 2850
Connection ~ 4750 2850
$Comp
L Connector:Conn_01x03_Male J1
U 1 1 5FD5C176
P 6750 3550
F 0 "J1" H 6722 3482 50  0000 R CNN
F 1 "Conn_01x03_Male" H 6722 3573 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Horizontal" H 6750 3550 50  0001 C CNN
F 3 "~" H 6750 3550 50  0001 C CNN
	1    6750 3550
	-1   0    0    1   
$EndComp
$Comp
L Amplifier_Operational:LM321 U2
U 1 1 5FD5FAD1
P 5850 3550
F 0 "U2" H 5900 3800 50  0000 L CNN
F 1 "LM321" H 5850 3700 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23-5" H 5850 3550 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/lm321.pdf" H 5850 3550 50  0001 C CNN
	1    5850 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	4750 2700 4750 2850
Wire Wire Line
	5200 3450 5550 3450
Connection ~ 5200 3450
$Comp
L Device:R R3
U 1 1 5FD64A81
P 6300 3550
F 0 "R3" V 6093 3550 50  0000 C CNN
F 1 "100" V 6184 3550 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric" V 6230 3550 50  0001 C CNN
F 3 "~" H 6300 3550 50  0001 C CNN
	1    6300 3550
	0    1    1    0   
$EndComp
Wire Wire Line
	6450 3550 6550 3550
Wire Wire Line
	5750 3850 5750 4000
Wire Wire Line
	5750 4000 5050 4000
Connection ~ 5050 4000
Wire Wire Line
	5550 3650 5450 3650
Wire Wire Line
	5450 3650 5450 3900
Wire Wire Line
	5450 3900 6150 3900
Wire Wire Line
	6150 3900 6150 3550
Connection ~ 6150 3550
Wire Wire Line
	6550 3650 6550 4000
Wire Wire Line
	6550 4000 5750 4000
Connection ~ 5750 4000
$Comp
L power:+3.3V #PWR03
U 1 1 5FD66773
P 6550 3250
F 0 "#PWR03" H 6550 3100 50  0001 C CNN
F 1 "+3.3V" H 6565 3423 50  0000 C CNN
F 2 "" H 6550 3250 50  0001 C CNN
F 3 "" H 6550 3250 50  0001 C CNN
	1    6550 3250
	1    0    0    -1  
$EndComp
Wire Wire Line
	6550 3450 6550 3250
$Comp
L power:+3.3V #PWR0101
U 1 1 5FD68FE8
P 5750 3150
F 0 "#PWR0101" H 5750 3000 50  0001 C CNN
F 1 "+3.3V" H 5765 3323 50  0000 C CNN
F 2 "" H 5750 3150 50  0001 C CNN
F 3 "" H 5750 3150 50  0001 C CNN
	1    5750 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	5750 3150 5750 3250
$Comp
L Connector:Conn_01x04_Female J2
U 1 1 5FD8426A
P 2950 3450
F 0 "J2" H 2978 3426 50  0000 L CNN
F 1 "Conn_01x04_Female" H 2650 3150 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Horizontal" H 2950 3450 50  0001 C CNN
F 3 "~" H 2950 3450 50  0001 C CNN
	1    2950 3450
	1    0    0    -1  
$EndComp
Text GLabel 4200 3450 0    50   Input ~ 0
Lp
Text GLabel 4200 3650 0    50   Input ~ 0
Ln
Text GLabel 5150 3650 2    50   Input ~ 0
Te
Wire Wire Line
	5150 3650 5050 3650
Connection ~ 5050 3650
Wire Wire Line
	4200 3650 4450 3650
Connection ~ 4450 3650
Wire Wire Line
	4200 3450 4300 3450
Connection ~ 4300 3450
Text GLabel 5050 3250 1    50   Input ~ 0
Tc
Wire Wire Line
	5050 3250 5050 3450
Connection ~ 5050 3450
Text GLabel 2750 3350 0    50   Input ~ 0
Lp
Text GLabel 2750 3450 0    50   Input ~ 0
Ln
Text GLabel 2750 3550 0    50   Input ~ 0
Tc
Text GLabel 2750 3650 0    50   Input ~ 0
Te
$EndSCHEMATC

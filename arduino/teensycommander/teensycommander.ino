// PROGRAM AS TRIPLE SERIAL!

#include <Encoder.h>
#include <FastCRC.h>
#include <PacketSerial.h>
#include <math.h>
#include "PulsePin.h"

#define EXTSERIAL Serial

const int pinsAnalogIn[] = {15, 16, 18, 19, 20, 21, 22, 23};
const int nAnalogIn = sizeof(pinsAnalogIn) / sizeof(pinsAnalogIn[0]);
const int pinsDigitalIn[] = {0, 1, 2, 3, 4, 5, 6, 7, 25, 26, 27, 28, 29, 30, 31, 32};
const int nDigitalIn = sizeof(pinsDigitalIn) / sizeof(pinsDigitalIn[0]);
const int pinsDigitalOut[] = {8, 9, 10, 11, 12, 13, 14, 24};
const int nDigitalOut = sizeof(pinsDigitalOut) / sizeof(pinsDigitalOut[0]);
const int nStates = 8;

#define WHEEL_ENC_PINA 5
#define WHEEL_ENC_PINB 6
Encoder wheelEncoder(WHEEL_ENC_PINA, WHEEL_ENC_PINB);

#define GATHER_INDICATOR 8
#define LOOP_INDICATOR 9

// interval Timer creation
IntervalTimer gatherTimer;
elapsedMicros current_micros;
elapsedMillis current_millis;

const int pinsPulsePins[] = {13, 14};
const int nPulsePins = sizeof(pinsPulsePins) / sizeof(pinsPulsePins[0]);
//PulsePin** pulsePins;
PulsePin** pulsePins = new PulsePin*[nPulsePins];

FastCRC16 CRC16;
PacketSerial packetSerialA;
PacketSerial packetSerialB;

// intermediate values
long encoderPosition = 0;
int last_packet_took = 0;

bool gatherNow = false;
bool packetReady = false;

enum packetType: uint8_t {
  ptSTATUS,
  ptINSTR,
  ptERROR,
  ptOK,
  ptACK
};

enum instructionType: uint8_t {
  instPIN_LOW,
  instPIN_HIGH,
  instPIN_TOGGLE,
  instPIN_PULSE,
  instSET_STATE
};

union bytesToULong {
  byte bytes[4];
  unsigned long ulong;
};


volatile unsigned long packetCount = 0;
struct dataPacket {
    uint8_t type;                // 1 B, packet type
    uint8_t length;              // 1 B, packet size
    uint16_t crc16;              // 2 B, CRC16
    unsigned long packetID;      // 4 B, running packet count
    
    unsigned long us_start;      // 4 B, gather start timestamp
    unsigned long us_end;        // 4 B, transmit timestamp
    uint16_t analog[nAnalogIn];  // 16 B, ADC values
    long variables[nStates];     // 32 B, variables (encoder, speed, etc)
    
    uint16_t digitalIn;          // 2 B, digital inputs
    uint8_t digitalOut;          // 1 B, digital outputs
    uint8_t padding[1];          // 1 B, align to 4B
    
    dataPacket() : type(ptSTATUS),
                   length(sizeof(dataPacket)),
                   crc16(0),
                   packetID(packetCount++),
                   digitalIn(0),
                   digitalOut(0) {}
};

struct instructionPacket {
    uint8_t type;                 // 1 B, packet type
    uint8_t length;               // 1 B, packet size
    uint16_t crc16;               // 2 B, CRC16
    
    instructionType instruction;  // 1 B
    uint8_t target;               // 1 B
    byte data[8];                 // 8 B
    uint8_t padding[2];           // 2 B

    instructionPacket() : type(ptINSTR),
                          length(sizeof(instructionPacket)),
                          crc16(0){}  
};

struct errorPacket {
    uint8_t type;          // 1 B, packet type
    uint8_t length;        // 1 B, packet size
    uint16_t crc16;        // 2 B, CRC16
    unsigned long packetID;// 4 B, running packet count
    unsigned long us_start;// 4 B, gather start timestamp

    char message[16];      // 16 B, error message

    errorPacket() : type(ptERROR),
                   length(sizeof(errorPacket)),
                   crc16(0),
                   packetID(packetCount++) {}    
};

const int ledPin = LED_BUILTIN;
unsigned char counter = 0;

dataPacket State;

void setup() {
  pinMode(ledPin, OUTPUT);
  
  // analog input channels
  analogReadResolution(16);
  for (int i=0; i<nAnalogIn; i++) {
    pinMode(pinsAnalogIn[i], INPUT_PULLDOWN);
  }
  
  // digital input channels
  for (int i=0; i<nDigitalIn; i++) {
    pinMode(pinsDigitalIn[i], INPUT_PULLDOWN);
  }

  // digital output channels
  for (int i=0; i<nDigitalOut; i++) {
    pinMode(pinsDigitalOut[i], OUTPUT);
  }
  
  for (int i=0; i<nPulsePins; i++) {
    pulsePins[i] = new PulsePin(i, pinsPulsePins[i], HIGH);
  }
  
  packetSerialA.begin(57600);
  packetSerialA.setPacketHandler(&onPacketReceived);
  packetSerialA.setStream(&SerialUSB1);
  packetSerialB.begin(57600);
  packetSerialB.setPacketHandler(&onPacketReceived);
  packetSerialB.setStream(&SerialUSB2);

  // start data acquisition ticks, [us] interval
  // lowering priority is required to give the Encoder priority
  // and seems to massively reduce/prevent missed counts
  gatherTimer.priority(200);
  gatherTimer.begin(gather, 1000);

  // DEBUGGING
  //delay(50);
  //current_micros = 4294967200;
  //pulsePins[0]->pulseMicro(5000000);
}

void loop() {
  digitalWriteFast(LOOP_INDICATOR, LOW);
  // check current serial status
  packetSerialA.update();
  packetSerialB.update();

  if (packetReady) {
    State.crc16 = CRC16.kermit((uint8_t*) &State, sizeof(State));
    packetSerialA.send((byte*) &State, sizeof(State));
    packetSerialB.send((byte*) &State, sizeof(State));

    // apply current state vector
    applyState(&State);

    packetReady = false;
  }
  
//  if (packetSerialA.overflow() || packetSerialB.overflow()) {
//    errorPacket ep;
//    ep.us_start = current_micros;
//    strcpy(ep.message, "serial_overflow");
//    // packetSerialA.send((byte *) &ep, sizeof(ep));
//    SerialUSB2.println("Buffer overflow!");
//  }

  if (packetSerialA.overflow()) {
    EXTSERIAL.println("S_A overflow!");
  }

  if (packetSerialB.overflow()) {
    EXTSERIAL.println("S_B overflow!");
  }

  // check if timed pins need updates
  for (size_t i = 0; i < nPulsePins; ++i) {
    pulsePins[i]->updateMicro();
  }
  digitalWriteFast(LOOP_INDICATOR, HIGH);
}


void gather() {
  digitalWriteFast(GATHER_INDICATOR, LOW); // toggle pin to indicate gather start
  dataPacket packet;
  packet.us_start = current_micros;
  
  for (int i=0; i<nAnalogIn; i++) {
    packet.analog[i] = analogRead(pinsAnalogIn[i]);
  }

  for (int i=0; i<nDigitalOut; i++) {
    packet.digitalOut |= digitalReadFast(pinsDigitalOut[i]) << i;
  }

  for (int i=0; i<nDigitalIn; i++) {
    packet.digitalIn |= digitalReadFast(pinsDigitalIn[i]) << i;
  }

  noInterrupts(); // are those needed?
  long new_pos = wheelEncoder.read();
  interrupts();

  for (int p=0; p<nStates; p++) {
    packet.variables[p] = 0L;
  }
  packet.variables[0] = new_pos;
  packet.variables[1] = 1;
  packet.variables[2] = 2;
  packet.variables[3] = 3;
  packet.variables[4] = counter;
  packet.variables[4] = 5;
  packet.variables[4] = 6;
  packet.variables[7] = last_packet_took;
  packet.us_end = current_micros;

  last_packet_took = current_micros - packet.us_start;

  State = packet;
  packetReady = true;
  digitalWriteFast(GATHER_INDICATOR, HIGH); // toggle pin to indicate gather end
}

void dumpBuffer(const uint8_t* buffer, size_t size) {
    EXTSERIAL.println(size, DEC);
    for (size_t i=0; i<size; i++) {
      EXTSERIAL.print(buffer[i], HEX);
      EXTSERIAL.print(' ');
    }
    EXTSERIAL.println(' ');
}

void onPacketReceived(const uint8_t* buffer, size_t size) {
  // if we receive a command, do what it tells us to do...
  if (buffer[0] == ptINSTR) {
    processInstruction(buffer, size);
  } else {
    dumpBuffer(buffer, size);
  }
}

void applyState(dataPacket* packet) {
  // apply finite state machine updates here
  //  for (int i=0; i<3; i++) {
  //    digitalWriteFast(9+i, (counter >> i) & 0x1);
  //  }
  counter++;
}

PulsePin* getPulsePinById(byte id){
  for (size_t i = 0; i < nPulsePins; ++i) {
      if (pulsePins[i]->getId() == id){
        return pulsePins[i];
      }
  }
  return 0;
}

void processInstruction (const uint8_t* buf, size_t buf_sz) {
//  EXTSERIAL.println("INSTR");
//  dumpBuffer(buf, buf_sz);
//  delay(1);
  struct instructionPacket* ip = (struct instructionPacket*)buf;
  char* data = (char*)ip->data;

  EXTSERIAL.println(ip->instruction, DEC);
  EXTSERIAL.println(ip->target, DEC);
  delay(1);
  
  switch(ip->instruction){
      case instPIN_LOW:   
        digitalWriteFast(pinsDigitalOut[ip->target], LOW);
        break;
      case instPIN_HIGH: 
        digitalWriteFast(pinsDigitalOut[ip->target], HIGH);
        break;
      case instPIN_TOGGLE: 
        digitalWriteFast(pinsDigitalOut[ip->target], !digitalReadFast(pinsDigitalOut[ip->target]));
        break;
      case instSET_STATE: 
        EXTSERIAL.println("instSet_State");
        break;
      case instPIN_PULSE:
        bytesToULong bul;
        for (size_t b=0; b<sizeof(bul); b++) {
          bul.bytes[b] = data[b];
        }
        pulsePins[ip->target]->pulse(bul.ulong);
        break;
      default: 
        EXTSERIAL.println("Unknown command"); 
        break;
  }
}

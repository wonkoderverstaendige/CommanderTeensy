/*
  Teensy Commander

  Event recorder for behavioral setups.
  
  Configurable inputs and outpus sampled at 1kHz interval.

  NB: Needs to be programmed in TRIPLE SERIAL mode.

  Created 17th December 2019
    By Ronny Eichler
  Modified 2021
    By Gerardo 

  https://github.com/wonkoderverstaendige/CommanderTeensy

*/

// TODO: Make multi-serial optional
// TODO: Handshake

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

#define GATHER_INDICATOR 41
#define LOOP_INDICATOR 40
#define PIN_SYNC_LED 10
#define PIN_CAMERA_FSTROBE 2

// timing
IntervalTimer gatherTimer;
elapsedMicros current_micros;
elapsedMillis current_millis;

const int pinsPulsePins[] = {13, 14};
const int nPulsePins = sizeof(pinsPulsePins) / sizeof(pinsPulsePins[0]);
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


const uint16_t syncCounterMax = 0x95FF;
const uint16_t syncCounterMin = 0x9500;
volatile uint16_t syncCounter = syncCounterMax;
volatile uint16_t syncCounterFrameInterval = 3;  // count N frames as 'clock'
volatile byte syncCounterIdx = 0;
volatile byte syncCounterSubIdx = 0;
volatile bool updateSyncCounter = true;

volatile unsigned long packetCount = 0;
volatile long bufferedStates[nStates];
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

//struct instructionPacket {
//    uint8_t type;                 // 1 B, packet type
//    uint8_t length;               // 1 B, packet size
//    uint16_t crc16;               // 2 B, CRC16
//    
//    instructionType instruction;  // 1 B
//    uint8_t target;               // 1 B
//    byte data[8];                 // 8 B
//    uint8_t padding[2];           // 2 B
//
//    instructionPacket() : type(ptINSTR),
//                          length(sizeof(instructionPacket)),
//                          crc16(0){}  
//};

enum instructionType: uint8_t {
  instPIN_LOW     = 0,
  instPIN_HIGH    = 1,
  instPIN_TOGGLE  = 2,
  instPIN_PULSE   = 3,
  instSET_STATE   = 4,
  instRESET       = 127
  instHANDSHAKE   = 111
};
const uint8_t strideInstLOW = 2;
const uint8_t strideInstHIGH = 2;
const uint8_t strideInstTOGGLE = 2;
const uint8_t strideInstPULSE = 5;
const uint8_t strideInstSTATE = 5;

union bytesToLong {
  byte bytes[4];
  unsigned long ulong;
  long slong;
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
volatile unsigned long counter = 0;

// current state, will be overwritten on gather
dataPacket State;

void reset() {
  noInterrupts();
  wheelEncoder.write(0);
  current_millis = 0;
  current_micros = 0;
  
  for (int i=0; i<nStates; i++) {
    bufferedStates[i] = 0;
  }

  for (int i=0; i<nDigitalOut; i++) {
    digitalWriteFast(pinsDigitalOut[i], LOW);
  }

  for (int i=0; i<nPulsePins; i++) {
    pulsePins[i]->restart();
  }
  interrupts();
}

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
  pinMode(GATHER_INDICATOR, OUTPUT);
  pinMode(LOOP_INDICATOR, OUTPUT);
  
  for (int i=0; i<nPulsePins; i++) {
    pulsePins[i] = new PulsePin(i, pinsPulsePins[i], HIGH);
  }

  reset();
  
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

  attachInterrupt(digitalPinToInterrupt(PIN_CAMERA_FSTROBE), syncBlink, CHANGE);
}

void loop() {
  digitalWriteFast(LOOP_INDICATOR, HIGH);
  // check serial status for data and buffer health
  packetSerialA.update();
  packetSerialB.update();

  if (updateSyncCounter) {
    updateSyncCounter = false;
    if (++syncCounterSubIdx > syncCounterFrameInterval) {
      syncCounterSubIdx = 0;
      if (++syncCounterIdx > 15) {
        syncCounterIdx = 0;
        if (++syncCounter > syncCounterMax) {
          syncCounter = syncCounterMin;
        }
      }
    }
  }

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
  
  digitalWriteFast(LOOP_INDICATOR, LOW);
}


void gather() {
  digitalWriteFast(GATHER_INDICATOR, HIGH);
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
  packet.variables[1] = bufferedStates[1];
  packet.variables[2] = bufferedStates[2];
  packet.variables[3] = bufferedStates[3];
  packet.variables[4] = bufferedStates[4];
  packet.variables[5] = bufferedStates[5];
  packet.variables[6] = bufferedStates[6];
  packet.variables[7] = bufferedStates[7];
  packet.us_end = current_micros;

  State = packet;
  packetReady = true;
  last_packet_took = current_micros - packet.us_start;
  digitalWriteFast(GATHER_INDICATOR, LOW); // toggle pin to indicate gather end
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

// synchronization pattern linking the camera to the teensy timing by
// sending a pulsed pattern. The pattern is a counter clocked by FSTROBE
// signal from the camera.
void syncBlink() {
  if (!digitalReadFast(PIN_CAMERA_FSTROBE)) {
    digitalWriteFast(PIN_SYNC_LED, (syncCounter >> syncCounterIdx) & 0x1);
    updateSyncCounter = true;
  } else {
    //digitalWriteFast(PIN_SYNC_LED, LOW);
  }
}

void processInstruction (const uint8_t* buf, size_t buf_sz) {
//  struct instructionPacket* ip = (struct instructionPacket*)buf;
//  char* data = (char*)ip->data;
  uint8_t instruction = buf[4];

  uint8_t stride;
  uint8_t target;
  uint8_t pin;
  bytesToLong bul;

  switch(instruction){
      case instPIN_LOW:
        stride = strideInstLOW;
        for (uint8_t pIdx = 5; pIdx + stride <= buf_sz; pIdx += stride) {
           target = buf[pIdx];
           pin = pinsDigitalOut[target];
           digitalWriteFast(pin, LOW);
        }
        break;
        
      case instPIN_HIGH:
        stride = strideInstHIGH;
        for (uint8_t pIdx = 5; pIdx + stride <= buf_sz; pIdx += stride) {
          target = buf[pIdx];
          pin = pinsDigitalOut[target];
          digitalWriteFast(pin, HIGH);
        }
        break;
        
      case instPIN_TOGGLE:
        stride = strideInstTOGGLE;
        for (uint8_t pIdx = 5; pIdx + stride <= buf_sz; pIdx += stride) {
          target = buf[pIdx];
          pin = pinsDigitalOut[target];
          digitalWriteFast(pin, !digitalReadFast(pin));
        }
        break;
        
      case instPIN_PULSE:
        stride = strideInstPULSE;
        for (uint8_t pIdx = 5; pIdx + stride <= buf_sz; pIdx += stride) {
          target = buf[pIdx];
          for (size_t b=0; b<sizeof(bul); b++) {
            bul.bytes[b] = buf[pIdx+1+b];
          }
          pulsePins[target]->pulseMicro(bul.ulong*1000);
        }
        break;
        
      case instSET_STATE:
        stride = strideInstSTATE;
        EXTSERIAL.println("instSet_State");
        for (uint8_t pIdx = 5; pIdx + stride <= buf_sz; pIdx += stride) {
          target = buf[pIdx];
          for (size_t b=0; b<sizeof(bul); b++) {
            bul.bytes[b] = buf[pIdx+1+b];
          }
          EXTSERIAL.print(target, DEC);
          EXTSERIAL.print(':');
          EXTSERIAL.println(bul.slong);
          bufferedStates[target] = bul.slong;
        }
        break;

      case instRESET:
        reset();
        break;
        
      default:
        EXTSERIAL.println("Unknown command"); 
        break;
  }
}

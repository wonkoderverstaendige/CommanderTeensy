#include <Encoder.h>
#include <FastCRC.h>
#include <PacketSerial.h>

#define WHEEL_ENC_PINA 5
#define WHEEL_ENC_PINB 6
#define WHEEL_ENC_SW 7
#define GATHER_INDICATOR 10
#define LOOP_INDICATOR 11

#define EXTSERIAL Serial1

FastCRC16 CRC16;
PacketSerial packetSerialA;
PacketSerial packetSerialB;
PacketSerial packetSerialExt;

// interval Timer creation
IntervalTimer gatherTimer;
elapsedMicros current_micros;

// Encoders and Sensors
Encoder wheelEncoder(WHEEL_ENC_PINA, WHEEL_ENC_PINB);

// intermediate values
long encoderPosition = 0;
int last_packet_took = 0;

bool gatherNow = false;
bool packetReady = false;

enum packetType: uint8_t {
  ptSTATUS,
  ptCOMMAND,
  ptERROR,
  ptOK,
  ptACK
};

enum Instructions: uint8_t {
  instPIN_TOGGLE,
  instPIN_HIGH,
  instPIN_LOW,
  instSET_STATE,
  instPULSE
};

volatile unsigned long packetCount = 0;
struct dataPacket {
    uint8_t type;          // 1 B, packet type
    uint8_t length;        // 1 B, packet size
    uint16_t crc16;        // 2 B, CRC16
    unsigned long packetID;// 4 B, running packet count
    
    unsigned long us_start;// 4 B, gather start timestamp
    unsigned long us_end;  // 4 B, transmit timestamp
    uint16_t analog[8];    // 16 B, ADC values
    long variables[8];     // 32 B, variables (encoder, speed, etc)
    
    uint16_t digitalIn;    // 2 B, digital inputs
    uint8_t digitalOut;    // 1 B, digital outputs
    uint8_t padding[1];    // 1 B, align to 4B
    
    dataPacket() : type(ptSTATUS),
                   length(sizeof(dataPacket)),
                   crc16(0),
                   packetID(packetCount++),
                   digitalIn(0),
                   digitalOut(0) {}
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
  // digital input channels
  for (int i=0; i<5; i++) {
    pinMode(0+i, INPUT_PULLUP);
  }

  pinMode(WHEEL_ENC_SW, INPUT);

  // digital output channels
  for (int i=0; i<4; i++) {
    pinMode(9+i, OUTPUT);
  }

  // analog input channels
  analogReadResolution(16);
  for (int i=0; i<8; i++) {
    pinMode(14+i, INPUT_PULLDOWN);
  }

  pinMode(ledPin, OUTPUT);

  packetSerialA.begin(57600);
  packetSerialA.setPacketHandler(&onPacketReceived);
  packetSerialB.begin(57600);
  packetSerialB.setPacketHandler(&onPacketReceived);
  packetSerialB.setStream(&SerialUSB1);

  // start data acquisition ticks, [us] interval
  // lowering priority is required to give the Encoder priority
  // and seems to massively reduce/prevent missed counts
  gatherTimer.priority(200);
  gatherTimer.begin(gather, 1000);
}

void loop() {
  digitalWriteFast(LOOP_INDICATOR, HIGH);
  // check current serial status
  packetSerialA.update();
  packetSerialB.update();

  if (packetReady) {
    State.crc16 = CRC16.kermit((uint8_t*) &State, sizeof(State));
    packetSerialA.send((byte*) &State, sizeof(State));
    packetSerialB.send((byte*) &State, sizeof(State));

    // apply current state vector
    processState(&State);

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
    SerialUSB2.println("S_A overflow!");
  }

  if (packetSerialB.overflow()) {
    SerialUSB2.println("S_B overflow!");
  }
  digitalWriteFast(LOOP_INDICATOR, LOW);
}

void gather() {
  digitalWriteFast(GATHER_INDICATOR, LOW); // toggle pin to indicate gather start
  dataPacket packet;
  packet.us_start = current_micros;
  
  for (int i=0; i<8; i++) {
    packet.analog[i] = analogRead(14+i);
    packet.digitalOut |= digitalReadFast(6+i) << i;
  }

  for (int i=0; i<14; i++) {
    packet.digitalIn |= digitalReadFast(i) << i;
  }

  noInterrupts(); // are those needed?
  long new_pos = wheelEncoder.read();
  interrupts();

  for (int p=0; p<8; p++) {
    packet.variables[p] = 0L;
  }
  packet.variables[0] = new_pos;
  packet.variables[1] = 1;
  packet.variables[2] = 2;
  packet.variables[3] = 3;
  packet.variables[4] = 4;
  packet.variables[4] = 5;
  packet.variables[4] = 6;
  packet.variables[7] = last_packet_took;
  packet.us_end = current_micros;

  last_packet_took = current_micros - packet.us_start;

  State = packet;
  packetReady = true;
  digitalWriteFast(GATHER_INDICATOR, HIGH); // toggle pin to indicate gather end
}

void onPacketReceived(const uint8_t* buffer, size_t size) {
  // if we receive a command, do what it tells us to do...
  if (buffer[0] == ptCOMMAND) {
    processCommand(buffer, size);
  } else {
    SerialUSB2.write(buffer, size);
  }
}

void processState(dataPacket* packet) {
  // apply finite state machine updates here
  for (int i=0; i<3; i++) {
    digitalWriteFast(9+i, (counter >> i) & 0x1);
  }
  counter++;
}

void processCommand(const uint8_t* buffer, size_t size) {
  digitalWrite(6+buffer[2], !digitalRead(6+buffer[2]));
}

#include <Encoder.h>
#include <FastCRC.h>
#include <PacketSerial.h>

#define WHEEL_ENC_PINA 5
#define WHEEL_ENC_PINB 6
#define WHEEL_ENC_SW 7

FastCRC16 CRC16;
PacketSerial packetSerialA;
PacketSerial packetSerialB;

// interval Timer creation
IntervalTimer gatherTimer;
elapsedMicros current_micros;

// Encoders and Sensors
Encoder wheelEncoder(WHEEL_ENC_PINA, WHEEL_ENC_PINB);

// intermediate values
int encoderPosition;
int velocity;
int acceleration;
int last_packet_took = 0;
int prev_lx = 0;

enum packetType: uint8_t {
  ptSTATUS,
  ptCOMMAND,
  ptERROR,
  ptOK,
  ptACK
};

enum Intructions: uint8_t {
  instPIN_TOGGLE,
  instPIN_HIGH,
  instPIN_LOW,
  instSET_STATE
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

void setup() {
  // analog input channels
  analogReadResolution(16);
  for (int i=0; i<8; i++) {
    pinMode(14+i, INPUT_PULLDOWN);
  }
  
  // digital input channels
  for (int i=0; i<5; i++) {
    pinMode(0+i, INPUT_PULLUP);
  }

  pinMode(WHEEL_ENC_SW, INPUT);

  // digital output channels
  for (int i=0; i<4; i++) {
    pinMode(9+i, OUTPUT);
  }

  pinMode(ledPin, OUTPUT);

  packetSerialA.begin(57600);
  packetSerialA.setPacketHandler(&onPacketReceived);
  packetSerialB.begin(57600);
  packetSerialB.setPacketHandler(&onPacketReceived);
  packetSerialB.setStream(&SerialUSB1);

  // start data acquisition ticks, [us] interval
  gatherTimer.begin(gather, 1000);
}

void loop() {
  delay(100);
  for (int i=0; i<3; i++) {
    digitalWriteFast(9+i, (counter >> i) & 0x1);
  }
  counter++;
  //SerialUSB2.println(counter);

  // check current serial status
  packetSerialA.update();
  packetSerialB.update();
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
}

void gather() {
  digitalWriteFast(7, LOW); // toggle pin to indicate gather start
  volatile dataPacket packet;
  packet.us_start = current_micros;
  
  for (int i=0; i<8; i++) {
    packet.analog[i] = analogRead(14+i);
    packet.digitalOut |= digitalReadFast(6+i) << i;
  }

  for (int i=0; i<14; i++) {
    packet.digitalIn |= digitalReadFast(i) << i;
  }

  long new_pos = wheelEncoder.read();
  int v = encoderPosition - new_pos;
  acceleration = velocity - v;
  encoderPosition = new_pos;
  velocity = v;
//  if (encoderPosition > 40960) encoderPosition = -encoderPosition;

  for (int p=0; p<8; p++) {
    packet.variables[p] = 0L;
  }
  packet.variables[0] = encoderPosition;
  packet.variables[1] = velocity;
  packet.variables[2] = acceleration;
  packet.variables[3] = packet.analog[0] - prev_lx;
  prev_lx = packet.analog[0];
  packet.variables[4] = 2130;
  packet.variables[7] = last_packet_took;

  packet.crc16 = CRC16.ccitt((uint8_t*) &packet, packet.length);

  // process state packet
  processState(&packet);
  
  packet.us_end = current_micros;
  packetSerialA.send((byte*) &packet, sizeof(packet));
  packetSerialB.send((byte*) &packet, sizeof(packet));
  last_packet_took = current_micros - packet.us_start;

  digitalWriteFast(7, HIGH); // toggle pin to indicate gather end
}

void onPacketReceived(const uint8_t* buffer, size_t size) {
  // if we receive a command, do what it tells us to do...
  if (buffer[0] == ptCOMMAND) {
    processCommand(buffer, size);
  } else {
    SerialUSB2.write(buffer, size);
  }
}

void processState(volatile dataPacket* packet) {
  // apply finite state machine updates here
}

void processCommand(const uint8_t* buffer, size_t size) {
  digitalWrite(6+buffer[2], !digitalRead(6+buffer[2]));
}

#include "PulsePin.h"
PulsePin::PulsePin(int pinID, int pinNr, int polarity) {
  this->pinID = pinID;
  this->pinNr = pinNr;
  
  // set polarity of ACTIVE state
  this->polarity = polarity;
  pinMode(pinID, OUTPUT);
  
  this->nextChangeTime = 0;
  this->run = true;
}

void PulsePin::update() {
  if (run) {
    if(current_millis < this->nextChangeTime) {
      digitalWriteFast(this->pinNr, this->polarity);
    } else {
      digitalWriteFast(this->pinNr, !this->polarity);
    }
  }
}

void PulsePin::pulse(unsigned long duration) {
  this->nextChangeTime = current_millis + duration;
  Serial.println(this->nextChangeTime);
}

void PulsePin::restart() {
  this->run = true;
  this->nextChangeTime = 0;
  digitalWriteFast(this->pinNr, !this->polarity);
}

void PulsePin::stop() {
	this->run = false;
}

int PulsePin::getId() {
  return this->pinID;
}

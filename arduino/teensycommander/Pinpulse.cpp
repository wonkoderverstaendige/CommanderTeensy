#include "Pinpulse.h"
Pinpulse::Pinpulse(byte pinID, unsigned int pinNr, boolean polarity) {
  this->pinID = pinID;
  this->pinNr = pinNr;
  // set default value for polarity
  this->polarity = polarity;
  pinMode(pinID, OUTPUT);
  this->run = true;
}

void Pinpulse::update() {
	if(run){
		if(current_micros >= this->nextChangeTime) {
			// Change pinState accordingly
      digitalWriteFast(this->pinNr,pinState);
    else{
      digitalWriteFast(this->pinNr,!pinState);
		}
	}else{}
}

void setTimer(unsigned long duration){
  this->nextChangeTime = current_micros + duration;
}

void Pinpulse::restart(){
	this->run = true;
	this->nextChangeTime = 0;
  digitalWriteFast(this->pinNr,pinState);
}

void Pinpulse::stop(){
	this->run = false;
}

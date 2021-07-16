#include "Pinpulse.h"
Pinpulse::Pinpulse(byte pinID, unsigned long timePinOn, unsigned long timePinOff, unsigned int pinNr) {
  this->pinID = pinID;
  this->timePinOn = timePinOn;
  this->timePinOff = timePinOff;
  this->pinNr = pinNr;

  pinMode(pinID, OUTPUT);
  //this->pinState = digitalRead(pinNr);
  unsigned long currentTime = millis();
  if (currentTime >= timePinOn){
	  this->pinState = HIGH;
  }
  this->run = true;
  this->turnOffTime = millis() + timePinOff;
}

void Pinpulse::update() {
	if(run){
		unsigned long currentTime = millis();
		// If timePinOn is in the future, we need to toggle it to HIGH
		if (currentTime >= timePinOn){
			this->pinState = HIGH;
		}
		if(currentTime >= turnOffTime) {
			// Change pinState accordingly
			if(pinState == HIGH) {
				pinState = LOW;
			}else{
				pinState = HIGH;
			}
			// Actually change the state of the pin
			digitalWrite(pinNr, pinState);
		}
	}else{}
}

void Pinpulse::restart(unsigned long timePinOn, unsigned long timePinOff){
	this->run = true;
	this->timePinOn = timePinOn;
	this->timePinOff = timePinOff;
}

void Pinpulse::cancel(){
	this->run = false;
}

void Pinpulse::continuepulse(){
	this->run = true;
}
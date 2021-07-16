#ifndef PINPULSE_H
#define PINPULSE_H
#include <Arduino.h>
class Pinpulse {
  
  private:
    byte pinID;
  	unsigned long timePinOn;
  	unsigned long timePinOff;
  	unsigned int pinNr;
  	boolean pinState;
  	unsigned long nextChangeTime = 0;
  	boolean run;
  	unsigned long turnOffTime;
    
  public:
    // Setup pin 
    Pinpulse(byte pinID, unsigned long timePinOn, unsigned long timePinOff, unsigned int pinNr);
    // Setup the pin as OUTPUT
	  //pinMode(pinNr, OUTPUT);
    
    // Check the states
    void update();
	
  	// Stop updating etc.
  	void cancel();

    // Continue after cancelling
  	void continuepulse();
  	
  	void restart(unsigned long timePinOn, unsigned long timePinOff);
};
#endif

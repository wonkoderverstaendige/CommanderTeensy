#ifndef PINPULSE_H
#define PINPULSE_H
#include <Arduino.h>
class Pinpulse {
  
  private:
    byte pinID;
  	unsigned int pinNr;
  	boolean polarity;
  	unsigned long nextChangeTime;
  	boolean run;
    elapsedMicros current_micros;
    
  public:
    // Setup pin 
    Pinpulse(byte pinID, unsigned int pinNr, boolean polarity, elapsedMicros current_micros);
    // Setup the pin as OUTPUT
	  //pinMode(pinNr, OUTPUT);
    
    // Check the states
    void update();
	
  	// Stop updating etc.
  	void stop();
  	
  	void restart();
   
    void setTimer(unsigned long duration);

    byte getId();
};
#endif

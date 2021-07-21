#ifndef PULSDPIN_H
#define PULSDPIN_H
#include <Arduino.h>

extern elapsedMillis current_millis;

class PulsePin {
  
  private:
    int pinID;
  	int pinNr;
  	int polarity;
  	unsigned long nextChangeTime;
  	boolean run;
    
  public:
    // Setup pin 
    PulsePin(int pinID, int pinNr, int polarity);
    
    // Check the states
    void update();
	
  	// Stop updating etc.
  	void stop();
  	
  	void restart();
   
    void pulse(unsigned long duration);

    int getId();
};
#endif

/* 
This is a test sketch for the Adafruit assembled Motor Shield for Arduino v2
It won't work with v1.x motor shields! Only for the v2's with built in PWM
control

For use with the Adafruit Motor Shield v2 
---->	http://www.adafruit.com/products/1438
*/


#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_MS_PWMServoDriver.h"

#define MAX_STEPS 50

Adafruit_MotorShield AFMS = Adafruit_MotorShield(); 
Adafruit_StepperMotor *myMotor = AFMS.getStepper(MAX_STEPS, 2);

float amount = 0.0;
uint8_t movement_amount = 0;

void setup() {
  Serial.begin(9600);      
  Serial.println("Stepper test!");

  AFMS.begin(); 
  //AFMS.begin(1000);  // OR with a different frequency, say 1KHz
  
  myMotor->setSpeed(10);  
}

void loop() {
  Serial.println("Awaiting Float");
  amount = Serial.parseFloat();

  if (amount != 0.0) {
    Serial.println("Moving to: ");
    Serial.println(amount);
    
    myMotor->step(movement_amount, FORWARD, MICROSTEP);

    movement_amount = amount * MAX_STEPS;

    myMotor->step(movement_amount, BACKWARD, MICROSTEP);
    Serial.println("Movement Complete");
  }
}


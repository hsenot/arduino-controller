// Open a serial connection and flash LED when input is received
#include <Servo.h> 
#include <EEPROM.h>

Servo myservo;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created 
 
int ledRed = 12;      // LED connected to digital pin 4
int finalPos = 0;
int initialPos = 0;
int readData = 0;
int s = 0;
int lightLevel;
int lightServo;

void setup(){
  myservo.attach(11);
  myservo.write(EEPROM.read(1));
  //myservo.write(myservo.read());
  pinMode(ledRed, OUTPUT);
  // Open serial connection.
  Serial.begin(9600);
}

void rotateTo(int fp){
      initialPos = myservo.read();
      EEPROM.write(1, fp);
      
      if (initialPos > fp)
      { s = -1; }
      else
      { s = 1; }
      
      for(int pos = initialPos; pos != fp; pos = pos + s)  // goes from 0 degrees to 180 degrees 
      {                                  // in steps of 1 degree 
        myservo.write(pos);              // tell servo to go to position in variable 'pos' 
        delay(25);                       // waits 15ms for the servo to reach the position 
      }
      
      // Sending an X signal indicating end of rotation movement
      Serial.println(0);
}

void loop(){
  if(Serial.available() > 0){      
        // if data present
        readData = Serial.parseInt();
        lightLevel = analogRead(0);
        switch (readData) {
            case 1 :
                finalPos = 15; rotateTo(finalPos); break;
            case 2 :
                finalPos = 65; rotateTo(finalPos); break;
            case 3 :
                finalPos = 115; rotateTo(finalPos); break;
            case 4 :
                finalPos = 165; rotateTo(finalPos); break;
            case 5 :
                Serial.println(lightLevel); break;                
            case 99:
                //just dummy to cancel the current read, needed to prevent lock 
                //when the PC side dropped the "w" that we sent
                break;
        }
        
        // blink
        digitalWrite(ledRed, HIGH);
        delay(50);             
        digitalWrite(ledRed, LOW);
        delay(50);
        
  }

  // Blinking a LED based on light levels
  lightLevel = analogRead(0);  
  if (lightLevel < 100)
  {
     digitalWrite(ledRed, HIGH);
     delay(lightLevel*10);
     digitalWrite(ledRed, LOW);
     delay((100-lightLevel)*10);
     
     //lightServo = map(lightLevel,0,25,0,179);
     //myservo.write(lightServo);
     //delay(100+lightServo);
  }
  
}
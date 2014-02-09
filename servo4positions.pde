// Open a serial connection and flash LED when input is received
#include <Servo.h> 
#include <EEPROM.h>

Servo myservo;  // create servo object to control a servo 
Servo myservo2;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created 
 
int ledRed = 12;      // LED connected to digital pin 4
int finalPos = 0;
int initialPos = 0;
int readData = 0;
int s = 0;
int lightLevel;
int lightServo;

void setup(){
  myservo.attach(10);
  myservo.write(EEPROM.read(1));

  myservo2.attach(8);
  myservo2.write(EEPROM.read(2));

  //myservo.write(myservo.read());
  pinMode(ledRed, OUTPUT);
  // Open serial connection.
  Serial.begin(9600);
}

void rotateTo(int servonb, int fp){
      if (servonb > 1)
      {
        initialPos = myservo2.read();
        EEPROM.write(2, fp);
      }
      else
      {
        initialPos = myservo.read();
        EEPROM.write(1, fp);        
      }
      
      if (initialPos > fp)
      { s = -1; }
      else
      { s = 1; }
      
      for(int pos = initialPos; pos != fp; pos = pos + s)  // goes from 0 degrees to 180 degrees 
      {                                  // in steps of 1 degree 
        if (servonb > 1)
        {
          myservo2.write(pos);              // tell servo to go to position in variable 'pos' 
        }
        else
        {
          myservo.write(pos);              // or tell servo2 to go to position in variable 'pos' 
        }
        delay(15);                       // waits 25ms for the servo to reach the position 
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
                finalPos = 15; rotateTo(1,finalPos); break;
            case 2 :
                finalPos = 65; rotateTo(1,finalPos); break;
            case 3 :
                finalPos = 115; rotateTo(1,finalPos); break;
            case 4 :
                finalPos = 165; rotateTo(1,finalPos); break;
            case 5 :
                finalPos = 15; rotateTo(2,finalPos); break;
            case 6 :
                finalPos = 65; rotateTo(2,finalPos); break;
            case 7 :
                finalPos = 115; rotateTo(2,finalPos); break;
            case 8 :
                finalPos = 165; rotateTo(2,finalPos); break;
            case 9 :
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
  }
  
}
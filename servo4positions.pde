// Open a serial connection and flash LED when input is received
#include <Servo.h> 
 
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
  // Open serial connection.
  Serial.begin(9600);
  pinMode(ledRed, OUTPUT);
  myservo.attach(11);
  myservo.write(15);
}

void loop(){
  if(Serial.available() > 0){      // if data present, blink
        readData = Serial.parseInt();
        initialPos= myservo.read();
        finalPos = initialPos;
        lightLevel = analogRead(0);
        switch (readData) {
            case 1 :
                finalPos = 15; break;
            case 2 :
                finalPos = 65; break;
            case 3 :
                finalPos = 115; break;
            case 4 :
                finalPos = 165; break;
            case 5 :
                Serial.println(lightLevel); break;
            case 99:
                //just dummy to cancel the current read, needed to prevent lock 
                //when the PC side dropped the "w" that we sent
                break;
        }
        
        digitalWrite(ledRed, HIGH);
        delay(100);             
        digitalWrite(ledRed, LOW);
        delay(100);
        
        if (initialPos > finalPos)
        {
          s = -2;
        }
        else
        {
          s = 2;
        }
        
        for(int pos = initialPos; pos != finalPos; pos = pos + s)  // goes from 0 degrees to 180 degrees 
        {                                  // in steps of 1 degree 
          myservo.write(pos);              // tell servo to go to position in variable 'pos' 
          delay(50);                       // waits 15ms for the servo to reach the position 
        }
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
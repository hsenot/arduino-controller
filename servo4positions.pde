// Open a serial connection and flash LED when input is received
#include <Servo.h> 
 
Servo myservo;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created 
 
int ledRed = 12;      // LED connected to digital pin 4
int finalPos = 0;
int initialPos = 0;
int readData = 0;
int s = 0;

void setup(){
  // Open serial connection.
  Serial.begin(115200);
  pinMode(ledRed, OUTPUT);
  myservo.attach(11);
  myservo.write(15);
}

void loop(){
  if(Serial.available() > 0){      // if data present, blink
        readData = Serial.parseInt();
        initialPos= myservo.read();
        finalPos = initialPos;
        switch (readData) {
            case 1 :
                finalPos = 15; break;
            case 2 :
                finalPos = 65; break;
            case 3 :
                finalPos = 115; break;
            case 4 :
                finalPos = 165; break;
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
}
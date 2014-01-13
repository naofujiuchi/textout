#include <MuxShield.h>

#define pinin A0
#define pinout 13

MuxShield muxShield;

void setup(){
  Serial.begin(9600);
  muxShield.setMode(1, ANALOG_IN);
  muxShield.setMode(2, ANALOG_IN);
  muxShield.setMode(3, ANALOG_IN);
}

int analog[49];

void loop(){
  int i = 1;
  for(int j = 1; j <= 3; j++){
    for(int k = 0; k <= 15; k++){
      analog[i] = muxShield.analogReadMS(j, k);
      i++;
    }
  }
  if(Serial.available() == 1){
    int samplenumber = Serial.read();
    Serial.flush();
    // send data
    for(int i = 1; i <= samplenumber; i++){
      int x = analog[i] / 256;
      int y = analog[i] - 256 * x;
      Serial.write(x);
      Serial.write(y);
      // Turn on LED
      digitalWrite(pinout, HIGH);
    }
  }
  delay(1000);
}

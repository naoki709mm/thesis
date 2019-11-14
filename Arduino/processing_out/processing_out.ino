#include <Wire.h>
#include <VL6180X.h>
#include <FlexiTimer2.h>

VL6180X sensor;

#define TM 16000 //終了時間(ms)
#define TM_MET 8000 //メトロノーム終了時間
#define OUT_MET 4
#define OUT_TAP 2
#define INIT_PIN 3 //メトロノームの音の初期化
#define SAMPLING 5

int analogPin=0;
int data;
int val=1024;
int i=0;
unsigned long t=0;
unsigned long tm=0;

void processing(){
  val=analogRead(analogPin);

  Serial.print(tm);
  Serial.print(",");
  Serial.print(data);
  Serial.print(",");
  Serial.print(val);
  Serial.print("\n");

  if(tm < TM_MET){ //メトロノームを鳴らし終える時間
    if(t == 0){
      digitalWrite(OUT_MET,HIGH);
      t=100;
    }
    else{
      digitalWrite(OUT_MET,LOW);
    }
    t--;
  }
  else
    digitalWrite(OUT_MET,LOW); //LOWに固定
  
  if(val <= 1000){
    digitalWrite(OUT_TAP,HIGH);
  }
  else{
    digitalWrite(OUT_TAP,LOW);
  }

  digitalWrite(INIT_PIN,LOW); //初期化PINをlowに固定
  
  if(tm >= TM){ //終了条件
    digitalWrite(OUT_TAP,LOW);
    digitalWrite(OUT_MET,LOW);
    Serial.end();
    FlexiTimer2::stop();
  }
  
  tm+=SAMPLING;
}

void setup(){
  Serial.begin(2000000);
  Wire.begin();

  pinMode(OUT_MET,OUTPUT);
  pinMode(OUT_TAP,OUTPUT);
  pinMode(INIT_PIN,OUTPUT);
  
  sensor.init();
  sensor.configureDefault();
  sensor.stopContinuous();
  sensor.setTimeout(100);
  delay(1000);
  sensor.startRangeContinuous(10);

  digitalWrite(INIT_PIN,HIGH); //メトロノームのtの初期化
  
  FlexiTimer2::set(SAMPLING,processing);
  FlexiTimer2::start();
}

void loop(){
  data=sensor.readRangeSingleMillimeters();
}

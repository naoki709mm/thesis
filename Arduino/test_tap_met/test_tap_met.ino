#include <Wire.h>
#include <TimerOne.h>

#define SAMPLING 5 //1/Hz*1000
#define TM 120000 //終了時間(ms)
#define TIME_MET 8000 //メトロノーム終了のタイム(ms)
#define PUSH 1000 //圧力センサの音を鳴らす最大値
#define OUT_MET 4
#define OUT_TAP 2
#define INIT_PIN 8 //メトロノームの音の初期化

int analogPin=0;
int data;
int val=1024;
int i=0;
int met_sound=1.0/SAMPLING*1000/2; //メトロノームの4カウント(1秒に2回だから割る2)
long end_time=TM+TIME_MET; //終了時間+メトロノーム時間
int start_stop=0; //スタート時1,ストップ時0
int read_status;
unsigned long t=0;
unsigned long tm=0;

void processing(){
  if(start_stop == 0){ //aが入力されたらスタート
    digitalWrite(OUT_TAP,LOW);
    digitalWrite(OUT_MET,LOW);
    if(Serial.available() > 0){
      read_status = Serial.read();
      if(read_status == 'a'){
        start_stop=1;
        Serial.println("start");
        delay(500);
        digitalWrite(INIT_PIN,HIGH);
      }
    }
  }
  else if(start_stop == 1){
    val=analogRead(analogPin);

    //メトロノーム
    if(tm < TIME_MET){ //メトロノームを鳴らし終える時間
      if(t == 0){
        digitalWrite(OUT_MET,HIGH);
        t=met_sound;
      }
      else{
        digitalWrite(OUT_MET,LOW);
      }
      t--;
    }
    else
      digitalWrite(OUT_MET,LOW); //LOWに固定

    //タップ
    if(val <= PUSH){
      digitalWrite(OUT_TAP,HIGH);
    }
    else{
      digitalWrite(OUT_TAP,LOW);
    }
  
    digitalWrite(INIT_PIN,LOW); //初期化PINをlowに固定

    //終了条件
    if(tm >= end_time){
      start_stop=0;
      tm=0;
      Serial.println("stop");
    }
    
    tm+=SAMPLING;
  }
  
  if(Serial.available() > 0){ //bが入力されたら停止
    read_status = Serial.read();
    if(read_status == 'b'){
      start_stop=0;
      tm=0;
      Serial.println("stop");
    }
  }
  
}

void setup(){
  Serial.begin(2000000);
  Wire.begin();

  pinMode(OUT_MET,OUTPUT);
  pinMode(OUT_TAP,OUTPUT);
  pinMode(INIT_PIN,OUTPUT);

  Timer1.initialize(SAMPLING*1000);
  Timer1.attachInterrupt(processing);
}

void loop(){}

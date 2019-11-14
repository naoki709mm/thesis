#define IN_MET 4 //デジタルインプットのピン
#define MET_OUT 8 //メトロノーム
#define INIT_PIN 3

int val_met;
int val_init;
int t=0;

void setup() {
  pinMode(IN_MET,INPUT);
}

void loop() {
  val_met=digitalRead(IN_MET);
  val_init=digitalRead(INIT_PIN);

  if(val_init == HIGH)
    t=0;
  
  if(val_met == HIGH){
    if(t == 0){
      tone(MET_OUT,880);
      t=3;
    }
    else{
      tone(MET_OUT,440);
      t--;
    }
    delay(50);
    noTone(MET_OUT);
  }
}

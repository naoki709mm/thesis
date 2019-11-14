#define IN_TAP 2 //タップのピン
#define TAP_OUT 7 //タッピング音

int val_tap;

void setup() {
  pinMode(IN_TAP,INPUT);
}

void loop() {
  val_tap=digitalRead(IN_TAP);
  
  if(val_tap == HIGH){
    tone(TAP_OUT,659.255);
    delay(50);
  }
  else
    noTone(TAP_OUT);
}

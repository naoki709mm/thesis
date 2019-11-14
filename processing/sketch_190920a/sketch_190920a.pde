import processing.serial.*;

Serial myPort;

PrintWriter file;

int x;
int i=0;
float y=0.0;

void setup(){
  myPort = new Serial(this, "/dev/cu.usbmodem141401", 9600);
  file=createWriter("test.csv");
}

void draw(){
}



void serialEvent(Serial p){
  
  
  file.print(y);
  file.print(",");
  x = myPort.read();
  file.print(x);
  file.print("\n");
  println(x);
  if(i >= 2000){
    file.flush();
    file.close();
    exit();
  }
  y+=0.01;
  i++;
}

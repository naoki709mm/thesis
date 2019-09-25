import processing.serial.*;

Serial myPort;

PrintWriter file;

int x;
float y=0.0;

void setup(){
  myPort = new Serial(this, "/dev/ttyACM0", 9600);
  file=createWriter("test.csv");
}

void draw(){
  
}

void serialEvent(Serial p){
  file.print(y);
  file.print(",");
  x = p.read();
  file.print(x);
  file.print("\n");
  println(x);
  if(y >= 10){
    file.flush();
    file.close();
    exit();
  }
  
  y+=0.05;
  
}

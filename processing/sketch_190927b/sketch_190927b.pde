import processing.serial.*;

Serial arduino;

PrintWriter file;

String filename="test.csv";

int i=0;
int []data=new int [3];
 
void setup() {
  println(Serial.list());
  arduino=new Serial(this, Serial.list()[1], 2000000);
  String path=sketchPath();
  path+="/data/"+filename;
  println("");
  print("PATH=");
  println(path);
  file=createWriter(path);
}

void draw(){}

void mousePressed(){
  if(i == 0){
    arduino.write('a');
    i=1;
  }
  else{
    arduino.write('b');
    i=0;
  }
}

void serialEvent(Serial arduino){
  String inString=arduino.readStringUntil('\n');
  if(inString != null){
    inString=trim(inString);
    if(inString.equals("stop")){
      file.flush();
      file.close();
      exit();
    }
    data=int(split(inString, ','));
    file.print(inString);
    print(inString);
    file.print("\n");
    print("\n");
    i++;
  }
}

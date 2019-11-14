import processing.serial.*;

Serial arduino;

PrintWriter file;

String d_path="test";
String filename="test"; //filename
String path;

int i=0;
int filenumber=0;
int []data=new int [3];
 
void setup() {
  println(Serial.list());
  arduino=new Serial(this, Serial.list()[3], 2000000);
  path=sketchPath()+"/"+d_path+"/"+filename+"_"+str(filenumber)+".csv"; //file path
  println("");
  print("PATH=");
  println(path);
}

void draw(){}

void keyPressed(){
  if(i==0){
  switch(key){
    case 'a':
    i=1;
    arduino.write('a');
    file=createWriter(path);
    filenumber++;
    break;
    case 'b':
    arduino.write('b');
    break;
  }
  }
  if(i==1){
    print(i);
    i=0;
    println(i);
  }
}

void serialEvent(Serial arduino){
  String inString=arduino.readStringUntil('\n');
  
  if(inString != null){
    inString=trim(inString);
    if(inString.equals("stop")){
      file.flush(); //writing file
      file.close();
      path=sketchPath()+"/"+d_path+"/"+filename+"_"+str(filenumber)+".csv"; //file path
      println("");
      print("PATH=");
      println(path);
    }
    data=int(split(inString, ','));
    file.print(inString);
    //print(inString);
    file.print("\n");
    //print("\n");
  } 
}

import processing.serial.*;

Serial arduino;

PrintWriter file;

String d_path="distans_test_3";
String filename="distans_test_3"; //filename
String path;

int i=0;
int filenumber=0;
int []data=new int [3];

char status;
 
void setup() {
  println(Serial.list());
  println("");
  println(Serial.list()[3]);
  arduino=new Serial(this, Serial.list()[3], 2000000);
}

void draw(){}

void keyPressed(){
  switch(i){
    case 0:
      switch(key){
        case 'a':
          path=sketchPath()+"/"+d_path+"/"+nf(filenumber,2)+"_"+filename+".csv"; //file path
          println("");
          print("PATH=");
          println(path);
          println("Prot Start");
          println("press key(YES=y,NO=n)");
          status=key;
          i=1;
          break;
        case 'b':
          arduino.write('b');
          break;
        case 't':
          println("");
          println("Adjustment test");
          println("press key(YES=y,NO=n)");
          status=key;
          i=1;
          break;
        case 'T':
          println("");
          println("Practice Test");
          println("press key(YES=y,NO=n)");
          status=key;
          i=1;
          break;
      }
      break;
    case 1:
      if(key == 'y'){
        i=0;
        println("Yes");
        switch(status){
          case 'a':
            file=createWriter(path);
            arduino.write('a');
            break;
          case 't':
            arduino.write('t');
            break;
          case 'T':
            arduino.write('T');
            break;
        }
      }
      if(key == 'n'){
        println("No");
        i=0;
      }
  }
}

void serialEvent(Serial arduino){
  String inString=arduino.readStringUntil('\n');
  if(inString != null){
    inString=trim(inString);
    print(inString);
    print("\n");
    if(status == 'a'){
      if(inString.equals("end")){
        file.flush(); //writing file
        file.close();
        filenumber++;
      }
      if(inString.equals("stop"))
        file.close();
      file.print(inString);
      file.print("\n");
    }
  } 
}

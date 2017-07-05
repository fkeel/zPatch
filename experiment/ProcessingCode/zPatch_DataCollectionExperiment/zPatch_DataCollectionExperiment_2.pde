import java.io.BufferedWriter; //log lines
import java.io.FileWriter; //create files
import processing.serial.*;


//////////////////UPDATE THIS///////////////
String participant = "test_Paul";
int participantID = 42; //any number between 0 and 99
////////////////////////////////////////////


///////////////EDIT STUFF HERE//////////////////////
int timeWindow = 60; //time of a window //chaged to number of readings
int numberOfWindows = 10; //how many times to record a gesture
int noiseRecordingWindows = 10; //number of windows in the noise conditions
int minRand = 1; //minimum number of noise window
int maxRand = 4; //max numbers of noise windows



String smallFiles = ""; //you could add a filepath here too
String masterFile = "masterFile.txt"; //you could add a filepath here too



int participantProgress = 0;

int state = -1;
//-1 = init
// 0 = waiting for trial to start
// 1 = recording noise
// 2 = recording gesture
// 3 = recording noise

String[] filenames = {
  "onBody_gentle_tap", 
  "onBody_strong_tap", 
  "onBody_push", 
  "onBody_swipe", 
  "onBody_hover", 
  "onTable_gentle_tap", 
  "onTable_strong_tap", 
  "onTable_push", 
  "onTable_swipe", 
  "onTable_hover"
};

String[] metaInstructions = {
  "Hit space to start trial:", 
  "Put on Sweater, hit Space to begin recording", 
  "Place Sweater on table, hit Space to begin recording", 
  "You will now record a gesture: when the screen turns red, perform the gesture as described. Hit space to start", 
  "Take off your sweater and put it in the box. Hit space when you are done."
};

String goNext = "Trial Complete, hit SPACE for next step";

String[] instructions = {
  "On Body: Tap the Sensor Gently", 
  "On Body: Give the Sensor a Strong Tap", 
  "On Body: Push the Sensor", 
  "On Body: Swipe over the sensor", 
  "On Body: Let your open hand hover over the sensor", 
  "On Table: Tap the Sensor Gently", 
  "On Table: Give the Sensor a Strong Tap", 
  "On Table: Push the Sensor", 
  "On Table: Swipe over the sensor", 
  "On Table: Let your open hand hover over the sensor", 
};

String[] actions = {
  "tap the Sensor Gently", 
  "give the Sensor a Strong Tap", 
  "push the Sensor", 
  "swipe over the sensor", 
  "let your open hand hover over the sensor", 
  "tap the Sensor Gently", 
  "give the Sensor a Strong Tap", 
  "push the Sensor", 
  "swipe over the sensor", 
  "let your open hand hover over the sensor", 
};

int fileNameCounter = 0;
int currentGestureWindow = 0; //keep track of gesture repititions

int totalMillis = 0;
int currentMillis = 0;
int deltaMillis = 0;

//dont edit these
int totalWindows = 0; //number of 'empty' windows toWrite
int windowsWritten = 0; //number of 'empty' windows written

String dataToBeLogged = "This is an example of how to write data to a file"; // string that we will write to file

boolean waitingForTouch = false;
boolean currentlyWriting = false;

int counter = 0; //log the number of loops 
int startWindowTime = 0;
int timeCounter = 0; //log the time
int delta = 0; //remember delta for displaying target

//SERIAL CONNECTION STUFF
Serial arduinoPort;  // The serial port at which we listen to data from the Arduino 
String rawIncomingValues; //this is where you dump the content of the serial port
int[] incomingValues = {0, 0}; //this is where you will store the incoming values, so you can use them in your program
int token = 10; //10 is the linefeed number in ASCII
boolean connectionEstablished = false;

//font to make things look nice
PFont font;
PFont largeFont;

void setup() {
  //this is just for easthetics. 
  font = createFont("arial", 18); 
   largeFont = createFont("arial", 28); 
  textFont(font);
  totalMillis = millis();
  size(1200, 500);

  //SERIAL CONNECTION STUFF
  println("these are the available ports: ");
  printArray(Serial.list());
  //chose your serial port, by putting the correct number in the square brackets 
  String serialPort = Serial.list()[0];
  println("You are using this port: " + serialPort);
  // Open the port with the same baud rate you set in your arduino
  arduinoPort = new Serial(this, serialPort, 115200);

  dataToBeLogged = "";
}


void draw() {
  totalMillis = millis();
  text("if you see this, there is a problem with the serial connection", 20, 20);
  if (connectionEstablished ) {
    if (incomingValues.length == 2) {


      if (participantProgress < filenames.length) {
        background(200);
        text("if you see this, there might be a problem with the state machine", 20, 20);

        // run experiment

        switch(state) {
        case -1: //getting prepared (for experimentor)
          background(30, 200, 30);
          text("Reminder: Update the name and ID?", 50, 50);
          text("Hit Space to start experiment", 50, 190);
          println("___________________________Initializing Experiment"); 
          break;

        case 0: //getting prepared (for participant)
           background(70, 70, 230);
          text("The next trial is: ", 50, 100);
          textSize(28);
          text(instructions[pseudoRandom[participantID][participantProgress]-1], 50, 160);
          textSize(18);
          text("Hit space to start", 50, 220);


          println("___________________________Preparing Trial"); 
          break;

        case 1: //explain record noise
          background(70, 70, 230);
          if (pseudoRandom[participantID][participantProgress]<6) {
            text("Put on Sweater, hit Space to begin recording", 50, 190);
          } else {
            text("Place sweater on Table, hit Space to begin recording", 50, 190);
          }

          println("___________________________explain record noise 1"); 
          break;

        case 2: //record noise

          writeNoise();

          println("___________________________Recording Noise 1"); 
          break;

        case 3: //explain record signal
          background(70, 70, 230);
          text("Record Input: when the screen turns red, perform the gesture:", 50, 120);
          textSize(28);
          text(instructions[pseudoRandom[participantID][participantProgress]-1], 50, 180);
          textSize(18);
          text("Hit SPACE when you are ready", 50, 220);



          println("___________________________Explain Recording Input");   
          break;

        case 4: //explain record signal
          background(70, 70, 230);

          writeCycle();


          println("___________________________Recording Input");   
          break;

        case 5: //record noise
          background(70, 70, 230);
          text("Place sweater in the box. Hit space to record.", 50, 190);

          println("___________________________Explain Recording Noise 2"); 


          //fileNameCounter = fileNameCounter +1;
          break;

        case 6: //record noise
          background(70, 70, 230);
          writeNoise();
          println("___________________________ Recording Noise 2"); 


          //fileNameCounter = fileNameCounter +1;
          break;
        }
      } else {
         background(70, 70, 230);
         textSize(28);
          text("EXPERIMENT COMPLETE, thank you!", 50, 190);
          textSize(18);
          state = 999;
      }
    }
  }
  println("State: " + state);
}

void keyReleased() {
  if (key == ' ') {
    state = state + 1;
    currentlyWriting = false;
    waitingForTouch = false;
    windowsWritten = 0;
    if (state > 6) {
      participantProgress = participantProgress +1;
      currentGestureWindow = 0;
      state = 0;
    }
    if (state == 999) {
      exit();
    }
  }
}
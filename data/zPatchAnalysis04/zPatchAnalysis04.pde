import processing.pdf.*; //for exporting visualizations
import java.io.BufferedWriter; //log lines
import java.io.FileWriter; //create files

String[] lines; //stores raw data

String[][] classes; //stores the identifying information
int[][] resistive; //stores all resistive readings
int[][] capacitive; //stores all capacitive readings

float[][] resistiveProcessed; //stores all preprocessed resistive readings
float[][] capacitiveProcessed; //stores all capacitive readings

float[][] resistiveFeatures; //stores all resistive readings features
float[][] capacitiveFeatures; //stores all capacitive readings features
float[][] sharedFeatures; //stores all shared features

int lineLimiter = 0; //helper variable for limiting the number of trials to display
float verticalOffset = 0; //helper variable to control Y position of visualization
int center = 0; //helper variable to control X position of visualization

int index = 900; //index of highlighted record

void setup() {

  // general graphics settings
  size(1620, 1100); // for visualizing on screen
  // size(1620, 1100 , PDF, "nothing.pdf"); //for exporting to pdf
  strokeCap(SQUARE);
  background(255);
  translate(200, height/2+60); //move the zero position towards the lower third of screen (data will be centred around that area)
  scale(1, -1); //flip screen so +y is up
  strokeWeight(2);

  //read data and split it up into smaller arrays that are easyer to work with
  lines = loadStrings("zPatch_balancedData.csv");
  classes = new String[lines.length][3];
  resistive = new int[lines.length][61];
  capacitive = new int[lines.length][61];
  resistiveProcessed = new float[lines.length][61];
  capacitiveProcessed = new float[lines.length][61];
  resistiveFeatures = new float[lines.length][7];
  capacitiveFeatures = new float[lines.length][7];
  sharedFeatures = new float[lines.length][22];

  //first three values are location, participant and type of input
  //then even values are resistive readings, odd values are capacitive. 
  //each reading has 60 samples from each sensor

  for (int i = 0; i < lines.length; i++) {
    int counter = 0; //for counting how many times the data has been assigned to array

    String[] placeHolder = split(lines[i], ','); //create an array of all items in a line

    for (int y = 0; y < placeHolder.length; y++) {
      if (y<3) {                //first three values
        classes[i][y] = trim(placeHolder[y]);
      } else if (y%2 == 0) {    //even, resistive
        resistive[i][counter] = int(placeHolder[y]);
      } else {                  //odd, capacitive
        capacitive[i][counter] = int(placeHolder[y]);
        counter++;
      }
    }

    // Sanity checks to see if data is read correctly:
    // println(lines[i]);
    // println(classes[i]);
    // println(resistive[i][1]);
    // println(capacitive[i][0]);
  }

  resistiveProcessed = preprocess(resistive);
  capacitiveProcessed = preprocess(capacitive);

  for (int i = 0; i < lines.length; i++) {
    float startingPosition = feature_ReleasePosition(resistiveProcessed[i]); //get the baseline for all index related variables
    //resistive measures decrease with touch events, so attack and release are swapped
    resistiveFeatures[i][0] = feature_ReleaseMagnitude(resistiveProcessed[i]);
    resistiveFeatures[i][1] = feature_AttackPosition(resistiveProcessed[i]) - startingPosition;
    resistiveFeatures[i][2] = feature_AttackMagnitude(resistiveProcessed[i]);
    resistiveFeatures[i][3] = feature_indexOfMin(resistiveProcessed[i]) - startingPosition;
    resistiveFeatures[i][4] = feature_magnitudeOfMin(resistiveProcessed[i]);
    resistiveFeatures[i][5] = feature_indexOfMax(resistiveProcessed[i]) - startingPosition;
    resistiveFeatures[i][6] = feature_magnitudeOfMax(resistiveProcessed[i]);
  }

  for (int i = 0; i < lines.length; i++) {
    float startingPosition = feature_AttackPosition(capacitiveProcessed[i]); //get the baseline for all index related variables

    capacitiveFeatures[i][0] = feature_AttackMagnitude(capacitiveProcessed[i]);
    capacitiveFeatures[i][1] = feature_ReleasePosition(capacitiveProcessed[i]) - startingPosition;
    capacitiveFeatures[i][2] = feature_ReleaseMagnitude(capacitiveProcessed[i]);
    capacitiveFeatures[i][3] = feature_indexOfMin(capacitiveProcessed[i]) - startingPosition;
    capacitiveFeatures[i][4] = feature_magnitudeOfMin(capacitiveProcessed[i]);
    capacitiveFeatures[i][5] = feature_indexOfMax(capacitiveProcessed[i]) - startingPosition;
    capacitiveFeatures[i][6] = feature_magnitudeOfMax(capacitiveProcessed[i]);
  }

  for (int i = 0; i < lines.length; i++) {
    float RESstartingPosition = feature_ReleasePosition(resistiveProcessed[i]); //make sure that all position data is in the same frame of reference
    float CAPstartingPosition = feature_ReleasePosition(capacitiveProcessed[i]); //make sure that all position data is in the same frame of reference

    //resistive part (max and min are swapped due to inverse behavior of signal
    sharedFeatures[i][0] = feature_ReleaseMagnitude(resistiveProcessed[i]);
    sharedFeatures[i][1] = feature_AttackPosition(resistiveProcessed[i]) - RESstartingPosition;
    sharedFeatures[i][2] = feature_AttackMagnitude(resistiveProcessed[i]);
    sharedFeatures[i][3] = feature_indexOfMax(resistiveProcessed[i]) - RESstartingPosition;
    sharedFeatures[i][4] = feature_magnitudeOfMax(resistiveProcessed[i]);
    sharedFeatures[i][5] = feature_indexOfMin(resistiveProcessed[i]) - RESstartingPosition;
    sharedFeatures[i][6] = feature_magnitudeOfMin(resistiveProcessed[i]);

    //capacitive part

    sharedFeatures[i][7] = feature_AttackMagnitude(capacitiveProcessed[i]);
    sharedFeatures[i][8] = feature_ReleasePosition(capacitiveProcessed[i]) - RESstartingPosition;
    sharedFeatures[i][9] = feature_ReleaseMagnitude(capacitiveProcessed[i]);
    sharedFeatures[i][10] = feature_indexOfMin(capacitiveProcessed[i]) - RESstartingPosition;
    sharedFeatures[i][11] = feature_magnitudeOfMin(capacitiveProcessed[i]);
    sharedFeatures[i][12] = feature_indexOfMax(capacitiveProcessed[i]) - RESstartingPosition;
    sharedFeatures[i][13] = feature_magnitudeOfMax(capacitiveProcessed[i]);

    //difference between the two
    sharedFeatures[i][14] = sharedFeatures[i][0] - sharedFeatures[i][7];
    sharedFeatures[i][15] = sharedFeatures[i][1] - sharedFeatures[i][8];
    sharedFeatures[i][16] = sharedFeatures[i][2] - sharedFeatures[i][9];
    sharedFeatures[i][17] = sharedFeatures[i][3] - sharedFeatures[i][10];
    sharedFeatures[i][18] = sharedFeatures[i][4] - sharedFeatures[i][11];
    sharedFeatures[i][19] = sharedFeatures[i][5] - sharedFeatures[i][12];
    sharedFeatures[i][20] = sharedFeatures[i][6] - sharedFeatures[i][13];
    sharedFeatures[i][21] = RESstartingPosition - CAPstartingPosition;
  }

  //Sanity check to make sure the processing is doing what I want it to
  print("Resistive Readings - Avg: ");
  print(mean(resistive));
  print(", SD: ");
  println(standardDeviation(resistive));

  print("Capacitive Readings - Avg: ");
  print(mean(capacitive));
  print(", SD: ");
  println(standardDeviation(capacitive));

  print("Resistive Readings after Processing - Avg: ");
  print(mean(resistiveProcessed));
  print(", SD: ");
  println(standardDeviation(resistiveProcessed));

  print("Capacitive Readings after Processing - Avg: ");
  print(mean(capacitiveProcessed));
  print(", SD: ");
  println(standardDeviation(capacitiveProcessed));

  //drawData("noise", 200);

  println("-----------------------------");
  println("");
  println("Data writing: ");


  //create the three files with features of capacitive, resistive and shared data.
  //this is very slow, probably because of how I am writing to the files
  //should be optimized, but works as is, if you have patience

  for (int i = 0; i < lines.length; i++) {
    /*
     print(i);
     print(", ");
     
     print(classes[i][2]);
     print(", ");
     */
    print(".");
    //start the lines with the input type
    appendTextToFile("resistive.txt", classes[i][1]);   
    appendTextToFile("capacitive.txt", classes[i][1]);    
    appendTextToFile("shared.txt", classes[i][1]); 
    appendTextToFile("resistive.txt", ", ");   
    appendTextToFile("capacitive.txt", ", ");    
    appendTextToFile("shared.txt", ", "); 
    appendTextToFile("resistive.txt", classes[i][2]);   
    appendTextToFile("capacitive.txt", classes[i][2]);    
    appendTextToFile("shared.txt", classes[i][2]); 

    //add the data where it belings
    for (int y = 0; y < resistiveFeatures[i].length; y++) {
      //   print(capacitiveFeatures[i][y]);
      //   print(", ");
      appendTextToFile("resistive.txt", ", " + str(resistiveFeatures[i][y]));
    }
    for (int y = 0; y < resistiveFeatures[i].length; y++) {
      appendTextToFile("capacitive.txt", ", " +  str(capacitiveFeatures[i][y]));    
      //   print(resistiveFeatures[i][y]);
      //   print(", ");
    }
    for (int y = 0; y < sharedFeatures[i].length; y++) {
      appendTextToFile("shared.txt", ", " + str(sharedFeatures[i][y])); 
      //   print(sharedFeatures[i][y]);
      //   print(", ");
    }

    //add linebreaks
    appendTextToFile("resistive.txt", "\n");   
    appendTextToFile("capacitive.txt", "\n");    
    appendTextToFile("shared.txt", "\n"); 
    //   println();
  }
  println("all data written to files");
}
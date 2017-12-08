import processing.pdf.*; //for exporting visualizations
import java.io.BufferedWriter; //log lines
import java.io.FileWriter; //create files

String[] linesR; //stores raw data
String[] linesC; //stores raw data
String[] linesS; //stores raw data
String[] names = {"Abe", "Mark", "Agata", "Ditte", "Fabian", "Eric", "Robert", "John", "Katelyn", "Nicolai"};

void setup() {

  // general graphics settings
  size(1620, 1100); // for visualizing on screen

  linesR = loadStrings("resistive_forSplit.txt");
  linesC = loadStrings("capacitive_forSplit.txt");
  linesS = loadStrings("shared_forSplit.txt");

  for (int nameIndex = 0; nameIndex < names.length; nameIndex++) {

    for (int i = 0; i < linesS.length; i++) {


      String[] placeHolder = split(linesS[i], ','); //create an array of all items in a line

      if (placeHolder[0].equals(names[nameIndex])) {
        appendTextToFile("SHARED_" + names[nameIndex] + "_test.arff", linesS[i]); 
        appendTextToFile("SHARED_" + names[nameIndex] + "_test.arff", "\n"); 

        appendTextToFile("CAPACITIVE_" + names[nameIndex] + "_test.arff", linesC[i]); 
        appendTextToFile("CAPACITIVE_" + names[nameIndex] + "_test.arff", "\n"); 

        appendTextToFile("RESISTIVE_" + names[nameIndex] + "_test.arff", linesR[i]); 
        appendTextToFile("RESISTIVE_" + names[nameIndex] + "_test.arff", "\n"); 
        //writeTestFille
      } else {
        appendTextToFile("SHARED_" + names[nameIndex] + "_train.arff  ", linesS[i]); 
        appendTextToFile("SHARED_" + names[nameIndex] + "_train.arff", "\n"); 

        appendTextToFile("CAPACITIVE_" + names[nameIndex] + "_train.arff", linesC[i]); 
        appendTextToFile("CAPACITIVE_" + names[nameIndex] + "_train.arff", "\n"); 

        appendTextToFile("RESISTIVE_" + names[nameIndex] + "_train.arff", linesR[i]); 
        appendTextToFile("RESISTIVE_" + names[nameIndex] + "_train.arff", "\n"); 
      }
      print(".");
    }
     print("x");
  }
  print("done");
}
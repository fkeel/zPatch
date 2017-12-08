import processing.pdf.*;

String[] lines; //stores raw data

void setup() {

  // general graphics settings
  size(800, 800); // for visualizing on screen
//   size(800, 800 , PDF, "visualization2.pdf"); //for exporting to pdf
  strokeCap(SQUARE);
  background(255);
  translate(0, height); //move the zero position towards the lower third of screen (data will be centred around that area)
  scale(1, -1); //flip screen so +y is up
  noStroke();
  translate(15, 15);
  //read data and split it up into smaller arrays that are easyer to work with
  lines = loadStrings("abeviz.txt");

  for (int i = lines.length-1; i > 0; i--) {

    String[] placeHolder = split(lines[i], ','); //create an array of all items in a line




    for (int y = 0; y < placeHolder.length; y++) {
      fill(10, 10, 10, 8);
      if (placeHolder[1].equals(" noise")) {
        // for (int z = 1; z < 4; z++) {
println("noSpace");
        ellipse(abs(float(placeHolder[2])*200), abs(float(placeHolder[15]))*100, 10, 10);
        //  }
      }
    }
  }
  for (int i = lines.length-1; i > 0; i--) {

    String[] placeHolder = split(lines[i], ','); //create an array of all items in a line
    for (int y = 0; y < placeHolder.length; y++) {

      if (placeHolder[1].equals(" noise")) {
      //  println(" noise?");
      } else {
        if (placeHolder[1].equals(" push")) {
          fill(0, 0, 255, 010);
        } else if (placeHolder[1].equals(" gentletap")) {
          fill(255, 0, 0, 10);
        } else if (placeHolder[0].equals(" strongtap")) {
          fill(255, 0, 255, 10);
        } else if (placeHolder[1].equals(" hover")) {
          fill(59, 200, 25, 10);
        } else if (placeHolder[1].equals(" swipe")) {
          fill(200, 200, 0, 10);
        } 

        ellipse(abs(float(placeHolder[2])*200), abs(float(placeHolder[15]))*100, 12, 12);
      }
    }
  }

println("done");
println("done");
println("done");
println("done");
println("done");
}
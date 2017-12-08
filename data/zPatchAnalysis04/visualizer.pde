

void drawData(String targetClass, int numberOfInstances) {

  for (int i = 0; i < lines.length; i++) { //loop through all records

    if (classes[i][2].equals(targetClass) && (lineLimiter < numberOfInstances) ) { //specify subset of records to display
      //  if (classes[i][2].equals("hover") && (lineLimiter < 200) && classes[i][1].equals("Robert")) { //specify subset of records to display
      lineLimiter++;

      //visualize resistive sensing
      if (lineLimiter == index) {
        stroke(220, 220, 0 );
        strokeWeight(5);
      } else {
        strokeWeight(4);
        stroke(random(180), random(180), random(20)+ 200, 60); //give each record a color
      }
      center = indexOfJump(resistiveProcessed[i]); //aligns the data based on change in resistance
      //  center = indexOfMin(resistive[i]); //alternative aligning method
      //  center = indexOfMax(capacitive[i]); //alternative aligning method
      //  center = 30; //if not using a smart centering method

      verticalOffset = getVerticalPositionRes(resistiveProcessed[i]);
       

  
      for (int y = 1; y < resistiveProcessed[i].length-1; y++) { //loop through array and draw individual line segments to form curve
        line((y+(30-center))*20, (resistiveProcessed[i][y]-verticalOffset)*50, (y+1+(30-center))*20, (resistiveProcessed[i][y+1]-verticalOffset)*50);
      }


      //visualize capacitive sensingc
      if (lineLimiter == index) {
        stroke(220, 220, 0);
        strokeWeight(5);
      } else {
        strokeWeight(4);
        stroke(random(20)+200, random(180), random(180), 60);
      }
      center = indexOfJump(resistiveProcessed[i]);
      //   center = 30;
      //   center = indexOfMin(resistive[i]);
      //   center = indexOfMax(capacitive[i]);
      pushMatrix();
translate(0,30);
      verticalOffset = getVerticalPositionCap(capacitiveProcessed[i]);

      for (int y = 1; y < resistiveProcessed[i].length-1; y++) {

        line((y+(30-center))*20, (capacitiveProcessed[i][y-1]-verticalOffset)*50, (y+1+(30-center))*20, (capacitiveProcessed[i][y]-verticalOffset)*50);
      }
      popMatrix();
    }
  }
}
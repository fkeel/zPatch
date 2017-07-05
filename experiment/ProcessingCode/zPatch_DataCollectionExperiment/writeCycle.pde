
void writeNoise() { //write 50 noise trials
  println("windowsWritten: " + windowsWritten);
  if (!currentlyWriting && !waitingForTouch) {
    background(50, 250, 10);
    //decide how long the pause will be 
    totalWindows = noiseRecordingWindows;
    currentlyWriting = true;
    waitingForTouch = true;
    startWindow("0");
  }

  //write the noise windos 
  if (currentlyWriting && waitingForTouch) {
    //set the background 
        background(80, 80, 80);
      text("RECORDING NOISE... please wait", 50, 190);
    addDataToWindow(); //concatinate to string
    if (windowComplete(timeWindow)) { //check if the milliseconds match, start new window
      windowsWritten = windowsWritten +1;

      startWindow("0");
    }
  }

  if (windowsWritten >= totalWindows) {
    waitingForTouch = false;
    background(200, 200, 30);
    text(goNext, 50, 190);
  }
}

void writeCycle() {

  //if we're not logging a touch and have not decided how long the pause will be
  if (!currentlyWriting && !waitingForTouch) {
    background(50, 250, 10);
    //decide how long the pause will be 
    totalWindows = int(random(minRand, maxRand));
    currentlyWriting = true;
    waitingForTouch = true;
    startWindow("0");
  }

  //write the noise windos 
  if (currentlyWriting && waitingForTouch) {
    //set the background 
    background(80, 80, 80);
    text("Get ready to " + actions[pseudoRandom[participantID][participantProgress]-1], 50, 190);
    addDataToWindow(); //concatinate to string
    if (windowComplete(timeWindow)) { //check if the milliseconds match, start new window
      windowsWritten = windowsWritten +1;

      startWindow("0");
    }

    if (windowsWritten == totalWindows) {
      windowsWritten = 0;
      waitingForTouch = false;
      startWindow("1");
    }
  }

  if (currentlyWriting && !waitingForTouch) {
    //set the background 
    background(250, 50, 50);
    text("NOW!", 50, 190);
    //write the dataWindow windos
    addDataToWindow();
    if (windowComplete(timeWindow)) { //check if the milliseconds match, start new window
      currentlyWriting = false;
      currentGestureWindow = currentGestureWindow +1;
    }
  }

  if (currentGestureWindow >= numberOfWindows) {
    background(200, 200, 30);
    text(goNext, 50, 190);
  }
}


void startWindow(String classID) {
  startWindowTime = 0;
  dataToBeLogged = classID + ", ";
  currentMillis = millis();
}
void addDataToWindow() {
  startWindowTime = startWindowTime + 1;
  deltaMillis = totalMillis - currentMillis;
  dataToBeLogged = dataToBeLogged +str(incomingValues[0]) + ", " + str(incomingValues[1]) + ", ";   //+ deltaMillis + ", ";
}

boolean windowComplete(int windowSize) {
  if (startWindowTime >= windowSize) {
    appendTextToFile(filenames[pseudoRandom[participantID][participantProgress]-1]+ "_" +participant +".txt", dataToBeLogged);
    appendTextToFile(filenames[pseudoRandom[participantID][participantProgress]-1]+ "_" + participant +".txt", "\r\n");

    appendTextToFile(masterFile, currentTime() + ", " + filenames[pseudoRandom[participantID][participantProgress]-1] 
                          + ", " + participant + ", " + dataToBeLogged);
    appendTextToFile(masterFile, "\r\n");
    return true;
  } else {
    return false;
  }
}
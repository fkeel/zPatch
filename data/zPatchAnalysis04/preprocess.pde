
//these are double at the moment, one set deals with float arrays the other with int

float mean(int[][] data) {
  int counter = 0;
  int total = 0;
  for (int i = 0; i < data.length; i++) {
    for (int y = 0; y < data[i].length; y++) {
      total = total+ data[i][y];
      counter++;
    }
  }
  float mean = total / counter;
  return mean;
}

float standardDeviation(int[][] data) {
  int counter = 0;
  float total = 0;  
  float variance = 0;
  float sd;
  float average = mean(data);
  for (int i = 0; i < data.length; i++) {
    for (int y = 0; y < data[i].length; y++) {
      total = total + sq(data[i][y]-average);
      counter++;
    }
  }
  variance = total / counter;
  sd = sqrt(variance);
  return sd;
}

float[][] preprocess(int[][] data) {
  float[][] processed = new float[data.length][data[1].length];
  float sd = standardDeviation(data);
  float average = mean(data);
  for (int i = 0; i < data.length; i++) {
    for (int y = 0; y < data[i].length; y++) {
      //   processed[i][y] = (float(data[i][y]) - average) ;
      processed[i][y] = (data[i][y] - average)/sd ;
    }
  }
  return processed;
}


float mean(float[][] data) {
  int counter = 0;
  float total = 0;
  for (int i = 0; i < data.length; i++) {
    for (int y = 0; y < data[i].length; y++) {
      total = total+ data[i][y];
      counter++;
    }
  }
  float mean = total / counter;
  return mean;
}

float standardDeviation(float[][] data) {
  int counter = 0;
  float total = 0;  
  float variance = 0;
  float sd;
  float average = mean(data);
  for (int i = 0; i < data.length; i++) {
    for (int y = 0; y < data[i].length; y++) {
      total = total + sq(data[i][y]-average);
      counter++;
    }
  }
  variance = total / counter;
  sd = sqrt(variance);
  return sd;
}
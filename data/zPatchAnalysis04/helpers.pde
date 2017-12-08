
float getVerticalPositionCap(float[] haystack) {
  float sum = 0;
  float average;
  for (int i=5; i<10; i++)
  {
    sum = sum + haystack[i];
  }
  average = sum / 5;
  return average;
}


float getVerticalPositionRes(float[] haystack) {
  float sum = 0;
  float average;
  for (int i=5; i<10; i++)
  {
    sum = sum + haystack[i];
  }
  average = sum / 5;
  return average;
}

int indexOfJump(float[] haystack) {
  int pos=-1;
  float delta=0; //lowest possible value of an int.
  for (int i=haystack.length-1; i>10; i--)
  {
    if (haystack[i-1] - haystack[i]> delta)
    {
      pos=i;
      delta=haystack[i-1] - haystack[i];
    }
  } 
  return pos;
}

int indexOfMin(float[] haystack) {
  int pos=-1;
  float min=99999999; //lowest possible value of an int.
  for (int i=20; i<haystack.length-15; i++)
  {
    if (haystack[i]<min)
    {
      pos=i;
      min=haystack[i];
    }
  } 
  return pos;
}


int indexOfMax(float[] haystack) {
  int pos=-1;
  float max=0; //lowest possible value of an int.
  for (int i=10; i<haystack.length-3; i++)
  {
    if (haystack[i]>max)
    {
      pos=i;
      max=haystack[i];
    }
  } 
  return pos;
}
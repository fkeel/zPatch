



float feature_AttackPosition(float[] haystack) { //location of strongest Positive Signal Change
  int pos=-1;
  float delta=0; //lowest possible value of an int.
  for (int i = 3; i < haystack.length-3; i++)
  {
    if (haystack[i] - haystack[i-1]> delta)
    {
      pos=i;
      delta=haystack[i] - haystack[i-1];
    }
  } 
  return pos;
}


float feature_AttackMagnitude(float[] haystack) { //magnitude of strongest Positive Signal Change
  float delta=0; //lowest possible value of an int.
  for (int i = 3; i < haystack.length-3; i++)
  {
    if (haystack[i] - haystack[i-1]> delta) //this should be positive, if a large value follows a small value
    {
      delta=haystack[i] - haystack[i-1];
    }
  } 
  return delta;
}


float feature_ReleasePosition(float[] haystack) { //location of strongest Negative Signal Change
  int pos=-1;
  float delta=999; //higher value than possble
  for (int i = 3; i < haystack.length-3; i++)
  {
    if (haystack[i] - haystack[i-1]< delta)
    {
      pos=i;
      delta=haystack[i] - haystack[i-1];
    }
  } 
  return pos;
}


float feature_ReleaseMagnitude(float[] haystack) { //location of strongest Negative Signal Change
  float delta=999; //higher value than possble
  for (int i = 3; i < haystack.length-3; i++)
  {
    if (haystack[i] - haystack[i-1]< delta)
    {
      delta=haystack[i] - haystack[i-1];
    }
  } 
  return delta;
}


float feature_indexOfMin(float[] haystack) {
  int pos=-1;
  float min=99999999; //lowest possible value of an int.
  for (int i=3; i<haystack.length-3; i++)
  {
    if (haystack[i]<min)
    {
      pos=i;
      min=haystack[i];
    }
  } 
  return pos;
}

float feature_magnitudeOfMin(float[] haystack) {

  float min=99999999; //lowest possible value of an int.
  for (int i=3; i<haystack.length-3; i++)
  {
    if (haystack[i]<min)
    {
      min=haystack[i];
    }
  } 
  return min;
}

float feature_indexOfMax(float[] haystack) {
  int pos=-1;
  float max=0; //lowest possible value of an int.
  for (int i=3; i<haystack.length-3; i++)
  {
    if (haystack[i]>max)
    {
      pos=i;
      max=haystack[i];
    }
  } 
  return pos;
}

float feature_magnitudeOfMax(float[] haystack) {
  float max=0; //lowest possible value of an int.
  for (int i=3; i<haystack.length-3; i++)
  {
    if (haystack[i]>max)
    {
      max=haystack[i];
    }
  } 
  return max;
}
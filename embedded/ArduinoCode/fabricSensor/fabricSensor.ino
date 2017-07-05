///////////////////////////
// zPatch Sensor Code /////
///////////////////////////

// paul.strohmeier@gmail.com, for HCC retreat 2017

// This Sketch is messy because I am still experimenting with how to do things the best way
// Feel free to muck around, but its a bit of a hack so its easy to break stuff

// The key things to know are the function 
// dualAnalogRead(pinA, pinB, samples) and capacitiveRead(pinA, pinB, samples)
// Both functions take two analog pins as parameters (where your sensors is connected)
// The third parameter is the number of times you want to sample. 
// capacitiveRead needs more samples, dualAnalogRead is quite stable.

// Based on the adcTouch library

//Values for filtering and storing capacitive readings
int baseline;
int capValues;
int prevCapValues;
int rawCapacitance;
float k = 0.2; // this adjusts the low-pass filter: 
               // 0 == no signal
               // 0.001 == very aggressive (slow but steady) 
               // 0.999 == not aggressive at all (fast but noisy)
               // 1 == no filter

//value for storing resistive readings
int resValues;

void setup()
{
  Serial.begin(9600); // open the arduino serial port
  delay(50); //delays might stabalize initial readings. Or they might be useless
  resValues = dualAnalogRead(A0, A1, 3); //this line should not be needed, but might stabalize readings
  baseline = capacitiveRead(A0, A1, 10); //set the baseline for capacitive readings
  Serial.println(baseline);
  delay(50);
}


void loop()
{
  rawCapacitance = capacitiveRead(A0, A1, 10); //sample capacitance
  rawCapacitance = (rawCapacitance - baseline); //baseline capacitance value 
  capValues = prevCapValues + (k * (rawCapacitance - prevCapValues)); //filter capacitive value
  prevCapValues = capValues; //for filtering

  resValues = dualAnalogRead(A0, A1, 3); //sample resistance

//print to serial port
  Serial.print(capValues); 
  Serial.print(", ");
  Serial.print(resValues); 
  Serial.println(); 
//if you add more values, keep this formatting (number - comma - space - etc and end with new line)
//the processing sketch is set up to expect it this way

  delay(5); // (so as not to completely flood the serial port

}

// ---------------- Don't worry about the code below this line ---------- 

int capacitiveRead(int pinA, int pinB, int number) {
  int capacitanceA = 0;
  int capacitanceB = 0;
  int capacitance = 0;

  for (int i = 0; i < number; i++) {
    pinMode(pinA, INPUT);
    pinMode(pinB, INPUT_PULLUP);
    ADMUX |=   0b11111;
    ADCSRA |= (1 << ADSC); //start conversion
    while (!(ADCSRA & (1 << ADIF))); //wait for conversion to finish
    ADCSRA |= (1 << ADIF); //reset the flag
    pinMode(pinB, INPUT);
    capacitanceB = analogRead(pinB);

    pinMode(pinB, INPUT);
    pinMode(pinA, INPUT_PULLUP);
    ADMUX |=   0b11111;
    ADCSRA |= (1 << ADSC); //start conversion
    while (!(ADCSRA & (1 << ADIF))); //wait for conversion to finish
    ADCSRA |= (1 << ADIF); //reset the flag
    pinMode(pinA, INPUT);
    capacitanceA = analogRead(pinA);

    capacitance = capacitance + capacitanceA + capacitanceB;

  }
  return capacitance;
}


int dualAnalogRead(int pinA, int pinB, int number) {
  int resistanceA = 0;
  int resistanceB = 0;
  int resistance = 0;

  for (int i = 0; i < number; i++) {
    pinMode(pinA, OUTPUT);
    digitalWrite(pinA, LOW);
    pinMode(pinB, INPUT_PULLUP);
    resistanceB = analogRead(pinB);

    pinMode(pinB, OUTPUT);
    digitalWrite(pinB, LOW);
    pinMode(pinA, INPUT_PULLUP);
    resistanceA = analogRead(pinA);

    resistance = resistance + (resistanceA + resistanceB) / 2;

  }
  return resistance / number;
}




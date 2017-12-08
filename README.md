# zPatch

Code & Data used in our TEI 2018 submission

## Using ZPatch

Go to 'embedded' and download 'fabricSensor.ino'

We used this sketch with Arduino v1.8.2
We succesfully tested it on Arduino Nano, Uno, Mega2560 and the Sparkfun RedBoard

For more information see our paper (link will be updated when available) or check out the Instructeable (link will be updated soon).

## Evaluating ZPatch

You can find the data in the /data directory. The 'rawDataForAnalysis.csv' is the file I used to extract features.
In the /Features directory you will find the .arff files that I used for running the analysis in Weka 3.8
I used the train/test pairs for the overall 10 fold cross validation. I used the 'test' files for the per-person analysis.

## Reconstructing our work

The sketch I used for collecting the data can be found in /experiment/processingCode

The sketch I used for extracting features and the visualization on page 6 can be found in /data/zPatchAnalysis04
That sketch does various things, read the inline comments - depending on what you want to use it for you will need to uncomment sections

The sketch for creating the scatterplot on page 7 can be found under /zPatchViz

I used Processing 3.2.4 


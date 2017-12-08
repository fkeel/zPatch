/**
 * Appends text to the end of a text file located in the data directory, 
 * creates the file if it does not exist.
 * Can be used for big files with lots of rows, 
 * existing lines will not be rewritten
 
 write like this:  appendTextToFile(outFilename, "Text " + i + "\r\n");
 */
 
 void create(String filename) {
  File f = new File(dataPath(filename));
  if (!f.exists()) {
    createFile(f);
  }
 }
  
void appendTextToFile(String filename, String text) {
  File f = new File(dataPath(filename));
  if (!f.exists()) {
    createFile(f);
  }
  try {
    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(f, true)));
    out.print(text);
    out.close();
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}

/**
 * Creates a new file including all subfolders
 */
void createFile(File f) {
  File parentDir = f.getParentFile();
  try {
    parentDir.mkdirs(); 
    f.createNewFile();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}


void newTextFile(String filename) {
  File f = new File(dataPath(filename));
  if (!f.exists()) {
    createFile(f);
  }
}
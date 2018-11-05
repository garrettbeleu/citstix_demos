
class  FrameData {
  public int w;
  public int h; 
  FrameData(int lw, int lh) {
    w = lw;
    h  = lh;   
  } 
}

//class to store circle detection data in (x,y,radius/2) format
// needed so it can be used in a pass-by-reference manner
class dataStorage {
  float[][] data;
  dataStorage() {}  
}

// quickly print an array containing the number of r,g,b circles detected 
void printTotals(float[][] r, float[][] g, float[][] b) {
   int[] theTotal = {r.length,g.length,b.length};
   println( "# of r,g,b= "+Arrays.toString(theTotal) );
}

// - - - - print 2d array to compare values
void print2D(double arr[][]) { 
  print("print2D= ");  
  // Loop through all rows 
  for (double[] row : arr) {
    // converting each row as string 
    // and then printing in a separate line 
    println(Arrays.toString(row));
  }
  println("");
}
// or as float[][]
void print2DFloats(float arr[][]) { 
  print("print2D= ");  
  // Loop through all rows 
  for (float[] row : arr) {
    // converting each row as string 
    // and then printing in a separate line 
    println(Arrays.toString(row));
  }
  println("");
}

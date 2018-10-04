/*

Setting opencv to run in Release Mode rather than Debug Mode is faster
Do NOT know where to check or change that
http://answers.opencv.org/question/19856/max-capture-frame-rate-supported/


*/

// - - - - IMPORTANT circles matrix to 2d array

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

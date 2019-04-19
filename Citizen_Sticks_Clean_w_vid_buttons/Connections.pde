/*
//\\//\\//\\//\\//\\//\\//\\//\\
    Connect circles data-viz
\\//\\//\\//\\//\\//\\//\\//\\//

drawCircles params -- (where to get circle data, what color to draw the connecting lines and circles)
*/

class Connections  {
  
  Connections() {  
  }
  
  void drawCircles(float[][] inputArray, color c) {
    
      stroke(c);
      
      // draw continuous spline curves connecting each detected circle
      if (inputArray.length>1) {
        beginShape();
        curveVertex(inputArray[0][0], inputArray[0][1]);
        curveVertex(inputArray[0][0], inputArray[0][1]);
        for (int i=0; i<inputArray.length; i++) {
          if(i>0) {
            curveVertex(inputArray[i-1][0], inputArray[i-1][1]);
            //curveVertex(inputArray[i-1][0], inputArray[i-1][1]);
          }
          if(i==inputArray.length-1) {
            curveVertex(inputArray[i][0], inputArray[i][1]);
          }
        }
        curveVertex(inputArray[0][0], inputArray[0][1]);
        curveVertex(inputArray[0][0], inputArray[0][1]);
        endShape();
      }
      
      // drawing ellipses at detected circle locations
      for (int i=0; i<inputArray.length; i++) {
        ellipse(inputArray[i][0],inputArray[i][1],inputArray[i][2]*2,inputArray[i][2]*2);
      }
  }
  
  void pushToScreen() {
    strokeWeight(3);
    noFill();
    drawCircles(dsRed.data, color(255,0,0));
    drawCircles(dsGreen.data, color(0,255,0));
    drawCircles(dsBlue.data, color(0,0,255));  
  }
 
}

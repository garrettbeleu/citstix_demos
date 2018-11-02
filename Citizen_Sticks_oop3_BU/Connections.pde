/*
//\\//\\//\\//\\//\\//\\//\\//\\
    Connect circles data-viz
\\//\\//\\//\\//\\//\\//\\//\\//
*/

class Connections  {
  
  Connections() {  
  }
  
  void drawCircles(float[][] inputArray, Mat circleMatrix, color c) {
    
    if( circleMatrix.rows()>0) {
      stroke(c);
        
      // draw as continuous spline curves
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
      
      // drawing as ellipses
      for (int i=0; i<inputArray.length; i++) {
        ellipse(inputArray[i][0],inputArray[i][1],inputArray[i][2]*2,inputArray[i][2]*2);
      }
    }
  }
  
  void pushToScreen() {
    strokeWeight(3);
    noFill();
    drawCircles(dsRed.data,gbcv.circlesRed, color(255,0,0));
    drawCircles(dsGreen.data, gbcv.circlesGreen, color(0,255,0));
    drawCircles(dsBlue.data, gbcv.circlesBlue, color(0,0,255));  
  }
 
}

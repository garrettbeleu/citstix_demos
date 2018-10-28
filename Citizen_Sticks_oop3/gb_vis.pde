


class gbDrawCircs  {
  
  gbDrawCircs() {
     
  }
  
  
  
  void updateCircles() {
      strokeWeight(3);
      noFill();
      findCircles(gbcv.matRed, gbcv.circlesRed, dsRed);
      drawCircles(dsRed.data, gbcv.circlesRed, color(255, 0, 0));
    
      findCircles(gbcv.matGreen, gbcv.circlesGreen, dsGreen);
      drawCircles(dsGreen.data, gbcv.circlesGreen, color(0, 255, 0));
    
      findCircles(gbcv.matBlue, gbcv.circlesBlue, dsBlue);
      drawCircles(dsBlue.data, gbcv.circlesBlue, color(0, 0, 255));
    
    
  }
  
  
   void findCircles(Mat input, Mat output, dataStorage theData) {
    Imgproc.HoughCircles(input, output, Imgproc.CV_HOUGH_GRADIENT, 
                         dp.getValue() ,minDist.getValue(), 
                         cannyHigh.getValue(), cannyLow.getValue(),
                         int(minSize.getValue()),int(maxSize.getValue()) );

      if (output.rows()>0) {
        //println("dump= "+output.dump() +"\n");
       
        //place circlesRed matrix values into an array of the same datatype
        double[][] tempData = new double[output.cols()][output.rows()];
        for(int i=0; i<output.cols(); i++) {  
          tempData[i] = output.get(0,i);
          //println(output.get(0,i));
        }
        
        // initialize the size of the float[][] array
        theData.data = new float[tempData.length][3];
          for(int i=0; i<tempData.length; i++) {
            for(int j=0; j<tempData[i].length; j++) {
              // cast the double[][] to a float[][]
              theData.data[i][j] = (float)tempData[i][j];
            }
          }        
      }else{
        //empty but not null
        theData.data = new float[0][0];
      }
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
    
    int[] calculateTotals(float[][] r, float[][] g, float[][] b) {
       int[] theTotal = {r.length,g.length,b.length};
       return theTotal;
    }
  
 
}

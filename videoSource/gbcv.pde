
class GBCV {
  Mat matRed, matRed2, matGreen, matBlue, matRGB;
  PImage src, redFilteredImage, greenFilteredImage, blueFilteredImage, rgbFilteredImage;
  Mat circlesRed, circlesGreen, circlesBlue;
  
  GBCV() {
    matRed = new Mat(gframe.w, gframe.h, CvType.CV_8UC1); //red hues 0-10
    matRed2 = new Mat(gframe.w, gframe.h, CvType.CV_8UC1); //red hues 150-179
    matGreen = new Mat(gframe.w, gframe.h, CvType.CV_8UC1);
    matBlue = new Mat(gframe.w, gframe.h, CvType.CV_8UC1);
    matRGB = new Mat(gframe.w, gframe.h, CvType.CV_8UC3);
    //
    circlesRed= new Mat();
    circlesGreen= new Mat();
    circlesBlue= new Mat();
  }
  
  void inRangeGB(Mat src, int h1, int h2, int s1, int s2, int v1, int v2, Mat dst){
      Core.inRange( src, new Scalar(h1,s1,v1), new Scalar(h2,s2,v2), dst );
  }
  
  void drawVideo(char theCase) {
    switch(theCase) {
    case '`':
      if (inputVideo.isWebcam) {
        image(inputVideo.webcam,0,0);
        //set(0,0,inputVideo.webcam); // this is faster if no resize or transformations are needed
      } else {
        image(inputVideo.movie,0,0);
      }
      break;
    case '1':
      // remember BGR is opencv order
      List<Mat> listMat = Arrays.asList(matBlue,matGreen,matRed);
      Core.merge(listMat, matRGB);
      
      // POST-PROCESS the gbMatRGB matrix, could also try preprocessing the opencv object (src video) instead
      // * * * * dilation followed by erosion has different results that erosion followed by dilation
      // https://stackoverflow.com/questions/30369031/remove-spurious-small-islands-of-noise-in-an-image-python-opencv
      if( cp5.getController("morphTog").getValue()==1.0 ) {
        // dilate then erode = closing operation
        // erode then dilate = opening operation
        //Imgproc.dilate(gbMatRGB,gbMatRGB, new Mat() );
        //Imgproc.erode(gbMatRGB,gbMatRGB, new Mat() );
                
        //CLOSE(erode?) w/ an ellipse shape and size(x,y) followed by OPEN(dilate?)
        Mat kernel = Imgproc.getStructuringElement( Imgproc.MORPH_ELLIPSE, new Size(6,6));
        Imgproc.morphologyEx(matRGB,matRGB, Imgproc.MORPH_CLOSE, kernel ); 
        Imgproc.morphologyEx(matRGB,matRGB, Imgproc.MORPH_OPEN, kernel );      
        //MORPH_TOPHAT,BLACKHAT,GRADIENT are not useful here
        
        // params- ( src, dst, size of blur(x,y) , deviation)
        //Imgproc.GaussianBlur(gbcv.matRGB, gbcv.matRGB, new Size(9,9), 0); //this seems slow
       }
       
      rgbFilteredImage = opencv.getSnapshot(matRGB);
      image(rgbFilteredImage,0,0);
      break;
    case '2':
      redFilteredImage = opencv.getSnapshot(matRed);
      image(redFilteredImage,0,0);
      break;
    case '3':
      greenFilteredImage = opencv.getSnapshot(matGreen);
      image(greenFilteredImage,0,0);
      break;
    case '4':
      blueFilteredImage = opencv.getSnapshot(matBlue);
      image(blueFilteredImage,0,0);
      break;
    case '0': //display no video
      break;
    default:
      break;
    }
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
        //empty but not null?
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
    
    void textPanel(float[][] r, float[][] g, float[][] b) {
      stroke(255);
      
      float participants = 18;
      float total = r.length + g.length + b.length;
      float percent = total*100/participants;
      
      text("Participation: "+String.format("%.2f", percent)+"%", 500,300);
      text( "Red: "+r.length,500,340);
      text( "Green: "+g.length,620,340);
      text( "Blue: "+b.length,740,340);
      
      for(int i=0; i<r.length; i++) {
        for( int j=0; j<r[i].length; j++) {
          if( j==r[i].length-1){
            redStrBuilder.append((int)r[i][j]+";\n");
          }else{
            redStrBuilder.append((int)r[i][j]+",");
          }
        }
      }
      
      for(int i=0; i<g.length; i++) {
        for( int j=0; j<g[i].length; j++) {
          if( j==g[i].length-1){
            greenStrBuilder.append((int)g[i][j]+";\n");
          }else{
            greenStrBuilder.append((int)g[i][j]+",");
          }
        }
      }
      
      for(int i=0; i<b.length; i++) {
        for( int j=0; j<b[i].length; j++) {
          if( j==b[i].length-1){
            blueStrBuilder.append((int)b[i][j]+";\n");
          }else{
            blueStrBuilder.append((int)b[i][j]+",");
          }
        }
      }
      
      String redString = redStrBuilder.toString();
      String greenString = greenStrBuilder.toString();
      String blueString = blueStrBuilder.toString();
      text( redString,500,380);
      text( greenString,620,380);
      text( blueString,740,380);
      //clear the stringBuilder object for next cycle
      redStrBuilder.setLength(0);
      greenStrBuilder.setLength(0);
      blueStrBuilder.setLength(0); 
    }
  
}

//class to store circle detection data in (x,y,radius/2) format
class dataStorage {
  float[][] data;
  dataStorage() {}
}

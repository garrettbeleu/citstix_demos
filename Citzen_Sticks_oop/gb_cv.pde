
class GBCV {
  Mat matRed, matRed2, matGreen, matBlue, matRGB;
  PImage src, redFilteredImage, greenFilteredImage, blueFilteredImage, rgbFilteredImage;
  Mat circlesRed, circlesGreen, circlesBlue;
  //vars for accessing circle detection data in (x,y,radius/2) format
  float[][] redData, blueData, greenData;
  
  GBCV() {
    matRed = new Mat(video.width, video.height, CvType.CV_8UC1); //red hues 0-10
    matRed2 = new Mat(video.width, video.height, CvType.CV_8UC1); //red hues 150-179
    matGreen = new Mat(video.width, video.height, CvType.CV_8UC1);
    matBlue = new Mat(video.width, video.height, CvType.CV_8UC1);
    matRGB = new Mat(video.width, video.height, CvType.CV_8UC3);
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
      opencv.useColor(); // set cv colorspace to RGB, needed for next line
      src = opencv.getSnapshot(); // save RGB source frame as PImage
      image(src, 0, 0);
      break;
    case '1':
      // remember BGR is opencv order
      List<Mat> listMat = Arrays.asList(gbcv.matBlue,gbcv.matGreen,gbcv.matRed);
      Core.merge(listMat, gbcv.matRGB);
      
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
        Imgproc.morphologyEx(gbcv.matRGB,gbcv.matRGB, Imgproc.MORPH_CLOSE, kernel ); 
        Imgproc.morphologyEx(gbcv.matRGB,gbcv.matRGB, Imgproc.MORPH_OPEN, kernel );      
        //MORPH_TOPHAT,BLACKHAT,GRADIENT are not useful here
        
        // params- ( src, dst, size of blur(x,y) , deviation)
        //Imgproc.GaussianBlur(gbcv.matRGB, gbcv.matRGB, new Size(9,9), 0); //this seems slow
       }
       
      rgbFilteredImage = opencv.getSnapshot(gbcv.matRGB);
      image(rgbFilteredImage,0,0);
      break;
    case '2':
      redFilteredImage = opencv.getSnapshot(gbcv.matRed);
      image(redFilteredImage,0,0);
      break;
    case '3':
      greenFilteredImage = opencv.getSnapshot(gbcv.matGreen);
      image(greenFilteredImage,0,0);
      break;
    case '4':
      blueFilteredImage = opencv.getSnapshot(gbcv.matBlue);
      image(blueFilteredImage,0,0);
      break;
    case '0': //display no video
      break;
    default:
      break;
    }
  }
  
  void detectCircles(String theColor) {
    if (theColor=="red") {
      Imgproc.HoughCircles(matRed, circlesRed, Imgproc.CV_HOUGH_GRADIENT, 
                           dp.getValue() ,minDist.getValue(), 
                           cannyHigh.getValue(), cannyLow.getValue(),
                           int(minSize.getValue()),int(maxSize.getValue()) );

      if (circlesRed.rows()>0) {
        stroke(255,0,0);
        //println("dump Red= "+circlesRed.dump() +"\n");
       
        //place circlesRed matrix values into an array of the same datatype
        double[][] tempRedData = new double[circlesRed.cols()][circlesRed.rows()];
        for(int i=0; i<circlesRed.cols(); i++) {  
          tempRedData[i] = circlesRed.get(0,i);
        }
       
        // cast the double[][] to a float[][]
        redData = new float[tempRedData.length][3];
        for(int i=0; i<tempRedData.length; i++) {
          for(int j=0; j<tempRedData[i].length; j++) {
            redData[i][j] = (float)tempRedData[i][j];
          }
        }
        //check the float values
        //print2DFloats(gbcv.redData);
        
        // draw as continuous spline curves
        if (redData.length>1) {
          beginShape();
          curveVertex(redData[0][0], redData[0][1]);
          curveVertex(redData[0][0], redData[0][1]);
          for (int i=0; i<redData.length; i++) {
            if(i>0) {
              curveVertex(redData[i-1][0], redData[i-1][1]);
              //curveVertex(redData[i-1][0], redData[i-1][1]);
            }
            if(i==redData.length-1) {
              curveVertex(redData[i][0], redData[i][1]);
            }
          }
          curveVertex(redData[0][0], redData[0][1]);
          curveVertex(redData[0][0], redData[0][1]);
          endShape();
        }
        
        // drawing as ellipses
        for (int i=0; i<redData.length; i++) {
          ellipse(redData[i][0],redData[i][1],redData[i][2]*2,redData[i][2]*2);
        }
      }
    }
    
    if (theColor=="green") {
      Imgproc.HoughCircles(matGreen, circlesGreen, Imgproc.CV_HOUGH_GRADIENT, 
                           dp.getValue() ,minDist.getValue(), 
                           cannyHigh.getValue(), cannyLow.getValue(),
                           int(minSize.getValue()),int(maxSize.getValue()) );
                       
      if (circlesGreen.rows()>0) {
        stroke(0,255,0);
        //println("dump Green= "+circlesGreen.dump() +"\n");
        
        double[][] tempGreenData = new double[circlesGreen.cols()][circlesGreen.rows()];
        for(int i=0; i<circlesGreen.cols(); i++) { 
            tempGreenData[i] = circlesGreen.get(0,i);
        }
      
        // cast the double[][] to a float[][]
        greenData = new float[tempGreenData.length][3];
        for(int i=0; i<tempGreenData.length; i++) {
          for(int j=0; j<tempGreenData[i].length; j++) {
            greenData[i][j] = (float)tempGreenData[i][j];
          }
        }
        //check the float values
        //print2DFloats(greenData);
     
        if (greenData.length>1) {
          beginShape();
          curveVertex(greenData[0][0], greenData[0][1]);
          curveVertex(greenData[0][0], greenData[0][1]);
          for (int i=0; i<greenData.length; i++) {
            // draw as continuous spline curves
            if(i>0) {
              curveVertex(greenData[i-1][0], greenData[i-1][1]);
            }
            if(i==greenData.length-1) {
              curveVertex(greenData[i][0], greenData[i][1]);
            }
          }
          curveVertex(greenData[0][0], greenData[0][1]);
          curveVertex(greenData[0][0], greenData[0][1]);
          endShape();
        }
        
        // drawing as ellipses
        for (int i=0; i<greenData.length; i++) {
          ellipse(greenData[i][0],greenData[i][1],greenData[i][2]*2,greenData[i][2]*2);
        }
      }              
    }
    
    if (theColor=="blue") {
      Imgproc.HoughCircles(matBlue, circlesBlue, Imgproc.CV_HOUGH_GRADIENT, 
                           dp.getValue() ,minDist.getValue(), 
                           cannyHigh.getValue(), cannyLow.getValue(),
                           int(minSize.getValue()),int(maxSize.getValue()) );
    
      if (circlesBlue.rows()>0) {
        stroke(0,0,255); 
        //println("dump Blue= "+circlesBlue.dump() +"\n");
        
        double[][] tempBlueData = new double[circlesBlue.cols()][circlesBlue.rows()];
        for(int i=0; i<circlesBlue.cols(); i++) { 
            tempBlueData[i] = circlesBlue.get(0,i);
        }
        //print2D(blueData);
        
        // cast the double[][] to a float[][]
        blueData = new float[tempBlueData.length][3];
        for(int i=0; i<tempBlueData.length; i++) {
          for(int j=0; j<tempBlueData[i].length; j++) {
            blueData[i][j] = (float)tempBlueData[i][j];
          }
        }
        //check the float values
        //print2DFloats(blueData);
        
        if (blueData.length>1) {
          beginShape();
          curveVertex(blueData[0][0], blueData[0][1]);
          curveVertex(blueData[0][0], blueData[0][1]);
          for (int i=0; i<blueData.length; i++) {
            // draw as continuous spline curves
            if(i>0) {
              curveVertex(blueData[i-1][0], blueData[i-1][1]);
            }
            if(i==blueData.length-1) {
              curveVertex(blueData[i][0], blueData[i][1]);
            }
          }
          curveVertex(blueData[0][0], blueData[0][1]);
          curveVertex(blueData[0][0], blueData[0][1]);
          endShape();
        }
        // drawing as ellipses
        for (int i=0; i<blueData.length; i++) {
          ellipse(blueData[i][0],blueData[i][1],blueData[i][2]*2,blueData[i][2]*2);
        }
      }
    }
  
  }
}

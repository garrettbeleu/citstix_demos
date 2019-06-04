/*
Main object for 
-handling different openCV matrixes
-filtering for color values within the desired range - inRangeGB method
-displaying the matrix resultant of the inRangeGB filter, mainly to visually check limits and results - drawVideo method
-detect circles within a given image and store thier locations and size in a global object - findCircles method
*/


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
      if (camStarted) {
        image(cam,0,0);
        //set(0,0,inputVideo.webcam); // this is faster if no resize or transformations are needed
      } 
      if(movieStarted) {
        image(movie,0,0);
      }
      break;
    case '1':
      // remember BGR is opencv order
      List<Mat> listMat = Arrays.asList(matBlue,matGreen,matRed);
      Core.merge(listMat, matRGB);
             
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
                       dpVal,  minDistVal, 
                       cannyHighVal, cannyLowVal,
                       minSizeVal,  maxSizeVal );

    if (output.rows()>0) {
      //println("dump= "+output.dump() +"\n");
     
      //place circlesRed matrix values into an array of the same datatype
      double[][] tempData = new double[output.cols()][output.rows()];
      for(int i=0; i<output.cols(); i++) {  
        tempData[i] = output.get(0,i);
        //println(output.get(0,i));
      }
      
      //added 4/23
      if(tempData.length <= maxSticksVal) { //capture them all if less than max
        
        //old unlimited size way  
        // initialize the size of the float[][] array
        theData.data = new float[tempData.length][3];
          for(int i=0; i<tempData.length; i++) {
            for(int j=0; j<tempData[i].length; j++) {
              // cast the double[][] to a float[][]
              theData.data[i][j] = (float)tempData[i][j];
            }
          } 
      }
        
      //limit number of circles to look for 
      if (tempData.length > maxSticksVal ) {
        theData.data = new float[int(maxSticksVal)][3];
        for(int i=0; i<maxSticksVal; i++) {
          for(int j=0; j<3; j++) { //for the x,y,radius values of each detected circle
            // cast the double[][] to a float[][]
            theData.data[i][j] = (float)tempData[i][j];
          }
        }
        
      }
        
        
    }else{
      //empty but not null - *important*
      theData.data = new float[0][0];
    }
  }
  
  
}

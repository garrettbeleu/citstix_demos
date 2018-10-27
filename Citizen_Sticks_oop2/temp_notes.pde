
// notes on how to "pass-by-reference"
// the float[][] into GBCV object

/*

// openCV for Processing Lib and Processing Video Lib
import gab.opencv.*;
import processing.video.*;

//opencv modules
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.CvType;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.Size;
import org.opencv.core.Scalar;

GBCV gbcv;
dataStorage theD;

void setup() {
  gbcv = new GBCV();
  theD = new dataStorage();
  
}


void draw() {
  
  gbcv.findCircles(gbcv.matRed, gbcv.circlesRed, theD.redData);
  
}

class GBCV {
  Mat matRed, matRed2, matGreen, matBlue, matRGB;
  PImage src, redFilteredImage, greenFilteredImage, blueFilteredImage, rgbFilteredImage;
  Mat circlesRed, circlesGreen, circlesBlue;
  //vars for accessing circle detection data in (x,y,radius/2) format
  //float[][] redData, blueData, greenData;
  
  GBCV() {
    
  }
  
  void findCircles(Mat input, Mat output, dataStorage theData) {
        Imgproc.HoughCircles(input, output, Imgproc.CV_HOUGH_GRADIENT, 
                         dp.getValue() ,minDist.getValue(), 
                         cannyHigh.getValue(), cannyLow.getValue(),
                         int(minSize.getValue()),int(maxSize.getValue()) );
                         
                         
    double[][] tempRedData = new double[output.cols()][output.rows()];
    //stuff stuff
    // dataStorage.theData = new float[tempData.length][3];
     //theData = new float[tempData.length][3];
     
     
     theD.rInit( ); // this will make it be size x by y or whatever
     
  }
}

class dataStorage{
  double[][] redData, blueData, greenData;
  
  dataStorage() {
  }
  
  double[][] getRedData() {
    // do stuff, convert for double[][] to float[][]
    return redData; 
  }
  
  void setRedData(double[][] rData ) {
    redData = rData;
    
    // do stuff, convert for double[][] to float[][]
    return redData; 
  }

  
}

*/

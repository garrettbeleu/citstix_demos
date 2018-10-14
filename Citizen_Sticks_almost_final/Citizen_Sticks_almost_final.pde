
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

//java list and array modules
import java.util.List;
import java.util.Arrays;

//controlP5 Lib
import controlP5.*;

ControlP5 cp5;
Range redRangeHue,redRangeSat,redRangeVal, greenRangeHue,greenRangeSat,greenRangeVal, blueRangeHue,blueRangeSat,blueRangeVal;
Range redRangeHue2, redRangeSat2, redRangeVal2;
Numberbox dp,minDist,cannyHigh,cannyLow,minSize,maxSize;
Toggle red2Toggle;

int rHueMin = 0;   int rHueMax = 10;
int rSatMin = 75; int rSatMax = 255;
int rValMin = 75; int rValMax = 255;

int gHueMin = 35;  int gHueMax = 85;
int gSatMin = 75; int gSatMax = 255;
int gValMin = 75; int gValMax = 255;

int bHueMin = 100; int bHueMax = 135;
int bSatMin = 75; int bSatMax = 255;
int bValMin = 75; int bValMax = 255;

int r2HueMin = 160; int r2HueMax = 179;
int r2SatMin = 75; int r2SatMax = 255;
int r2ValMin = 75; int r2ValMax = 255;


PImage src, redFilteredImage, greenFilteredImage, blueFilteredImage, rgbFilteredImage;
color c; //color at mouseX/Y
int hue; //color c mapped to hue range 0-179 
color currentR,currentG,currentB = color(0,0,0);

OpenCV opencv;
Mat gbMatRed, gbMatRed2, gbMatAddedRed, gbMatGreen, gbMatBlue, gbMatRGB;
double[][] redData, blueData, greenData;

// !.!.!.!.!.!.!.! note on opencv_processing lib Github says to use Processing IDE in 64bit mode
// !.!.!.!.!.!.!.! Processing seems to revert to 32bit mode everytime it is opened :(

//Capture video; //uncomment for webcam
boolean logitech = true; // true for Logitech webcam - false for built in webcam
Movie video; //comment for webcam
boolean isMovie = true;

boolean guiVisibility = true;

char whichVideo = '`';

void setup() {
  fullScreen();
  //size(1500, 900);
  textSize(16);
  textLeading(16);
  stroke(255);
  
  //String[] cameras = Capture.list();
  //printArray(cameras);
  //if(logitech==true && isMovie!=true) {
  //  video = new Capture(this, 1920, 1080, "C922 Pro Stream Webcam #3", 30); // "#3" changes depending on usb port?
  //  video.start();
  //} else {
  //  video = new Capture(this, 1280, 720, "FaceTime HD Camera", 30);
  //  video.start();
  //}
  
  if (isMovie) {
    video = new Movie(this, "demo1Edit.mp4"); 
    video.loop();
    video.read(); //needed so that video.width&height !=empty for the cv object
  }
   
  //    If you get error "A library used by this sketch is not installed properly."
  //    then load the line below.
  // System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  
  opencv = new OpenCV(this, video.width, video.height);
  gbMatRed = new Mat(video.width, video.height, CvType.CV_8UC1);
  gbMatRed2 = new Mat(video.width, video.height, CvType.CV_8UC1); //red hues 150-179
  //gbMatAddedRed = new Mat(video.width, video.height, CvType.CV_8UC1);
  gbMatGreen = new Mat(video.width, video.height, CvType.CV_8UC1);
  gbMatBlue = new Mat(video.width, video.height, CvType.CV_8UC1);
  gbMatRGB = new Mat(video.width, video.height, CvType.CV_8UC3);
  
  loadGUI();
}

void draw() {
  //background(195);
  fill(0,20);
  rect(0,0,width,height);
  
  // Read last captured frame
  if (video.available()) {
    video.read();
  }

  opencv.loadImage(video); // ! ! ! ! ! ! ! ! look into this, might be slow????
  opencv.useColor(HSB); // set cv colorspace to HSB for HSB filtering
  
  // params* (input matrix, hue-low, hue-high, sat-low, sat-high, value-low, value-high, output matrix)
  inRangeGB( opencv.matHSV, rHueMin,rHueMax, rSatMin,rSatMax, rValMin,rValMax, gbMatRed );
  inRangeGB( opencv.matHSV, gHueMin,gHueMax, gSatMin,gSatMax, gValMin,gValMax, gbMatGreen );
  inRangeGB( opencv.matHSV, bHueMin,bHueMax, bSatMin,bSatMax, bValMin,bValMax, gbMatBlue );
  
  if (red2Toggle.getValue()==1.0) {
    //println("hue:"+r2HueMin+","+r2HueMax+" Sat:"+r2SatMin+","+r2SatMax+" Val:"+r2ValMin+","+r2ValMax );
    inRangeGB( opencv.matHSV, r2HueMin,r2HueMax, r2SatMin,r2SatMax, r2ValMin,r2ValMax, gbMatRed2 );
    //add the 2 red filtered matrices into one (gbMatRed and gbMatRed2)
    // place results back into gbMatRed so that code below does not need more if statements
    Core.addWeighted(gbMatRed, 1, gbMatRed2, 1, 0, gbMatRed );
  }
  
  fill(255);
  //drawing videos
    switch(whichVideo) {
    case '`':
      opencv.useColor(); // set cv colorspace to RGB, needed for next line
      src = opencv.getSnapshot(); // save RGB source frame as PImage
      image(src, 0, 0);
      text("video: SRC", 10, height-320);
      break;
    case '1':
      // remember BGR is opencv order
      List<Mat> listMat = Arrays.asList(gbMatBlue,gbMatGreen,gbMatRed);
      Core.merge(listMat, gbMatRGB);
      
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
        Imgproc.morphologyEx(gbMatRGB,gbMatRGB, Imgproc.MORPH_CLOSE, kernel ); 
        Imgproc.morphologyEx(gbMatRGB,gbMatRGB, Imgproc.MORPH_OPEN, kernel );      
        //MORPH_TOPHAT,BLACKHAT,GRADIENT are not useful here
        
        // params- ( src, dst, size of blur(x,y) , deviation)
        //Imgproc.GaussianBlur(gbMatRGB, gbMatRGB, new Size(9,9), 0); //this seems slow
       }
       
      rgbFilteredImage = opencv.getSnapshot(gbMatRGB);
      image(rgbFilteredImage,0,0);
      text("video: R&G&B", 10, height-320);
      break;
    case '2':
      redFilteredImage = opencv.getSnapshot(gbMatRed);
      image(redFilteredImage,0,0);
      text("video: RED FILTERED", 10, height-320);
      break;
    case '3':
      greenFilteredImage = opencv.getSnapshot(gbMatGreen);
      image(greenFilteredImage,0,0);
      text("video: GREEN FILTERED", 10, height-320);
      break;
    case '4':
      blueFilteredImage = opencv.getSnapshot(gbMatBlue);
      image(blueFilteredImage,0,0);
      text("video: BLUE FILTERED", 10, height-320);
      break;
    case '0': //display no video
      break;
    default:
      break;
  }

  //view frameRate
  text(frameRate,10,25);
  // NOTES on framerate - even w/ 1080p prerecorded video, framerate is still ~10-12fps, so that is not a webcam issue, but opencv issue
  
  if(guiVisibility) {
    text("hold key(R||G||B)+click in \nsrc video to select hue",10, height-295);
    text("HoughCircles params",290,height-70);
    //current color (hue) that is selected - center value for hue-range filter
    strokeWeight(1);
    stroke(255);
    
    fill(currentR);
    rect(10,height-270,28,28);
    fill(currentG);
    rect(10,height-180,28,28);
    fill(currentB);
    rect(10,height-90,28,28);
  }
  
  //circle detect red matrix
  Mat circlesRed = new Mat();
  // could do some image processing here - blur, erode, dilate idk
  Imgproc.HoughCircles(gbMatRed, circlesRed, Imgproc.CV_HOUGH_GRADIENT, 
                       dp.getValue() ,minDist.getValue(), 
                       cannyHigh.getValue(), cannyLow.getValue(),
                       int(minSize.getValue()),int(maxSize.getValue()) );
  strokeWeight(3);
  stroke(255,0,0);
  noFill();
  if (circlesRed.rows()>0) {
    //println("dump Red= "+circlesRed.dump() +"\n");
    double[][] redData = new double[circlesRed.cols()][circlesRed.rows()];
    for(int i=0; i<circlesRed.cols(); i++) {  
        redData[i] = circlesRed.get(0,i);
    }
    //print2D(redData);
    //println(redData.length);
    
    if (redData.length>1) {
      beginShape();
      curveVertex((float)redData[0][0], (float)redData[0][1]);
      curveVertex((float)redData[0][0], (float)redData[0][1]);
      for (int i=0; i<redData.length; i++) {
        //draw as straight lines
      //  if(i>0) {
      //    line((float)redData[i-1][0],(float)redData[i-1][1],(float)redData[i][0],(float)redData[i][1]);
      //  }
      //  if(i==redData.length-1) {
      //    line((float)redData[i][0],(float)redData[i][1],(float)redData[0][0],(float)redData[0][1]);
      //  }
      //}
        // draw as continuous spline curves
        if(i>0) {
          curveVertex((float)redData[i-1][0], (float)redData[i-1][1]);
          //curveVertex(redData[i-1][0], redData[i-1][1]);
        }
        if(i==redData.length-1) {
          curveVertex((float)redData[i][0], (float)redData[i][1]);
        }
      }
      curveVertex((float)redData[0][0], (float)redData[0][1]);
      curveVertex((float)redData[0][0], (float)redData[0][1]);
      endShape();
    }  
    
    // drawing ellipses
    for (int i=0; i<circlesRed.cols(); i++) {
      double [] v = circlesRed.get(0, i);
      float x = (float)v[0];
      float y = (float)v[1];
      float r = (float)v[2];
      ellipse(x, y, r*2, r*2);
    }
  }
  //println( circlesRed.cols() ); // number of (x,y,radius/2) elements
  //println(circlesRed.type()); type=21 CV_32F 3channel
  
  // does not seem to impact speed, but saw someone else doing this
  gbMatRed.release();
  circlesRed.release();
  
  //circle detect green matrix
  Mat circlesGreen = new Mat();
  // could do some image processing here - blur, erode, dilate idk
  Imgproc.HoughCircles(gbMatGreen, circlesGreen, Imgproc.CV_HOUGH_GRADIENT, 
                       dp.getValue() ,minDist.getValue(), 
                       cannyHigh.getValue(), cannyLow.getValue(),
                       int(minSize.getValue()),int(maxSize.getValue()) );
  stroke(0,255,0);
  noFill();
  if (circlesGreen.rows()>0) {
    //println("dump Green= "+circlesGreen.dump() +"\n");
    double[][] greenData = new double[circlesGreen.cols()][circlesGreen.rows()];
    for(int i=0; i<circlesGreen.cols(); i++) { 
        greenData[i] = circlesGreen.get(0,i);
    }
    //print2D(greenData);
   
    if (greenData.length>1) {
      beginShape();
      curveVertex((float)greenData[0][0], (float)greenData[0][1]);
      curveVertex((float)greenData[0][0], (float)greenData[0][1]);
      for (int i=0; i<greenData.length; i++) {
        //draw as straight lines
      //  if(i>0) {
      //    line((float)greenData[i-1][0],(float)greenData[i-1][1],(float)greenData[i][0],(float)greenData[i][1]);
      //  }
      //  if(i==greenData.length-1) {
      //    line((float)greenData[i][0],(float)greenData[i][1],(float)greenData[0][0],(float)greenData[0][1]);
      //  }
      //}
        // draw as continuous spline curves
        if(i>0) {
          curveVertex((float)greenData[i-1][0], (float)greenData[i-1][1]);
        }
        if(i==greenData.length-1) {
          curveVertex((float)greenData[i][0], (float)greenData[i][1]);
        }
      }
      curveVertex((float)greenData[0][0], (float)greenData[0][1]);
      curveVertex((float)greenData[0][0], (float)greenData[0][1]);
      endShape();
    }

    for (int i=0; i<circlesGreen.cols(); i++) {
      double [] v = circlesGreen.get(0, i);
      float x = (float)v[0];
      float y = (float)v[1];
      float r = (float)v[2];
      ellipse(x, y, r*2, r*2);
    }
  }
  // does not seem to impact speed, but saw someone else doing this
  gbMatGreen.release();
  circlesGreen.release();
  
  //circle detect blue matrix
  Mat circlesBlue = new Mat();
  // could do some image processing here - blur, erode, dilate idk
  Imgproc.HoughCircles(gbMatBlue, circlesBlue, Imgproc.CV_HOUGH_GRADIENT, 
                       dp.getValue() ,minDist.getValue(), 
                       cannyHigh.getValue(), cannyLow.getValue(),
                       int(minSize.getValue()),int(maxSize.getValue()) );
  stroke(0,0,255);
  noFill();
  if (circlesBlue.rows()>0) {
    //println("dump Blue= "+circlesBlue.dump() +"\n");
    double[][] blueData = new double[circlesBlue.cols()][circlesBlue.rows()];
    for(int i=0; i<circlesBlue.cols(); i++) { 
        blueData[i] = circlesBlue.get(0,i);
    };
    //print2D(blueData);
    
    if (blueData.length>1) {
      beginShape();
      curveVertex((float)blueData[0][0], (float)blueData[0][1]);
      curveVertex((float)blueData[0][0], (float)blueData[0][1]);
      for (int i=0; i<blueData.length; i++) {
        //draw as straight lines
      //  if(i>0) {
      //    line((float)blueData[i-1][0],(float)blueData[i-1][1],(float)blueData[i][0],(float)blueData[i][1]);
      //  }
      //  if(i==blueData.length-1) {
      //    line((float)blueData[i][0],(float)blueData[i][1],(float)blueData[0][0],(float)blueData[0][1]);
      //  }
      //}
        // draw as continuous spline curves
        if(i>0) {
          curveVertex((float)blueData[i-1][0], (float)blueData[i-1][1]);
        }
        if(i==blueData.length-1) {
          curveVertex((float)blueData[i][0], (float)blueData[i][1]);
        }
      }
      curveVertex((float)blueData[0][0], (float)blueData[0][1]);
      curveVertex((float)blueData[0][0], (float)blueData[0][1]);
      endShape();
    }
    
    for (int i=0; i<circlesBlue.cols(); i++) {
      double [] v = circlesBlue.get(0, i);
      float x = (float)v[0];
      float y = (float)v[1];
      float r = (float)v[2];
      ellipse(x, y, r*2, r*2);
    }
  }
  // does not seem to impact speed, but saw someone else doing this
  gbMatBlue.release();
  circlesBlue.release();
  
  gbMatRGB.release();
  gbMatRed2.release();
  opencv.matHSV.release();
 
  
}

void mousePressed() {
  if(key=='r'||key=='g'||key=='b') {
    if(keyPressed) {
         c = get(mouseX, mouseY);
        //println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));
        // hue needs to be remapped bc opencv uses hue range (0-179) but processing uses (0-255)
         hue = int(map(hue(c), 0, 255, 0, 179));
        //println("hue at mouseX: " + hue);
    }
  }
  
  if (key == 'r' && keyPressed) {
    currentR = color(c);
     
    // STILL NEED TO DO! ---- toggle for this is done, but not the rest
    //add wrap around for red hues (~0-15 and ~165-179)
    // solution for setting the values is in sketch... "wrap_values_around_179.pde"
    // solution for combining matrixes is in sketch... "cv_addMatrixes_and_blur.pde"
    
    //hue
    float[] tempSliderVals = redRangeHue.getArrayValue();
    int sliderDistance = round(tempSliderVals[1]/2)-round(tempSliderVals[0]/2);
    println("redRangeHue**** "+"min:"+int(hue-sliderDistance)+" max:"+int(hue+sliderDistance)+" ||__at mX:"+hue+" distance:+-"+sliderDistance );
    rHueMin = hue - sliderDistance;
    rHueMax = hue + sliderDistance;
    redRangeHue.setRangeValues(rHueMin,rHueMax);
   
    //saturation
    int sat = int(saturation(c));
    float[] tempSatVals = redRangeSat.getArrayValue();
    int satSliderDistance = round(tempSatVals[1])-round(tempSatVals[0]);
    rSatMin = sat - round(satSliderDistance/2);
    rSatMax = sat + round(satSliderDistance/2);
    redRangeSat.setRangeValues(rSatMin,rSatMax);
    
    ////value(brightness)
    int val = int(brightness(c));
    float[] tempValueVals = redRangeVal.getArrayValue();
    int valSliderDistance = round(tempValueVals[1]) - round(tempValueVals[0]);
    rValMin = val - round(valSliderDistance/2);
    rValMax = val + round(valSliderDistance/2);
    redRangeVal.setRangeValues(rValMin,rValMax);
  }
  
  if (key=='g' && keyPressed) {
    currentG = color(c);
    //hue
    float[] tempSliderVals = greenRangeHue.getArrayValue();
    int sliderDistance = round(tempSliderVals[1]/2)-round(tempSliderVals[0]/2);
    println("greenRangeHue**** "+"min:"+int(hue-sliderDistance)+" max:"+int(hue+sliderDistance)+" ||__at mX:"+hue+" distance:+-"+sliderDistance );
    gHueMin = hue - sliderDistance;
    gHueMax = hue + sliderDistance;
    greenRangeHue.setRangeValues(gHueMin,gHueMax);
    //saturation
    int sat = int(saturation(c));
    float[] tempSatVals = greenRangeSat.getArrayValue();
    int satSliderDistance = round(tempSatVals[1])-round(tempSatVals[0]);
    gSatMin = sat - round(satSliderDistance/2);
    gSatMax = sat + round(satSliderDistance/2);
    greenRangeSat.setRangeValues(gSatMin,gSatMax);
    ////value(brightness)
    int val = int(brightness(c));
    float[] tempValueVals = greenRangeVal.getArrayValue();
    int valSliderDistance = round(tempValueVals[1]) - round(tempValueVals[0]);
    gValMin = val - round(valSliderDistance/2);
    gValMax = val + round(valSliderDistance/2);
    greenRangeVal.setRangeValues(gValMin,gValMax);
  }
  
  if (key=='b' && keyPressed) {
    currentB = color(c);
    //hue
    float[] tempSliderVals = blueRangeHue.getArrayValue();
    int sliderDistance = round(tempSliderVals[1]/2)-round(tempSliderVals[0]/2);
    println("blueRangeHue**** "+"min:"+int(hue-sliderDistance)+" max:"+int(hue+sliderDistance)+" ||__at mX:"+hue+" distance:+-"+sliderDistance );
    bHueMin = hue - sliderDistance;
    bHueMax = hue + sliderDistance;
    blueRangeHue.setRangeValues(bHueMin,bHueMax);
    //saturation
    int sat = int(saturation(c));
    float[] tempSatVals = blueRangeSat.getArrayValue();
    int satSliderDistance = round(tempSatVals[1])-round(tempSatVals[0]);
    bSatMin = sat - round(satSliderDistance/2);
    bSatMax = sat + round(satSliderDistance/2);
    blueRangeSat.setRangeValues(bSatMin,bSatMax);
    ////value(brightness)
    int val = int(brightness(c));
    float[] tempValueVals = blueRangeVal.getArrayValue();
    int valSliderDistance = round(tempValueVals[1]) - round(tempValueVals[0]);
    bValMin = val - round(valSliderDistance/2);
    bValMax = val + round(valSliderDistance/2);
    blueRangeVal.setRangeValues(bValMin,bValMax); 
  }
  
}

void keyPressed() {
 if (key=='p') {
    println(red2Toggle.getValue());   
 }
 
 if (key=='v') {
   guiVisibility = !guiVisibility;
   if(guiVisibility) {
     cp5.show();
   }else{
     cp5.hide();
   }
 }
 
 //switch change state
 if (key=='`') whichVideo='`'; // src video
 if (key=='1') whichVideo='1'; // R&G&B filtered
 if (key=='2') whichVideo='2'; // red filtered
 if (key=='3') whichVideo='3'; // green filtered
 if (key=='4') whichVideo='4'; // blue filtered 
 if (key=='0') whichVideo='0'; // no video (hide video)
  
}

//rewrote this function to use scalar w/ 3 values 
//in order to do filtering on hue,saturation and value channels
// it is now more similar to the OpenCV source code
// - - - https://docs.opencv.org/java/2.4.5/org/opencv/core/Core.html#inRange(org.opencv.core.Mat,%20org.opencv.core.Scalar,%20org.opencv.core.Scalar,%20org.opencv.core.Mat)
 
  public void inRangeGB(Mat src, int h1, int h2, int s1, int s2, int v1, int v2, Mat dst){
      Core.inRange( src, new Scalar(h1,s1,v1), new Scalar(h2,s2,v2), dst );
  }
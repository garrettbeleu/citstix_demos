
import gab.opencv.*;
import processing.video.*;

//import scalar module
import org.opencv.core.Scalar;
// Core module
import org.opencv.core.Core;
// Mat modue
import org.opencv.core.Mat;
// CvType module
import org.opencv.core.CvType;

Capture video;
OpenCV opencv;

PImage src, hsbFilteredImage;

int hueRangeLow = 20;
int hueRangeHigh = 35;

Mat gbMat; // the empty matrix to hold the result of the hsb filter (inRangeGB)

void setup() {
  
  size(800, 480, P2D);
  
  video = new Capture(this, 640, 480);
  video.start();
  
  //  If you get error "A library used by this sketch is not installed properly."
  //  then load the line below.
  // System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  
  opencv = new OpenCV(this, video.width, video.height);
  
  gbMat = new Mat(640, 480, CvType.CV_8UC1);
 
}

void draw() {
  // Read last captured frame
  if (video.available()) {
    video.read();
  }

  opencv.loadImage(video);
  
  opencv.useColor(); // set cv colorspace to RGB, needed for next line
  src = opencv.getSnapshot(); // save RGB source frame as PImage
  
  opencv.useColor(HSB); // set cv colorspace to HSB for HSB filtering
  
  // ( hue-low, hue-high, sat-low, sat-high, value-low, value-high)
  inRangeGB( hueRangeLow,hueRangeHigh, 100,255, 100,255 );
  // add sliders for the h,s,v range values to see what works best
 
 
 // _ _ _ - - - these are some functions that might be helpful, but not neccessary.
 // _ _ _ - - - idk how to use them anymore because opencv and the results of the inRangeGB function (gbMat)
 // _ _ _ - - -  are no longer linked. EX: gbMat.blur(9); opencv.gbMat.blur(9); ERROR idk
 //opencv.blur(8);
 //opencv.dilate();
 //opencv.erode();
 
  hsbFilteredImage = opencv.getSnapshot(gbMat);
  
  image(src, 0, 0,src.width/2,src.height/2);
  image(hsbFilteredImage, (src.width/2)+20 , 0,src.width/2,src.height/2);
  
  fill(0);
  text("source",10,250);
  text("hsb filtered",350,250);
  text("click on color in source video to select a hue",20,300);
  
}

void mousePressed() {
  color c = get(mouseX, mouseY);
  //println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));
   
  // hue needs to be remapped bc opencv uses hue range (0-179) but processing uses (0-255)
  int hue = int(map(hue(c), 0, 255, 0, 179));
  println("hue at mouseX: " + hue);
  
  //add wrap around here for hues 4,3,2,1,0,179,178,177,176,175 (these are all "red" but on opposite ends of the spectrum)
  // ex: hue range from -5 to 5 does NOT make sense, or work properly...
  // ... instead it should be hue range [175,176,177,178,179,0,1,2,3,4,5]
  hueRangeLow = hue - 5;
  hueRangeHigh = hue + 5;
  println("hue range: "+hueRangeLow+" to "+hueRangeHigh);
  println("");
}

//rewrote this function to use scalar w/ 3 values 
//in order to do filtering on hue,saturation and value channels
// it is now more similar to the OpenCV source code
// - - - https://docs.opencv.org/java/2.4.5/org/opencv/core/Core.html#inRange(org.opencv.core.Mat,%20org.opencv.core.Scalar,%20org.opencv.core.Scalar,%20org.opencv.core.Mat)
 
  public void inRangeGB(int h1, int h2, int s1, int s2, int v1, int v2){
      Core.inRange( opencv.matHSV, new Scalar(h1,s1,v1), new Scalar(h2,s2,v2), gbMat );
  }
 
// below is the standard inRange function from the opencv_processing library
// found in Documents/Processing/libraries/opencv_processing/src/gab/opencv/OpenCV.java
/* 
  public void inRange(int lowerBound, int upperBound){
    Core.inRange(getCurrentMat(), new Scalar(lowerBound), new Scalar(upperBound), getCurrentMat());
  }
 */
  

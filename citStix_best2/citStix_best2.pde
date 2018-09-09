
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

import controlP5.*;

ControlP5 cp5;
Range redRangeHue,redRangeSat,redRangeVal, greenRangeHue,greenRangeSat,greenRangeVal, blueRangeHue,blueRangeSat,blueRangeVal;

int rHueMin = 0;
int rHueMax = 10;
int rSatMin = 100;
int rSatMax = 255;
int rValMin = 100;
int rValMax = 255;

int gHueMin = 35;
int gHueMax = 80;
int gSatMin = 100;
int gSatMax = 255;
int gValMin = 100;
int gValMax = 255;

int bHueMin = 100;
int bHueMax = 135;
int bSatMin = 100;
int bSatMax = 255;
int bValMin = 100;
int bValMax = 255;

Capture video;
OpenCV opencv;

PImage src, redFilteredImage, greenFilteredImage, blueFilteredImage;
color c; //color at mouseX/Y
int hue; //color c mapped to hue range 0-179 
color currentR,currentG,currentB = color(0,0,0);

Mat gbMatRed, gbMatGreen, gbMatBlue;

// !.!.!.!.!.!.!.! note on opencv_processing lib Github says to use Processing IDE in 64bit mode
// !.!.!.!.!.!.!.! Processing seems to revert to 32bit mode everytime it is opened :(

// true for Logitech webcam - false for built in webcam
boolean logitech = false;

void setup() {
  
  size(1500, 900, P2D);
  textSize(16);
  textAlign(RIGHT,TOP);
  
  //String[] cameras = Capture.list();
  //printArray(cameras);
  //  "name=C922 Pro Stream Webcam #2,size=1920x1080,fps=30"
  if(logitech==true) {
    //rescale erything for 1920 by 1080?
    video = new Capture(this, 1280, 720, "C922 Pro Stream Webcam #2", 30);
  } else {
    video = new Capture(this, 1280, 720, Capture.list()[0], 30);
  }
  video.start();
  
  //  If you get error "A library used by this sketch is not installed properly."
  //  then load the line below.
  // System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  
  opencv = new OpenCV(this, video.width, video.height);
  
  gbMatRed = new Mat(video.width, video.height, CvType.CV_8UC1);
  gbMatGreen = new Mat(video.width, video.height, CvType.CV_8UC1);
  gbMatBlue = new Mat(video.width, video.height, CvType.CV_8UC1);
  
  cp5 = new ControlP5(this);

  redRangeHue = cp5.addRange("redRangeHue")
             // disable broadcasting since setRange and setRangeValues will trigger an event
             .setBroadcast(false) 
             .setPosition(50,video.height/2 +30)
             .setSize(400,20)
             .setHandleSize(20)
             .setRange(0,179)
             .setRangeValues(rHueMin,rHueMax)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(255,80,80))
             .setColorBackground(color(255,0,0,40))
             .setColorValueLabel(0)
             ;
             
  redRangeSat = cp5.addRange("redRangeSat")
             // disable broadcasting since setRange and setRangeValues will trigger an event
             .setBroadcast(false) 
             .setPosition(50,video.height/2 +60)
             .setSize(400,20)
             .setHandleSize(20)
             .setRange(0,255)
             .setRangeValues(rSatMin,rSatMax)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(255,80,80))
             .setColorBackground(color(255,0,0,40))
             .setColorValueLabel(0);
             ;
             
  redRangeVal = cp5.addRange("redRangeVal")
             // disable broadcasting since setRange and setRangeValues will trigger an event
             .setBroadcast(false) 
             .setPosition(50,video.height/2 +90)
             .setSize(400,20)
             .setHandleSize(20)
             .setRange(0,255)
             .setRangeValues(rValMin,rValMax)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(255,80,80))
             .setColorBackground(color(255,0,0,40))
             .setColorValueLabel(0);
             ;
             
  greenRangeHue = cp5.addRange("greenRangeHue")
             // disable broadcasting since setRange and setRangeValues will trigger an event
             .setBroadcast(false) 
             .setPosition(50,550)
             .setSize(400,20)
             .setHandleSize(20)
             .setRange(0,179)
             .setRangeValues(gHueMin,gHueMax)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(80,255,80))
             .setColorBackground(color(255,0,0,40))
             .setColorValueLabel(0)
             ;
  greenRangeSat = cp5.addRange("greenRangeSat")
             // disable broadcasting since setRange and setRangeValues will trigger an event
             .setBroadcast(false) 
             .setPosition(50,550+30)
             .setSize(400,20)
             .setHandleSize(20)
             .setRange(0,255)
             .setRangeValues(gSatMin,gSatMax)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(80,255,80))
             .setColorBackground(color(255,0,0,40))
             .setColorValueLabel(0);
             ;
  greenRangeVal = cp5.addRange("greenRangeVal")
             // disable broadcasting since setRange and setRangeValues will trigger an event
             .setBroadcast(false) 
             .setPosition(50,550+60)
             .setSize(400,20)
             .setHandleSize(20)
             .setRange(0,255)
             .setRangeValues(gValMin,gValMax)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(80,255,80))
             .setColorBackground(color(255,0,0,40))
             .setColorValueLabel(0);
             ;

  blueRangeHue = cp5.addRange("blueRangeHue")
             // disable broadcasting since setRange and setRangeValues will trigger an event
             .setBroadcast(false) 
             .setPosition(50,700)
             .setSize(400,20)
             .setHandleSize(20)
             .setRange(0,179)
             .setRangeValues(bHueMin,bHueMax)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(80,80,255))
             .setColorBackground(color(255,0,0,40))
             .setColorValueLabel(0)
             ;
  blueRangeSat = cp5.addRange("blueRangeSat")
             // disable broadcasting since setRange and setRangeValues will trigger an event
             .setBroadcast(false) 
             .setPosition(50,700+30)
             .setSize(400,20)
             .setHandleSize(20)
             .setRange(0,255)
             .setRangeValues(bSatMin,bSatMax)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(80,80,255))
             .setColorBackground(color(255,0,0,40))
             .setColorValueLabel(0);
             ;
  blueRangeVal = cp5.addRange("blueRangeVal")
             // disable broadcasting since setRange and setRangeValues will trigger an event
             .setBroadcast(false) 
             .setPosition(50,700+60)
             .setSize(400,20)
             .setHandleSize(20)
             .setRange(0,255)
             .setRangeValues(bValMin,bValMax)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(80,80,255))
             .setColorBackground(color(255,0,0,40))
             .setColorValueLabel(0);
             ;
}

void draw() {
  background(195);
  
  // Read last captured frame
  if (video.available()) {
    video.read();
  }

  opencv.loadImage(video);
  
  opencv.useColor(); // set cv colorspace to RGB, needed for next line
  src = opencv.getSnapshot(); // save RGB source frame as PImage
  
  opencv.useColor(HSB); // set cv colorspace to HSB for HSB filtering
  
  // params* (input matrix, hue-low, hue-high, sat-low, sat-high, value-low, value-high, output matrix)
  inRangeGB( opencv.matHSV, rHueMin,rHueMax, rSatMin,rSatMax, rValMin,rValMax, gbMatRed );
  inRangeGB( opencv.matHSV, gHueMin,gHueMax, gSatMin,gSatMax, gValMin,gValMax, gbMatGreen );
  inRangeGB( opencv.matHSV, bHueMin,bHueMax, bSatMin,bSatMax, bValMin,bValMax, gbMatBlue );
 
 
 // _ _ _ - - - these are some functions that might be helpful, but not neccessary.
 // temp note * * * * *
 // * * * * dilation followed by erosion has different result (effect) that erosion followed by dilation
 // https://stackoverflow.com/questions/30369031/remove-spurious-small-islands-of-noise-in-an-image-python-opencv
 //opencv.blur(8);
 //opencv.dilate();
 //opencv.erode();
 
  redFilteredImage = opencv.getSnapshot(gbMatRed);
  greenFilteredImage = opencv.getSnapshot(gbMatGreen);
  blueFilteredImage = opencv.getSnapshot(gbMatBlue);
  
  image(src, 0, 0,src.width/2,src.height/2);
  image(redFilteredImage, (src.width/2)+20 , 0,src.width/4,src.height/4);
  image(greenFilteredImage, (src.width/2)+20 , src.height/4+30,src.width/4,src.height/4);
  image(blueFilteredImage, (src.width/2)+20 , src.height/2+60,src.width/4,src.height/4);
  
  fill(0);
  text("source",video.width/2 ,video.height/2);
  text("red filtered",video.width-200, video.height/4-20);
  text("hold key(R||G||B)+click in source video to select hue",420, video.height/2);
  text("green filtered", video.width-200+15, video.height/2);
  text("blue filtered", video.width-200+10, video.height/2+215);
  
  //current color (hue) that is selected - center value for hue-range filter
  fill(currentR);
  rect(10,video.height/2 +30,28,28);
  fill(currentG);
  rect(10,video.height/2 +190,28,28);
  fill(currentB);
  rect(10,video.height/2 +320,28,28);
  
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
    //print("");   
 }
}

//rewrote this function to use scalar w/ 3 values 
//in order to do filtering on hue,saturation and value channels
// it is now more similar to the OpenCV source code
// - - - https://docs.opencv.org/java/2.4.5/org/opencv/core/Core.html#inRange(org.opencv.core.Mat,%20org.opencv.core.Scalar,%20org.opencv.core.Scalar,%20org.opencv.core.Mat)
 
  public void inRangeGB(Mat src, int h1, int h2, int s1, int s2, int v1, int v2, Mat dst){
      Core.inRange( src, new Scalar(h1,s1,v1), new Scalar(h2,s2,v2), dst );
  }
  
//~*~*~*~*~*~*~*~*~ update slider values
void redRangeHue() {
  rHueMin = round(redRangeHue.getLowValue());
  rHueMax = round(redRangeHue.getHighValue());
  //println("cmin,max from rc function:"+ rHueMin+" "+rHueMax);
  //range.setArrayValue(rHueMin,rHueMax); nope
  //printArray(range.getArrayValue() );
}
void redRangeSat() {
  rSatMin = round(redRangeSat.getLowValue());
  rSatMax = round(redRangeSat.getHighValue());
}
void redRangeVal() {
  rValMin = round(redRangeVal.getLowValue());
  rValMax = round(redRangeVal.getHighValue());
}

void greenRangeHue() {
  gHueMin = round(greenRangeHue.getLowValue());
  gHueMax = round(greenRangeHue.getHighValue());
}
void greenRangeSat() {
  gSatMin = round(greenRangeSat.getLowValue());
  gSatMax = round(greenRangeSat.getHighValue());
}
void greenRangeVal() {
  gValMin = round(greenRangeVal.getLowValue());
  gValMax = round(greenRangeVal.getHighValue());
}

void blueRangeHue() {
  bHueMin = round(blueRangeHue.getLowValue());
  bHueMax = round(blueRangeHue.getHighValue());
}
void blueRangeSat() {
  bSatMin = round(blueRangeSat.getLowValue());
  bSatMax = round(blueRangeSat.getHighValue());
}
void blueRangeVal() {
  bValMin = round(blueRangeVal.getLowValue());
  bValMax = round(blueRangeVal.getHighValue());
}
 
  

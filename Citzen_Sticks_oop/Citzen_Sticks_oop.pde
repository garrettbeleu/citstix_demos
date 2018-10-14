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

OpenCV opencv;
GBCV gbcv;

void setup() {
  //fullScreen();
  size(1500, 900);
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
  
  opencv = new OpenCV(this, video.width, video.height);
  gbcv = new GBCV();
  
  loadGUI();
}

void draw() {
  background(195);
    
  //Read last captured frame
  if (video.available()) {
    video.read();
  }
  
  opencv.loadImage(video);
  opencv.useColor(HSB); // set cv colorspace to HSB for filtering
   
  // params* (input matrix, hue-low, hue-high, sat-low, sat-high, value-low, value-high, output matrix)
  gbcv.inRangeGB( opencv.matHSV, rHueMin,rHueMax, rSatMin,rSatMax, rValMin,rValMax, gbcv.matRed );
  gbcv.inRangeGB( opencv.matHSV, gHueMin,gHueMax, gSatMin,gSatMax, gValMin,gValMax, gbcv.matGreen );
  gbcv.inRangeGB( opencv.matHSV, bHueMin,bHueMax, bSatMin,bSatMax, bValMin,bValMax, gbcv.matBlue );

  // if toggle==true, then run inRange on higher set of red values(150-179) and add results to matRed
  // note: should remove if statement and do this all the time, as it is neccessary!
//  if (red2Toggle.getValue()==1.0) {
    gbcv.inRangeGB( opencv.matHSV, r2HueMin,r2HueMax, r2SatMin,r2SatMax, r2ValMin,r2ValMax, gbcv.matRed2 );
    //add the 2 red filtered matrices into one (gbMatRed and gbMatRed2)
    // place results back into gbMatRed so that code below does not need more if statements
    Core.addWeighted(gbcv.matRed, 1, gbcv.matRed2, 1, 0, gbcv.matRed );
 // }
  
  gbcv.drawVideo(whichVideo);
  
  guiText(color(255),guiVisibility,whichVideo);
  
  strokeWeight(3);
  noFill();
  gbcv.detectCircles("red");
  gbcv.detectCircles("green");
  gbcv.detectCircles("blue");
  
  // get the circles data to maybe use it elsewhere
  // is null if a circle has not yet been detected
  // maybe only use that data inside the detectCircles method?
  if (gbcv.redData!=null) {
    //print2DFloats(gbcv.redData);
  }
  
}

void keyPressed() {
  
  if (key=='v') {
    guiVisibility = !guiVisibility;
    if(guiVisibility) {
      cp5.show();
    }else{
      cp5.hide();
    }
  }
 
  //switch case state
  if (key=='`') whichVideo='`'; // src video
  if (key=='1') whichVideo='1'; // R&G&B filtered
  if (key=='2') whichVideo='2'; // red filtered
  if (key=='3') whichVideo='3'; // green filtered
  if (key=='4') whichVideo='4'; // blue filtered 
  if (key=='0') whichVideo='0'; // no video (hide video)
}

// - - - - print 2d array to compare values
 void print2D(double arr[][]) { 
   print("print2D= ");  
   // Loop through all rows 
   for (double[] row : arr) {
     // converting each row as string 
     // and then printing in a separate line 
     println(Arrays.toString(row));
   }
   println("");
 }
 
 void print2DFloats(float arr[][]) { 
   print("print2D= ");  
   // Loop through all rows 
   for (float[] row : arr) {
     // converting each row as string 
     // and then printing in a separate line 
     println(Arrays.toString(row));
   }
   println("");
 }

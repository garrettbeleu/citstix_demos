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
// java string builder
import java.lang.StringBuilder;

//controlP5 Lib
import controlP5.*;

//Start Globals
// FS true sets the screen to full
boolean fs = false;
char whichVideo = '`';
boolean guiVisibility = true;

//Main Objects
VideoSource inputVideo;
Movie video;
Capture cap;
FrameData gframe; 
OpenCV opencv;
GBCV gbcv;
dataStorage dsRed, dsGreen, dsBlue;
StringBuilder redStrBuilder, greenStrBuilder, blueStrBuilder;

// Main PApplet Sketch: 
void settings() {
  if (fs) {
    fullScreen();
  } else { 
    size(1500, 900);
  }
} 

void setup() {
  //fullScreen();
  size(1280, 720);
  textSize(16);
  textLeading(16);
  stroke(255);

  // //...camera input source
  inputVideo = new VideoSource(video,this,"demo1Edit.mp4");
  // //...movie inout source
  //inputVideo = new VideoSource(cap, this, 1280, 720); 

  // // notes after test 2 update starting variables in gui tab
  
  opencv.useColor(HSB);// set cv colorspace to HSB for filtering
  
  gbcv = new GBCV();
  
  dsRed = new dataStorage();
  dsGreen = new dataStorage();
  dsBlue = new dataStorage();
  
  redStrBuilder= new StringBuilder();
  greenStrBuilder= new StringBuilder();
  blueStrBuilder= new StringBuilder();
  
  loadGUI(); 
}

void draw() {
 background(0);
      
 inputVideo.loadFrames();
  
 updateCV();

 drawCurrentUI();
 // println( Arrays.toString(gbcv.calculateTotals(dsRed.data,dsGreen.data,dsBlue.data)) );
   
}

void updateCV() {
  // params* (input matrix, hue-low, hue-high, sat-low, sat-high, value-low, value-high, output matrix)
  gbcv.inRangeGB( opencv.matHSV, rHueMin,rHueMax, rSatMin,rSatMax, rValMin,rValMax, gbcv.matRed );
  gbcv.inRangeGB( opencv.matHSV, gHueMin,gHueMax, gSatMin,gSatMax, gValMin,gValMax, gbcv.matGreen );
  gbcv.inRangeGB( opencv.matHSV, bHueMin,bHueMax, bSatMin,bSatMax, bValMin,bValMax, gbcv.matBlue );
  //run inRange on higher set of red values(150-179)
  gbcv.inRangeGB( opencv.matHSV, r2HueMin,r2HueMax, r2SatMin,r2SatMax, r2ValMin,r2ValMax, gbcv.matRed2 );
  //add the 2 red filtered matrices together, and place result back into matRed
  Core.addWeighted(gbcv.matRed, 1, gbcv.matRed2, 1, 0, gbcv.matRed );
  
  gbcv.findCircles(gbcv.matRed, gbcv.circlesRed, dsRed);
  gbcv.findCircles(gbcv.matGreen, gbcv.circlesGreen, dsGreen);
  gbcv.findCircles(gbcv.matBlue, gbcv.circlesBlue, dsBlue);
}

void drawCurrentUI() {
 // pushMatrix();
 // scale(1.5,1.5); // scale to 1080p resolution
 // scale(-1.3,1.45);
 // translate(-width+480,0); //trying to figure out what the proper x value is in translate?  
  gbcv.drawVideo(whichVideo);
  
  strokeWeight(3);
  noFill();  
  gbcv.drawCircles(dsRed.data,gbcv.circlesRed, color(255,0,0));
  gbcv.drawCircles(dsGreen.data, gbcv.circlesGreen, color(0,255,0));
  gbcv.drawCircles(dsBlue.data, gbcv.circlesBlue, color(0,0,255));
 // popMatrix();
  
  gbcv.textPanel(dsRed.data,dsGreen.data,dsBlue.data);
  
  guiText(color(255),guiVisibility,whichVideo);
  
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

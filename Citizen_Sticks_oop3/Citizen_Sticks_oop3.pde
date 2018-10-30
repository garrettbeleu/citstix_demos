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

PImage[] for_imgs = new PImage[3];
PImage[] bak_imgs = new PImage[3];


//End

//Main Objects 
VideoSource inputVideo;
Movie video;
Capture cap;
FrameData gframe; 
OpenCV opencv;
GBCV gbcv;

promptControl pc;
sdUI objui;  

dataStorage dsRed, dsGreen, dsBlue;
TextPanel tPanel = new TextPanel(0,0);

Connections connections;
VisualPercent vizPercent;


// Main PApplet Sketch: 
void settings() {
  if (fs) {
    fullScreen();
  } else { 
    size(1280, 720);
  }
}  

void setup() {
  objui = new sdUI(this); 
  runSketch(new String[] { "My uiObj Window" }, objui);
 
  for_imgs[0] = loadImage("button_a.png");
  for_imgs[1] = loadImage("button_b.png");
  for_imgs[2] = loadImage("button_c.png");
  
  bak_imgs[0] = loadImage("ba_button_a.png");
  bak_imgs[1] = loadImage("ba_button_b.png");
  bak_imgs[2] = loadImage("ba_button_c.png");


 
  videoStartUpManager();
 
}


void videoStartUpManager() {   
  textSize(16);
  textLeading(16);
  stroke(255);
  pc = new  promptControl();

  //frameRate(0.5);

  // //...movie input source  - - - test2.mp4 or demo1Edit.mp4
  inputVideo = new VideoSource(video,this,"test2.mp4");
  // //...camera input source
  //inputVideo = new VideoSource(cap, this, 1280, 720); 
  
  opencv.useColor(HSB);// set cv colorspace to HSB for filtering
  
  gbcv = new GBCV();
  
  dsRed = new dataStorage();
  dsGreen = new dataStorage();
  dsBlue = new dataStorage();
  connections  = new Connections();
  vizPercent = new VisualPercent();
 
  //loadGUI(); // need this to create all those cp5 gui widgets
}

void draw() {
  background(0);
  
  inputVideo.loadFrames();
  
  // seperation of the CV from the visuals.
  updateCV();  
  drawCurrentUI();
  // println( Arrays.toString(gbcv.calculateTotals(dsRed.data,dsGreen.data,dsBlue.data)) );
  pc.loadPrompt();
  pc.displayPrompt(width/2,100);

  //printTotals(dsRed.data,dsGreen.data,dsBlue.data);
 
}

void updateCV() {
  // params* (input matrix, hue-low, hue-high, sat-low, sat-high, value-low, value-high, output matrix)
  gbcv.inRangeGB( opencv.matHSV, objui.rHueMin,objui.rHueMax, objui.rSatMin,objui.rSatMax, objui.rValMin,objui.rValMax, gbcv.matRed );
  gbcv.inRangeGB( opencv.matHSV, objui.gHueMin,objui.gHueMax, objui.gSatMin,objui.gSatMax, objui.gValMin,objui.gValMax, gbcv.matGreen );
  gbcv.inRangeGB( opencv.matHSV, objui.bHueMin,objui.bHueMax, objui.bSatMin,objui.bSatMax, objui.bValMin,objui.bValMax, gbcv.matBlue );
  //run inRange on higher set of red values(150-179)
  gbcv.inRangeGB( opencv.matHSV, objui.r2HueMin,objui.r2HueMax, objui.r2SatMin,objui.r2SatMax, objui.r2ValMin,objui.r2ValMax, gbcv.matRed2 );
  //add the 2 red filtered matrices together, and place result back into matRed
  Core.addWeighted(gbcv.matRed, 1, gbcv.matRed2, 1, 0, gbcv.matRed );
  
  //detect where circles are located
  gbcv.findCircles(gbcv.matRed, gbcv.circlesRed, dsRed);
  gbcv.findCircles(gbcv.matGreen, gbcv.circlesGreen, dsGreen);
  gbcv.findCircles(gbcv.matBlue, gbcv.circlesBlue, dsBlue);
   
}

void drawCurrentUI() {

  gbcv.drawVideo(whichVideo);
  //uiObj.guiText(color(255), guiVisibility, whichVideo);

  //guiText(color(255), guiVisibility, whichVideo);
 // connections.pushToScreen();
  // full mode
 // vizPercent.pushToScreen(100,"full");
  
  // this one is cool, but the problem is that it uses the
  // opacity screen wipe technique, therefore
  // background() and anything reliant on it cannot also be used
  //vizPercent.pushToScreen(255,"stripes");
 
  //tPanel.pushToScreen();
 
}


void keyPressed() {

  if (key=='v') {
    guiVisibility = !guiVisibility;
    if (guiVisibility) {
    //  cp5.show();
    } else {
    //  cp5.hide();
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

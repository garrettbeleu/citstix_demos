// openCV for Processing Lib and Processing Video Lib
import gab.opencv.*;
import processing.video.*;
import toxi.geom.*;

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

//java modules used for making path buttons
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
//// all new stuff for camera and video input buttons
ArrayList<String> videoPaths = new ArrayList<String>();
ArrayList<String> cameraFound = new ArrayList<String>();

//controlP5 Lib
import controlP5.*;

//Start Globals
// FS true sets the screen to full
boolean fs = false;
char whichVideo = '`';
boolean guiVisibility = true;
int tempOff = 160;

PImage[] for_imgs = new PImage[3];
PImage[] bak_imgs = new PImage[3];

PFont helv20;
PFont helvBold20;
PFont helvBold60;

float promptOpacity;
//End

//Main Objects

//video select button variables
boolean camStarted = false;
boolean movieStarted = false;
boolean mainWindowDelay = false;
boolean uiWinVis = false;

Capture cam;
Movie movie;
FrameData gframe; 

OpenCV opencv;
GBCV gbcv;

promptVisControl pc;
mainUI objui;
simpleUI sobjui;


dataStorage dsRed, dsGreen, dsBlue;
TextPanel tPanel = new TextPanel(20, 20);

Connections connections;
Puddle puddles;
Grow growth;

VisualPercent vizPercent;
ArrayList<Particle> particles;
BlackFade blackTranny;
VidMimic vidMimic;


//~~~~~ global cp5 values
int rHueMin = 0;   int rHueMax = 10;
int rSatMin = 75; int rSatMax = 255;
int rValMin = 75; int rValMax = 255;

int r2HueMin = 160; int r2HueMax = 179;
int r2SatMin = 75; int r2SatMax = 255;
int r2ValMin = 75; int r2ValMax = 255;

int gHueMin = 35;  int gHueMax = 85;
int gSatMin = 75; int gSatMax = 255;
int gValMin = 75; int gValMax = 255;

int bHueMin = 100; int bHueMax = 135;
int bSatMin = 75; int bSatMax = 255;
int bValMin = 75; int bValMax = 255;
    
float dpVal = 2;
float minDistVal = 30;
float cannyHighVal = 50;
float cannyLowVal = 19;
int minSizeVal = 5;
int maxSizeVal = 35;
float maxSticksVal = 15;

boolean showHideButtons = false;


// Main PApplet Sketch: 
void settings() {
  if (fs) {
    fullScreen();
  } else { 
    size(1280, 720);
  }
}  





void setup() {
  

  checkVideoOptions();
  launchUiWin();
  
  for_imgs[0] = loadImage("button_a.png");
  for_imgs[1] = loadImage("button_b.png");
  for_imgs[2] = loadImage("button_c.png");

  bak_imgs[0] = loadImage("ba_button_a.png");
  bak_imgs[1] = loadImage("ba_button_b.png");
  bak_imgs[2] = loadImage("ba_button_c.png");

  //frameRate(1);

  //load helvetica fonts
  // these fonts are size specific.. 20px, 60px
  helv20 = loadFont("Helvetica-20.vlw");
  helvBold20 = loadFont("Helvetica-Bold-20.vlw");
  helvBold60 = loadFont("Helvetica-Bold-60.vlw");
  
  
  
  
  //videoStartUpManager(); //now run from video button callback functions

 
}


void checkVideoOptions() {
  
  // creates to lists of video options for making buttons on window
  // These are global array lists
   
  // video paths need to be obtained from this main window
  // when doing it from a secondary window, there is an ERROR
  try {
    //  **NOTE** this dataPath might change in the standalone app version, idk yet
    DirectoryStream<Path> stream = Files.newDirectoryStream(Paths.get(dataPath("videos"))); 
    //println(stream + "  from main window");
    for (Path file : stream) {
      //println(file.getFileName());
      videoPaths.add( file.getFileName().toString() );
    }
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
  
   println(videoPaths);
   


  // ** make camera input buttons
 // int camButtonY = 0;
  String[] cameras = Capture.list();
  if (cameras != null && cameras.length>0) {
    for (int i=0; i < cameras.length; i++) {

      //regex to select only cameras that are 1280x720
      String[] matched = match(cameras[i], "size=1280x720,fps=30");

      if (matched != null) {
        cameraFound.add(cameras[i]);   
      }
      
        
      
    }
  } else {
    println("Cameras not available or null! Exiting Program");
    exit();
  }

  println(cameraFound);
  
  
}

void videoStartUpManager() {   
  textSize(16);
  textLeading(16);
  stroke(255);

  pc = new  promptVisControl();
  //pc.loadBoth();


  opencv.useColor(HSB);// set cv colorspace to HSB for filtering

  //initialize main objects
  gbcv = new GBCV();
  dsRed = new dataStorage();
  dsGreen = new dataStorage();
  dsBlue = new dataStorage();
  connections  = new Connections();
  vizPercent = new VisualPercent();
  particles = new ArrayList<Particle>();
  puddles  = new Puddle();
  growth = new Grow();
  blackTranny = new BlackFade(width, height);
  vidMimic = new VidMimic();
}

void draw() {

  //___________main routine
  
  if(camStarted || movieStarted ) {

    loadFrames();

    // seperation of the CV from the visuals.
    updateCV(); 

    drawCurrentUI();

    pc.displayPrompt(width/2,height-300, int(promptOpacity) );


    // delay for "clear" button
    if (mainWindowDelay == true) {
      background(20);
      delay(250);      
      mainWindowDelay = false;
    }

  }




  //printTotals(dsRed.data,dsGreen.data,dsBlue.data);
}


//read cam or video data and load into openCV
  void loadFrames() {
    if (camStarted == true) {
      if (cam.available() == true) {
        cam.read();
        opencv.loadImage(cam);
        
      }
    }
    
    if (movieStarted == true) {
      if (movie.available()) {
        movie.read();
        opencv.loadImage(movie);
        
      }
    }
    
  }

 void launchUiWin() {
   if (objui == null ) {
    objui = new mainUI(this); 
    runSketch(new String[] { "My uiObj Window" }, objui);
    uiWinVis = true;
   }
  }


// Garrett, here is an example of the objui objects dependents, that needs to be moved to a object
// That is not dependent on the window object, kind of like gbcv .  Im letting you do this as you 
// know more about those properties and how they are tied to the interface widgets and and the cv adjustments

void updateCV() {
  // params* (input matrix, hue-low, hue-high, sat-low, sat-high, value-low, value-high, output matrix)
  gbcv.inRangeGB( opencv.matHSV, rHueMin, rHueMax, rSatMin, rSatMax, rValMin, rValMax, gbcv.matRed );
  gbcv.inRangeGB( opencv.matHSV, gHueMin, gHueMax, gSatMin, gSatMax, gValMin, gValMax, gbcv.matGreen );
  gbcv.inRangeGB( opencv.matHSV, bHueMin, bHueMax, bSatMin, bSatMax, bValMin, bValMax, gbcv.matBlue );
  //run inRange on higher set of red values(150-179)
  gbcv.inRangeGB( opencv.matHSV, r2HueMin, r2HueMax, r2SatMin, r2SatMax, r2ValMin, r2ValMax, gbcv.matRed2 );
  //add the 2 red filtered matrices together, and place result back into matRed
  Core.addWeighted(gbcv.matRed, 1, gbcv.matRed2, 1, 0, gbcv.matRed );

  //detect where circles are located
  gbcv.findCircles(gbcv.matRed, gbcv.circlesRed, dsRed);
  gbcv.findCircles(gbcv.matGreen, gbcv.circlesGreen, dsGreen);
  gbcv.findCircles(gbcv.matBlue, gbcv.circlesBlue, dsBlue);
}

void drawCurrentUI() {

  switch(pc.visNum) {

  case 0: //BT
    //background(20); 
    blackTranny.fadeOut(); // move this, idk where - GB*****
    break; 
  case 1:  //connect
    pushMatrix();
    scale(-1, 1);
    translate(-width+tempOff, 0);
    background(20); 
    vidMimic.pushToScreen(255);
    connections.pushToScreen();
    popMatrix();
    break;
  case 2: //VizPerFull
    background(20);
    pushMatrix();
    scale(-1, 1);
    translate(-width+tempOff, 0);
    //gbcv.drawVideo(whichVideo);
    vidMimic.pushToScreen(255);
    popMatrix();
    tPanel.pushToScreen();
    vizPercent.pushToScreen(100, "full");
    break;
  case 3:  //VizPerStripe
    pushMatrix();
    scale(-1, 1);
    translate(-width + tempOff, 0);
    vidMimic.pushSquares(60);
    popMatrix();
    vizPercent.pushToScreen(100, "stripes");
    break;
  case 4: //growth
    background(20);
    pushMatrix();
    scale(-1, 1);
    translate(-width + tempOff, 0);
    vidMimic.pushToScreen(255);
    growth.pushToScreen();
    popMatrix(); 

    break;
  case 5: //Puddles
    background(20); 
    //gbcv.drawVideo(whichVideo);
    pushMatrix();
    scale(-1, 1);
    translate(-width + tempOff, 0);
    vidMimic.pushToScreen(255);
    puddles.pushToScreen();
    popMatrix();
    break;
  case 6: //Particle
    background(20);
    pushMatrix();
    scale(-1, 1);
    translate(-width + tempOff, 0);
    particleTimer( int(random(5000, 10000)) );
    doParticleViz(dsRed.data, dsGreen.data, dsBlue.data);
    vidMimic.pushToScreen(255);
    popMatrix();
    break;
  case 7://Video
    background(20);
    pushMatrix();
    scale(-1, 1);
    translate(-width+tempOff, 0);
    gbcv.drawVideo(whichVideo);
    //connections.pushToScreen();   // this is test! remove
    popMatrix();
    break;
  case 8: // Hough Circles Calibration
    background(20);
    pushMatrix();
    scale(-1, 1);
    translate(-width+tempOff, 0);
    gbcv.drawVideo(whichVideo);
    connections.pushToScreenCirclesOnly();
    popMatrix();
    break;
    //case 9:
    //  //zzzz.pushToScreen();
    //   break;
    // case 10:  //Black Transition
    //  //zzzz.pushToScreen();
    //   break;
  default:             // Default executes if the case labels
    // println("None");   // don't match the switch parameter
    break;
  }


  //uiObj.guiText(color(255), guiVisibility, whichVideo);
}

void exit() {
  if (cam != null) {
    cam.stop();
  }
  super.exit();//let processing carry with it's regular exit routine
}

//void keyPressed() {
//  println( objui.maxSticks.getValue() ); 
//}


void keyPressed() {

  //int k = key; 
  //println(k);

  // if (k == ENTER | k == RETURN)  //activateSketch(another);

  //  if (k == 'T') mainparent.toggleSketch(this);  // disableSketch(another); 
  //if (k == 'S') saveWords();
  //if (k == 'L') loadWords();

  //switch case for video drawing
  if (key==' ') {
    println("-main space");
    //println("hey");
    
    if(objui == null) {     
       launchUiWin();
    } else {     
      toggleUiWinVis();
    }
    
  }
  // whichVideo='`'; // src video



  // if (key=='1') whichVideo='1'; //
}


void toggleUiWinVis() {
  
  if (uiWinVis == true) {
      uiWinVis = false;
      objui.getSurface().setVisible(uiWinVis);
  } else {
      uiWinVis = true;
      objui.getSurface().setVisible(uiWinVis);   
  } 
}

void minDist() {
  minDistVal = objui.minDist.getValue();
  println(minDistVal);
}
void cannyHigh() { 
  cannyHighVal= objui.cannyHigh.getValue();
  //println(cannyHighVal);
}
void cannyLow() {
 cannyLowVal = objui.cannyLow.getValue();
 //println(cannyLowVal);
}
void minSize() {
  minSizeVal = int(objui.minSize.getValue());
  //println(minSizeVal);
}
void maxSize() {
  maxSizeVal = int(objui.maxSize.getValue());
  //println(maxSizeVal);
}
void maxSticks() {
 maxSticksVal = objui.maxSticks.getValue(); 
 //println(maxSticksVal);
}

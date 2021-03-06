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
//// all new stuff for video input buttons
ArrayList<String> videoPaths = new ArrayList<String>();
Capture cam;
Movie movie;




//controlP5 Lib
import controlP5.*;

//Start Globals
// FS true sets the screen to full
boolean fs = true;
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

FrameData gframe; 
OpenCV opencv;
GBCV gbcv;

promptVisControl pc;
sdUI objui;
// sd add 4.29
configUI figui;

vidSelectUI vidUI; // vid select window


dataStorage dsRed, dsGreen, dsBlue;
TextPanel tPanel = new TextPanel(20,20);

Connections connections;
Puddle puddles;
Grow growth;

VisualPercent vizPercent;
ArrayList<Particle> particles;
BlackFade blackTranny;
VidMimic vidMimic;

// Main PApplet Sketch: 
void settings() {
  if (fs) {
    fullScreen();
  } else { 
    size(1280, 720);
  }
}  


void opensdUI() {
  objui = new sdUI(this); 
  runSketch(new String[] { "My uiObj Window" }, objui); 
}

void openvidUI() {
   //added 4/15
  vidUI = new vidSelectUI(this);
  runSketch(new String[] { "vid Select Window" }, vidUI); 
}

void openvidconfigUI() {
  
  figui = new configUI(this); 
  runSketch(new String[] { "My figui Window" }, figui); 
}


void setup() {
  
  opensdUI();
  openvidUI();
  openvidconfigUI();
  
  // video paths need to be obtained from this main window
  // when doing it from the vidUI window, therre is an ERROR
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
        
        
 
  for_imgs[0] = loadImage("button_a.png");
  for_imgs[1] = loadImage("button_b.png");
  for_imgs[2] = loadImage("button_c.png");
  
  bak_imgs[0] = loadImage("ba_button_a.png");
  bak_imgs[1] = loadImage("ba_button_b.png");
  bak_imgs[2] = loadImage("ba_button_c.png");
  
  //frameRate(1);

  //videoStartUpManager(); now run from video button callback functions (window_vid_select tab)
  
  //load helvetica fonts
  // these fonts are size specific.. 20px, 60px
  helv20 = loadFont("Helvetica-20.vlw");
  helvBold20 = loadFont("Helvetica-Bold-20.vlw");
  helvBold60 = loadFont("Helvetica-Bold-60.vlw");
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
  blackTranny = new BlackFade(width,height);
  vidMimic = new VidMimic();
}

void draw() {
    if (vidUI !=null) {
  //___________main routine
  if(vidUI.camStarted || vidUI.movieStarted ) {
  
    vidUI.loadFrames();
    
    // seperation of the CV from the visuals.
    updateCV(); 
    
    drawCurrentUI();
    
    pc.displayPrompt(width/2,height-300, int(promptOpacity) );
     
  }
  
    }
  
  //________ test to draw videos only but no openCV
  //  if (vidUI.camStarted == true) {
  //  if (cam.available() == true) {
  //    cam.read();
  //    //println(cam.width);
  //  }
  //  background(175);
  //  image(cam, 0, 0);
  //}
  
  //if (vidUI.movieStarted == true) {
  //  if (movie.available()) {
  //    movie.read();
  //  }
  //  background(175);
  //  image(movie, 0, 0);
  //}
  
  
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
  
  switch(pc.visNum) {
    
    case 0: //BT
      //background(20); 
      blackTranny.fadeOut(); // move this, idk where - GB*****
    break; 
    case 1:  //connect
      pushMatrix();
      scale(-1,1);
      translate(-width+tempOff, 0);
      background(20); 
      vidMimic.pushToScreen(255);
      connections.pushToScreen();
      popMatrix();
      break;
    case 2: //VizPerFull
      background(20);
      pushMatrix();
      scale(-1,1);
      translate(-width+tempOff, 0);
      //gbcv.drawVideo(whichVideo);
      vidMimic.pushToScreen(255);
      popMatrix();
      tPanel.pushToScreen();
      vizPercent.pushToScreen(100,"full");
      break;
    case 3:  //VizPerStripe
      pushMatrix();
      scale(-1,1);
      translate(-width + tempOff, 0);
        vidMimic.pushSquares(60);
      popMatrix();
      vizPercent.pushToScreen(100,"stripes");
      break;
    case 4: //growth
      background(20);
      pushMatrix();
      scale(-1,1);
      translate(-width + tempOff, 0);
      vidMimic.pushToScreen(255);
      growth.pushToScreen();
      popMatrix(); 
      
      break;
    case 5: //Puddles
      background(20); 
      //gbcv.drawVideo(whichVideo);
      pushMatrix();
      scale(-1,1);
      translate(-width + tempOff, 0);
        vidMimic.pushToScreen(255);
        puddles.pushToScreen();
      popMatrix();
      break;
    case 6: //Particle
      background(20);
      pushMatrix();
      scale(-1,1);
      translate(-width + tempOff, 0);
        particleTimer( int(random(5000,10000)) );
        doParticleViz(dsRed.data, dsGreen.data, dsBlue.data);
        vidMimic.pushToScreen(255);
      popMatrix();
      break;
    case 7://Video
      background(200,200,0);
      pushMatrix();
      scale(-1,1);
      translate(-width+tempOff, 0);
      gbcv.drawVideo(whichVideo);
      //connections.pushToScreen();   // this is test! remove
  
      popMatrix();
      break;
     //case 7:
    //  //zzzz.pushToScreen();
    //   break;
    //case 8:
    //  //zzzz.pushToScreen();
    //   break;
     // case 9:  //Black Transition
    //  //zzzz.pushToScreen();
    //   break;
    default:             // Default executes if the case labels
     // println("None");   // don't match the switch parameter
      break;
  }
  
  
  //uiObj.guiText(color(255), guiVisibility, whichVideo);
  

}

void exit(){
  if (cam != null) {
    cam.stop();
  }
  super.exit();//let processing carry with it's regular exit routine
}

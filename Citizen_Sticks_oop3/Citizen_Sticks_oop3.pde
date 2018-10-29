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
//End

//Main Objects 
VideoSource inputVideo;
Movie video;
Capture cap;
FrameData gframe; 
OpenCV opencv;
GBCV gbcv;
<<<<<<< HEAD
gbDrawCircs gbcvis;
promptControl pc;

=======
>>>>>>> 972b4552d8b91957f182e3c807b1dccca4329674
dataStorage dsRed, dsGreen, dsBlue;
TextPanel tPanel = new TextPanel(0,0);

Connections connections;
VisualPercent vizPercent;


final PApplet uiObj = new sdUI(this);  

// Main PApplet Sketch: 
void settings() {
  if (fs) {
    fullScreen();
  } else { 
    size(1280, 720);
  }
}  

void setup() {
<<<<<<< HEAD
  runSketch(new String[] { "My uiObj Window" }, uiObj);
 
 
  
  videoStartUpManager();
  textSize(16);
  textLeading(16);
  stroke(255);
  //loadGUI();
}



void videoStartUpManager() {

  if (isMovie) {
    // use test video
    mvideo = new Movie(this, "demo1Edit.mp4"); 
    mvideo.loop();
    mvideo.read(); //needed so that video.width&height !=empty for the cv object
    
   opencv = new OpenCV(this, mvideo.width, mvideo.height);
   gframe = new FrameData(mvideo.width, mvideo.height);
  } else {
     // use camera, either dslr or webcam
    String[] cameras = Capture.list();
    printArray(cameras);
    
    if (dslr==true && isMovie==false) {
      cvideo = new Capture(this, 1280, 720, cameras[15], 30);
      cvideo.start();
    } else {
      // video = new Capture(this, 1280, 720, "FaceTime HD Camera", 30);
      cvideo = new Capture(this, 1280, 720, cameras[0]);
      cvideo.start();
       
    }
    
    opencv = new OpenCV(this, cvideo.width, cvideo.height);
    gframe = new FrameData(cvideo.width, cvideo.height);
  }

  // notes after test 2 update starting variables in gui tab
  
  pc = new  promptControl();
=======
  textSize(16);
  textLeading(16);
  stroke(255);
  
  //frameRate(0.5);
>>>>>>> 972b4552d8b91957f182e3c807b1dccca4329674

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
  
  loadGUI(); 
}

void draw() {
  background(0);
  
  inputVideo.loadFrames();
  
<<<<<<< HEAD
   // seperation of the CV from the visuals.
    updateCV();  
    drawCurrentUI();
    // println( Arrays.toString(gbcv.calculateTotals(dsRed.data,dsGreen.data,dsBlue.data)) );
    pc.loadPrompt();
    pc.displayPrompt(width/2,100);

=======
  // seperation of the CV from the visuals.
  updateCV();
    
  drawCurrentUI();
    
  //printTotals(dsRed.data,dsGreen.data,dsBlue.data);
 
>>>>>>> 972b4552d8b91957f182e3c807b1dccca4329674
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
  
  //detect where circles are located
  gbcv.findCircles(gbcv.matRed, gbcv.circlesRed, dsRed);
  gbcv.findCircles(gbcv.matGreen, gbcv.circlesGreen, dsGreen);
  gbcv.findCircles(gbcv.matBlue, gbcv.circlesBlue, dsBlue);
   
}

void drawCurrentUI() {

  //gbcv.drawVideo(whichVideo);
 
<<<<<<< HEAD
  //  uiObj.guiText(color(255), guiVisibility, whichVideo);
=======
  //guiText(color(255), guiVisibility, whichVideo);
   
  connections.pushToScreen();
>>>>>>> 972b4552d8b91957f182e3c807b1dccca4329674
  
  // full mode
  //vizPercent.pushToScreen(100,"full");
  
  // this one is cool, but the problem is that it uses the
  // opacity screen wipe technique, therefore
  // background() and anything reliant on it cannot also be used
  vizPercent.pushToScreen(255,"stripes");
 
  tPanel.pushToScreen();
 
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

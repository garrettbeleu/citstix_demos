import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import gab.opencv.*; 
import processing.video.*; 
import toxi.geom.*; 
import org.opencv.core.Core; 
import org.opencv.core.Mat; 
import org.opencv.core.CvType; 
import org.opencv.imgproc.Imgproc; 
import org.opencv.core.Size; 
import org.opencv.core.Scalar; 
import java.util.List; 
import java.util.Arrays; 
import java.lang.StringBuilder; 
import java.io.IOException; 
import java.nio.file.DirectoryStream; 
import java.nio.file.Files; 
import java.nio.file.Path; 
import java.nio.file.Paths; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class CitizenSticks extends PApplet {

// openCV for Processing Lib and Processing Video Lib




//opencv modules







//java list and array modules


// java string builder


//java modules used for making path buttons





//// all new stuff for camera and video input buttons
ArrayList<String> videoPaths = new ArrayList<String>();
ArrayList<String> cameraFound = new ArrayList<String>();

//controlP5 Lib


//Start Globals
// FS true sets the screen to full
boolean fs = true;
char whichVideo = '`';
boolean guiVisibility = true;
int tempOff = 160; // 160 when display is normal, 0 when display is set to scaled 1280x800px

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
sdUI objui;


dataStorage dsRed, dsGreen, dsBlue;
TextPanel tPanel = new TextPanel(20, 20);

Connections connections;
Puddle puddles;
Grow growth;
Buildr buildth;

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

String globalPromptText = "";

boolean showHideButtons = false;


// Main PApplet Sketch: 
public void settings() {
  if (fs) {
    fullScreen();
  } else { 
    //size(1280, 720);
    size(1480,900);
  }
}  





public void setup() {
  

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


public void checkVideoOptions() {
  
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

public void videoStartUpManager() {   
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
  buildth = new Buildr();
  blackTranny = new BlackFade(width, height);
  vidMimic = new VidMimic();
  
  //load viz 1 so it is ready to go
  pc.queVisForward();

}

public void draw() {

  //___________main routine
  
  if(camStarted || movieStarted ) {

    loadFrames();

    // seperation of the CV from the visuals.
    updateCV(); 

    drawCurrentUI();

    //pc.displayPrompt(width/2,height-300, int(promptOpacity) );
    pc.displayPrompt(width/2, gframe.h-50 , PApplet.parseInt(promptOpacity) );

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
  public void loadFrames() {
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

 public void launchUiWin() {
   if (objui == null ) {
    objui = new sdUI(this); 
    runSketch(new String[] { "My uiObj Window" }, objui);
    uiWinVis = true;
   }
  }


// Garrett, here is an example of the objui objects dependents, that needs to be moved to a object
// That is not dependent on the window object, kind of like gbcv .  Im letting you do this as you 
// know more about those properties and how they are tied to the interface widgets and and the cv adjustments

public void updateCV() {
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

public void drawCurrentUI() {

  switch(pc.visNum) {

  case 0: //BT
    //background(20); 
    blackTranny.fadeOut(); // move this, idk where - GB*****
    break; 
  case 1:  //connect
    pushMatrix();
    scale(-1, 1);
    //translate(-width+tempOff, 0);
    translate(  (-width) + (width-gframe.w)/2  ,0);
    background(20); 
    vidMimic.pushToScreen(255);
    connections.pushToScreen();
    popMatrix();
    break;
  case 2: //VizPerFull
    background(20);
    pushMatrix();
    scale(-1, 1);
    //translate(-width+tempOff, 0);
    translate(  (-width) + (width-gframe.w)/2  ,0);
    //gbcv.drawVideo(whichVideo);
    vidMimic.pushToScreen(255);
    popMatrix();
    tPanel.pushToScreen();
    vizPercent.pushToScreen(100, "full");
    break;
  case 3:  //VizPerStripe
    pushMatrix();
    scale(-1, 1);
    //translate(-width + tempOff, 0);
    translate(  (-width) + (width-gframe.w)/2  ,0);
    vidMimic.pushSquares(60);
    popMatrix();
    vizPercent.pushToScreen(100, "stripes");
    break;
  case 4: //Growth
    background(20);
    pushMatrix();
    scale(-1, 1);
    //translate(-width + tempOff, 0);
    translate(  (-width) + (width-gframe.w)/2  ,0);
    vidMimic.pushToScreen(255);
    growth.pushToScreen();
    popMatrix(); 
    break;
  case 5: //Puddles
    background(20); 
    //gbcv.drawVideo(whichVideo);
    pushMatrix();
    scale(-1, 1);
    //translate(-width + tempOff, 0);
    translate(  (-width) + (width-gframe.w)/2  ,0);
    vidMimic.pushToScreen(255);
    puddles.pushToScreen();
    popMatrix();
    break;
  case 6: //Particle
    background(20);
    pushMatrix();
    scale(-1, 1);
    //translate(-width + tempOff, 0);
    translate(  (-width) + (width-gframe.w)/2  ,0);
    particleTimer( PApplet.parseInt(random(5000, 10000)) );
    doParticleViz(dsRed.data, dsGreen.data, dsBlue.data);
    vidMimic.pushToScreen(255);
    popMatrix();
    break;
  case 7: //Buildth
    background(20);
    pushMatrix();
    scale(-1, 1);
    //translate(-width + tempOff, 0);
    translate(  (-width) + (width-gframe.w)/2  ,0);
    buildth.pushToScreen();
    vidMimic.pushToScreen(255);
    popMatrix(); 
    break;
  case 8://Video
    background(20);
    pushMatrix();
    scale(-1, 1);
    //translate(-width+tempOff, 0);
    translate(  (-width) + (width-gframe.w)/2  ,0);
    //println( (-width) + (width-gframe.w)/2 );
    gbcv.drawVideo(whichVideo);
    //connections.pushToScreen();   // this is test! remove
    popMatrix();
    break;
  case 9: // Hough Circles Calibration
    background(20);
    pushMatrix();
    scale(-1, 1);
    //translate(-width+tempOff, 0);
    translate(  (-width) + (width-gframe.w)/2  ,0);
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

public void exit() {
  if (cam != null) {
    cam.stop();
  }
  super.exit();//let processing carry with it's regular exit routine
}

//void keyPressed() {
//  println( objui.maxSticks.getValue() ); 
//}


public void keyPressed() {

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


public void toggleUiWinVis() {
  
  if (uiWinVis == true) {
      uiWinVis = false;
      objui.getSurface().setVisible(uiWinVis);
  } else {
      uiWinVis = true;
      objui.getSurface().setVisible(uiWinVis);   
  } 
}

public void minDist() {
  minDistVal = objui.minDist.getValue();
  println(minDistVal);
}
public void cannyHigh() { 
  cannyHighVal= objui.cannyHigh.getValue();
  //println(cannyHighVal);
}
public void cannyLow() {
 cannyLowVal = objui.cannyLow.getValue();
 //println(cannyLowVal);
}
public void minSize() {
  minSizeVal = PApplet.parseInt(objui.minSize.getValue());
  //println(minSizeVal);
}
public void maxSize() {
  maxSizeVal = PApplet.parseInt(objui.maxSize.getValue());
  //println(maxSizeVal);
}
public void maxSticks() {
 maxSticksVal = objui.maxSticks.getValue(); 
 //println(maxSticksVal);
}
/*
Fade to black by repeatedly drawing
transparent black rectangle over entire screen
*/

class BlackFade {
  int w;
  int h;
  int counter = 0;
  float opacity; 
  float easing = 0.75f;
  
  BlackFade(int _w, int _h) {
    w = _w;
    h =_h;
  }
  
  public void fadeOut() {
    if (counter<50) {
      float targetOpacity = 20;
      float dOpac = targetOpacity - opacity;
      opacity += dOpac * easing;
      
      counter++;
      noStroke();
      rectMode(CORNER);
      fill(0,0,0,opacity);
      rect(0,0,w,h);
      
      promptOpacity = map(opacity,0,20,255,0);
    } 
    //float tempPromptOpacity;
    //println(counter);
  }
  
  public void reset() {
    counter = 0;
    opacity=0;
    promptOpacity = 255;
  }
  
}

/*

// SD commenting needed (created Building and remove effect)

// Buildr Class that runs the visual builds/destroys Block objects
//  The Block class has moving and flocking methods to move and compare

*/


class Buildr {

  ArrayList<Blockr> blockCollectionR;
  ArrayList<Blockr> blockCollectionG;
  ArrayList<Blockr> blockCollectionB;
  int counter = 0;
  int gridSize = 30; //30
  int alphaAmnt = 20;
  
  //constructor
  Buildr() {  
   println("hey");
   
    blockCollectionR = new ArrayList();
    blockCollectionG = new ArrayList();
    blockCollectionB = new ArrayList();
  }

  public void blockBuildMaster(float[][] ar, float[][] ag, float[][] ab, 
                         int kr, int kg,int kb, ArrayList cr,ArrayList cg,ArrayList cb) {
       
     
        
        

        
       // Grn ////////////////

        for (int i=0; i<ag.length; i++) {                                                    
              Vec3D origin =  new Vec3D(PApplet.parseInt(ag[i][0]/gridSize)*gridSize, PApplet.parseInt(ag[i][1]/gridSize)*gridSize, 0);  
              Blockr curB =  new Blockr(1,origin, this, cg, kg); 
              cg.add(curB);           
        }
                 
          
         for (int i = cg.size() - 1; i >= 0; i--) {            
            Blockr curG = (Blockr) cg.get(i);            
            if (curG.finished()) {
              cg.remove(i);
            }
          }
          

       
        for (int i = 0; i < cg.size(); i++) {
           Blockr newG = (Blockr) cg.get(i);
           newG.run(); 
        }
        
         // Red ////////////////  Actually blacks out or dims the green.
             
        for (int i=0; i<ar.length; i++) {                                                    
              Vec3D origin =  new Vec3D(PApplet.parseInt(ar[i][0]/gridSize)*gridSize, PApplet.parseInt(ar[i][1]/gridSize)*gridSize, 0);  
              Blockr curR =  new Blockr(0,origin, this, cr, kr); 
              cr.add(curR);           
        }
                 
          
         for (int i = cr.size() - 1; i >= 0; i--) {            
            Blockr curR = (Blockr) cr.get(i);            
            if (curR.finished()) {
              cr.remove(i);
            }
          }
          

       
        for (int i = 0; i < cr.size(); i++) {
           Blockr newR = (Blockr) cr.get(i);
           newR.run(); 
        }
        
        // Blu ////////////////////////// BRINGER OF CHANGE  // reduces the life of any object
        
           for (int i=0; i<ab.length; i++) {                                                    
            
             Vec3D origin =  new Vec3D(PApplet.parseInt(ab[i][0]/gridSize)*gridSize, PApplet.parseInt(ab[i][1]/gridSize)*gridSize, 0); 
            
              for (int j = cr.size() - 1; j >= 0; j--) { 
               // print("r" + j);
                Blockr newR = (Blockr) cr.get(j);
                  
                float distanceR = origin.distanceTo(newR.loc);
                   
                  if ( distanceR < 80 ) {
                    //print("dr" + j);
                    newR.life = 20;
                    //cg.remove(j);
                  }       
              }
              
              
              for (int j = cg.size() - 1; j >= 0; j--) { 
               // print("g" + j);
                Blockr newG = (Blockr) cg.get(j);
                  
                float distanceG = origin.distanceTo(newG.loc);

                  if ( distanceG < 80 ) {
                   //  print("dg" + j);
                     newG.life = 20;
                    // cg.remove(j);
                  }       
              }
            
                       
            }
         
               
          //for (int i = cg.size() - 1; i >= 0; i--) {            
             
            
              
          //  //if (curB.finished()) {
          //  //  cg.remove(i);
          //  //}
          //}       
                 
                 
          //for (int i = cb.size() - 1; i >= 0; i--) {            
          //  Blockr curB = (Blockr) cb.get(i);            
          //  if (curB.finished()) {
          //    cb.remove(i);
          //  }
          //}

      
        //for (int i = 0; i < cb.size(); i++) {
        //   Blockr newB = (Blockr) cb.get(i);
        //   newB.run(); 
        //}
     
    
  }



  public void pushToScreen() {
    //strokeWeight(3);
    rectMode(CORNER);
    noFill();
    //color(0,alphaAmnt)
   // color(0,0,200,alphaAmnt)
    blockBuildMaster(dsRed.data, dsGreen.data, dsBlue.data, color(15,alphaAmnt*2),color(0,255,0,alphaAmnt),color(0,0,255,alphaAmnt),
    blockCollectionR, blockCollectionG, blockCollectionB);
    
    // GB added
    if (mainWindowDelay == true) {
      blockCollectionR.clear();
      blockCollectionG.clear();
      blockCollectionB.clear();
    }
    
  }
  
  
}

////////////// END OF CLASS Buildr ////////////////


////////////////////////////////// Begin Block  //////////////////


class Blockr { 
  //var available for the whole class
  float x = 0;
  float y = 0; 
  float speedX = 0; //random(-2.2);
  float speedY = 0; // random(-2.2);
  Buildr p;
  ArrayList c;
  int k;
 public int life = 3000; // 80

  public Vec3D loc =   new Vec3D(0, 0, 0);
  Vec3D speed = new Vec3D(random(-2, 2), random(-2, 2), 0);
  Vec3D grav =  new Vec3D(0, 0.2f, 0);
  Vec3D acc = new Vec3D();

  //Constructor
  Blockr (int whichK, Vec3D _loc, Buildr _p, ArrayList _c, int _k) {  
    loc = _loc;
    p = _p;
    c = _c;
    k = _k;
    
  } 

  public void run() {

    display();
    core();
  
  }


  
   public Vec3D getVect() {
     return loc;
   }

  



  public void core() {

    //adding core

    for (int i = 0; i < c.size(); i++ ) {

      Blockr other = (Blockr) c.get(i);

      float distance = loc.distanceTo(other.loc);

      if ( distance > 60 && distance < 80) {
        //strokeWeight(40/distance);
        rectMode(CENTER);
        fill(k);
        rect(loc.x, loc.y, 15,15,3);
      }
    }
  }

  public void display() { 
  
        rectMode(CENTER);
        fill(k);
        stroke(k);
        rect(loc.x, loc.y, 30,30,6); 
  } 
  
 

  public void bounce() {

    if ( loc.x > width) {
      speed.x = - speed.x;
    }
    if (loc.x < 0) {
      speed.x = - speed.x;
    }

    if ( loc.y > height+10) {
      speed.y = -speed.y;
    }
    if (loc.y < 0) {
      speed.y = -speed.y;
    }
  }

  
  
  public boolean finished() {
    // Balls fade out
    life--;
    if (life < 0) {
      return true;
    } else {
      return false;
    }
  }
   
  
} 
/*
//\\//\\//\\//\\//\\//\\//\\//\\
    Connect circles data-viz
\\//\\//\\//\\//\\//\\//\\//\\//

drawCircles params -- (where to get circle data, what color to draw the connecting lines and circles)
*/

class Connections  {
  
  Connections() {  
  }
  
  public void drawCircles(float[][] inputArray, int c) {
    
      stroke(c);
      
      // draw continuous spline curves connecting each detected circle
      if (inputArray.length>1) {
        beginShape();
        curveVertex(inputArray[0][0], inputArray[0][1]);
        curveVertex(inputArray[0][0], inputArray[0][1]);
        for (int i=0; i<inputArray.length; i++) {
          if(i>0) {
            curveVertex(inputArray[i-1][0], inputArray[i-1][1]);
            //curveVertex(inputArray[i-1][0], inputArray[i-1][1]);
          }
          if(i==inputArray.length-1) {
            curveVertex(inputArray[i][0], inputArray[i][1]);
          }
        }
        curveVertex(inputArray[0][0], inputArray[0][1]);
        curveVertex(inputArray[0][0], inputArray[0][1]);
        endShape();
      }
      
      // drawing ellipses at detected circle locations
      for (int i=0; i<inputArray.length; i++) {
        ellipse(inputArray[i][0],inputArray[i][1],inputArray[i][2]*2,inputArray[i][2]*2);
      }
  }
  
  public void pushToScreen() {
    strokeWeight(3);
    noFill();
    drawCircles(dsRed.data, color(255,0,0));
    drawCircles(dsGreen.data, color(0,255,0));
    drawCircles(dsBlue.data, color(0,0,255));  
  }
  
  public void drawCirclesOnly(float[][] inputArray, int c) {
      stroke(c);
      // drawing ellipses at detected circle locations
      for (int i=0; i<inputArray.length; i++) {
        ellipse(inputArray[i][0],inputArray[i][1],inputArray[i][2]*2,inputArray[i][2]*2);
      }
  }
  public void pushToScreenCirclesOnly() {
    strokeWeight(3);
    noFill();
    drawCirclesOnly(dsRed.data, color(255,0,255)); //
    drawCirclesOnly(dsGreen.data, color(255,255,0));
    drawCirclesOnly(dsBlue.data, color(0,0,255));  
  }

 
}
/*
Main object for 
-handling different openCV matrixes
-filtering for color values within the desired range - inRangeGB method
-displaying the matrix resultant of the inRangeGB filter, mainly to visually check limits and results - drawVideo method
-detect circles within a given image and store thier locations and size in a global object - findCircles method
*/


class GBCV {
  Mat matRed, matRed2, matGreen, matBlue, matRGB;
  PImage src, redFilteredImage, greenFilteredImage, blueFilteredImage, rgbFilteredImage;
  Mat circlesRed, circlesGreen, circlesBlue;
  
  GBCV() {
    matRed = new Mat(gframe.w, gframe.h, CvType.CV_8UC1); //red hues 0-10
    matRed2 = new Mat(gframe.w, gframe.h, CvType.CV_8UC1); //red hues 150-179
    matGreen = new Mat(gframe.w, gframe.h, CvType.CV_8UC1);
    matBlue = new Mat(gframe.w, gframe.h, CvType.CV_8UC1);
    matRGB = new Mat(gframe.w, gframe.h, CvType.CV_8UC3);

    circlesRed= new Mat();
    circlesGreen= new Mat();
    circlesBlue= new Mat();
  }
  
  public void inRangeGB(Mat src, int h1, int h2, int s1, int s2, int v1, int v2, Mat dst){
      Core.inRange( src, new Scalar(h1,s1,v1), new Scalar(h2,s2,v2), dst );
  }
  
  public void drawVideo(char theCase) {
    switch(theCase) {
    case '`':
      if (camStarted) {
        image(cam,0,0);
        //set(0,0,inputVideo.webcam); // this is faster if no resize or transformations are needed
      } 
      if(movieStarted) {
        image(movie,0,0);
      }
      break;
    //case '1':
    //  // remember BGR is opencv order
    //  List<Mat> listMat = Arrays.asList(matBlue,matGreen,matRed);
    //  Core.merge(listMat, matRGB);
             
    //  rgbFilteredImage = opencv.getSnapshot(matRGB);
    //  image(rgbFilteredImage,0,0);
    //  break;
    //case '2':
    //  redFilteredImage = opencv.getSnapshot(matRed);
    //  image(redFilteredImage,0,0);
    //  break;
    //case '3':
    //  greenFilteredImage = opencv.getSnapshot(matGreen);
    //  image(greenFilteredImage,0,0);
    //  break;
    //case '4':
    //  blueFilteredImage = opencv.getSnapshot(matBlue);
    //  image(blueFilteredImage,0,0);
    //  break;
    //case '0': //display no video
    //  break;
    default:
      break;
    }
  }
  
  public void findCircles(Mat input, Mat output, dataStorage theData) {
  Imgproc.HoughCircles(input, output, Imgproc.CV_HOUGH_GRADIENT, 
                       dpVal,  minDistVal, 
                       cannyHighVal, cannyLowVal,
                       minSizeVal,  maxSizeVal );

    if (output.rows()>0) {
      //println("dump= "+output.dump() +"\n");
     
      //place circlesRed matrix values into an array of the same datatype
      double[][] tempData = new double[output.cols()][output.rows()];
      for(int i=0; i<output.cols(); i++) {  
        tempData[i] = output.get(0,i);
        //println(output.get(0,i));
      }
      
      //added 4/23
      if(tempData.length <= maxSticksVal) { //capture them all if less than max
        
        //old unlimited size way  
        // initialize the size of the float[][] array
        theData.data = new float[tempData.length][3];
          for(int i=0; i<tempData.length; i++) {
            for(int j=0; j<tempData[i].length; j++) {
              // cast the double[][] to a float[][]
              theData.data[i][j] = (float)tempData[i][j];
            }
          } 
      }
        
      //limit number of circles to look for 
      if (tempData.length > maxSticksVal ) {
        theData.data = new float[PApplet.parseInt(maxSticksVal)][3];
        for(int i=0; i<maxSticksVal; i++) {
          for(int j=0; j<3; j++) { //for the x,y,radius values of each detected circle
            // cast the double[][] to a float[][]
            theData.data[i][j] = (float)tempData[i][j];
          }
        }
        
      }
        
        
    }else{
      //empty but not null - *important*
      theData.data = new float[0][0];
    }
  }
  
  
}
/*

// SD commenting needed (created blocky effect)

// Grow Class that runs the visual birthes/destroys Block objects
//  The Block class has moving and flocking methods to move and compare


*/


class Grow {

  ArrayList<Block> blockCollectionR;
  ArrayList<Block> blockCollectionG;
  ArrayList<Block> blockCollectionB;
  int counter = 0;
  int gridSize = 30;
  
  //constructor
  Grow() {  
    blockCollectionR = new ArrayList();
    blockCollectionG = new ArrayList();
    blockCollectionB = new ArrayList();
  }

  public void blockGrowthMaster(float[][] ar, float[][] ag, float[][] ab, 
                         int kr, int kg,int kb, ArrayList cr,ArrayList cg,ArrayList cb) {

      // if (inputArray.length>0) {
        
         // Red ////////////////
             
        for (int i=0; i<ar.length; i++) {                                                    
                Vec3D origin =  new Vec3D(PApplet.parseInt(ar[i][0]/gridSize)*gridSize, PApplet.parseInt(ar[i][1]/gridSize)*gridSize, 0);  
                Block curB =  new Block(origin, this, cr, kr); 
                cr.add(curB);           
            }
                 
        for (int i = cr.size() - 1; i >= 0; i--) {            
          Block curB = (Block) cr.get(i);            
          if (curB.finished()) {
            cr.remove(i);
          }
        }

        for (int i = 0; i < cr.size(); i++) {
                 Block newB = (Block) cr.get(i);
                 newB.run(); 
        }
        
       // Grn ////////////////

          for (int i=0; i<ag.length; i++) {                                                    
                Vec3D origin =  new Vec3D(PApplet.parseInt(ag[i][0]/gridSize)*gridSize, PApplet.parseInt(ag[i][1]/gridSize)*gridSize, 0);  
                Block curB =  new Block(origin, this, cg, kg); 
                cg.add(curB);           
            }
                 
          for (int i = cg.size() - 1; i >= 0; i--) {            
            Block curB = (Block) cg.get(i);            
            if (curB.finished()) {
              cg.remove(i);
            }
          }

        // sd should this be grn objects????
        for (int i = 0; i < cg.size(); i++) {
           Block newB = (Block) cg.get(i);
           newB.run(); 
        }
        
        // Blu //////////////////////////
        
           for (int i=0; i<ab.length; i++) {                                                    
                Vec3D origin =  new Vec3D(PApplet.parseInt(ab[i][0]/gridSize)*gridSize, PApplet.parseInt(ab[i][1]/gridSize)*gridSize, 0);  
                Block curB =  new Block(origin, this, cb, kb); 
                cb.add(curB);           
            }
                 
          for (int i = cb.size() - 1; i >= 0; i--) {            
            Block curB = (Block) cb.get(i);            
            if (curB.finished()) {
              cb.remove(i);
            }
          }

      
        for (int i = 0; i < cb.size(); i++) {
           Block newB = (Block) cb.get(i);
           newB.run(); 
        }
     
    
  }



  public void pushToScreen() {
    //strokeWeight(3);
    rectMode(CORNER);
    noFill();
    blockGrowthMaster(dsRed.data, dsGreen.data, dsBlue.data, color(255,0,0,9),color(0,255,0,9),color(0,0,255,9),
    blockCollectionR, blockCollectionG, blockCollectionB);
    
    // GB added
    if (mainWindowDelay == true) {
      blockCollectionR.clear();
      blockCollectionG.clear();
      blockCollectionB.clear();
    }
    
  }
  
  
}

////////////// END OF CLASS PUDDLE ////////////////


////////////////////////////////// Begin Orb  //////////////////


class Block { 
  //var available for the whole class
  float x = 0;
  float y = 0; 
  float speedX = 0; //random(-2.2);
  float speedY = 0; // random(-2.2);
  Grow p;
  ArrayList c;
  int k;
  int life = 80;

  Vec3D loc =   new Vec3D(0, 0, 0);
 // Vec3D speed = new Vec3D(random(-2, 2), random(-2, 2), 0);
  Vec3D speed = new Vec3D(random(-2, 2), random(-2, 2), 0);
  Vec3D grav =  new Vec3D(0, 0.2f, 0);
  Vec3D acc = new Vec3D();

  //Constructor
  Block (Vec3D _loc, Grow _p, ArrayList _c, int _k) {  
    loc = _loc;
    p = _p;
    c = _c;
    k = _k;
    
  } 

  public void run() {

    display();
    //move();
    bounce();
   // gravity();
    lineBetween();

    //flock();
  }


  public void flock() {
    seperate(5);
    cohesion(.001f);
    align(1.0f);
  }


  public void align (float magnitude) {

    Vec3D steer = new Vec3D();
    int count = 0;

    for (int i = 0; i < c.size(); i++ ) {
      Block other = (Block) c.get(i);
      float distance = loc.distanceTo(other.loc);

      if ( distance > 0 && distance < 40) {

        steer.addSelf(other.speed);
        count++;
      }
    }

    if ( count > 0 ) {
      steer.scaleSelf(1.0f/count);
    }

    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }


  public void cohesion(float magnitude) {

    Vec3D sum = new Vec3D();
    int count = 0;

    for (int i = 0; i < c.size(); i++ ) {
      Block other = (Block) c.get(i);
      float distance = loc.distanceTo(other.loc);

      if ( distance > 0 && distance < 40) {
        sum.addSelf(other.loc);
        count++;
      }
    }

    if ( count > 0) {
      sum.scaleSelf(1.0f/count);
    }
    Vec3D steer = sum.sub(loc);

    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }




  public void seperate(float magnitude) {

    Vec3D steer = new Vec3D();
    int count = 0;

    for (int i = 0; i < c.size(); i++ ) {
      Block other = (Block) c.get(i);
      float distance = loc.distanceTo(other.loc);

      if ( distance > 0 && distance < 40) {

        Vec3D diff = loc.sub(other.loc);
        diff.normalizeTo(1.0f/distance);

        steer.addSelf(diff);
        count++;
      }
    }

    if ( count > 0) {
      steer.scaleSelf(1.0f/count);
    }
    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }



  public void lineBetween() {

    //ballCollection

    for (int i = 0; i < c.size(); i++ ) {

      Block other = (Block) c.get(i);

      float distance = loc.distanceTo(other.loc);

      if ( distance > 60 && distance < 80) {
        //strokeWeight(40/distance);
        rectMode(CENTER);
        fill(k);
        rect(loc.x, loc.y, 15,15,3);
      }
    }
  }

  public void display() { 
  
        rectMode(CENTER);
        fill(k);
        stroke(k);
        rect(loc.x, loc.y, 30,30,6); 
  } 
  public void move() {

    speed.addSelf(acc);
    speed.limit(2);

    loc.addSelf(speed);

    acc.clear();
  }

  public void bounce() {

    if ( loc.x > width) {
      speed.x = - speed.x;
    }
    if (loc.x < 0) {
      speed.x = - speed.x;
    }

    if ( loc.y > height+10) {
      speed.y = -speed.y;
    }
    if (loc.y < 0) {
      speed.y = -speed.y;
    }
  }

  public void gravity() {
    speed.addSelf(grav);
  }
  
  
  public boolean finished() {
    // Balls fade out
    life--;
    if (life < 0) {
      return true;
    } else {
      return false;
    }
  }
   
  
} 
/*
=.=.=.=.=.=.=.=.=.=.=.=.=.=.=.=.
    Particle Visualization
=.=.=.=.=.=.=.=.=.=.=.=.=.=.=.=.
*/
/*
_____NOTES_____
play with acceleration, velocity and opacity to find the best look
*/

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float opacity;
  float size;
  int finalColor;
  
  Particle(PVector l, int _finalColor, int theCount) {
    
    if(theCount==0) {
      //down
      acceleration = new PVector(0, random(0.5f,1.5f) );
      velocity = new PVector(0, random(3, 5));  
    }
    if(theCount==1) {
      //left-down
      acceleration = new PVector(0.55f, 0.25f );
      velocity = new PVector(10, 3); 
    }
    if(theCount==2) {
      //left
      acceleration = new PVector(0.25f, 0.25f );
      velocity = new PVector(10, 0); 
    }
    if(theCount==3) {
      //circles
      acceleration = new PVector(0.15f, 0.15f );
      velocity = new PVector(-10, 10); 
    }
    if(theCount==4) {
      //idk - death spiral
      acceleration = new PVector(0.15f, 0.15f );
      velocity = new PVector(random(-10,-15),-10); 
    }

    
    //random direction fast
    //acceleration = new PVector(random(-10.05,10.05), random(-10.05,10.05) );
    //velocity = new PVector(random(-5, 5), random(-5, 5));
    
    //random direction slow
    //acceleration = new PVector(random(-0.05,0.05), random(-0.05,0.05) );
    //velocity = new PVector(random(-5, 5), random(-5, 5));
    
    
    position = new PVector(l.x,l.y);
    size = l.z; 
    opacity = 255.0f;
    finalColor = _finalColor;
  }


  // Method to update position
  public void update() {
    if(timerCount==0) {
      velocity.add(acceleration);
      position.add(velocity);
      opacity -= 9.5f;
    }
    if(timerCount==1) {
      velocity.add(acceleration);
      position.add(velocity);
      opacity -= 7.5f;
    }
    if(timerCount==2) {
      velocity.add(acceleration);
      position.add(velocity);
      opacity -= 9.5f;
    }
    if(timerCount==3) {
      float inc = TWO_PI/80.0f;
      velocity.add(acceleration.x,acceleration.y);
      position.add(sin(velocity.x)*10.5f, sin(velocity.y)*10.5f );    
      opacity -= 6.5f;
      velocity.x += inc;
      velocity.y += inc;
    }
    if(timerCount==4) {
      float inc = TWO_PI/24.0f;
      velocity.add(acceleration.x*2,acceleration.y*2);
      position.add(sin(velocity.x)*65.5f, sin(velocity.y)*-45.5f );    
      opacity -= 10.5f;
      velocity.x += inc;
      velocity.y += inc;
    }
    
    
  }//end update

  // Method to display
  public void display() {
    noStroke();
    //stroke(0, opacity);
    //strokeWeight(2);
    fill(finalColor, opacity);
    if(timerCount==0) { ellipse(position.x, position.y, (size+=0.5f), (size+=0.5f)); }
    if(timerCount==1) { ellipse(position.x, position.y, (size+=0.3f), (size+=0.3f)); }
    if(timerCount==2) { ellipse(position.x, position.y, (size+=0.4f), (size+=0.4f)); }
    if(timerCount==3) { ellipse(position.x, position.y, (size+=0.4f), (size+=0.4f)); }
    if(timerCount==4) { ellipse(position.x, position.y, (size+=0.5f), (size+=0.5f)); }
  }
  
  public void run() {
    update();
    display();
  }

  // Kill it... or not
  public boolean isDead() {
    // if it is off-screen or zero opacity, get ride of it!
    if (position.x<0 || position.x>width || position.y<0 || position.y>height || opacity<0) {
      //println("death zone!!!");
      return true;
    } else {
      return false;
    } 
  }  
  
}

/// function to run all the particle stuff
// - - - I can't figure out how to add this into the particle class, so here is a standalone function

public void doParticleViz(float[][] r, float[][] g, float[][] b) {
 //make red particle  
  if (r.length>0) {
    for(int i=0; i<r.length; i++) {
      //make object for every input entry
      particles.add(new Particle(new PVector(r[i][0], r[i][1],r[i][2] ), color(150,0,0),timerCount ));
    }
  }
  //make green particle
  if (g.length>0) {
    for(int i=0; i<g.length; i++) {
      //make object for every input entry
      particles.add(new Particle(new PVector(g[i][0], g[i][1], g[i][2] ), color(0,150,0),timerCount ));
    }
  }
  //make blue particle
  if (b.length>0) {
    for(int i=0; i<b.length; i++) {
      //make object for every input entry
      particles.add(new Particle(new PVector(b[i][0], b[i][1], b[i][2] ), color(0,0,150),timerCount ));
    }
  } 
    
  
    // Looping through the Arraylist backwards to run and delete particles
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
    
    if(mainWindowDelay == true) {
     particles.clear(); 
    }
  
  
}


//timer function for changing particle parameters

int dif;
int time = 0;
int timerCount=0;

public int particleTimer(int duration) {
  if ((millis() - time) > duration) {
    //stuff happens here\\
    //println(timerCount);
    timerCount++;
    
    dif = millis()-time;
    time = millis(); //reset time
    if(timerCount>4) { timerCount=0;}
  }
  return timerCount;
}
/*
_-_-_-_-_-_-_-_-_-_-_-_
 Onscreen Data readout
-_-_-_-_-_-_-_-_-_-_-_-
*/

/*
TO-DO
-add font stylings
-maybe adjust positions relative to eachother
-the hard values used in these text() commands could be made dynamic...
  ... but leave for now until we decide upon a final font size
*/

class TextPanel {
  int x,y;
  int c;
  StringBuilder redStrBuilder = new StringBuilder();
  StringBuilder greenStrBuilder = new StringBuilder();
  StringBuilder blueStrBuilder = new StringBuilder();
  
    TextPanel(int _x, int _y ) {
      x = _x;
      y = _y+16;
    }
    
    public void buildString(float[][] r, float[][] g, float[][] b, int c ) {  
      fill(c);
      
      //float participants = 18;
      float total = r.length + g.length + b.length;
      //float percent = total*100/participants;
      
      float redPercent = r.length*100/total;
      float greenPercent = g.length*100/total;
      float bluePercent = b.length*100/total;
      
      //the font to use
      textFont(helv20,20);
      
      //format the percentage string to 2 decimal places
     // text("Participation: "+String.format("%.2f", percent)+"%", x,y);
      
      text("Red: "+ PApplet.parseInt(redPercent) +"%", x,y);
      text("Green: "+ PApplet.parseInt(greenPercent) +"%", x+120,y);
      text("Blue: "+ PApplet.parseInt(bluePercent) +"%", x+260,y);
      //old non-percentage numbers
      //text( "Red: "+r.length, x, y+40);
      //text( "Green: "+g.length, x+120, y+40);
      //text( "Blue: "+b.length, x+260, y+40);
      
      for(int i=0; i<r.length; i++) {
        for( int j=0; j<r[i].length; j++) {
          if( j==r[i].length-1){
            redStrBuilder.append((int)r[i][j]+";\n");
          }else{
            redStrBuilder.append((int)r[i][j]+",");
          }
        }
      }
      
      for(int i=0; i<g.length; i++) {
        for( int j=0; j<g[i].length; j++) {
          if( j==g[i].length-1){
            greenStrBuilder.append((int)g[i][j]+";\n");
          }else{
            greenStrBuilder.append((int)g[i][j]+",");
          }
        }
      }
      
      for(int i=0; i<b.length; i++) {
        for( int j=0; j<b[i].length; j++) {
          if( j==b[i].length-1){
            blueStrBuilder.append((int)b[i][j]+";\n");
          }else{
            blueStrBuilder.append((int)b[i][j]+",");
          }
        }
      }
      
      String redString = redStrBuilder.toString();
      String greenString = greenStrBuilder.toString();
      String blueString = blueStrBuilder.toString();
      text( redString, x, y+80);
      text( greenString, x+120, y+80);
      text( blueString, x+260, y+80);
      //clear the stringBuilder object for next cycle
      redStrBuilder.setLength(0);
      greenStrBuilder.setLength(0);
      blueStrBuilder.setLength(0); 
    }
  
  public void pushToScreen() {
    buildString(dsRed.data, dsGreen.data, dsBlue.data, color(255,255,255));
  }
    
}
/*
Draw filled gradient orbs instead of the video 
so that the vizualizations run at faster FPS
*/

class VidMimic{
  
  VidMimic() {
  }
  
  public void drawMimic(float[][] inputArray, int cTest, int opacity) {
    int c1;
    int c2;
    
    //mimicing the red leds
    if (cTest == color(255,0,0)) {
      c1 = color(255, 220, 220); //bright inside
      c2 = color(235, 0, 0); //darker at edges
    
      // drawing as gradient orbs
      for (int i=0; i<inputArray.length; i++) {
        float maxr = inputArray[i][2]*2; //size
       // c1 = color(255, rCol, rCol); //bright inside
       // c2 = color(random(200,255), 0, 0); //darker at edges
        for(int r = 0; r < maxr; r++) {
          float n = map(r, 0, maxr, 0, 0.6f);
          int newc = lerpColor(c1, c2, n);
          stroke(newc,opacity);
          ellipse(inputArray[i][0], inputArray[i][1], r, r);
        }
      }
    }
    
    //mimicing the green leds
    if (cTest == color(0,255,0)) {
      c1 = color(220, 255, 220); //bright inside
      c2 = color(0, 235, 0); //darker at edges
    
      // drawing as gradient orbs
      for (int i=0; i<inputArray.length; i++) {
        float maxr = inputArray[i][2]*2; //size
       // c1 = color(255, rCol, rCol); //bright inside
       // c2 = color(random(200,255), 0, 0); //darker at edges
        for(int r = 0; r < maxr; r++) {
          float n = map(r, 0, maxr, 0, 0.6f);
          int newc = lerpColor(c1, c2, n);
          stroke(newc,opacity);
          ellipse(inputArray[i][0], inputArray[i][1], r, r);
        }
      }
    }
    
    //mimicing the blue leds
    if (cTest == color(0,0,255)) {
      c1 = color(220, 220, 255); //bright inside
      c2 = color(0, 0, 235); //darker at edges
    
      // drawing as gradient orbs
      for (int i=0; i<inputArray.length; i++) {
        float maxr = inputArray[i][2]*2; //size
       // c1 = color(255, rCol, rCol); //bright inside
       // c2 = color(random(200,255), 0, 0); //darker at edges
        for(int r = 0; r < maxr; r++) {
          float n = map(r, 0, maxr, 0, 0.6f);
          int newc = lerpColor(c1, c2, n);
          stroke(newc,opacity);
          ellipse(inputArray[i][0], inputArray[i][1], r, r);
        }
      }
    }
     
  }
  
  public void pushToScreen(int finalOpacity) {
    strokeWeight(2);
    noFill();
    drawMimic(dsRed.data, color(255,0,0),finalOpacity);
    drawMimic(dsGreen.data, color(0,255,0),finalOpacity);
    drawMimic(dsBlue.data, color(0,0,255),finalOpacity);  
  }
  
  //SQUARE VERSION 
  public void drawMimicSquares(float[][] inputArray, int cTest, int opacity) {
    int c1;
    int c2;
    
    //mimicing the red leds
    if (cTest == color(255,0,0)) {
      // drawing as gradient sqaures
        c1 = color(255, random(100,220), random(100,220)); //bright inside
        c2 = color(random(230,255), 0, 0); //darker at edges
      for (int i=0; i<inputArray.length; i++) {
       float size = inputArray[i][2]*2;
        for(int r = 0; r < size; r++) {
          float n = map(r, 0, size, 0, 0.6f);
          int newc = lerpColor(c1, c2, n);
          stroke(newc,opacity);
          rect(inputArray[i][0]-(size/2), inputArray[i][1]-(size/2) , r, r);
       }
      }
    }
    
    //mimicing the green leds -sqaure
    if (cTest == color(0,255,0)) {
        c1 = color(random(100,220), 255, random(100,220)); //bright inside
        c2 = color(0, random(230,255), 0); //darker at edges
      for (int i=0; i<inputArray.length; i++) {
        float size = inputArray[i][2]*2;

        for(int r = 0; r < size; r++) {
          float n = map(r, 0, size, 0, 0.6f);
          int newc = lerpColor(c1, c2, n);
          stroke(newc,opacity);
          rect(inputArray[i][0]-(size/2), inputArray[i][1]-(size/2) , r, r);
        }
      }
    }
    
    //mimicing the blue leds -sqaure
    if (cTest == color(0,0,255)) {
        c1 = color(random(100,220), random(100,220), 255); //bright inside
        c2 = color(0, 0, random(230,255)); //darker at edges

      for (int i=0; i<inputArray.length; i++) {
        float size = inputArray[i][2]*2; //size

        for(int r = 0; r < size; r++) {
          float n = map(r, 0, size, 0, 0.6f);
          int newc = lerpColor(c1, c2, n);
          stroke(newc,opacity);
          rect(inputArray[i][0]-(size/2), inputArray[i][1]-(size/2) , r, r);
        }
      }
    }
     
  }
  
  public void pushSquares(int finalOpacity) {
    strokeWeight(1);
    noFill();
    rectMode(CORNER);
    drawMimicSquares(dsRed.data, color(255,0,0),finalOpacity);
    drawMimicSquares(dsGreen.data, color(0,255,0),finalOpacity);
    drawMimicSquares(dsBlue.data, color(0,0,255),finalOpacity);  
  }
  
  
}
/*
|:|:|:|:|:|:|:|:|:|:|:|:|:|:|:|:|:|
 percentage of colors data-viz-ed  
    as rects and/or stripes
|:|:|:|:|:|:|:|:|:|:|:|:|:|:|:|:|:|
*/

/*
TO-DO
- the whole "not being able to use background()"
  while in "stripes" mode is an issue
  - will have to careful manage when and where background refresh can be used
*/

class VisualPercent {
 // float[][] r,g,b;
  int totalCircles = 0;
  int h = 0;
  float redEase;
  float greenEase;
  float easing = 0.2f;
  int stripesHeight = 2;
  
  VisualPercent() {
  }
  
  public void calc(float[][] r, float[][] g, float[][] b, int opacity, String mode) {
    totalCircles = r.length + g.length + b.length;
    //println( "total: "+ totalCircles );
  
    noStroke();
    //fixes issue caused by -- pc.displayPrompt(width/2,100);
    rectMode(CORNER);
    
    if (totalCircles>0) {
      // found the bug! for some reason the lines below need
      // the float cast inside ??  
      float redArea = ((float)r.length/totalCircles) * width;
      float greenArea = ((float)g.length/totalCircles) * width;
      
      // println("red length: "+ r.length + " of "+ totalCircles);
       
      if (mode=="full") {
        ////_______red-end & green-start eases
        float targetRed = redArea;
        float rX = targetRed - redEase;
        redEase += rX * easing;
        constrain(redEase,0,width);
        
        ////______green-end & blue-start eases
        float targetGreen = greenArea;
        float gX = targetGreen - greenEase;
        greenEase += gX * easing;
        constrain(greenEase,0,width);
        //println("red ease:"+redEase + " green ease:"+greenEase);
        //println(width);
      
        fill(255,0,0,opacity);
        rect(0,0,redEase,height);
  
        fill(0,255,0,opacity);
        rect(redEase,0,greenEase,height);
  
        fill(0,0,255,opacity);
        rect(redEase+greenEase,0,width,height);
        
        // //__**__**__**________ non-eased version
        //fill(255,0,0,opacity);
        //rect(0,0,redArea,height);
        ////println("redArea:"+redArea +"\n");
        
        //fill(0,255,0,opacity);
        //rect(redArea,0,greenArea,height);
        
        //fill(0,0,255,opacity);
        //rect(redArea+greenArea,0,width,height);
      }
      
      if (mode=="stripes") {
        fill(255,0,0,opacity);
        rect(0,h,redArea,stripesHeight);
        
        fill(0,255,0,opacity);
        rect(redArea,h,greenArea,stripesHeight);
        
        fill(0,0,255,opacity);
        rect(redArea+greenArea,h,width,stripesHeight);
      }
      
    }//end if totalCircles>0
    
    if(mode=="stripes" && totalCircles==0) {
      //fill with black stripe
      fill(0,0,0,opacity);
      rect(0,h,width,stripesHeight);
    }
    if (mode=="stripes") {
      //increment height counter
      h+=stripesHeight;
      // draw opacity over the screen
      fill(0,0,0,1); // 5
      rect(0,0,width,height);
      if( h>height-stripesHeight) {
        // reset vertical position counter
        h=0;
      }
    }
      
  }
  
  public void pushToScreen(int opac, String screenMode) {
    calc(dsRed.data,dsGreen.data,dsBlue.data, opac, screenMode);
    //printTotals(dsRed.data,dsGreen.data,dsBlue.data);
  }
  
}

// Sd keep commenting out this tab for time being


//ControlP5 cp5;
//Range redRangeHue,redRangeSat,redRangeVal, greenRangeHue,greenRangeSat,greenRangeVal, blueRangeHue,blueRangeSat,blueRangeVal;
//Range redRangeHue2, redRangeSat2, redRangeVal2;
//Numberbox dp,minDist,cannyHigh,cannyLow,minSize,maxSize;

////initial slider values
//int rHueMin = 0;   int rHueMax = 10;
//int rSatMin = 75; int rSatMax = 255;
//int rValMin = 75; int rValMax = 255;

//int r2HueMin = 160; int r2HueMax = 179;
//int r2SatMin = 75; int r2SatMax = 255;
//int r2ValMin = 75; int r2ValMax = 255;

//int gHueMin = 35;  int gHueMax = 85;
//int gSatMin = 75; int gSatMax = 255;
//int gValMin = 75; int gValMax = 255;

//int bHueMin = 100; int bHueMax = 135;
//int bSatMin = 75; int bSatMax = 255;
//int bValMin = 75; int bValMax = 255;


////draw text depending upon the case and state
//void guiText(color c, boolean state, char theCase) {
//  if(state) {
//    fill(c);
//    text("fR: "+frameRate,50,height-310);
//    text("HoughCircles params",290,height-70);

//    switch(theCase) {
//      case '`':
//        text("video: SRC", 50, height-290);
//        break;
//      case '1':
//        text("video: R&G&B", 50, height-290);
//        break;
//      case '2':
//        text("video: RED FILTERED", 50, height-290);
//        break;
//      case '3':
//        text("video: GREEN FILTERED", 50, height-290);
//        break;
//      case '4':
//        text("video: BLUE FILTERED", 50, height-290);
//        break;
//      case '0':
//        text("video: HIDE", 50, height-290);
//        break;
//    }
//  }
//}

////~*~*~*~*~*~*~*~*~ update slider values
//void redRangeHue() {
//  rHueMin = round(redRangeHue.getLowValue());
//  rHueMax = round(redRangeHue.getHighValue());
//}
//void redRangeSat() {
//  rSatMin = round(redRangeSat.getLowValue());
//  rSatMax = round(redRangeSat.getHighValue());
//}
//void redRangeVal() {
//  rValMin = round(redRangeVal.getLowValue());
//  rValMax = round(redRangeVal.getHighValue());
//}

//void redRangeHue2() {
//  r2HueMin = round(redRangeHue2.getLowValue());
//  r2HueMax = round(redRangeHue2.getHighValue());
//}
//void redRangeSat2() {
//  r2SatMin = round(redRangeSat2.getLowValue());
//  r2SatMax = round(redRangeSat2.getHighValue());
//}
//void redRangeVal2() {
//  r2ValMin = round(redRangeVal2.getLowValue());
//  r2ValMax = round(redRangeVal2.getHighValue());
//}

//void greenRangeHue() {
//  gHueMin = round(greenRangeHue.getLowValue());
//  gHueMax = round(greenRangeHue.getHighValue());
//}
//void greenRangeSat() {
//  gSatMin = round(greenRangeSat.getLowValue());
//  gSatMax = round(greenRangeSat.getHighValue());
//}
//void greenRangeVal() {
//  gValMin = round(greenRangeVal.getLowValue());
//  gValMax = round(greenRangeVal.getHighValue());
//}

//void blueRangeHue() {
//  bHueMin = round(blueRangeHue.getLowValue());
//  bHueMax = round(blueRangeHue.getHighValue());
//}
//void blueRangeSat() {
//  bSatMin = round(blueRangeSat.getLowValue());
//  bSatMax = round(blueRangeSat.getHighValue());
//}
//void blueRangeVal() {
//  bValMin = round(blueRangeVal.getLowValue());
//  bValMax = round(blueRangeVal.getHighValue());
//}


////toggle gui visibilities and color
//void morphTog(boolean theFlag) {
//  if (theFlag) {
//    cp5.getController("morphTog").setColorActive(color(15,255,80));
//  }else{
//    cp5.getController("morphTog").setColorActive(color(255,15,80));
//  }
//}



////initialize all the gui elements
//void loadGUI() {
//  cp5 = new ControlP5(this);
//  redRangeHue = cp5.addRange("redRangeHue")
//       // disable broadcasting since setRange and setRangeValues will trigger an event
//       .setBroadcast(false) 
//       .setPosition(50,height-270)
//       .setSize(200,20)
//       .setHandleSize(10)
//       .setRange(0,179)
//       .setRangeValues(rHueMin,rHueMax)
//       // after the initialization we turn broadcast back on again
//       .setBroadcast(true)
//       .setColorForeground(color(255,80,15))
//       .setColorBackground(color(255,80,15,40))
//       .setColorValueLabel(255)
//       .setCaptionLabel("Hue");
//       //redRangeHue.getCaptionLabel().toUpperCase(false);
                     
//  redRangeSat = cp5.addRange("redRangeSat")
//       // disable broadcasting since setRange and setRangeValues will trigger an event
//       .setBroadcast(false) 
//       .setPosition(50,height-240)
//       .setSize(200,20)
//       .setHandleSize(10)
//       .setRange(0,255)
//       .setRangeValues(rSatMin,rSatMax)
//       // after the initialization we turn broadcast back on again
//       .setBroadcast(true)
//       .setColorForeground(color(255,80,80))
//       .setColorBackground(color(255,0,0,40))
//       .setColorValueLabel(255)
//       .setCaptionLabel("Sat");
             
//  redRangeVal = cp5.addRange("redRangeVal")
//       // disable broadcasting since setRange and setRangeValues will trigger an event
//       .setBroadcast(false) 
//       .setPosition(50,height-210)
//       .setSize(200,20)
//       .setHandleSize(10)
//       .setRange(0,255)
//       .setRangeValues(rValMin,rValMax)
//       // after the initialization we turn broadcast back on again
//       .setBroadcast(true)
//       .setColorForeground(color(255,80,80))
//       .setColorBackground(color(255,0,0,40))
//       .setColorValueLabel(255)
//       .setCaptionLabel("Val");
                       
//  greenRangeHue = cp5.addRange("greenRangeHue")
//       // disable broadcasting since setRange and setRangeValues will trigger an event
//       .setBroadcast(false) 
//       .setPosition(50,height-180)
//       .setSize(200,20)
//       .setHandleSize(10)
//       .setRange(0,179)
//       .setRangeValues(gHueMin,gHueMax)
//       // after the initialization we turn broadcast back on again
//       .setBroadcast(true)
//       .setColorForeground(color(80,255,80))
//       .setColorBackground(color(255,0,0,40))
//       .setColorValueLabel(255)
//       .setCaptionLabel("Hue");
             
//  greenRangeSat = cp5.addRange("greenRangeSat")
//       // disable broadcasting since setRange and setRangeValues will trigger an event
//       .setBroadcast(false) 
//       .setPosition(50,height-150)
//       .setSize(200,20)
//       .setHandleSize(10)
//       .setRange(0,255)
//       .setRangeValues(gSatMin,gSatMax)
//       // after the initialization we turn broadcast back on again
//       .setBroadcast(true)
//       .setColorForeground(color(80,255,80))
//       .setColorBackground(color(255,0,0,40))
//       .setColorValueLabel(255)
//       .setCaptionLabel("Sat");
             
//  greenRangeVal = cp5.addRange("greenRangeVal")
//       // disable broadcasting since setRange and setRangeValues will trigger an event
//       .setBroadcast(false) 
//       .setPosition(50,height-120)
//       .setSize(200,20)
//       .setHandleSize(10)
//       .setRange(0,255)
//       .setRangeValues(gValMin,gValMax)
//       // after the initialization we turn broadcast back on again
//       .setBroadcast(true)
//       .setColorForeground(color(80,255,80))
//       .setColorBackground(color(255,0,0,40))
//       .setColorValueLabel(255)
//       .setCaptionLabel("Val");

//  blueRangeHue = cp5.addRange("blueRangeHue")
//       // disable broadcasting since setRange and setRangeValues will trigger an event
//       .setBroadcast(false) 
//       .setPosition(50,height-90)
//       .setSize(200,20)
//       .setHandleSize(10)
//       .setRange(0,179)
//       .setRangeValues(bHueMin,bHueMax)
//       // after the initialization we turn broadcast back on again
//       .setBroadcast(true)
//       .setColorForeground(color(80,80,255))
//       .setColorBackground(color(255,0,0,40))
//       .setColorValueLabel(255)
//       .setCaptionLabel("Hue");
             
//  blueRangeSat = cp5.addRange("blueRangeSat")
//       // disable broadcasting since setRange and setRangeValues will trigger an event
//       .setBroadcast(false) 
//       .setPosition(50,height-60)
//       .setSize(200,20)
//       .setHandleSize(10)
//       .setRange(0,255)
//       .setRangeValues(bSatMin,bSatMax)
//       // after the initialization we turn broadcast back on again
//       .setBroadcast(true)
//       .setColorForeground(color(80,80,255))
//       .setColorBackground(color(255,0,0,40))
//       .setColorValueLabel(255)
//       .setCaptionLabel("Sat");
             
//  blueRangeVal = cp5.addRange("blueRangeVal")
//       // disable broadcasting since setRange and setRangeValues will trigger an event
//       .setBroadcast(false) 
//       .setPosition(50,height-30)
//       .setSize(200,20)
//       .setHandleSize(10)
//       .setRange(0,255)
//       .setRangeValues(bValMin,bValMax)
//       // after the initialization we turn broadcast back on again
//       .setBroadcast(true)
//       .setColorForeground(color(80,80,255))
//       .setColorBackground(color(255,0,0,40))
//       .setColorValueLabel(255)
//       .setCaptionLabel("Val");
             
//  //these sliders are for the higher HSB red values (150-179)
//  redRangeHue2 = cp5.addRange("redRangeHue2")
//       // disable broadcasting since setRange and setRangeValues will trigger an event
//       .setBroadcast(false) 
//       .setPosition(290,height-270)
//       .setSize(200,20)
//       .setHandleSize(10)
//       .setRange(150,179)
//       .setRangeValues(r2HueMin,r2HueMax)
//       // after the initialization we turn broadcast back on again
//       .setBroadcast(true)
//       .setColorForeground(color(255,15,80))
//       .setColorBackground(color(255,15,80,40))
//       .setColorValueLabel(255)
//       .setCaptionLabel("Hue 2");
     
//  redRangeSat2 = cp5.addRange("redRangeSat2")
//       // disable broadcasting since setRange and setRangeValues will trigger an event
//       .setBroadcast(false) 
//       .setPosition(290,height-240)
//       .setSize(200,20)
//       .setHandleSize(10)
//       .setRange(0,255)
//       .setRangeValues(r2SatMin,r2SatMax)
//       // after the initialization we turn broadcast back on again
//       .setBroadcast(true)
//       .setColorForeground(color(255,15,80))
//       .setColorBackground(color(255,15,80,40))
//       .setColorValueLabel(255)
//       .setCaptionLabel("Sat 2");
       
//  redRangeVal2 = cp5.addRange("redRangeVal2")
//       // disable broadcasting since setRange and setRangeValues will trigger an event
//       .setBroadcast(false) 
//       .setPosition(290,height-210)
//       .setSize(200,20)
//       .setHandleSize(10)
//       .setRange(0,255)
//       .setRangeValues(r2ValMin,r2ValMax)
//       // after the initialization we turn broadcast back on again
//       .setBroadcast(true)
//       .setColorForeground(color(255,15,80))
//       .setColorBackground(color(255,15,80,40))
//       .setColorValueLabel(255)
//       .setCaptionLabel("Val 2");
       
//    cp5.addToggle("morphTog")
//       .setPosition(290,height-150)
//       .setSize(50,20)
//       .setBroadcast(false)
//       .setValue(false)
//       .setBroadcast(true)
//       .setMode(ControlP5.SWITCH)
//       .setColorActive(color(255,15,80))
//       .setColorBackground(color(255));

//// Circle detect numberboxes
//  dp = cp5.addNumberbox("dp")
//   .setPosition(290,height-60)
//   .setSize(45,20)
//   .setRange(1,6)
//   .setValue(2)
//   .setColorForeground(color(255,0,0))
//   .setColorActive(color(255,0,0,125))
//   .setColorBackground(color(255,255,255))
//   .setColorValueLabel(255)
//   .setScrollSensitivity(0.1)
//   .setDirection(Controller.HORIZONTAL)
//   .setCaptionLabel("Rez");
//     dp.getCaptionLabel().toUpperCase(false);
     
//  minDist = cp5.addNumberbox("minDist")
//   .setPosition(350,height-60)
//   .setSize(45,20)
//   .setRange(1,100)
//   .setValue(30)
//   .setColorForeground(color(255,0,0))
//   .setColorActive(color(255,0,0,125))
//   .setColorBackground(color(255,255,255))
//   .setColorValueLabel(255)
//   .setScrollSensitivity(0.2)
//   .setDirection(Controller.HORIZONTAL);
//     minDist.getCaptionLabel().toUpperCase(false);

// cannyHigh = cp5.addNumberbox("cannyHigh")
//   .setPosition(410,height-60)
//   .setSize(45,20)
//   .setRange(1,500)
//   .setValue(50)
//   .setColorForeground(color(255,0,0))
//   .setColorActive(color(255,0,0,125))
//   .setColorBackground(color(255,255,255))
//   .setColorValueLabel(255)
//   .setScrollSensitivity(0.2)
//   .setDirection(Controller.HORIZONTAL);
//     cannyHigh.getCaptionLabel().toUpperCase(false);
     
//  cannyLow = cp5.addNumberbox("cannyLow")
//   .setPosition(470,height-60)
//   .setSize(45,20)
//   .setRange(1,500)
//   .setValue(19)
//   .setColorForeground(color(255,0,0))
//   .setColorActive(color(255,0,0,125))
//   .setColorBackground(color(255,255,255))
//   .setColorValueLabel(255)
//   .setScrollSensitivity(0.2)
//  .setDirection(Controller.HORIZONTAL);
//     cannyLow.getCaptionLabel().toUpperCase(false);
    
//  minSize = cp5.addNumberbox("minSize")
//   .setPosition(530,height-60)
//   .setSize(45,20)
//   .setRange(1,500)
//   .setValue(5)
//   .setColorForeground(color(255,0,0))
//   .setColorActive(color(255,0,0,125))
//   .setColorBackground(color(255,255,255))
//   .setColorValueLabel(255)
//   .setScrollSensitivity(0.2)
//   .setDirection(Controller.HORIZONTAL);
//     minSize.getCaptionLabel().toUpperCase(false);
     
//  maxSize = cp5.addNumberbox("maxSize")
//   .setPosition(590,height-60)
//   .setSize(45,20)
//   .setRange(5,200)
//   .setValue(35)
//   .setColorForeground(color(255,0,0))
//   .setColorActive(color(255,0,0,125))
//   .setColorBackground(color(255,255,255))
//   .setColorValueLabel(255)
//   .setScrollSensitivity(0.2)
//   .setDirection(Controller.HORIZONTAL);
//     maxSize.getCaptionLabel().toUpperCase(false);
//}
 

/////////////////////////////////////////////////////////////////////////////////// 
/*
Code for loading, controlling and displaying the Prompt features
Also Includes the JSON load and save functions


*/

 
     
  class promptVisControl{
      JSONArray jwords,jvis;
     // JSONArray values;
      int queBothNum =0;
      public int bothNum;
      int queVisNum =0;
      public int visNum;
      int wlen,vlen;
      String prompt = " ";
      public String currPrompt = "";
      public String nextPrompt = "";
      public String currVis = "";
      public String nextVis = "";    
      public boolean pvis = false;
    
       //Constructor
      promptVisControl() {      
        loadJson();  
        //queBoth(queBothNum);
        
      }
     
          
          
     public void queBothForward() {
        if (queBothNum < wlen-1 ) {
         queBothNum++;
        } else {
         queBothNum = 0;
        }
         queBoth(queBothNum);
      }
          
      public void queBothBack() {   
        if (queBothNum > 0 ) {
          queBothNum--;
        } else {
          queBothNum = wlen-1;
        }
        queBoth(queBothNum);
      }
      
      
      public void queVisForward() {
        if (queVisNum < vlen-1 ) {
         queVisNum++;
        } else {
         queVisNum = 1;
        }
         queVis(queVisNum);
      }
          
      public void queVisBack() {   
        if (queVisNum > 1 ) {
          queVisNum--;
        } else {
          queVisNum = vlen-1;
        }
        queVis(queVisNum);
      }
    
    
          
      public void queBoth(int num) {
        JSONObject session = jwords.getJSONObject(num); 
        queVisNum =num;
        int id = session.getInt("id");
         nextPrompt = session.getString("prompt");
         nextVis = session.getString("visual");
        println(id + ", QueBoth " + nextPrompt + ", " + nextVis);  
        objui.promptTxt.setText(nextPrompt + "\n" + nextVis);
        objui.visualTxt.setText(nextVis);
        //sendPromptVisToUi();      
      }
      
       public void queVis(int num) {
        JSONObject session = jvis.getJSONObject(num); 
        int id = session.getInt("id");
         nextVis = session.getString("visual");
        println(id + ", QueVis " + nextVis); 
        objui.visualTxt.setText(nextVis);
       
        //sendVisToUi();      
      }
           
      public void sendPromptVisToUi() {
          
          println("sendPrompt  ==>" + nextPrompt);  
      }
      
      public void sendVisToUi() {
        // objui.currPromptTxt.setText(nextVis);
          println("sendPrompt  ==>" + nextVis);   
      }
           
      public void loadBoth() {     
         currPrompt = nextPrompt; 
         println("loadBoth " + currPrompt);
         currVis = nextVis;
         bothNum = queBothNum;
         visNum = queVisNum;
         pvis = true;
         objui.currPromptTxt.setText(currPrompt);
         objui.currVisualTxt.setText(currVis);
      }
      
      public void loadVis() {     
         currVis = nextVis;
          println("loadVis " + currVis);
           println("The vizNum " + queVisNum);
         visNum = queVisNum;
         objui.currVisualTxt.setText(currVis);
      }
         
      public void togglePrompt() {
         pvis = !pvis;
      }
      
      
      /* 
      -- Be aware that these rectMode and maybe textAlign functions 
      -- will influence any other drawings that follow it
      -- unless explicitly reset to the default rectMode(CORNER)... etc
      */
      public void displayPrompt(int x, int y, int opacity) {
        //the font to use
        textFont(helvBold60,60);
        
      // if (currPrompt != "Blank") { 
        if (pvis) {       
          //String currPrompt = "hi";
         // println("testOPac  --- " + opacity);
          noStroke();
          textSize(60);
          pushMatrix();
          translate(x,y);
          fill(20,30);
          rectMode(CENTER);
         // rect(0,0,500,100);
          rectMode(LEFT);
          fill(255,opacity);
         // fill(255);
          textAlign(CENTER);
          //text(currPrompt,0,15);
          
          //text(objui.cp5.get(Textfield.class,"promptInput").getText(), 0,15);  
         text(globalPromptText, 0,15);
          
          //text("",0,15);
          textAlign(LEFT);
          popMatrix();        
        }
     //  }
     
       //println("OO --" + opacity);
      }
      
      
      
      public void reloadJson() {
        loadJson();   
      }
     
    
       public void loadJson() {
        jwords = loadJSONArray("data/words.json");
        wlen = jwords.size();      
        jvis = loadJSONArray("data/vis.json");
        vlen = jvis.size();
        
    //   println("Hey -----" + vlen);
      
       }
        
      public void saveJason() {         
         saveJSONArray(jwords, "data/words.json");
         saveJSONArray(jvis, "data/vis.json");
               
      }
           
  }   // END OF CLASS promptControl

/*
// Puddle Class that runs the visual birthes/destroys Rip objects
//  The Rip class has moving and flocking methods to move and compare

*/


class Puddle {

  ArrayList orbCollectionR;
  ArrayList orbCollectionG;
  ArrayList orbCollectionB;
  int counter = 0;


  //Constructor
  Puddle() {  
    orbCollectionR = new ArrayList();
    orbCollectionG = new ArrayList();
    orbCollectionB = new ArrayList();
  }

  public void drawPuddles(float[][] inputArray, Mat circleMatrix, int k, ArrayList collection) {

    if ( circleMatrix.rows()>0) {
      //stroke(k);      
      // make sure there is some balls
      if (inputArray.length>1) {

        for (int i=0; i<inputArray.length; i++) {

         // Vec3D origin =  new Vec3D(random(width), random(200), 0);  
          
          Vec3D origin =  new Vec3D(inputArray[i][0],inputArray[i][1], 0); 
          Rip curRip =  new Rip(origin, this, collection, k); 
          collection.add(curRip);
          
          //curOrb.run();
        }

        for (int i = collection.size() - 1; i >= 0; i--) {
          
          Rip curRip = (Rip) collection.get(i);
          
          if (curRip.finished()) {
            collection.remove(i);
          }
        }


       //println("--" + collection.size());

        //if (collection.size() > 30 ) {
        //  for (int i=0; i<inputArray.length; i++) {
        //    println("woot");
        //    collection.remove(i);
        //  }
        //}


        for ( int i = 0; i < collection.size(); i++) {
           Rip newRip = (Rip) collection.get(i);
           newRip.run(); 
        }
      }
    }
  }



  public void pushToScreen() {
    // strokeWeight(3);
    noFill();
    drawPuddles(dsRed.data, gbcv.circlesRed, color(255,0,0,90), orbCollectionR);
    drawPuddles(dsGreen.data, gbcv.circlesGreen, color(0,255,0,90), orbCollectionG);
    drawPuddles(dsBlue.data, gbcv.circlesBlue, color(0,0,255,90), orbCollectionB);
    
    if (mainWindowDelay == true) {
      orbCollectionR.clear();
      orbCollectionG.clear();
      orbCollectionB.clear();
    }
    
  }
}

////////////// END OF CLASS PUDDLE ////////////////


////////////////////////////////// Begin Orb  //////////////////


class Rip { 
  //var available for the whole class
  float x = 0;
  float y = 0; 
  float speedX = random(-2.2f);
  float speedY = random(-2.2f);
  Puddle p;
  ArrayList c;
  int k;
  int life = 50;

  Vec3D loc =   new Vec3D(0, 0, 0);
  Vec3D speed = new Vec3D(random(-2, 2), random(-2, 2), 0);
  Vec3D grav =  new Vec3D(0, 0.2f, 0);
  Vec3D acc = new Vec3D();


  //Constructor
  Rip (Vec3D _loc, Puddle _p, ArrayList _c, int _k) {  
    loc = _loc;
    p = _p;
    c = _c;
    k = _k;
  } 

  public void run() {

    //display();
    move();
    bounce();
    //gravity();
    lineBetween();

    flock();
  }


  public void flock() {

    seperate(5);
    cohesion(.001f);
    align(1.0f);
  }


  public void align (float magnitude) {

    Vec3D steer = new Vec3D();
    int count = 0;

    for (int i = 0; i < c.size(); i++ ) {
      Rip other = (Rip) c.get(i);
      float distance = loc.distanceTo(other.loc);

      if ( distance > 0 && distance < 40) {

        steer.addSelf(other.speed);
        count++;
      }
    }

    if ( count > 0 ) {
      steer.scaleSelf(1.0f/count);
    }

    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }


  public void cohesion(float magnitude) {

    Vec3D sum = new Vec3D();
    int count = 0;

    for (int i = 0; i < c.size(); i++ ) {
      Rip other = (Rip) c.get(i);
      float distance = loc.distanceTo(other.loc);

      if ( distance > 0 && distance < 60) {
        sum.addSelf(other.loc);
        count++;
      }
    }

    if ( count > 0) {
      sum.scaleSelf(1.0f/count);
    }
    Vec3D steer = sum.sub(loc);

    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }




  public void seperate(float magnitude) {

    Vec3D steer = new Vec3D();
    int count = 0;

    for (int i = 0; i < c.size(); i++ ) {
      Rip other = (Rip) c.get(i);
      float distance = loc.distanceTo(other.loc);

      if ( distance > 0 && distance < 40) {

        Vec3D diff = loc.sub(other.loc);
        diff.normalizeTo(1.0f/distance);

        steer.addSelf(diff);
        count++;
      }
    }

    if ( count > 0) {
      steer.scaleSelf(1.0f/count);
    }
    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }






  public void lineBetween() {

    //ballCollection

    for (int i = 0; i < c.size(); i++ ) {

      Rip other = (Rip) c.get(i);

      float distance = loc.distanceTo(other.loc);

      if ( distance > 0 && distance < 40) {
        strokeWeight(40/distance);
        stroke(k);
        line(loc.x, loc.y, other.loc.x, other.loc.y);
      }
    }
  }

  public void display() { 
    ellipse(loc.x, loc.y, 10, 10);
  } 
  public void move() {

    speed.addSelf(acc);
    speed.limit(2);

    loc.addSelf(speed);

    acc.clear();
  }

  public void bounce() {

    if ( loc.x > width) {
      speed.x = - speed.x;
    }
    if (loc.x < 0) {
      speed.x = - speed.x;
    }

    if ( loc.y > height+10) {
      speed.y = -speed.y;
    }
    if (loc.y < 0) {
      speed.y = -speed.y;
    }
  }

  public void gravity() {
    speed.addSelf(grav);
  }
  
  
  
  public boolean finished() {
    // Balls fade out
    life--;
    if (life < 0) {
      return true;
    } else {
      return false;
    }
  }
  
  
  
  
} 


//class recVis {
//    JSONArray jdump;
   
//  recVis() {
    
    
    
//  }
  
  
//  void startRecVisSet() {
    
//    jdump = new JSONArray();
    
//    JSONObject session = new JSONObject();
        
//        //  session.setString("prompt", prompts[i]);
//        //  session.setString("visual", visuals[i]);
      
//        //  values.setJSONObject(i, session);
//        //}
    
//  }
  
  
// void  nextRecVect() {
    
//        //  session.setInt("id", i);
//        //  session.setString("prompt", prompts[i]);
//        //  session.setString("visual", visuals[i]);
      
//        //  values.setJSONObject(i, session);
       
    
//  }
  
//  void saveRecVisSet() {
//        String whichVisName = "";
//        String timeStamp = "";
//        String currFile = "data/dump/" + whichVisName + "_" + timeStamp + "_" +  dump.json";
//        //jdump = new JSONArray();
      
//        //for (int i = 0; i < prompts.length; i++) {
      
//        //  JSONObject session = new JSONObject();
//        //  session.setInt("id", i);
//        //  session.setString("prompt", prompts[i]);
//        //  session.setString("visual", visuals[i]);
      
//        //  values.setJSONObject(i, session);
//        //}
      
//        saveJSONArray(values, currFile);
    
//  }
  
  
  
//}
/*
  This has the UI windowing code as well as the 
  P5 Interface Elements 
*/

 
 
 public String UIPrompt ="naz";

// Nested PApplet Class A:
public class sdUI extends PApplet {
    PApplet mainparent;
    
    ControlP5 cp5;
    Range redRangeHue,redRangeSat,redRangeVal, greenRangeHue,greenRangeSat,greenRangeVal, blueRangeHue,blueRangeSat,blueRangeVal;
    Range redRangeHue2, redRangeSat2, redRangeVal2;
    Numberbox dp,minDist,cannyHigh,cannyLow,minSize,maxSize;
    Numberbox maxSticks;

    //sd
    Textarea promptTxt;
    Textarea visualTxt;
    
    Textarea currPromptTxt;
    Textarea currVisualTxt;
          

      
    PFont fontF;
    
        
    //video select button font
    PFont vidButtonFont;
    ControlFont fontV;
    
   
    
    
     public sdUI(PApplet parent){
      this.mainparent = parent;
     
      //super();
      //PApplet.runSketch(new String[]{this.getClass().getName()}, this);
      
      
    }



///////////////////////////////////////////////////////////////////////////////////
///// ALL CONTROL P5 definations below after setup/draw ////
  
  
  public void settings() {
     size(770, 550 );
    
    //smooth(4);
  }
  
  
  public void setup() {
     background(50);
     
    // below textFont gives me an error occasionally
    //textFont(createFont("SansSerif", 24, true));
    
    fontF = createFont("arial",18);
    textAlign(CENTER, CENTER);
    fill(20, 120, 20);
    loadGUI();
    //cp5.show(); // I think this is only necessary if you have hidden cp5
    
    vidButtonFont = createFont("Verdana",10); 
    fontV = new ControlFont(vidButtonFont);
    //cp5.setFont(fontV); only way to change numberbox font but overrides all other font settings
    
    updateCurrentVideoBtns();
   
    // checkVideoOptions();
    
  }
  
  
  public void updateCurrentVideoBtns() {
    
    // retrieve 2 arrays of data
    // cameras and videopaths
    
    for (int i=0; i < cameraFound.size(); i++) {
        
        //regex to select only cameras that are 1280x720
        String[] matched = match(cameraFound.get(i), "size=1280x720,fps=30");
        
        if(matched != null) {
          cp5.addButton(cameraFound.get(i))
          .onPress(btnAction)
          .setValue(0)
          .setPosition(50,i*40 +380)
          .setSize(300,30)
          .getCaptionLabel().toUpperCase(false)
          .setFont(fontV)
          ;
          //camButtonY+=40;
        }
        
      }
      
       int i = 0; 
  for (int x=0; x<videoPaths.size();x++) {
    //println(videoPaths.get(x));
    cp5.addButton( videoPaths.get(x) )
    .onPress(btnAction2)
    .setValue(0)
    .setPosition(400,(380)+40*i)
    .setSize(300,30)
    .getCaptionLabel().toUpperCase(false)
    .setFont(fontV)
    ;
    i++;
  }
    
    
  }
  
  
  
  
  
  
  
 public void draw() {
    background(50);
    textSize(16);
    textLeading(16);
    stroke(255);
  //  guiText(color(255), true, '`'); // just testing this here, the global variable don't reach this :(
    guiText(color(255), guiVisibility, whichVideo);
    
   //promptTxt.setText(UIPrompt);
  }
  
  //////////////////////////// Close Function ( no crashed)
   public void exit() {
    dispose();
    objui = null;
  }
  
  
  
public void keyPressed() {
   //this.mainparent.keyPressed();
 // int k = keyCode; 
  // if (k == ENTER | k == RETURN)  //activateSketch(another);
  
 //  if (k == 'T') mainparent.toggleSketch(this);  // disableSketch(another); 
  //if (k == 'S') saveWords();
  //if (k == 'L') loadWords();
  
 // println(k);
  
  //switch case for video drawing
  //if (key=='`') whichVideo='`'; // src video
  //if (key=='1') whichVideo='1'; // R&G&B filtered
  //if (key=='2') whichVideo='2'; // red filtered
  //if (key=='3') whichVideo='3'; // green filtered
  //if (key=='4') whichVideo='4'; // blue filtered 
  //if (key=='0') whichVideo='0'; // no video (hide video) 
  if(keyCode==32) { 
    //blackTranny.reset();
    println("--win space");
    toggleUiWinVis();
   } //spacebar to reset black fade
  
 
}
  
  
  
  
public void guiText(int c, boolean state, char theCase) {
  //if(state) {
    textAlign(LEFT);
    fill(c);  
    //text("HoughCircles params",360,height-80);
    
    text("Camera Input", 50, 370  );  
    text("Movie Input", 400, 370  );
    
    if(showHideButtons == false) {
      text("Choose an input source:", 185, 340);
    }

   // pushMatrix();
    //translate(540,height-250);
    //text("fR: "+this.mainparent.frameRate,540, 500);
    
    //switch(theCase) {
    //  case '`':
    //    text("video: SRC", 0,30);
    //    break;
    //  case '1':
    //    text("video: R&G&B", 0, 30);
    //    break;
    //  case '2':
    //    text("video: RED FILTERED", 0, 30);
    //    break;
    //  case '3':
    //    text("video: GREEN FILTERED", 0, 30);
    //    break;
    //  case '4':
    //    text("video: BLUE FILTERED", 0, 30);
    //    break;
    //  case '0':
    //    text("video: HIDE", 0, 30);
    //    break;
    //}
    
    //popMatrix();
    
  //}
}

//~*~*~*~*~*~*~*~*~ update cp5 values and store in global variables
public void redRangeHue() {
  rHueMin = round(redRangeHue.getLowValue());
  rHueMax = round(redRangeHue.getHighValue());
}
public void redRangeSat() {
  rSatMin = round(redRangeSat.getLowValue());
  rSatMax = round(redRangeSat.getHighValue());
}
public void redRangeVal() {
  rValMin = round(redRangeVal.getLowValue());
  rValMax = round(redRangeVal.getHighValue());
}

public void redRangeHue2() {
  r2HueMin = round(redRangeHue2.getLowValue());
  r2HueMax = round(redRangeHue2.getHighValue());
}
public void redRangeSat2() {
  r2SatMin = round(redRangeSat2.getLowValue());
  r2SatMax = round(redRangeSat2.getHighValue());
}
public void redRangeVal2() {
  r2ValMin = round(redRangeVal2.getLowValue());
  r2ValMax = round(redRangeVal2.getHighValue());
}

public void greenRangeHue() {
  gHueMin = round(greenRangeHue.getLowValue());
  gHueMax = round(greenRangeHue.getHighValue());
}
public void greenRangeSat() {
  gSatMin = round(greenRangeSat.getLowValue());
  gSatMax = round(greenRangeSat.getHighValue());
}
public void greenRangeVal() {
  gValMin = round(greenRangeVal.getLowValue());
  gValMax = round(greenRangeVal.getHighValue());
}

public void blueRangeHue() {
  bHueMin = round(blueRangeHue.getLowValue());
  bHueMax = round(blueRangeHue.getHighValue());
}
public void blueRangeSat() {
  bSatMin = round(blueRangeSat.getLowValue());
  bSatMax = round(blueRangeSat.getHighValue());
}
public void blueRangeVal() {
  bValMin = round(blueRangeVal.getLowValue());
  bValMax = round(blueRangeVal.getHighValue());
}




// clear button routine
public void Clear() { 
  switch(pc.visNum) {
    case 0: //BT
      break; 
    case 1:  //connect
      mainWindowDelay = true;
      break;
    case 2: //VizPerFull
      mainWindowDelay = true;
      break;
    case 3:  //VizPerStripe
      mainWindowDelay = true;
      break;
    case 4: //growth
      // Steve... add clear routine here
      // GB added clear() to the Class arraylists in Grow tab - line 107
      mainWindowDelay = true;
      break;
    case 5: //Puddles
      // Steve... add clear routine here
      // GB added clear() to class araylists in puddle tab - line 79
      mainWindowDelay = true;
      break;
    case 6: //Particle 
      mainWindowDelay = true;
      ////particles.clear() added to Particle tab - it empties the particle Arraylist
      break;
    case 7: //Buildr 
      mainWindowDelay = true;
      ////particles.clear() added to Particle tab - it empties the particle Arraylist
      break;
    case 8://Video
      mainWindowDelay = true;
      break;
    default:             // Default executes if the case labels
     // println("None");   // don't match the switch parameter
      break;
  }
  
  
}


//initialize all the gui elements
public void loadGUI() {
  cp5 = new ControlP5(this);
   
   //PImage[] for_imgs = {loadImage("data/button_a.png"),loadImage("button_b.png"),loadImage("button_c.png")};
   //PImage[] bak_imgs = {loadImage("data/ba_button_a.png"),loadImage("ba_button_b.png"),loadImage("ba_button_c.png")};

    
redRangeHue = cp5.addRange("redRangeHue")
       // disable broadcasting since setRange and setRangeValues will trigger an event
       .setBroadcast(false) 
       .setPosition(50,height-270)
       .setSize(200,20)
       .setHandleSize(10)
       .setRange(0,179)
       .setRangeValues(rHueMin,rHueMax)
       // after the initialization we turn broadcast back on again
       .setBroadcast(true)
       .setColorForeground(color(255,80,15))
       .setColorBackground(color(255,80,15,40))
       .setColorValueLabel(255)
       .setCaptionLabel("Hue")
       .setVisible(false);
       //redRangeHue.getCaptionLabel().toUpperCase(false);
                     
  redRangeSat = cp5.addRange("redRangeSat")
       // disable broadcasting since setRange and setRangeValues will trigger an event
       .setBroadcast(false) 
       .setPosition(50,height-240)
       .setSize(200,20)
       .setHandleSize(10)
       .setRange(0,255)
       .setRangeValues(rSatMin,rSatMax)
       // after the initialization we turn broadcast back on again
       .setBroadcast(true)
       .setColorForeground(color(255,80,80))
       .setColorBackground(color(255,0,0,40))
       .setColorValueLabel(255)
       .setCaptionLabel("Sat")
       .setVisible(false);
             
  redRangeVal = cp5.addRange("redRangeVal")
       // disable broadcasting since setRange and setRangeValues will trigger an event
       .setBroadcast(false) 
       .setPosition(50,height-210)
       .setSize(200,20)
       .setHandleSize(10)
       .setRange(0,255)
       .setRangeValues(rValMin,rValMax)
       // after the initialization we turn broadcast back on again
       .setBroadcast(true)
       .setColorForeground(color(255,80,80))
       .setColorBackground(color(255,0,0,40))
       .setColorValueLabel(255)
       .setCaptionLabel("Val")
       .setVisible(false);
                       
  greenRangeHue = cp5.addRange("greenRangeHue")
       // disable broadcasting since setRange and setRangeValues will trigger an event
       .setBroadcast(false) 
       .setPosition(50,height-180)
       .setSize(200,20)
       .setHandleSize(10)
       .setRange(0,179)
       .setRangeValues(gHueMin,gHueMax)
       // after the initialization we turn broadcast back on again
       .setBroadcast(true)
       .setColorForeground(color(80,255,80))
       .setColorBackground(color(255,0,0,40))
       .setColorValueLabel(255)
       .setCaptionLabel("Hue")
       .setVisible(false);
             
  greenRangeSat = cp5.addRange("greenRangeSat")
       // disable broadcasting since setRange and setRangeValues will trigger an event
       .setBroadcast(false) 
       .setPosition(50,height-150)
       .setSize(200,20)
       .setHandleSize(10)
       .setRange(0,255)
       .setRangeValues(gSatMin,gSatMax)
       // after the initialization we turn broadcast back on again
       .setBroadcast(true)
       .setColorForeground(color(80,255,80))
       .setColorBackground(color(255,0,0,40))
       .setColorValueLabel(255)
       .setCaptionLabel("Sat")
       .setVisible(false);
             
  greenRangeVal = cp5.addRange("greenRangeVal")
       // disable broadcasting since setRange and setRangeValues will trigger an event
       .setBroadcast(false) 
       .setPosition(50,height-120)
       .setSize(200,20)
       .setHandleSize(10)
       .setRange(0,255)
       .setRangeValues(gValMin,gValMax)
       // after the initialization we turn broadcast back on again
       .setBroadcast(true)
       .setColorForeground(color(80,255,80))
       .setColorBackground(color(255,0,0,40))
       .setColorValueLabel(255)
       .setCaptionLabel("Val")
       .setVisible(false);

  blueRangeHue = cp5.addRange("blueRangeHue")
       // disable broadcasting since setRange and setRangeValues will trigger an event
       .setBroadcast(false) 
       .setPosition(50,height-90)
       .setSize(200,20)
       .setHandleSize(10)
       .setRange(0,179)
       .setRangeValues(bHueMin,bHueMax)
       // after the initialization we turn broadcast back on again
       .setBroadcast(true)
       .setColorForeground(color(80,80,255))
       .setColorBackground(color(255,0,0,40))
       .setColorValueLabel(255)
       .setCaptionLabel("Hue")
       .setVisible(false);
             
  blueRangeSat = cp5.addRange("blueRangeSat")
       // disable broadcasting since setRange and setRangeValues will trigger an event
       .setBroadcast(false) 
       .setPosition(50,height-60)
       .setSize(200,20)
       .setHandleSize(10)
       .setRange(0,255)
       .setRangeValues(bSatMin,bSatMax)
       // after the initialization we turn broadcast back on again
       .setBroadcast(true)
       .setColorForeground(color(80,80,255))
       .setColorBackground(color(255,0,0,40))
       .setColorValueLabel(255)
       .setCaptionLabel("Sat")
       .setVisible(false);
             
  blueRangeVal = cp5.addRange("blueRangeVal")
       // disable broadcasting since setRange and setRangeValues will trigger an event
       .setBroadcast(false) 
       .setPosition(50,height-30)
       .setSize(200,20)
       .setHandleSize(10)
       .setRange(0,255)
       .setRangeValues(bValMin,bValMax)
       // after the initialization we turn broadcast back on again
       .setBroadcast(true)
       .setColorForeground(color(80,80,255))
       .setColorBackground(color(255,0,0,40))
       .setColorValueLabel(255)
       .setCaptionLabel("Val")
       .setVisible(false);
  
 //these sliders are for the higher HSB red values (150-179)           
  redRangeHue2 = cp5.addRange("redRangeHue2")
       // disable broadcasting since setRange and setRangeValues will trigger an event
       .setBroadcast(false) 
       .setPosition(290,height-270)
       .setSize(200,20)
       .setHandleSize(10)
       .setRange(150,179)
       .setRangeValues(r2HueMin,r2HueMax)
       // after the initialization we turn broadcast back on again
       .setBroadcast(true)
       .setColorForeground(color(255,15,80))
       .setColorBackground(color(255,15,80,40))
       .setColorValueLabel(255)
       .setCaptionLabel("Hue 2")
       .setVisible(false);
       
  redRangeSat2 = cp5.addRange("redRangeSat2")
       // disable broadcasting since setRange and setRangeValues will trigger an event
       .setBroadcast(false) 
       .setPosition(290,height-240)
       .setSize(200,20)
       .setHandleSize(10)
       .setRange(0,255)
       .setRangeValues(r2SatMin,r2SatMax)
       // after the initialization we turn broadcast back on again
       .setBroadcast(true)
       .setColorForeground(color(255,15,80))
       .setColorBackground(color(255,15,80,40))
       .setColorValueLabel(255)
       .setCaptionLabel("Sat 2")
       .setVisible(false);
       
  redRangeVal2 = cp5.addRange("redRangeVal2")
       // disable broadcasting since setRange and setRangeValues will trigger an event
       .setBroadcast(false) 
       .setPosition(290,height-210)
       .setSize(200,20)
       .setHandleSize(10)
       .setRange(0,255)
       .setRangeValues(r2ValMin,r2ValMax)
       // after the initialization we turn broadcast back on again
       .setBroadcast(true)
       .setColorForeground(color(255,15,80))
       .setColorBackground(color(255,15,80,40))
       .setColorValueLabel(255)
       .setCaptionLabel("Val 2")
       .setVisible(false);
       

// Circle detect numberboxes
  dp = cp5.addNumberbox("dp")
   .setPosition(290,height-60)
   .setSize(45,20)
   .setRange(1,6)
   .setValue(dpVal)
   //.setColorForeground(color(255,0,0))
   //.setColorActive(color(255,0,0,125))
   .setColorBackground(color(255,255,255))
   .setColorValueLabel(255)
   .setScrollSensitivity(0.1f)
   .setDirection(Controller.HORIZONTAL)
   .setCaptionLabel("Rez")
   .setVisible(false);
     dp.getCaptionLabel().toUpperCase(false);
     
  minDist = cp5.addNumberbox("minDist")
   .setPosition(350,height-60)
   .setSize(45,20)
   .setRange(1,100)
   .setValue(minDistVal)
   //.setColorForeground(color(255,0,0))
   //.setColorActive(color(255,0,0,125))
   .setColorBackground(color(255,255,255))
   .setColorValueLabel(255)
   .setScrollSensitivity(0.2f)
   .setDirection(Controller.HORIZONTAL)
   .setVisible(false);
     minDist.getCaptionLabel().toUpperCase(false);

 cannyHigh = cp5.addNumberbox("cannyHigh")
   .setPosition(410,height-60)
   .setSize(45,20)
   .setRange(1,500)
   .setValue(cannyHighVal)
   //.setColorForeground(color(255,0,0))
   //.setColorActive(color(255,0,0,125))
   .setColorBackground(color(255,255,255))
   .setColorValueLabel(255)
   .setScrollSensitivity(0.2f)
   .setDirection(Controller.HORIZONTAL)
   .setVisible(false);
     cannyHigh.getCaptionLabel().toUpperCase(false);
     
  cannyLow = cp5.addNumberbox("cannyLow")
   .setPosition(470,height-60)
   .setSize(45,20)
   .setRange(1,500)
   .setValue(cannyLowVal)
   //.setColorForeground(color(255,0,0))
   //.setColorActive(color(255,0,0,125))
   .setColorBackground(color(255,255,255))
   .setColorValueLabel(255)
   .setScrollSensitivity(0.2f)
  .setDirection(Controller.HORIZONTAL)
  .setVisible(false);
     cannyLow.getCaptionLabel().toUpperCase(false);
     
  minSize = cp5.addNumberbox("minSize")
   .setPosition(530,height-60)
   .setSize(45,20)
   .setRange(1,500)
   .setValue(minSizeVal)
   //.setColorForeground(color(255,0,0))
   //.setColorActive(color(255,0,0,125))
   .setColorBackground(color(255,255,255))
   .setColorValueLabel(255)
   .setScrollSensitivity(0.2f)
   .setDirection(Controller.HORIZONTAL)
   .setVisible(false);
     minSize.getCaptionLabel().toUpperCase(false);
     
  maxSize = cp5.addNumberbox("maxSize")
   .setPosition(590,height-60)
   .setSize(45,20)
   .setRange(5,200)
   .setValue(maxSizeVal)
  // .setColorForeground(color(255,0,0))
 //  .setColorActive(color(255,0,0,125))
   .setColorBackground(color(255,255,255))
   .setColorValueLabel(255)
   .setScrollSensitivity(0.2f)
   .setDirection(Controller.HORIZONTAL)
   .setVisible(false);
     maxSize.getCaptionLabel().toUpperCase(false);

// other ui elements     
     
   cp5.addButton("HoughCalibrate")
     .setPosition(650,height-60)
     .setSize(45,20)
     //.setFont(createFont("arial",22))
     .setColorBackground(color(0,150,180))
     .setColorForeground(color(180))
     .setCaptionLabel("Calib")
     .setVisible(false)
     ;
   
      
  
 /////////////////////////////// Main Prompt Vis Controls 
  int localx = 20;
  int localy = -70;
  
  promptTxt = cp5.addTextarea("promptTxt")
            .setPosition(localx+50,localy+20)
            .setSize(210,50)
            .setFont(createFont("arial",22))
            .setColor(color(255))
            .setColorBackground(color(80))
            .setColorForeground(color(255))
            .setVisible(false);
            
 promptTxt.setText("The Prompt");      
          
  // buttons with images for Prompt 
  cp5.addButton("prompt_for")
     .setPosition(localx+260,localy+20)
     .setImages(for_imgs)
     .updateSize()
     .setVisible(false);
     
  cp5.addButton("prompt_bak")
     .setPosition(localx,localy+20)
     .setImages(bak_imgs)
     .updateSize()
     .setVisible(false);
         
 visualTxt = cp5.addTextarea("visTxt")
            .setPosition(localx+50,localy+100)
            .setSize(210,50)
            .setFont(createFont("arial",22))
            .setColor(color(255))
            .setColorBackground(color(80))
            .setColorForeground(color(255))
            .setVisible(showHideButtons);
            
  visualTxt.setText("The Vis");   
  
   // buttons with images for Vis 
  cp5.addButton("vis_for")
     .setPosition(localx+260,localy+100)
     .setImages(for_imgs)
     .updateSize()
     .setVisible(showHideButtons);
     
  cp5.addButton("vis_bak")
     .setPosition(localx,localy+100)
     .setImages(bak_imgs)
     .updateSize()
     .setVisible(showHideButtons);
     
  currPromptTxt = cp5.addTextarea("cPromptTxt")
        .setPosition(localx+525,localy+20)
        .setSize(200,50)
        .setFont(createFont("arial",22))
        .setColor(color(255))
        .setColorBackground(color(80))
        .setColorForeground(color(255))
        .setVisible(false);
        
  currPromptTxt.setText("The curr Prompt");   
  
   currVisualTxt = cp5.addTextarea("cVisTxt")
        .setPosition(localx+525,localy+100)
        .setSize(200,50)
        .setFont(createFont("arial",22))
        .setColor(color(255))
        .setColorBackground(color(80))
        .setColorForeground(color(255))
        .setVisible(showHideButtons);
  currVisualTxt.setText("The curr Visual");  
  
  
  // create a new button with name 'buttonA'
  cp5.addButton("Load_Prompt")
     .setPosition(localx+320,localy+20)
     .setSize(180,50)
     .setFont(createFont("arial",22))
     .setColorBackground(color(0,150,180))
     .setColorForeground(color(180))
     .setVisible(false)
     
     ;
  
  // and add another 2 buttons
  cp5.addButton("Load_Vis")
     .setPosition(localx+320,localy+100)
     .setSize(180,50)
     .setFont(createFont("arial",22))
     .setColorBackground(color(0,150,180))
     .setColorForeground(color(180))
     .setVisible(showHideButtons)
     ;
 
  cp5.addButton("videoOnly")
     .setPosition(localx+20,localy+180)
     .setSize(180,50)
     .setFont(createFont("arial",20))
     .setColorBackground(color(0,150,180))
     .setColorForeground(color(180))
     //.setLock(true)
     .setCaptionLabel("Video Only")
     .setVisible(showHideButtons)
     ;
 
  cp5.addButton("BlackTrans")
     .setPosition(localx+270,localy+180) 
     .setSize(180,50)
     .setFont(createFont("arial",20))
     .setColorBackground(color(0,150,180))
     .setColorForeground(color(180))
     .setCaptionLabel("Fade Out")
     .setVisible(showHideButtons)
     ;
 
  cp5.addButton("Clear")
     .setPosition(localx+530,localy+180)
     .setSize(180,50)
     .setFont(createFont("arial",22))
     .setColorBackground(color(0,150,180))
     .setColorForeground(color(180))
     .setCaptionLabel("Clear Screen")
     .setVisible(showHideButtons)
     ;
     
     
    cp5.addTextfield("promptInput")
     .setPosition(localx+20,localy+290)
     .setSize(200,40)
     .setFont(createFont("arial",20))
     .setFocus(true)
     .setCaptionLabel("Set Prompt")
     //.setColor(color(255,0,0))
     .setVisible(showHideButtons)
     ;
     
  cp5.addButton("TogglePrompt")
     .setPosition(localx+230,localy+290)
      //.setPosition(230,600)
     .setSize(180,40)
     .setFont(createFont("arial",20))
     .setColorBackground(color(0,150,180))
     .setColorForeground(color(180))
     .setVisible(showHideButtons)
     .setCaptionLabel("Show Prompt")
     ;
     
   maxSticks = cp5.addNumberbox("maxSticks")
     //.setPosition(160,400)
     .setPosition(localx+530,localy+290)
     .setSize(70,30)
     .setScrollSensitivity(1.1f)
     .setRange(1,30)
     .setValue(maxSticksVal)
     .setDirection(Controller.HORIZONTAL)
     .setCaptionLabel("max Sticks")
     .setFont(fontF) // use a pfont not a ControlFont
     .setVisible(showHideButtons)
     ;
     maxSticks.getCaptionLabel().toUpperCase(false);

     
}


// Events for promptVisControl

  public void prompt_for() {
     //println("a button event from prompt_for: "+theValue);
     pc.queBothForward();
  }
  
  public void prompt_bak() {
    // println("a button event from prompt_bak: "+theValue);
     pc.queBothBack();
  }
  
  public void vis_for() {
     //println("a button event from vis_for: "+theValue);
      pc.queVisForward();
  }
   
  public void vis_bak() {
     //println("a button event from vis_bak: "+theValue);
     pc.queVisBack();
  }
  
  ///
  
  public void Load_Prompt() {
     println("btn event: Load_Prompt");
     blackTranny.reset(); 
     pc.loadBoth();
  }
   
  public void Load_Vis() {
     println("btn event Load_Vis");
     blackTranny.reset(); 
     pc.loadVis();
  }
  
   public void TogglePrompt() {
     //println("btn event: togglePrompt");
     globalPromptText = cp5.get(Textfield.class,"promptInput").getText();
     pc.togglePrompt();
     
    //println(pc.pvis);
     
     if (pc.pvis == true) {
       cp5.getController("TogglePrompt").setCaptionLabel("Hide Prompt");
     } else {
       cp5.getController("TogglePrompt").setCaptionLabel("Show Prompt");
     }
     
  }
  
  public void videoOnly() {
    // put the vis ID here
    println("video");
    pc.pvis = false;
    blackTranny.reset(); 
    pc.visNum = 8;
  }

  public void BlackTrans() {
    // put the vis ID here
    println("bt");
    blackTranny.reset(); 
    pc.visNum = 0;
  }
  
// cp5 variables to global variables
public void dp() {
 dpVal = dp.getValue();
 //println(dpVal);
}
public void minDist() {
  minDistVal = minDist.getValue();
  //println(minDistVal);
}
public void cannyHigh() { 
  cannyHighVal= cannyHigh.getValue();
  //println(cannyHighVal);
}
public void cannyLow() {
 cannyLowVal = cannyLow.getValue();
 //println(cannyLowVal);
}
public void minSize() {
  minSizeVal = PApplet.parseInt(minSize.getValue());
  //println(minSizeVal);
}
public void maxSize() {
  maxSizeVal = PApplet.parseInt(maxSize.getValue());
  //println(maxSizeVal);
}
 public void maxSticks() {
 maxSticksVal = maxSticks.getValue(); 
 //println(maxSticksVal);
}
public void HoughCalibrate() {
  pc.visNum = 8;
}

//void promptInput() {
//  globalPromptText = cp5.get(Textfield.class,"promptInput").getText();
//  println("prompt input function test");
//}
  
  
  
//~~~~~~~ video button functions

  
  
  // callback for webcam buttons
  final CallbackListener btnAction = new CallbackListener() {
    public @Override void controlEvent(CallbackEvent evt) {
      Button btn = (Button) evt.getController();
      String name = btn.getName();
      //println(name, frameCount);
      
      //if another camera is already open
      if (camStarted == true) {
        cam.stop();
      }
      
      if(movieStarted == true) {
        movie.stop();
        movieStarted=false;
      }
       
       cam = new Capture(mainparent, name);
       cam.start();
       
       //if(cam.available()==false) { println("cam not ready yet"); }
       
       //while(true) {
       //  //infinite loop until cam.available() = true
       //  try {
       //    Thread.sleep(500);
       //  }
       //  catch(InterruptedException ex) {
       //     Thread.currentThread().interrupt();
       //     println("interupt idk");
       // }
       //  if(cam.available()) {
       //    cam.read();
       //    break; 
       //  }
       //}
       
       // how to improve this... sometimes works, sometimes locks up
       //only seems to lock up with 1fps cam option
       while(true) {
         //infinite loop until cam.available() = true
         try {
           Thread.sleep(50);
         }
         catch(InterruptedException ex) {
            Thread.currentThread().interrupt();
        }
         if(cam.available()) {
           cam.read();
          // println("cam size: "+cam.width+" x "+cam.height);
           gframe = new FrameData(cam.width, cam.height);
           opencv = new OpenCV(mainparent, cam.width, cam.height);
           videoStartUpManager();
           camStarted = true;
           showHideButtons = true;
           buttonVisibility(showHideButtons);
           
          pc.visNum = 8;
           
           break; 
         }
       }
       
    }
  };

  //callback for movie buttons
  final CallbackListener btnAction2 = new CallbackListener() {
    public @Override void controlEvent(CallbackEvent evt) {
      Button btn = (Button) evt.getController();
      String name = btn.getName();
      
      if(camStarted == true) {
        cam.stop();
        camStarted=false;
      }
      
      //if a movie was already open, close it
      if (movieStarted == true) {
        movieStarted = false;
        movie.stop();
      }
      
      movie = new Movie(mainparent, "videos/"+name);
      movie.loop();
      movie.read(); //need to read movie so that it's size is available to cv object
      
      //println("movie size: "+movie.width+" x "+movie.height);
      
      gframe = new FrameData(movie.width, movie.height);
      opencv = new OpenCV(mainparent, movie.width, movie.height);

      videoStartUpManager();
      
      movieStarted=true;
      
      showHideButtons = true;
      buttonVisibility(showHideButtons);
      
      pc.visNum = 8;
     
    }
  };
  
  public void buttonVisibility(boolean theFlag) {
    cp5.getController("videoOnly").setVisible(theFlag);
    cp5.getController("BlackTrans").setVisible(theFlag);
    cp5.getController("TogglePrompt").setVisible(theFlag);
    cp5.getController("Load_Vis").setVisible(theFlag);
    currVisualTxt.setVisible(theFlag);
    cp5.getController("vis_for").setVisible(theFlag);
    cp5.getController("vis_bak").setVisible(theFlag);
    visualTxt.setVisible(theFlag);
    
    //cp5.getController("Load_Prompt").setVisible(theFlag);
    //currPromptTxt.setVisible(theFlag);
    //cp5.getController("prompt_for").setVisible(theFlag);
    //cp5.getController("prompt_bak").setVisible(theFlag);
    //promptTxt.setVisible(theFlag);
    
    //cp5.getController("HoughCalibrate").setVisible(theFlag);
    cp5.getController("Clear").setVisible(theFlag);
    cp5.getController("maxSticks").setVisible(theFlag);
    
    cp5.getController("promptInput").setVisible(theFlag);
  }

  
}  // END OF UI Applet



class  FrameData {
  public int w;
  public int h; 
  FrameData(int lw, int lh) {
    w = lw;
    h  = lh;   
  } 
}

//class to store circle detection data in (x,y,radius/2) format
// needed so it can be used in a pass-by-reference manner
class dataStorage {
  float[][] data;
  dataStorage() {}  
}

// quickly print an array containing the total number of r,g,b circles detected 
public void printTotals(float[][] r, float[][] g, float[][] b) {
   int[] theTotal = {r.length,g.length,b.length};
   println( "# of r,g,b= "+Arrays.toString(theTotal) );
}

// - - - - print 2d array to compare values
public void print2D(double arr[][]) { 
  print("print2D= ");  
  // Loop through all rows 
  for (double[] row : arr) {
    // converting each row as string 
    // and then printing in a separate line 
    println(Arrays.toString(row));
  }
  println("");
}
// or as float[][]
public void print2DFloats(float arr[][]) { 
  print("print2D= ");  
  // Loop through all rows 
  for (float[] row : arr) {
    // converting each row as string 
    // and then printing in a separate line 
    println(Arrays.toString(row));
  }
  println("");
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "CitizenSticks" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

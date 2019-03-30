
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import controlP5.*;
ControlP5 cp5;

import processing.video.*;
Capture cam;
Movie movie;

//the reference to the base PApplet
PApplet sketchPApplet=this;

boolean camStarted = false;
boolean movieStarted = false;


// https://forum.processing.org/two/discussion/14176/controlp5-get-value-when-pressing-a-button

// callback for webcam buttons
final CallbackListener btnAction = new CallbackListener() {
  @ Override void controlEvent(CallbackEvent evt) {
    Button btn = (Button) evt.getController();
    String name = btn.getName();
    //println(name, frameCount);
    
    //if another camera is already open
    if (camStarted == true) {
      cam.stop();
    }
     
     cam = new Capture(sketchPApplet, name);
     cam.start();
     movieStarted=false;
     camStarted = true;
  }
};

//callback for movie buttons
final CallbackListener btnAction2 = new CallbackListener() {
  @ Override void controlEvent(CallbackEvent evt) {
    Button btn = (Button) evt.getController();
    String name = btn.getName();
    
    movie = new Movie(sketchPApplet, name);
    movie.loop();
    movie.read(); //need to read movie so that it's size is available to cv object
    
    if(camStarted == true) {
      camStarted=false;
      cam.stop();
    }
    
    movieStarted=true;
  }
};

void setup() {
  
  size(1280,720);
  cp5 = new ControlP5(this);
  
  // change the default button font
  PFont p = createFont("Verdana",10); 
  ControlFont font = new ControlFont(p);
  cp5.setFont(font);
 
 
  String[] cameras = Capture.list();
  if (cameras != null && cameras.length>0) {
    for (int i=0; i < cameras.length; i++) {
      
      //regex to select only cameras that are 1280x720
      String[] matched = match(cameras[i], "size=1280x720"); //maybe add fps as well
      if(matched != null) {
        cp5.addButton(cameras[i])
        .onPress(btnAction)
        .setValue(0)
        .setPosition(50,40*i)
        .setSize(300,30)
        .getCaptionLabel().toUpperCase(false)
        ;
      }
      
    }
  } else {
   println("Cameras not available or null! Exiting Program");
   exit();
  }
  
  
  try {
      int x=0;
      //  **NOTE** this dataPath might change in the standalone app version, idk yet
      DirectoryStream<Path> stream = Files.newDirectoryStream(Paths.get(dataPath(""))); 
      for (Path file : stream) {
        //println(file.getFileName());
         cp5.addButton(file.getFileName().toString() )
         .onPress(btnAction2)
         .setValue(0)
         .setPosition(400,40*x)
         .setSize(300,30)
         .getCaptionLabel().toUpperCase(false)
         ;
         x++;
      }
    } 
    catch (IOException e) {
      e.printStackTrace();
  }
  
  
}

void draw() {
  
  if (camStarted == true) {
    if (cam.available() == true) {
      cam.read();
    }
    image(cam, 0, 0);
  }
  
  if (movieStarted == true) {
    if (movie.available()) {
      movie.read();
    }
    image(movie, 0, 0);
  }
   
 
}

// void controlEvent(ControlEvent theEvent) {
//  println("a button event from: "+theEvent.getController().getName());
//}

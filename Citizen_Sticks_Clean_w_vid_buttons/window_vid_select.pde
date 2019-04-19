/*
  This has the UI windowing code for video selection 
*/



 
// Nested PApplet Class
public class vidSelectUI extends PApplet {
    PApplet mainparent;
    
          
  //globals for this window
  ControlP5 cp5VideoUI;
  
  boolean camStarted = false;
  boolean movieStarted = false;
    
    
  public vidSelectUI(PApplet parent){
    this.mainparent = parent;
    //super();
    //PApplet.runSketch(new String[]{this.getClass().getName()}, this);     
  }
  
  
  void settings() {
     size(770, 525 );
    
    //smooth(4);
  }
  
  
  public void setup() {
    background(50);
       
    cp5VideoUI = new ControlP5(this);
    
    // change the default button font
    PFont p = createFont("Verdana",10); 
    ControlFont font = new ControlFont(p);
    cp5VideoUI.setFont(font);
    
    // ** make camera input buttons
    String[] cameras = Capture.list();
    if (cameras != null && cameras.length>0) {
      for (int i=0; i < cameras.length; i++) {
        
        //regex to select only cameras that are 1280x720
        String[] matched = match(cameras[i], "size=1280x720,fps=30|size=1280x720,fps=15"); //maybe add fps as well
        if(matched != null) {
          cp5VideoUI.addButton(cameras[i])
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
   
  // ** make video input buttons 
  int i = 0; 
  for (int x=0; x<videoPaths.size();x++) {
    //println(videoPaths.get(x));
    cp5VideoUI.addButton( videoPaths.get(x) )
    .onPress(btnAction2)
    .setValue(0)
    .setPosition(400,40*i)
    .setSize(300,30)
    .getCaptionLabel().toUpperCase(false)
    ;
    i++;
  }
  
      // ** this gives a weird directory not found type error
    // ** instead the paths to the videos are grabbed from the main window
    //try {
    //    int x=0;
    //    //  **NOTE** this dataPath might change in the standalone app version, idk yet
    //    DirectoryStream<Path> stream = Files.newDirectoryStream(Paths.get(dataPath("videos"))); 
    //    println(stream + "  from 2nd window");
    //    for (Path file : stream) {
    //      println(file.getFileName());
    //       cp5VideoUI.addButton(file.getFileName().toString() )
    //       .onPress(btnAction2)
    //       .setValue(0)
    //       .setPosition(400,40*x)
    //       .setSize(300,30)
    //       .getCaptionLabel().toUpperCase(false)
    //       ;
    //       x++;
    //    }
    //  } 
    //  catch (IOException e) {
    //    e.printStackTrace();
    //}

  }
  
  void draw() {
    background(50);

  }
  
  //_______functions
  
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
      
      if(movieStarted == true) {
        movie.stop();
        movieStarted=false;
      }
       
       cam = new Capture(mainparent, name);
       cam.start();
       
       if(cam.available()==false) { println("cam not ready yet"); }
       
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
           println("cam size: "+cam.width+" x "+cam.height);
           gframe = new FrameData(cam.width, cam.height);
           opencv = new OpenCV(mainparent, cam.width, cam.height);
           videoStartUpManager();
           camStarted = true;
           break; 
         }
       }
       
    }
  };

  //callback for movie buttons
  final CallbackListener btnAction2 = new CallbackListener() {
    @ Override void controlEvent(CallbackEvent evt) {
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
     
    }
  };


}  // END OF UI Applet

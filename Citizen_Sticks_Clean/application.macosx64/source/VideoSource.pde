
// VideoSource grabs either camera or movie file and passes to openCV object


class VideoSource{
  Capture webcam;
  Movie movie;
  PApplet parent;
  int w, h;
  boolean isWebcam = true;
  String path;
  
  //initialize w/ Capture object
  VideoSource(Capture _webcam, PApplet _parent, int _w, int _h ) {
    webcam = _webcam;
    w = _w;
    h = _h;
    parent = _parent;
    
    String[] cameras = Capture.list();
    webcam = new Capture(parent, w, h, cameras[0]);
    webcam.start();
    gframe = new FrameData(webcam.width, webcam.height);
    opencv = new OpenCV(parent, webcam.width, webcam.height);
  }
  
  // or initialize w/ Movie object
  VideoSource(Movie _movie, PApplet _parent, String _path) {
    movie = _movie;
    parent = _parent;
    path = _path;
    isWebcam = false;
    
    movie = new Movie(parent, path); 
    movie.loop();
    movie.read(); //need to read movie so that it's size is available to cv object
    gframe = new FrameData(movie.width, movie.height);
    opencv = new OpenCV(parent, movie.width, movie.height);
  }
  
  //Read last frame
  void loadFrames() {
    if (isWebcam) {
      if (webcam.available()) {
        webcam.read();
        opencv.loadImage(webcam);
        //print("test webcam is true");
      }
    } else {
      if (movie.available()) {
         movie.read();
         opencv.loadImage(movie);
        //println("webcam is false");  
      }  
    }
  }
    
}

/*
Fade to black by repeatedly drawing
transparent black rectangle over entire screen
*/

class BlackFade {
  int w;
  int h;
  int counter = 0;
  float opacity; 
  float easing = 0.75;
  
  BlackFade(int _w, int _h) {
    w = _w;
    h =_h;
  }
  
  void fadeOut() {
    if (counter<50) {
      float targetOpacity = 20;
      float dOpac = targetOpacity - opacity;
      opacity += dOpac * easing;
      
      counter++;
      noStroke();
      fill(0,0,0,opacity);
      rect(0,0,w,h);
      
      promptOpacity = map(opacity,0,20,255,0);
    } 
    //float tempPromptOpacity;
    //println(counter);
  }
  
  void reset() {
    counter = 0;
    opacity=0;
    promptOpacity = 255;
  }
  
}

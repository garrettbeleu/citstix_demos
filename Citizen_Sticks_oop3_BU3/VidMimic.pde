/*
Draw filled gradient orbs instead of the video 
so that the vizualizations run at faster FPS
*/

class VidMimic{
  
  VidMimic() {
  }
  
  void drawMimic(float[][] inputArray, color cTest, int opacity) {
    color c1;
    color c2;
    
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
          float n = map(r, 0, maxr, 0, 0.6);
          color newc = lerpColor(c1, c2, n);
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
          float n = map(r, 0, maxr, 0, 0.6);
          color newc = lerpColor(c1, c2, n);
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
          float n = map(r, 0, maxr, 0, 0.6);
          color newc = lerpColor(c1, c2, n);
          stroke(newc,opacity);
          ellipse(inputArray[i][0], inputArray[i][1], r, r);
        }
      }
    }
     
  }
  
  void pushToScreen(int finalOpacity) {
    strokeWeight(2);
    noFill();
    drawMimic(dsRed.data, color(255,0,0),finalOpacity);
    drawMimic(dsGreen.data, color(0,255,0),finalOpacity);
    drawMimic(dsBlue.data, color(0,0,255),finalOpacity);  
  }
  
  
}

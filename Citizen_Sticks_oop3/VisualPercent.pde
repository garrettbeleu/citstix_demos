/*
this is not working as expected for some reason
-both the eased and non-eased versions
- need break, gb-10/28/18 @ 5:18pm
*/

class VisualPercent {
 // float[][] r,g,b;
  int totalCircles = 0;
  int h = 0;
  float redEase;
  float greenEase;
  float easing = 0.2;
  
  VisualPercent() {
  }
  
  void calc(float[][] r, float[][] g, float[][] b) {
    totalCircles = r.length + g.length +b.length;
    //println( r.length + g.length +b.length );
  
    noStroke();
    if (totalCircles>0) {
      float redArea = (r.length/totalCircles) * width;
      float greenArea = (g.length/totalCircles) * width;
      
      // //__**__**__** non-eased
      //fill(255,0,0,50);
      //rect(0,0,redArea,height);
      //println(redArea);
      
      //fill(0,255,0,50);
      //rect(redArea,0,greenArea,height);
      
      //fill(0,0,255,50);
      //rect(redArea+greenArea,0,width,height);
      
      // // __**__**__** eased version
      // //red-end & green-start
      float targetRed = redArea;
      float rX = targetRed - redEase;
      redEase += rX * easing;
      //constrain(redEase,0,width);
      
      // //green-end & blue-start
      float targetGreen = redArea;
      float gX = targetGreen - greenEase;
      greenEase += gX * easing;
      //constrain(greenEase,0,width);
      
      //red
      fill(255,0,0,50);
      rect(0,0,redEase,height);
      //green
      fill(0,255,0,50);
      rect(redEase,0,greenEase,height);
      //blue
      fill(0,0,255,50);
      rect(redEase+greenEase,0,width,height);
      
      //println("red ease:"+redEase + " green ease:"+greenEase);
    }
      
  }
  
  void pushToScreen() {
    calc(dsRed.data,dsGreen.data,dsBlue.data);
    //printTotals(dsRed.data,dsGreen.data,dsBlue.data);
  }
  
}

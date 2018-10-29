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
  float easing = 0.2;
  int stripesHeight = 30;
  
  VisualPercent() {
  }
  
  void calc(float[][] r, float[][] g, float[][] b, int opacity, String mode) {
    totalCircles = r.length + g.length + b.length;
    //println( "total: "+ totalCircles );
  
    noStroke();
    
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
      fill(0,0,0,20);
      rect(0,0,width,height);
      if( h>720-stripesHeight) {
        // reset vertical position counter
        h=0;
      }
    }
      
  }
  
  void pushToScreen(int opac, String screenMode) {
    calc(dsRed.data,dsGreen.data,dsBlue.data, opac, screenMode);
    //printTotals(dsRed.data,dsGreen.data,dsBlue.data);
  }
  
}

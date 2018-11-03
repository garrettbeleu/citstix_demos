 
 public String UIPrompt ="naz";

// Nested PApplet Class A:
public class sdUI extends PApplet {
    PApplet mainparent;
    
    ControlP5 cp5;
    Range redRangeHue,redRangeSat,redRangeVal, greenRangeHue,greenRangeSat,greenRangeVal, blueRangeHue,blueRangeSat,blueRangeVal;
    Range redRangeHue2, redRangeSat2, redRangeVal2;
    Numberbox dp,minDist,cannyHigh,cannyLow,minSize,maxSize;

    //sd
    Textarea promptTxt;
    Textarea visualTxt;
    
    Textarea currPromptTxt;
    Textarea currVisualTxt;
          
    //initial slider values
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
      
    PFont fontF;
    
    
     public sdUI(PApplet parent){
      this.mainparent = parent;
     
      //super();
      //PApplet.runSketch(new String[]{this.getClass().getName()}, this);
      
      
    }



///////////////////////////////////////////////////////////////////////////////////
///// ALL CONTROL P5 definations below after setup/draw ////
  
  
  void settings() {
     size(770, 525 );
    
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
    
     
   
  }
  
   void draw() {
    background(50);
    textSize(16);
    textLeading(16);
    stroke(255);
  //  guiText(color(255), true, '`'); // just testing this here, the global variable don't reach this :(
    guiText(color(255), guiVisibility, whichVideo);
    
   //promptTxt.setText(UIPrompt);
  }
  
  
  
  
  
  
void keyPressed() {
  
  int k = keyCode; 
  // if (k == ENTER | k == RETURN)  //activateSketch(another);
  
 //  if (k == 'T') mainparent.toggleSketch(this);  // disableSketch(another); 
  //if (k == 'S') saveWords();
  //if (k == 'L') loadWords();
  
  println(k);
  
}
  
  
  
  
public void guiText(color c, boolean state, char theCase) {
  //if(state) {
    textAlign(LEFT);
    fill(c);  
    text("HoughCircles params",360,370); //this is the label for the white numberboxes - moved back GB

    pushMatrix();
    translate(540,280);
    text("fR: "+this.mainparent.frameRate,0,0);
    
    switch(theCase) {
      case '`':
        text("video: SRC", 0,30);
        break;
      case '1':
        text("video: R&G&B", 0, 30);
        break;
      case '2':
        text("video: RED FILTERED", 0, 30);
        break;
      case '3':
        text("video: GREEN FILTERED", 0, 30);
        break;
      case '4':
        text("video: BLUE FILTERED", 0, 30);
        break;
      case '0':
        text("video: HIDE", 0, 30);
        break;
    }
    
    popMatrix();
    
  //}
}

//~*~*~*~*~*~*~*~*~ update slider values
void redRangeHue() {
  rHueMin = round(redRangeHue.getLowValue());
  rHueMax = round(redRangeHue.getHighValue());
}
void redRangeSat() {
  rSatMin = round(redRangeSat.getLowValue());
  rSatMax = round(redRangeSat.getHighValue());
}
void redRangeVal() {
  rValMin = round(redRangeVal.getLowValue());
  rValMax = round(redRangeVal.getHighValue());
}

void redRangeHue2() {
  r2HueMin = round(redRangeHue2.getLowValue());
  r2HueMax = round(redRangeHue2.getHighValue());
}
void redRangeSat2() {
  r2SatMin = round(redRangeSat2.getLowValue());
  r2SatMax = round(redRangeSat2.getHighValue());
}
void redRangeVal2() {
  r2ValMin = round(redRangeVal2.getLowValue());
  r2ValMax = round(redRangeVal2.getHighValue());
}

void greenRangeHue() {
  gHueMin = round(greenRangeHue.getLowValue());
  gHueMax = round(greenRangeHue.getHighValue());
}
void greenRangeSat() {
  gSatMin = round(greenRangeSat.getLowValue());
  gSatMax = round(greenRangeSat.getHighValue());
}
void greenRangeVal() {
  gValMin = round(greenRangeVal.getLowValue());
  gValMax = round(greenRangeVal.getHighValue());
}

void blueRangeHue() {
  bHueMin = round(blueRangeHue.getLowValue());
  bHueMax = round(blueRangeHue.getHighValue());
}
void blueRangeSat() {
  bSatMin = round(blueRangeSat.getLowValue());
  bSatMax = round(blueRangeSat.getHighValue());
}
void blueRangeVal() {
  bValMin = round(blueRangeVal.getLowValue());
  bValMax = round(blueRangeVal.getHighValue());
}

//toggle gui visibilities and color
void morphTog(boolean theFlag) {
  if (theFlag) {
    cp5.getController("morphTog").setColorActive(color(15,255,80));
    
  }else{
    cp5.getController("morphTog").setColorActive(color(255,15,80));
  }
}

//initialize all the gui elements
void loadGUI() {
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
       .setCaptionLabel("Hue");
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
       .setCaptionLabel("Sat");
             
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
       .setCaptionLabel("Val");
                       
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
       .setCaptionLabel("Hue");
             
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
       .setCaptionLabel("Sat");
             
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
       .setCaptionLabel("Val");

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
       .setCaptionLabel("Hue");
             
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
       .setCaptionLabel("Sat");
             
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
       .setCaptionLabel("Val");
  
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
       .setCaptionLabel("Hue 2");
       
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
       .setCaptionLabel("Sat 2");
       
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
       .setCaptionLabel("Val 2");
       
    cp5.addToggle("morphTog")
       .setPosition(290,height-150)
       .setSize(50,20)
       .setBroadcast(false)
       .setValue(false)
       .setBroadcast(true)
       .setMode(ControlP5.SWITCH)
       .setColorActive(color(255,15,80))
       .setColorBackground(color(255));

// Circle detect numberboxes
  dp = cp5.addNumberbox("dp")
   .setPosition(290,height-60)
   .setSize(45,20)
   .setRange(1,6)
   .setValue(2)
   .setColorForeground(color(255,0,0))
   .setColorActive(color(255,0,0,125))
   .setColorBackground(color(255,255,255))
   .setColorValueLabel(255)
   .setScrollSensitivity(0.1)
   .setDirection(Controller.HORIZONTAL)
   .setCaptionLabel("Rez");
     dp.getCaptionLabel().toUpperCase(false);
     
  minDist = cp5.addNumberbox("minDist")
   .setPosition(350,height-60)
   .setSize(45,20)
   .setRange(1,100)
   .setValue(30)
   .setColorForeground(color(255,0,0))
   .setColorActive(color(255,0,0,125))
   .setColorBackground(color(255,255,255))
   .setColorValueLabel(255)
   .setScrollSensitivity(0.2)
   .setDirection(Controller.HORIZONTAL);
     minDist.getCaptionLabel().toUpperCase(false);

 cannyHigh = cp5.addNumberbox("cannyHigh")
   .setPosition(410,height-60)
   .setSize(45,20)
   .setRange(1,500)
   .setValue(50)
   .setColorForeground(color(255,0,0))
   .setColorActive(color(255,0,0,125))
   .setColorBackground(color(255,255,255))
   .setColorValueLabel(255)
   .setScrollSensitivity(0.2)
   .setDirection(Controller.HORIZONTAL);
     cannyHigh.getCaptionLabel().toUpperCase(false);
     
  cannyLow = cp5.addNumberbox("cannyLow")
   .setPosition(470,height-60)
   .setSize(45,20)
   .setRange(1,500)
   .setValue(19)
   .setColorForeground(color(255,0,0))
   .setColorActive(color(255,0,0,125))
   .setColorBackground(color(255,255,255))
   .setColorValueLabel(255)
   .setScrollSensitivity(0.2)
  .setDirection(Controller.HORIZONTAL);
     cannyLow.getCaptionLabel().toUpperCase(false);
     
  minSize = cp5.addNumberbox("minSize")
   .setPosition(530,height-60)
   .setSize(45,20)
   .setRange(1,500)
   .setValue(5)
   .setColorForeground(color(255,0,0))
   .setColorActive(color(255,0,0,125))
   .setColorBackground(color(255,255,255))
   .setColorValueLabel(255)
   .setScrollSensitivity(0.2)
   .setDirection(Controller.HORIZONTAL);
     minSize.getCaptionLabel().toUpperCase(false);
     
  maxSize = cp5.addNumberbox("maxSize")
   .setPosition(590,height-60)
   .setSize(45,20)
   .setRange(5,200)
   .setValue(35)
   .setColorForeground(color(255,0,0))
   .setColorActive(color(255,0,0,125))
   .setColorBackground(color(255,255,255))
   .setColorValueLabel(255)
   .setScrollSensitivity(0.2)
   .setDirection(Controller.HORIZONTAL);
     maxSize.getCaptionLabel().toUpperCase(false); 
  
 /////////////////////////////// Main Prompt Vis Controls 
  int localx = 20;
  int localy = 0;
  
  promptTxt = cp5.addTextarea("promptTxt")
            .setPosition(localx+50,localy+20)
            .setSize(200,50)
            .setFont(createFont("arial",22))
            .setColor(color(255))
            .setColorBackground(color(80))
            .setColorForeground(color(255));
            
 promptTxt.setText("The Prompt");      
          
  // buttons with images for Prompt 
  cp5.addButton("prompt_for")
     .setValue(128)
     .setPosition(localx+250,localy+20)
     .setImages(for_imgs)
     .updateSize();
     
  cp5.addButton("prompt_bak")
     .setValue(128)
     .setPosition(localx,localy+20)
     .setImages(bak_imgs)
     .updateSize();
         
 visualTxt = cp5.addTextarea("visTxt")
            .setPosition(localx+50,localy+100)
            .setSize(200,50)
            .setFont(createFont("arial",22))
            .setColor(color(255))
            .setColorBackground(color(80))
            .setColorForeground(color(255));
            
  visualTxt.setText("The Vis");   
  
   // buttons with images for Vis 
  cp5.addButton("vis_for")
     .setValue(128)
     .setPosition(localx+250,localy+100)
     .setImages(for_imgs)
     .updateSize() ;
     
  cp5.addButton("vis_bak")
     .setValue(128)
     .setPosition(localx,localy+100)
     .setImages(bak_imgs)
     .updateSize();
     
  currPromptTxt = cp5.addTextarea("cPromptTxt")
        .setPosition(localx+525,localy+20)
        .setSize(200,50)
        .setFont(createFont("arial",22))
        .setColor(color(255))
        .setColorBackground(color(80))
        .setColorForeground(color(255));
        
  currPromptTxt.setText("The curr Prompt");   
  
   currVisualTxt = cp5.addTextarea("cVisTxt")
        .setPosition(localx+525,localy+100)
        .setSize(200,50)
        .setFont(createFont("arial",22))
        .setColor(color(255))
        .setColorBackground(color(80))
        .setColorForeground(color(255));      
  currVisualTxt.setText("The curr Visual");  
  
  
  // create a new button with name 'buttonA'
  cp5.addButton("Load_Prompt")
     .setValue(100)
     .setPosition(localx+320,localy+20)
     .setSize(180,50)
     .setFont(createFont("arial",22))
     .setColorBackground(color(0,150,180))
     .setColorForeground(color(180))
     ;
  
  // and add another 2 buttons
  cp5.addButton("Load_Vis")
     .setValue(100)
     .setPosition(localx+320,localy+100)
     .setSize(180,50)
     .setFont(createFont("arial",22))
     .setColorBackground(color(0,150,180))
     .setColorForeground(color(180))
     ;
     
   // and add another 2 buttons
  cp5.addButton("TogglePrompt")
     .setValue(100)
     .setPosition(localx+320,localy+180)
     .setSize(180,50)
     .setFont(createFont("arial",20))
     .setColorBackground(color(0,150,180))
     .setColorForeground(color(180))
     ;
 
     
}


// Events for promptVisControl

  public void prompt_for(int theValue) {
     //println("a button event from prompt_for: "+theValue);
     pc.queBothForward();
  }
  
  public void prompt_bak(int theValue) {
    // println("a button event from prompt_bak: "+theValue);
     pc.queBothBack();
  }
  
  public void vis_for(int theValue) {
     //println("a button event from vis_for: "+theValue);
      pc.queVisForward();
  }
   
  public void vis_bak(int theValue) {
     //println("a button event from vis_bak: "+theValue);
     pc.queVisBack();
  }
  
  public void Load_Prompt(int theValue) {
     println("a button event from vis_for: Load_Prompt");
     pc.loadBoth();
  }
   
  public void Load_Vis(int theValue) {
     println("a button event from vis_bak: Load_Vis");
     pc.loadVis();
  }
  
   public void TogglePrompt(int theValue) {
     println("a button event from vis_bak: togglePrompt");
     pc.togglePrompt();
  }

  
}  // END OF UI Applet
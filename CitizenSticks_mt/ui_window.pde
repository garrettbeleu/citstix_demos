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
  
  
  void settings() {
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
  
  
  void updateCurrentVideoBtns() {
    
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
  
  
  
  
  
  
  
 void draw() {
    background(50);
    textSize(16);
    textLeading(16);
    stroke(255);
  //  guiText(color(255), true, '`'); // just testing this here, the global variable don't reach this :(
    guiText(color(255), guiVisibility, whichVideo);
    
   //promptTxt.setText(UIPrompt);
  }
  
  //////////////////////////// Close Function ( no crashed)
   void exit() {
    dispose();
    objui = null;
  }
  
  
  
void keyPressed() {
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
  
  
  
  
public void guiText(color c, boolean state, char theCase) {
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




// clear button routine
void Clear() { 
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
void loadGUI() {
  cp5 = new ControlP5(this);
   
   //PImage[] for_imgs = {loadImage("data/button_a.png"),loadImage("button_b.png"),loadImage("button_c.png")};
   //PImage[] bak_imgs = {loadImage("data/ba_button_a.png"),loadImage("ba_button_b.png"),loadImage("ba_button_c.png")};


 // create a toggle
  cp5.addToggle("HDT_OFF")
     .setPosition(550,450)
     .setSize(30,30)
     .setValue(false)  
     ;
  
 
 //.setMode(ControlP5.SWITCH)
 

    
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
   .setScrollSensitivity(0.1)
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
   .setScrollSensitivity(0.2)
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
   .setScrollSensitivity(0.2)
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
   .setScrollSensitivity(0.2)
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
   .setScrollSensitivity(0.2)
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
   .setScrollSensitivity(0.2)
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
     .setScrollSensitivity(1.1)
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
void dp() {
 dpVal = dp.getValue();
 //println(dpVal);
}
void minDist() {
  minDistVal = minDist.getValue();
  //println(minDistVal);
}
void cannyHigh() { 
  cannyHighVal= cannyHigh.getValue();
  //println(cannyHighVal);
}
void cannyLow() {
 cannyLowVal = cannyLow.getValue();
 //println(cannyLowVal);
}
void minSize() {
  minSizeVal = int(minSize.getValue());
  //println(minSizeVal);
}
void maxSize() {
  maxSizeVal = int(maxSize.getValue());
  //println(maxSizeVal);
}
 void maxSticks() {
 maxSticksVal = maxSticks.getValue(); 
 //println(maxSticksVal);
}
void HoughCalibrate() {
  pc.visNum = 8;
}

//void promptInput() {
//  globalPromptText = cp5.get(Textfield.class,"promptInput").getText();
//  println("prompt input function test");
//}
  
  void HDT_OFF(boolean theFlag) {
    if(theFlag) {
      multiT =false;
    } else {
      multiT = true;
    }
  println("a toggling HDT");
  }

  
  
//~~~~~~~ video button functions

  
  
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
      
      showHideButtons = true;
      buttonVisibility(showHideButtons);
      
      pc.visNum = 8;
     
    }
  };
  
  void buttonVisibility(boolean theFlag) {
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

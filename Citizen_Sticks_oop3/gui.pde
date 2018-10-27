ControlP5 cp5;
Range redRangeHue,redRangeSat,redRangeVal, greenRangeHue,greenRangeSat,greenRangeVal, blueRangeHue,blueRangeSat,blueRangeVal;
Range redRangeHue2, redRangeSat2, redRangeVal2;
Numberbox dp,minDist,cannyHigh,cannyLow,minSize,maxSize;
Toggle red2Toggle;

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


   //Capture video; //uncomment for webcam
boolean dslr = false; // true for Logitech webcam - false for built in webcam
   Movie video; //comment for webcam
   
boolean isMovie = true;

boolean guiVisibility = true;

char whichVideo = '`';

//draw text depending upon the case and state
void guiText(color c, boolean state, char theCase) {
  if(state) {
    fill(c);
    text("fR: "+frameRate,50,height-310);
    text("HoughCircles params",290,height-70);

    switch(theCase) {
      case '`':
        text("video: SRC", 50, height-290);
        break;
      case '1':
        text("video: R&G&B", 50, height-290);
        break;
      case '2':
        text("video: RED FILTERED", 50, height-290);
        break;
      case '3':
        text("video: GREEN FILTERED", 50, height-290);
        break;
      case '4':
        text("video: BLUE FILTERED", 50, height-290);
        break;
      case '0':
        text("video: HIDE", 50, height-290);
        break;
    }
  }
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
void red2Toggle(boolean theFlag) {
  redRangeHue2.setVisible(theFlag);
  redRangeSat2.setVisible(theFlag);
  redRangeVal2.setVisible(theFlag);
  if (theFlag) {
    cp5.getController("red2Toggle").setColorActive(color(15,255,80));
  }else{
     cp5.getController("red2Toggle").setColorActive(color(255,15,80));
  }
}
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
             
  red2Toggle = cp5.addToggle("red2Toggle")
       .setPosition(290,height-315)
       .setSize(50,20)
       .setBroadcast(false)
       .setValue(true)
       .setBroadcast(true)
       .setMode(ControlP5.SWITCH)
       .setColorActive(color(15,255,80))
       .setColorBackground(color(255))
       .setCaptionLabel("Red 2 Toggle");

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
   .setRange(1,500)
   .setValue(35)
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
   .setValue(80)
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
   .setValue(30)
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
   .setRange(50,500)
   .setValue(80)
   .setColorForeground(color(255,0,0))
   .setColorActive(color(255,0,0,125))
   .setColorBackground(color(255,255,255))
   .setColorValueLabel(255)
   .setScrollSensitivity(0.2)
   .setDirection(Controller.HORIZONTAL);
     maxSize.getCaptionLabel().toUpperCase(false);
}

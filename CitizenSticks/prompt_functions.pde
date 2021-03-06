 

/////////////////////////////////////////////////////////////////////////////////// 
/*
Code for loading, controlling and displaying the Prompt features
Also Includes the JSON load and save functions


*/

 
     
  class promptVisControl{
      JSONArray jwords,jvis;
     // JSONArray values;
      int queBothNum =0;
      public int bothNum;
      int queVisNum =0;
      public int visNum;
      int wlen,vlen;
      String prompt = " ";
      public String currPrompt = "";
      public String nextPrompt = "";
      public String currVis = "";
      public String nextVis = "";    
      public boolean pvis = false;
    
       //Constructor
      promptVisControl() {      
        loadJson();  
        //queBoth(queBothNum);
        
      }
     
          
          
     void queBothForward() {
        if (queBothNum < wlen-1 ) {
         queBothNum++;
        } else {
         queBothNum = 0;
        }
         queBoth(queBothNum);
      }
          
      void queBothBack() {   
        if (queBothNum > 0 ) {
          queBothNum--;
        } else {
          queBothNum = wlen-1;
        }
        queBoth(queBothNum);
      }
      
      
      void queVisForward() {
        if (queVisNum < vlen-1 ) {
         queVisNum++;
        } else {
         queVisNum = 1;
        }
         queVis(queVisNum);
      }
          
      void queVisBack() {   
        if (queVisNum > 1 ) {
          queVisNum--;
        } else {
          queVisNum = vlen-1;
        }
        queVis(queVisNum);
      }
    
    
          
      void queBoth(int num) {
        JSONObject session = jwords.getJSONObject(num); 
        queVisNum =num;
        int id = session.getInt("id");
         nextPrompt = session.getString("prompt");
         nextVis = session.getString("visual");
        println(id + ", QueBoth " + nextPrompt + ", " + nextVis);  
        objui.promptTxt.setText(nextPrompt + "\n" + nextVis);
        objui.visualTxt.setText(nextVis);
        //sendPromptVisToUi();      
      }
      
       void queVis(int num) {
        JSONObject session = jvis.getJSONObject(num); 
        int id = session.getInt("id");
         nextVis = session.getString("visual");
        println(id + ", QueVis " + nextVis); 
        objui.visualTxt.setText(nextVis);
       
        //sendVisToUi();      
      }
           
      void sendPromptVisToUi() {
          
          println("sendPrompt  ==>" + nextPrompt);  
      }
      
      void sendVisToUi() {
        // objui.currPromptTxt.setText(nextVis);
          println("sendPrompt  ==>" + nextVis);   
      }
           
      void loadBoth() {     
         currPrompt = nextPrompt; 
         println("loadBoth " + currPrompt);
         currVis = nextVis;
         bothNum = queBothNum;
         visNum = queVisNum;
         pvis = true;
         objui.currPromptTxt.setText(currPrompt);
         objui.currVisualTxt.setText(currVis);
      }
      
      void loadVis() {     
         currVis = nextVis;
          println("loadVis " + currVis);
           println("The vizNum " + queVisNum);
         visNum = queVisNum;
         objui.currVisualTxt.setText(currVis);
      }
         
      void togglePrompt() {
         pvis = !pvis;
      }
      
      
      /* 
      -- Be aware that these rectMode and maybe textAlign functions 
      -- will influence any other drawings that follow it
      -- unless explicitly reset to the default rectMode(CORNER)... etc
      */
      void displayPrompt(int x, int y, int opacity) {
        //the font to use
        textFont(helvBold60,60);
        
      // if (currPrompt != "Blank") { 
        if (pvis) {       
          //String currPrompt = "hi";
         // println("testOPac  --- " + opacity);
          noStroke();
          textSize(60);
          pushMatrix();
          translate(x,y);
          fill(20,30);
          rectMode(CENTER);
         // rect(0,0,500,100);
          rectMode(LEFT);
          fill(255,opacity);
         // fill(255);
          textAlign(CENTER);
          //text(currPrompt,0,15);
          
          //text(objui.cp5.get(Textfield.class,"promptInput").getText(), 0,15);  
         text(globalPromptText, 0,15);
          
          //text("",0,15);
          textAlign(LEFT);
          popMatrix();        
        }
     //  }
     
       //println("OO --" + opacity);
      }
      
      
      
      void reloadJson() {
        loadJson();   
      }
     
    
       void loadJson() {
        jwords = loadJSONArray("data/words.json");
        wlen = jwords.size();      
        jvis = loadJSONArray("data/vis.json");
        vlen = jvis.size();
        
    //   println("Hey -----" + vlen);
      
       }
        
      void saveJason() {         
         saveJSONArray(jwords, "data/words.json");
         saveJSONArray(jvis, "data/vis.json");
               
      }
           
  }   // END OF CLASS promptControl

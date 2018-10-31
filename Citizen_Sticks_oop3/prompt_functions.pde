

/////////////////////////////////////////////////////////////////////////////////// 
   
  class promptControl{
    JSONArray values;
    int quePromptNum =0;
    int promptNum;
    int len;
    String prompt = " ";
    String currPrompt = " . ";
    String nextPrompt = " . ";
    String quePromptStr;
    String queVisStr;
    
    boolean vis = true;
    
    promptControl() {      
      loadJson();      
    }
      
       
    int queForward() {
      if (quePromptNum < len-1 ) {
       quePromptNum++;
      } else {
       quePromptNum = 0;
      }
      int temp = quePromptNum;
      return temp;
    }
        
    int queBack() {
      
      if (quePromptNum > 0 ) {
        quePromptNum--;
      } else {
        quePromptNum = len-1;
      }
      
      int temp = quePromptNum;
      return temp;
      
    }
      
      
      void quePrompt(int num) {
        JSONObject session = values.getJSONObject(num); 
        int id = session.getInt("id");
        String quePromptStr = session.getString("prompt");
        String queVisStr = session.getString("visual");
        println(id + ", " + quePromptStr + ", " + queVisStr);   
        nextPrompt = quePromptStr;  
        sendPromptToUi();      
      }
      
      
      void sendPromptToUi() {
         // uiObj.UIPrompt = nextPrompt;
          println("sendPrompt  ==>" + nextPrompt);
          
      }
      
      
      void loadPrompt() {     
           currPrompt = nextPrompt;      
      }
      
      
      void showPrompt(boolean state ) {
         vis = state;
      }
      
      
      /* 
      -- Be aware that these rectMode and maybe textAlign functions 
      -- will influence any other drawings that follow it
      -- unless explicitly reset to the default rectMode(CORNER)... etc
      */
      void displayPrompt(int x, int y) {
        if (vis) {       
         // String currPrompt = "hi";
        textSize(50);
        pushMatrix();
        translate(x,y);
        fill(20,30);
        rectMode(CENTER);
        rect(0,0,500,100);
        rectMode(LEFT);
        fill(255);
        textAlign(CENTER);
        text(currPrompt,0,15); 
        //text("",0,15);
        textAlign(LEFT);
        popMatrix();        
        }
      }
      
      
      
      void reloadJson() {
        loadJson();   
      }
     
    
       void loadJson() {
         
        values = loadJSONArray("data/words.json");
        len = values.size();
          
          
        //for (int i = 0; i < len; i++) {
        //  JSONObject session = values.getJSONObject(i); 
        //  //int id = session.getInt("id");
        //  //String prompt = session.getString("prompt");
        //  //String vis = session.getString("visual");
        //  //println(id + ", " + prompt + ", " + vis);
        //}
      }
        
      void saveJason() {
         // default start for format
        //String[] prompts = {"Demo Phrase1","Demo Phrase2", "Trans-Disciplinary","Post-Internet","Agency", "Proliferation", "Sacred" };
        //String[] visuals = { "loops", "graph", "basic","loops", "chart", "basic","final" };
      
        //values = new JSONArray();
      
        //for (int i = 0; i < prompts.length; i++) {
      
        //  JSONObject session = new JSONObject();
        //  session.setInt("id", i);
        //  session.setString("prompt", prompts[i]);
        //  session.setString("visual", visuals[i]);
      
        //  values.setJSONObject(i, session);
        //}
      
        saveJSONArray(values, "data/words.json");
               
      }
           
  }   // END OF CLASS promptControl

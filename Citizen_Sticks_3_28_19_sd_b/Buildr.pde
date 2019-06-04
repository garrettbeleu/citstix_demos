
/*

// SD commenting needed (created Building and remove effect)

// Buildr Class that runs the visual builds/destroys Block objects
//  The Block class has moving and flocking methods to move and compare

*/


class Buildr {

  ArrayList<Blockr> blockCollectionR;
  ArrayList<Blockr> blockCollectionG;
  ArrayList<Blockr> blockCollectionB;
  int counter = 0;
  int gridSize = 30; //30
  int alphaAmnt = 20;
  
  //constructor
  Buildr() {  
   println("hey");
   
    blockCollectionR = new ArrayList();
    blockCollectionG = new ArrayList();
    blockCollectionB = new ArrayList();
  }

  void blockBuildMaster(float[][] ar, float[][] ag, float[][] ab, 
                         color kr, color kg,color kb, ArrayList cr,ArrayList cg,ArrayList cb) {
       
     
        
        

        
       // Grn ////////////////

        for (int i=0; i<ag.length; i++) {                                                    
              Vec3D origin =  new Vec3D(int(ag[i][0]/gridSize)*gridSize, int(ag[i][1]/gridSize)*gridSize, 0);  
              Blockr curB =  new Blockr(1,origin, this, cg, kg); 
              cg.add(curB);           
        }
                 
          
         for (int i = cg.size() - 1; i >= 0; i--) {            
            Blockr curG = (Blockr) cg.get(i);            
            if (curG.finished()) {
              cg.remove(i);
            }
          }
          

       
        for (int i = 0; i < cg.size(); i++) {
           Blockr newG = (Blockr) cg.get(i);
           newG.run(); 
        }
        
         // Red ////////////////  Actually blacks out or dims the green.
             
        for (int i=0; i<ar.length; i++) {                                                    
              Vec3D origin =  new Vec3D(int(ar[i][0]/gridSize)*gridSize, int(ar[i][1]/gridSize)*gridSize, 0);  
              Blockr curR =  new Blockr(0,origin, this, cr, kr); 
              cr.add(curR);           
        }
                 
          
         for (int i = cr.size() - 1; i >= 0; i--) {            
            Blockr curR = (Blockr) cr.get(i);            
            if (curR.finished()) {
              cr.remove(i);
            }
          }
          

       
        for (int i = 0; i < cr.size(); i++) {
           Blockr newR = (Blockr) cr.get(i);
           newR.run(); 
        }
        
        // Blu ////////////////////////// BRINGER OF CHANGE  // reduces the life of any object
        
           for (int i=0; i<ab.length; i++) {                                                    
            
             Vec3D origin =  new Vec3D(int(ab[i][0]/gridSize)*gridSize, int(ab[i][1]/gridSize)*gridSize, 0); 
            
              for (int j = cr.size() - 1; j >= 0; j--) { 
               // print("r" + j);
                Blockr newR = (Blockr) cr.get(j);
                  
                float distanceR = origin.distanceTo(newR.loc);
                   
                  if ( distanceR < 80 ) {
                    print("dr" + j);
                    newR.life = 20;
                    //cg.remove(j);
                  }       
              }
              
              
              for (int j = cg.size() - 1; j >= 0; j--) { 
               // print("g" + j);
                Blockr newG = (Blockr) cg.get(j);
                  
                float distanceG = origin.distanceTo(newG.loc);

                  if ( distanceG < 80 ) {
                   //  print("dg" + j);
                     newG.life = 20;
                    // cg.remove(j);
                  }       
              }
            
                       
            }
         
               
          //for (int i = cg.size() - 1; i >= 0; i--) {            
             
            
              
          //  //if (curB.finished()) {
          //  //  cg.remove(i);
          //  //}
          //}       
                 
                 
          //for (int i = cb.size() - 1; i >= 0; i--) {            
          //  Blockr curB = (Blockr) cb.get(i);            
          //  if (curB.finished()) {
          //    cb.remove(i);
          //  }
          //}

      
        //for (int i = 0; i < cb.size(); i++) {
        //   Blockr newB = (Blockr) cb.get(i);
        //   newB.run(); 
        //}
     
    
  }



  void pushToScreen() {
    //strokeWeight(3);
    rectMode(CORNER);
    noFill();
    //color(0,alphaAmnt)
   // color(0,0,200,alphaAmnt)
    blockBuildMaster(dsRed.data, dsGreen.data, dsBlue.data, color(10,alphaAmnt*2),color(0,255,0,alphaAmnt),color(0,0,255,alphaAmnt),
    blockCollectionR, blockCollectionG, blockCollectionB);
    
    // GB added
    if (objui.mainWindowDelay == true) {
      blockCollectionR.clear();
      blockCollectionG.clear();
      blockCollectionB.clear();
    }
    
  }
  
  
}

////////////// END OF CLASS Buildr ////////////////


////////////////////////////////// Begin Block  //////////////////


class Blockr { 
  //var available for the whole class
  float x = 0;
  float y = 0; 
  float speedX = 0; //random(-2.2);
  float speedY = 0; // random(-2.2);
  Buildr p;
  ArrayList c;
  color k;
 public int life = 3000; // 80

  public Vec3D loc =   new Vec3D(0, 0, 0);
  Vec3D speed = new Vec3D(random(-2, 2), random(-2, 2), 0);
  Vec3D grav =  new Vec3D(0, 0.2, 0);
  Vec3D acc = new Vec3D();

  //Constructor
  Blockr (int whichK, Vec3D _loc, Buildr _p, ArrayList _c, color _k) {  
    loc = _loc;
    p = _p;
    c = _c;
    k = _k;
    
  } 

  void run() {

    display();
    //move();
   // bounce();
   // gravity();
   
    core();

    
  }


  
   Vec3D getVect() {
     return loc;
   }

  //void align (float magnitude) {

  //  Vec3D steer = new Vec3D();
  //  int count = 0;

  //  for (int i = 0; i < c.size(); i++ ) {
  //    Blockr other = (Blockr) c.get(i);
  //    float distance = loc.distanceTo(other.loc);

  //    if ( distance > 0 && distance < 40) {

  //      steer.addSelf(other.speed);
  //      count++;
  //    }
  //  }

  //  if ( count > 0 ) {
  //    steer.scaleSelf(1.0/count);
  //  }

  //  steer.scaleSelf(magnitude);
  //  acc.addSelf(steer);
  //}


  //void cohesion(float magnitude) {

  //  Vec3D sum = new Vec3D();
  //  int count = 0;

  //  for (int i = 0; i < c.size(); i++ ) {
  //    Blockr other = (Blockr) c.get(i);
  //    float distance = loc.distanceTo(other.loc);

  //    if ( distance > 0 && distance < 40) {
  //      sum.addSelf(other.loc);
  //      count++;
  //    }
  //  }

  //  if ( count > 0) {
  //    sum.scaleSelf(1.0/count);
  //  }
  //  Vec3D steer = sum.sub(loc);

  //  steer.scaleSelf(magnitude);
  //  acc.addSelf(steer);
  //}




  //void seperate(float magnitude) {

  //  Vec3D steer = new Vec3D();
  //  int count = 0;

  //  for (int i = 0; i < c.size(); i++ ) {
  //    Blockr other = (Blockr) c.get(i);
  //    float distance = loc.distanceTo(other.loc);

  //    if ( distance > 0 && distance < 40) {

  //      Vec3D diff = loc.sub(other.loc);
  //      diff.normalizeTo(1.0/distance);

  //      steer.addSelf(diff);
  //      count++;
  //    }
  //  }

  //  if ( count > 0) {
  //    steer.scaleSelf(1.0/count);
  //  }
  //  steer.scaleSelf(magnitude);
  //  acc.addSelf(steer);
  //}



  void core() {

    //adding core

    for (int i = 0; i < c.size(); i++ ) {

      Blockr other = (Blockr) c.get(i);

      float distance = loc.distanceTo(other.loc);

      if ( distance > 60 && distance < 80) {
        //strokeWeight(40/distance);
        rectMode(CENTER);
        fill(k);
        rect(loc.x, loc.y, 15,15,3);
      }
    }
  }

  void display() { 
  
        rectMode(CENTER);
        fill(k);
        stroke(k);
        rect(loc.x, loc.y, 30,30,6); 
  } 
  
  
  //void move() {

  //  speed.addSelf(acc);
  //  speed.limit(2);

  //  loc.addSelf(speed);

  //  acc.clear();
  //}

  void bounce() {

    if ( loc.x > width) {
      speed.x = - speed.x;
    }
    if (loc.x < 0) {
      speed.x = - speed.x;
    }

    if ( loc.y > height+10) {
      speed.y = -speed.y;
    }
    if (loc.y < 0) {
      speed.y = -speed.y;
    }
  }

  //void gravity() {
  //  speed.addSelf(grav);
  //}
  
  
  boolean finished() {
    // Balls fade out
    life--;
    if (life < 0) {
      return true;
    } else {
      return false;
    }
  }
   
  
} 

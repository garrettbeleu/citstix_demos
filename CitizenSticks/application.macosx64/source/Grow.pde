/*

// SD commenting needed (created blocky effect)

// Grow Class that runs the visual birthes/destroys Block objects
//  The Block class has moving and flocking methods to move and compare


*/


class Grow {

  ArrayList<Block> blockCollectionR;
  ArrayList<Block> blockCollectionG;
  ArrayList<Block> blockCollectionB;
  int counter = 0;
  int gridSize = 30;
  
  //constructor
  Grow() {  
    blockCollectionR = new ArrayList();
    blockCollectionG = new ArrayList();
    blockCollectionB = new ArrayList();
  }

  void blockGrowthMaster(float[][] ar, float[][] ag, float[][] ab, 
                         color kr, color kg,color kb, ArrayList cr,ArrayList cg,ArrayList cb) {

      // if (inputArray.length>0) {
        
         // Red ////////////////
             
        for (int i=0; i<ar.length; i++) {                                                    
                Vec3D origin =  new Vec3D(int(ar[i][0]/gridSize)*gridSize, int(ar[i][1]/gridSize)*gridSize, 0);  
                Block curB =  new Block(origin, this, cr, kr); 
                cr.add(curB);           
            }
                 
        for (int i = cr.size() - 1; i >= 0; i--) {            
          Block curB = (Block) cr.get(i);            
          if (curB.finished()) {
            cr.remove(i);
          }
        }

        for (int i = 0; i < cr.size(); i++) {
                 Block newB = (Block) cr.get(i);
                 newB.run(); 
        }
        
       // Grn ////////////////

          for (int i=0; i<ag.length; i++) {                                                    
                Vec3D origin =  new Vec3D(int(ag[i][0]/gridSize)*gridSize, int(ag[i][1]/gridSize)*gridSize, 0);  
                Block curB =  new Block(origin, this, cg, kg); 
                cg.add(curB);           
            }
                 
          for (int i = cg.size() - 1; i >= 0; i--) {            
            Block curB = (Block) cg.get(i);            
            if (curB.finished()) {
              cg.remove(i);
            }
          }

        // sd should this be grn objects????
        for (int i = 0; i < cg.size(); i++) {
           Block newB = (Block) cg.get(i);
           newB.run(); 
        }
        
        // Blu //////////////////////////
        
           for (int i=0; i<ab.length; i++) {                                                    
                Vec3D origin =  new Vec3D(int(ab[i][0]/gridSize)*gridSize, int(ab[i][1]/gridSize)*gridSize, 0);  
                Block curB =  new Block(origin, this, cb, kb); 
                cb.add(curB);           
            }
                 
          for (int i = cb.size() - 1; i >= 0; i--) {            
            Block curB = (Block) cb.get(i);            
            if (curB.finished()) {
              cb.remove(i);
            }
          }

      
        for (int i = 0; i < cb.size(); i++) {
           Block newB = (Block) cb.get(i);
           newB.run(); 
        }
     
    
  }



  void pushToScreen() {
    //strokeWeight(3);
    rectMode(CORNER);
    noFill();
    blockGrowthMaster(dsRed.data, dsGreen.data, dsBlue.data, color(255,0,0,9),color(0,255,0,9),color(0,0,255,9),
    blockCollectionR, blockCollectionG, blockCollectionB);
    
    // GB added
    if (mainWindowDelay == true) {
      blockCollectionR.clear();
      blockCollectionG.clear();
      blockCollectionB.clear();
    }
    
  }
  
  
}

////////////// END OF CLASS PUDDLE ////////////////


////////////////////////////////// Begin Orb  //////////////////


class Block { 
  //var available for the whole class
  float x = 0;
  float y = 0; 
  float speedX = 0; //random(-2.2);
  float speedY = 0; // random(-2.2);
  Grow p;
  ArrayList c;
  color k;
  int life = 80;

  Vec3D loc =   new Vec3D(0, 0, 0);
 // Vec3D speed = new Vec3D(random(-2, 2), random(-2, 2), 0);
  Vec3D speed = new Vec3D(random(-2, 2), random(-2, 2), 0);
  Vec3D grav =  new Vec3D(0, 0.2, 0);
  Vec3D acc = new Vec3D();

  //Constructor
  Block (Vec3D _loc, Grow _p, ArrayList _c, color _k) {  
    loc = _loc;
    p = _p;
    c = _c;
    k = _k;
    
  } 

  void run() {

    display();
    //move();
    bounce();
   // gravity();
    lineBetween();

    //flock();
  }


  void flock() {
    seperate(5);
    cohesion(.001);
    align(1.0);
  }


  void align (float magnitude) {

    Vec3D steer = new Vec3D();
    int count = 0;

    for (int i = 0; i < c.size(); i++ ) {
      Block other = (Block) c.get(i);
      float distance = loc.distanceTo(other.loc);

      if ( distance > 0 && distance < 40) {

        steer.addSelf(other.speed);
        count++;
      }
    }

    if ( count > 0 ) {
      steer.scaleSelf(1.0/count);
    }

    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }


  void cohesion(float magnitude) {

    Vec3D sum = new Vec3D();
    int count = 0;

    for (int i = 0; i < c.size(); i++ ) {
      Block other = (Block) c.get(i);
      float distance = loc.distanceTo(other.loc);

      if ( distance > 0 && distance < 40) {
        sum.addSelf(other.loc);
        count++;
      }
    }

    if ( count > 0) {
      sum.scaleSelf(1.0/count);
    }
    Vec3D steer = sum.sub(loc);

    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }




  void seperate(float magnitude) {

    Vec3D steer = new Vec3D();
    int count = 0;

    for (int i = 0; i < c.size(); i++ ) {
      Block other = (Block) c.get(i);
      float distance = loc.distanceTo(other.loc);

      if ( distance > 0 && distance < 40) {

        Vec3D diff = loc.sub(other.loc);
        diff.normalizeTo(1.0/distance);

        steer.addSelf(diff);
        count++;
      }
    }

    if ( count > 0) {
      steer.scaleSelf(1.0/count);
    }
    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }



  void lineBetween() {

    //ballCollection

    for (int i = 0; i < c.size(); i++ ) {

      Block other = (Block) c.get(i);

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
  void move() {

    speed.addSelf(acc);
    speed.limit(2);

    loc.addSelf(speed);

    acc.clear();
  }

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

  void gravity() {
    speed.addSelf(grav);
  }
  
  
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

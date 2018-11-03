

class Grow {

  ArrayList blockCollectionR;
  ArrayList blockCollectionG;
  ArrayList blockCollectionB;
  int counter = 0;

  //constructor
  Grow() {  
    blockCollectionR = new ArrayList();
    blockCollectionG = new ArrayList();
    blockCollectionB = new ArrayList();
  }

  void blockGrowth(float[][] inputArray, color k, ArrayList collection) {

       if (inputArray.length>1) {

        for (int i=0; i<inputArray.length; i++) {

         // Vec3D origin =  new Vec3D(random(width), random(200), 0);  
          
          Vec3D origin =  new Vec3D(inputArray[i][0],inputArray[i][1], 0); 
          Block curB =  new Block(origin, this, collection, k); 
          collection.add(curB);
          
          //curOrb.run();
        }

        for (int i = collection.size() - 1; i >= 0; i--) {
          
          Block curB = (Block) collection.get(i);
          
          if (curB.finished()) {
            collection.remove(i);
          }
        }


       //println("--" + collection.size());

        //if (collection.size() > 30 ) {
        //  for (int i=0; i<inputArray.length; i++) {
        //    println("woot");
        //    collection.remove(i);
        //  }
        //}


        for ( int i = 0; i < collection.size(); i++) {
            Block newB = (Block) collection.get(i);
           newB.run(); 
        }
      }
    
  }



  void pushToScreen() {
    // strokeWeight(3);
    noFill();
    blockGrowth(dsRed.data,   color(255,0,0,5), blockCollectionR);
    blockGrowth(dsGreen.data, color(0,255,0,5), blockCollectionG);
    blockGrowth(dsBlue.data,  color(0,0,255,5), blockCollectionB);
  }
  
  
}

////////////// END OF CLASS PUDDLE ////////////////


////////////////////////////////// Begin Orb  //////////////////


class Block { 
  //var available for the whole class
  float x = 0;
  float y = 0; 
  float speedX = random(-2.2);
  float speedY = random(-2.2);
  Grow p;
  ArrayList c;
  color k;
  int life = 50;

  Vec3D loc =   new Vec3D(0, 0, 0);
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
    move();
    bounce();
    //gravity();
    lineBetween();

    flock();
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

      if ( distance > 0 && distance < 60) {
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

      if ( distance > 0 && distance < 40) {
        //strokeWeight(40/distance);
        fill(k);
        rect(loc.x, loc.y, other.loc.x, other.loc.y);
      }
    }
  }

  void display() { 
    fill(k);
    rect(loc.x, loc.y, loc.z, loc.z);
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

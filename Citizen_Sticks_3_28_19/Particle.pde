/*
=.=.=.=.=.=.=.=.=.=.=.=.=.=.=.=.
    Particle Visualization
=.=.=.=.=.=.=.=.=.=.=.=.=.=.=.=.
*/
/*
_____NOTES_____
play with acceleration, velocity and opacity to find the best look
*/

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float opacity;
  float size;
  color finalColor;
  
  Particle(PVector l, color _finalColor, int theCount) {
    
    if(theCount==0) {
      //down
      acceleration = new PVector(0, random(0.5,1.5) );
      velocity = new PVector(0, random(3, 5));  
    }
    if(theCount==1) {
      //left-down
      acceleration = new PVector(0.55, 0.25 );
      velocity = new PVector(10, 3); 
    }
    if(theCount==2) {
      //left
      acceleration = new PVector(0.25, 0.25 );
      velocity = new PVector(10, 0); 
    }
    if(theCount==3) {
      //circles
      acceleration = new PVector(0.15, 0.15 );
      velocity = new PVector(-10, 10); 
    }
    if(theCount==4) {
      //idk - death spiral
      acceleration = new PVector(0.15, 0.15 );
      velocity = new PVector(random(-10,-15),-10); 
    }

    
    //random direction fast
    //acceleration = new PVector(random(-10.05,10.05), random(-10.05,10.05) );
    //velocity = new PVector(random(-5, 5), random(-5, 5));
    
    //random direction slow
    //acceleration = new PVector(random(-0.05,0.05), random(-0.05,0.05) );
    //velocity = new PVector(random(-5, 5), random(-5, 5));
    
    
    position = new PVector(l.x,l.y);
    size = l.z; 
    opacity = 255.0;
    finalColor = _finalColor;
  }


  // Method to update position
  void update() {
    if(timerCount==0) {
      velocity.add(acceleration);
      position.add(velocity);
      opacity -= 9.5;
    }
    if(timerCount==1) {
      velocity.add(acceleration);
      position.add(velocity);
      opacity -= 7.5;
    }
    if(timerCount==2) {
      velocity.add(acceleration);
      position.add(velocity);
      opacity -= 9.5;
    }
    if(timerCount==3) {
      float inc = TWO_PI/80.0;
      velocity.add(acceleration.x,acceleration.y);
      position.add(sin(velocity.x)*10.5, sin(velocity.y)*10.5 );    
      opacity -= 6.5;
      velocity.x += inc;
      velocity.y += inc;
    }
    if(timerCount==4) {
      float inc = TWO_PI/24.0;
      velocity.add(acceleration.x*2,acceleration.y*2);
      position.add(sin(velocity.x)*65.5, sin(velocity.y)*-45.5 );    
      opacity -= 10.5;
      velocity.x += inc;
      velocity.y += inc;
    }
    
    
  }//end update

  // Method to display
  void display() {
    noStroke();
    //stroke(0, opacity);
    //strokeWeight(2);
    fill(finalColor, opacity);
    if(timerCount==0) { ellipse(position.x, position.y, (size+=0.5), (size+=0.5)); }
    if(timerCount==1) { ellipse(position.x, position.y, (size+=0.3), (size+=0.3)); }
    if(timerCount==2) { ellipse(position.x, position.y, (size+=0.4), (size+=0.4)); }
    if(timerCount==3) { ellipse(position.x, position.y, (size+=0.4), (size+=0.4)); }
    if(timerCount==4) { ellipse(position.x, position.y, (size+=0.5), (size+=0.5)); }
  }
  
  void run() {
    update();
    display();
  }

  // Kill it... or not
  boolean isDead() {
    // if it is off-screen or zero opacity, get ride of it!
    if (position.x<0 || position.x>width || position.y<0 || position.y>height || opacity<0) {
      //println("death zone!!!");
      return true;
    } else {
      return false;
    } 
  }  
  
}

/// function to run all the particle stuff
// - - - I can't figure out how to add this into the particle class, so here is a standalone function

void doParticleViz(float[][] r, float[][] g, float[][] b) {
 //make red particle  
  if (r.length>0) {
    for(int i=0; i<r.length; i++) {
      //make object for every input entry
      particles.add(new Particle(new PVector(r[i][0], r[i][1],r[i][2] ), color(150,0,0),timerCount ));
    }
  }
  //make green particle
  if (g.length>0) {
    for(int i=0; i<g.length; i++) {
      //make object for every input entry
      particles.add(new Particle(new PVector(g[i][0], g[i][1], g[i][2] ), color(0,150,0),timerCount ));
    }
  }
  //make blue particle
  if (b.length>0) {
    for(int i=0; i<b.length; i++) {
      //make object for every input entry
      particles.add(new Particle(new PVector(b[i][0], b[i][1], b[i][2] ), color(0,0,150),timerCount ));
    }
  } 
    
  
    // Looping through the Arraylist backwards to run and delete particles
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
    
    if(objui.mainWindowDelay == true) {
     particles.clear(); 
    }
  
  
}


//timer function for changing particle parameters

int dif;
int time = 0;
int timerCount=0;

int particleTimer(int duration) {
  if ((millis() - time) > duration) {
    //stuff happens here\\
    //println(timerCount);
    timerCount++;
    
    dif = millis()-time;
    time = millis(); //reset time
    if(timerCount>4) { timerCount=0;}
  }
  return timerCount;
}

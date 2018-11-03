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
  
  Particle(PVector l, color _finalColor) {
    //falling
    acceleration = new PVector(0, random(0.5,2.5) );
    velocity = new PVector(0, random(3, 5));
    
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

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    opacity -= 3.5;
  }

  // Method to display
  void display() {
    noStroke();
    //stroke(0, opacity);
    //strokeWeight(2);
    fill(finalColor, opacity);
    ellipse(position.x, position.y, size, size);
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
      particles.add(new Particle(new PVector(r[i][0], r[i][1],r[i][2] ), color(150,0,0) ));
    }
  }
  //make green particle
  if (g.length>0) {
    for(int i=0; i<g.length; i++) {
      //make object for every input entry
      particles.add(new Particle(new PVector(g[i][0], g[i][1], g[i][2] ), color(0,150,0) ));
    }
  }
  //make blue particle
  if (b.length>0) {
    for(int i=0; i<b.length; i++) {
      //make object for every input entry
      particles.add(new Particle(new PVector(b[i][0], b[i][1], b[i][2] ), color(0,0,150) ));
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
  
}

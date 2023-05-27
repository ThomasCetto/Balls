/*
It's important to note that the world of every ball is his father, and not the entire application
This means that each ball velocity is influenced only by his "brothers", when they crash into each other.
*/

class Ball{
  
  // actual ball things
  PVector position;
  PVector velocity;
  PVector acceleration;
  float radius;
  int[] rgb;
  
  // children things 
  int nChildren;
  int depth;
  ArrayList<Ball> children = new ArrayList<>();
  
  // father things
  PVector fatherPosition;
  Float fatherRadius;
  
  static final int N_GENERATIONS = 2;
  
  
  Ball(PVector pos, float radius, int nChildren, int[] rgb, int depth, PVector fatherPos, Float fatherRadius){
      this.radius = radius;
      this.rgb = rgb;
      this.nChildren = nChildren;
      this.depth = depth;  
    
      acceleration = new PVector(0,0); //TODO: cambiare accelerazione
      velocity = new PVector(radius/50, radius/50);
      position = pos;
      
      
      this.fatherPosition = fatherPos;
      this.fatherRadius = fatherRadius;
      
      // add children
      float childRadius = radius / 6;
      if(depth < Ball.N_GENERATIONS - 1){
        for(int i=0; i<nChildren; i++){
            children.add(
              new Ball(
                new PVector(
                  random(pos.x - radius + childRadius, pos.x + radius - childRadius),
                  random(pos.y - radius + childRadius, pos.y + radius - childRadius)
                ),
                childRadius,
                nChildren - 1,
                rgb,
                depth + 1,
                pos,
                radius
            ));
        }
      }
  }
  
  void run(){
    update();
    display();
  }
  
  void update(){
    velocity.add(acceleration);
    
    if(depth == 0){ // rectangular boundaries
      if(position.x - radius <= 0  || position.x + radius >= width){
         velocity.x *= -1; 
      }
      if(position.y - radius <= 0 || position.y + radius >= height){
         velocity.y *= -1; 
      }
    }else{ // round boundaries
       float bufferZone = 5;
       if (PVector.dist(position, fatherPosition) >= fatherRadius - radius - bufferZone) {
          // Calculate the vector from the father's center to the ball
          PVector ballToFather = PVector.sub(position, fatherPosition);
          ballToFather.normalize();
        
          // Calculate the new position of the ball by moving it just outside the buffer zone
          position = PVector.add(fatherPosition, PVector.mult(ballToFather, fatherRadius - radius - bufferZone));
        
          // Calculate the reflection vector
          float dotProduct = PVector.dot(velocity, ballToFather);
          PVector reflection = PVector.sub(velocity, PVector.mult(ballToFather, 2 * dotProduct));
        
          // Set the new velocity as the reflection vector
          velocity.set(reflection);
        }

    }
    
    position.add(velocity);
    
    
    for(Ball ball : children){
      ball.update();
      ball.display();
    }
  }
  
  void display(){
      stroke(color(rgb[0], rgb[1], rgb[2]));
      fill(255, 0);
      ellipse(position.x, position.y, radius*2, radius*2);
  }
  
}

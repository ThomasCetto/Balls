/*
  It's important to note that the world of every ball is his father, and not the entire application.
  This means that each ball velocity is influenced only by his "brothers", when they crash into each other, and not by the movement of the father by inertia.
*/

class Ball{
  // actual ball things
  PVector absolutePosition;
  PVector positionInFather;
  PVector velocity;
  float radius;
  int[] rgb;
  
  // children things 
  int nChildren;
  int depth;
  ArrayList<Ball> children = new ArrayList<>();
  
  // father things
  PVector fatherPosition;
  Float fatherRadius;
  
  static final int N_GENERATIONS = 3;
  static final float CHILD_RADIUS_DIVISOR = 2.5; // > 2 please
  
  
  
  
  
  Ball(float radius, int nChildren, int[] rgb, int depth, PVector fatherPos, Float fatherRadius){
      this.radius = radius;
      this.rgb = rgb;
      this.nChildren = nChildren;
      this.depth = depth;  
      this.fatherPosition = fatherPos;
      this.fatherRadius = fatherRadius;
    
      float vx = random(0, 5);
      float vy = 5 - vx;
      
      if(depth == 0){
        vx = vy = 2;
      }
    
      velocity = new PVector(vx + radius/50, vy * radius/50);
      
      if(depth == 0){
        positionInFather = new PVector(radius+100, radius+50);
        if(absolutePosition == null){
          absolutePosition = new PVector(0, 0);
        }
        absolutePosition.set(positionInFather);
      }else{
        positionInFather = new PVector(random(2*radius, 2*fatherRadius - 2*radius), random(2*radius, 2*fatherRadius - 2*radius)); //inside his father
        if(absolutePosition == null){
          absolutePosition = new PVector(0, 0);
        }
        absolutePosition.set(PVector.add(positionInFather, fatherPosition));
      }
      
      // add children
      float childRadius = radius / CHILD_RADIUS_DIVISOR;
      if(depth < Ball.N_GENERATIONS - 1){
        for(int i=0; i<nChildren; i++){
            children.add(
              new Ball(
                childRadius,
                nChildren,
                rgb,
                depth + 1,
                absolutePosition,
                radius
            ));
        }
      }
  }
  
  void update(){
    if(depth == 0){ // rectangular boundaries
      if(positionInFather.x - radius <= 0  || positionInFather.x + radius >= width){
         velocity.x *= -1; 
      }
      if(positionInFather.y - radius <= 0 || positionInFather.y + radius >= height){
         velocity.y *= -1; 
      }
    }else{ // round boundaries
       if (PVector.dist(positionInFather, new PVector(fatherRadius, fatherRadius)) >= fatherRadius - radius) { // if hits the rim or goes out
          PVector ballToFather = PVector.sub(positionInFather, new PVector(fatherRadius, fatherRadius));
          ballToFather.normalize();
          PVector reflection = PVector.sub(velocity, PVector.mult(ballToFather, 2 * PVector.dot(velocity, ballToFather)));
          velocity.set(reflection);
        }
    }
    positionInFather.add(velocity);
    
    
    if(depth == 0){
         absolutePosition.set(positionInFather);
    }else{
         absolutePosition.set(PVector.add(positionInFather, fatherPosition).sub(new PVector(fatherRadius, fatherRadius)));
    }
    
    for(Ball ball : children){
      ball.update();
      ball.display();
    }
  }
  
  void display(){
      stroke(color(rgb[0], rgb[1], rgb[2]));
      fill(255, 0);
      ellipse(absolutePosition.x, absolutePosition.y, radius*2, radius*2);
  }
  
  void run(){
    update();
    display();
  }
  
}

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
  ArrayList<Ball> brothers = new ArrayList<>();
 
  // father things
  PVector fatherPosition;
  Float fatherRadius;
 
  static final float SPEED = 1;
  static final int N_GENERATIONS = 7;
  static final float CHILD_RADIUS_DIVISOR = 2.5; // > 2 please
 
  Ball(float radius, int nChildren, int[] rgb, int depth, PVector fatherPos, Float fatherRadius, ArrayList<Ball> brothers){
      this.radius = radius;
      this.rgb = rgb;
      this.nChildren = nChildren;
      this.depth = depth;  
      this.fatherPosition = fatherPos;
      this.fatherRadius = fatherRadius;
      this.brothers = brothers;
   
      this.velocity = generateBallVelocity();
      generateBall();
      addChildren();
  }
 
  void update(){
    velocity.set(calculateVelocity());
    positionInFather.add(velocity);
    absolutePosition.set(getAbsolutePosition());
   
    updateChildren();
  }
 
  void generateBall(){
    if(absolutePosition == null){
       absolutePosition = new PVector(0, 0);
    }
    if(depth == 0){
        positionInFather = new PVector(random(radius + 3, width - radius - 3), random(radius + 3, height - radius - 3));
        absolutePosition.set(positionInFather);
      }else{
        positionInFather = new PVector(random(2*radius, 2*fatherRadius - 2*radius), random(2*radius, 2*fatherRadius - 2*radius)); //inside his father
        absolutePosition.set(PVector.add(positionInFather, fatherPosition));
      }
  }
 
  PVector generateBallVelocity(){
      // x + y velocities = Ball.SPEED -> so it's always the same speed
      float vx = (depth == 0) ? random(0.25*Ball.SPEED, 0.75*Ball.SPEED) : random(0, Ball.SPEED);
      if(random(0, 1) > 0.5) // 50% prob
        vx *= -1;
        
      
      float vy = Ball.SPEED - vx;
      
      if(depth == 0){
         vx = 0; //canc
          vy = 0; 
      }
        
      
      return new PVector(vx, vy);
  }
 
  void addChildren(){
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
                radius,
                children
            ));
        }
      }
  }
 
  PVector calculateVelocity(){
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
    return velocity;
  }
 
  void updateChildren(){
    for(Ball ball : children){
        ball.update();
        ball.display();
    }
  }
 
  PVector getAbsolutePosition(){
      if(depth == 0){
         return positionInFather;
      }else{
           return PVector.add(positionInFather, fatherPosition).sub(new PVector(fatherRadius, fatherRadius));
      }
  }
 
   void display(){
      stroke(color(rgb[0], rgb[1], rgb[2]));
      strokeWeight(1);
      fill(255, 0);
      ellipse(absolutePosition.x, absolutePosition.y, radius*2, radius*2);
  }
 
  void run(){
    update();
    display();
  }
 
}

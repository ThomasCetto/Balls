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
  final float STROKE_WEIGHT;
  boolean valid = true;
  
 
  // children things
  int depth;
  ArrayList<Ball> children = new ArrayList<>();
  ArrayList<Ball> brothers = new ArrayList<>();
 
  // father things
  PVector fatherPosition;
  Float fatherRadius;
 
  static final float SPEED = 1;
  static final int N_GENERATIONS = 5;
  static final float CHILD_RADIUS_DIVISOR = 3; // >= 2.5 please
  
 
  Ball(float radius, final int N_CHILDREN, int[] rgb, final float STROKE_WEIGHT, int depth, PVector fatherPos, Float fatherRadius, ArrayList<Ball> brothers){
      this.radius = radius;
      this.rgb = rgb;
      this.depth = depth;  
      this.fatherPosition = fatherPos;
      this.fatherRadius = fatherRadius;
      this.brothers = brothers;
      this.STROKE_WEIGHT = STROKE_WEIGHT;
   
      generateBall();
      this.velocity = generateBallVelocity();
      addChildren(N_CHILDREN);
  }
 
  void update(){
    velocity.set(calculateVelocity());
    positionInFather.add(velocity);
    absolutePosition.set(getAbsolutePosition());
   
    updateChildren();
  }
 
  void generateBall(){
    final int MAX_TRIES_OF_PLACING = 20;
    
    if(absolutePosition == null){
       absolutePosition = new PVector(0, 0);
    }
    if(depth == 0){
        // spaws inside the rectangle
        positionInFather = new PVector(random(radius + 3, width - radius - 3), random(radius + 3, height - radius - 3));
        absolutePosition.set(positionInFather);
      }else{
        // tries to not collide with the others inside the same ball
        int tries = 0;
        boolean overlapsABrother;
        do{
          overlapsABrother = false;
          positionInFather = generatePositionInFather();
          
          for(Ball brother : brothers){
              boolean collides = PVector.dist(positionInFather, brother.positionInFather) <= 2 * radius;
              
              if(collides){
                overlapsABrother = true;
                break;
              }
          }
          tries++;
          
        }while(overlapsABrother && tries < MAX_TRIES_OF_PLACING);
        
        valid = !overlapsABrother;
        PVector newAbsPos = valid ? PVector.add(positionInFather, fatherPosition) : new PVector(-100000, -100000);
        absolutePosition.set(newAbsPos);
      }
  }
  
  PVector generatePositionInFather() {
    float radians = random(TWO_PI);
    float deviation = (fatherRadius - radius) * sqrt(random(1));
    float cx = fatherRadius + deviation * cos(radians);
    float cy = fatherRadius + deviation * sin(radians);
    return new PVector(cx, cy);
    
  }
 
  PVector generateBallVelocity(){
      // x + y velocities = Ball.SPEED -> so it's always the same speed
      float vx = (depth == 0) ? random(0.25*Ball.SPEED, 0.75*Ball.SPEED) : random(0, Ball.SPEED);
      float vy = Ball.SPEED - vx;
      
      if(random(0, 1) > 0.5) // 50% prob
        vx *= -1;
      if(random(0, 1) > 0.5) // 50% prob
        vy *= -1;
        
      return new PVector(vx, vy);
  }
 
  void addChildren(final int N_CHILDREN){
      if(!valid) return;
    
      float childRadius = radius / CHILD_RADIUS_DIVISOR;
      if(depth < Ball.N_GENERATIONS - 1){ // if it can have babies
        for(int i=0; i<N_CHILDREN; i++){
            children.add(
              new Ball(
                childRadius,
                N_CHILDREN,
                rgb,
                STROKE_WEIGHT / 1.5,
                depth + 1,
                absolutePosition,
                radius,
                children
            ));
        }
      }
  }
 
  PVector calculateVelocity(){
    if(!valid) return null;
    
    if(depth == 0){ // rectangular boundaries
      if(positionInFather.x - radius <= 0  || positionInFather.x + radius >= width){
         velocity.x *= -1;
      }
      if(positionInFather.y - radius <= 0 || positionInFather.y + radius >= height){
         velocity.y *= -1;
      }
    }else{ // round boundaries
      boolean collidesWithTheFather = PVector.dist(positionInFather, new PVector(fatherRadius, fatherRadius)) >= fatherRadius - radius;
       if (collidesWithTheFather) {
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
        ball.run();
    }
  }
 
  PVector getAbsolutePosition(){
      return depth == 0 ? positionInFather :
          PVector.add(positionInFather, fatherPosition).sub(new PVector(fatherRadius, fatherRadius));
  }
 
   void display(){
      stroke(color(rgb[0], rgb[1], rgb[2]));
      strokeWeight(STROKE_WEIGHT);
      fill(255, 0);
      ellipse(absolutePosition.x, absolutePosition.y, radius*2, radius*2);
  }
 
  void run(){
    if(!valid) return;
    
    update();
    display();
  }
 
}

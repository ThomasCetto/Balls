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
  
  static final int N_GENERATIONS = 2;
  
  
  Ball(float radius, int nChildren, int[] rgb, int depth, PVector fatherPos, Float fatherRadius){
      this.radius = radius;
      this.rgb = rgb;
      this.nChildren = nChildren;
      this.depth = depth;  
    
      velocity = new PVector(radius/25, radius/25);
      
      if(depth == 0){
        positionInFather = new PVector(radius+100, radius+50);
      }else{
        positionInFather = new PVector(random(radius, 2*fatherRadius - radius), random(radius, 2*fatherRadius - radius));
      }
      
      this.fatherPosition = fatherPos;
      this.fatherRadius = fatherRadius;
      
      println(absolutePosition);
      
      // add children
      float childRadius = radius / 3;
      if(depth < Ball.N_GENERATIONS - 1){
        for(int i=0; i<nChildren; i++){
            children.add(
              new Ball(
                childRadius,
                nChildren - 1,
                rgb,
                depth + 1,
                absolutePosition,
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
    println("ciao");
    positionInFather.add(velocity);
    println("ciao2");
    
    
    if(depth == 0){
         absolutePosition = positionInFather.copy();
    }else{
         absolutePosition = PVector.add(positionInFather, fatherPosition).sub(new PVector(fatherRadius, fatherRadius));
    }
    
    println("ciao3");
    
    
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
  
}

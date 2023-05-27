class Ball{
  
  PVector position;
  PVector velocity;
  PVector acceleration;
  int radius;
  int[] rgb;
  int nChildren;
  
  
  Ball(int cx, int cy, int r, int nChildren, int[] rgb){
      acceleration = new PVector(0,0); //TODO: cambiare accellerazione
      velocity = new PVector(3, 5);
      position = new PVector(cx, cy);
      this.radius = r;
      this.rgb = rgb;
      this.nChildren = nChildren;
  }
  
  void run(){
    update();
    display();
  }
  
  void update(){
    velocity.add(acceleration);
    position.add(velocity);
    if(position.x - radius <= 0  || position.x + radius >= width){
       velocity.x *= -1; 
    }
    if(position.y - radius <= 0 || position.y + radius >= height){
       velocity.y *= -1; 
    }
  }
  
  void display(){
      stroke(255);
      fill(color(rgb[0], rgb[1], rgb[2]));
      ellipse(position.x, position.y, radius*2, radius*2);
  }
  
}

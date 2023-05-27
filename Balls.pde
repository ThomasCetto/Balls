Ball ball;

void setup() {
  size(800, 500);
  ball = new Ball(new PVector(400, 250), 150, 4, new int[]{33, 150, 243}, 0, null, null);
}

void draw(){
  background(0);
  ball.run();
}



/*


PVector position;      // Ball position
PVector velocity;      // Ball velocity
float radius;          // Ball radius
PVector center;        // Center of the circular boundary
float boundaryRadius;  // Radius of the circular boundary

void setup() {
  size(400, 400);

  // Initialize ball properties
  position = new PVector(150, 150);
  velocity = new PVector(6, 8);
  radius = 20;

  // Initialize circular boundary properties
  center = new PVector(width/2, height/2);
  boundaryRadius = 150;
}

void draw() {
  background(220);

  

  // Draw ball
  fill(255, 0, 0);
  ellipse(position.x, position.y, radius*2, radius*2);

  // Draw circular boundary
  noFill();
  stroke(0);
  ellipse(center.x, center.y, boundaryRadius*2, boundaryRadius*2);
}

*/

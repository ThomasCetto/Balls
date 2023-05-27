

Ball ball;

void setup() {
  size(800, 500);
  ball = new Ball(150, 1, new int[]{33, 150, 243}, 0, null, null);
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
  position = new PVector(200, 150);
  velocity = new PVector(8, 0);
  radius = 20;

  // Initialize circular boundary properties
  center = new PVector(width/2, height/2);
  boundaryRadius = 150;
}

void draw() {
  background(220);

  // Update ball position
  position.add(velocity);

  // Check for collision with circular boundary
  if (PVector.dist(position, center) >= boundaryRadius - radius) {
    PVector normal = PVector.sub(position, center); // Vector from center to ball
    normal.normalize(); // Normalize the normal vector
    PVector reflection = PVector.sub(velocity, PVector.mult(normal, 2 * PVector.dot(velocity, normal))); // Calculate the reflection vector
    velocity.set(reflection); // Set the new velocity as the reflection vector
  }

  // Draw ball
  fill(255, 0, 0);
  ellipse(position.x, position.y, radius*2, radius*2);

  // Draw circular boundary
  noFill();
  stroke(0);
  ellipse(center.x, center.y, boundaryRadius*2, boundaryRadius*2);
}*/

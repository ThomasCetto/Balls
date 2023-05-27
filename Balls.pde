

Ball ball;

void setup() {
  size(800, 500);
  ball = new Ball(150, 5, new int[]{33, 150, 243}, 0, null, null);
}

void draw(){
  background(0);
  ball.run();
}

Ball ball;

void setup() {
  size(800, 500);
  ball = new Ball(400, 250, 20, 5, new int[]{0, 255, 0});
}

void draw(){
  background(0);
  ball.run();
}

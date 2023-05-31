

ArrayList<Ball> balls = new ArrayList<>();
final int N_BALLS = 1;
final float R = 300;
final int N_CHILDREN = 2;
final float STROKE_WEIGHT = 3;


void setup() {
  size(1500, 800);
   
   generateBalls();
}

void draw(){
  background(0);
  for(Ball ball: balls){
   ball.run();
  }
  
  fill(255);
  noStroke();
}

void keyPressed() {
  if (keyCode == 82) { // R key
    balls.clear();
    generateBalls();
  }
}

void generateBalls(){
  for(int i=0; i<N_BALLS; i++){
      Ball ball = new Ball(R, N_CHILDREN, new int[]{(int)random(0, 255), (int)random(0, 255), (int)random(0, 255)}, STROKE_WEIGHT, 0, null, null, balls);
      balls.add(ball);
  }
}

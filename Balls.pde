ArrayList<Ball> balls = new ArrayList<>();

void setup() {
  size(1500, 800);
 
  int N_BALLS = 1;
 
  for(int i=0; i<N_BALLS; i++){
      Ball ball = new Ball(400, 1, new int[]{(int)random(0, 255), (int)random(0, 255), (int)random(0, 255)}, 0, null, null, null);
      balls.add(ball);
  }
 
}

void draw(){
  background(0);
  for(Ball ball: balls){
   ball.run();
  }
}

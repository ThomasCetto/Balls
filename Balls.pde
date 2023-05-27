ArrayList<Ball> balls = new ArrayList<>();

void setup() {
  size(1500, 800);
  Ball ball = new Ball(150, 2, new int[]{33, 150, 243}, 0, null, null);
  balls.add(ball);
  
  ball = new Ball(150, 2, new int[]{255,0,0}, 0, null, null);
  balls.add(ball);
  
  ball = new Ball(150, 2, new int[]{0,255,0}, 0, null, null);
  balls.add(ball);
  
  
}

void draw(){
  background(0);
  for(Ball ball: balls){
   ball.run(); 
  }
}

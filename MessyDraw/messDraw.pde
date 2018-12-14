PImage img;
Paint paint;
int subStep = 800;
float z = 0;

int imgIndex = -1;
boolean isStop = false;

void setup() {
  size(800,800);
  img = loadImage("test1.png");
  img.resize(height,height);
  paint = new Paint(new PVector(width/2, height/2));
  background(255, 255, 255);
  colorMode(HSB);
}

void draw() {
  //console.log(frameRate());
  if (!isStop) {
    for (int i = 0 ; i < subStep ; i++) {
      paint.update();
      paint.show();
      z+= 0.01;
    }
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    isStop = !isStop;
  } 
}

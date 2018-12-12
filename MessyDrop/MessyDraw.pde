PImage img;
Paint paint;
int subStep = 2000;
float z = 0;
void setup() {
  size(800, 800);
  img = loadImage("test1.png");
  img.resize(height, height);
  paint = new Paint(new PVector(width/2, height/2));
  background(255, 255, 255);
  colorMode(HSB);
}
void draw() {
  for (int i = 0 ; i < subStep ; i++) {
    paint.update();
    paint.show();
    z+= 0.01;
  }
  image(img, 0, 0);
  saveFrame("img/save####.png");
}

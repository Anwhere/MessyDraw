class Paint {
  boolean isDrawBlack = true;
  
  PVector ppos;
  PVector pos;
  PVector vel;
  PVector force;
  
  float maxSpeed = 3.0;
  float perception = 40;
  float bound = 60;
  float boundForceFactor = 0.16;
  float noiseScale = 100.0;
  float noiseInfluence = 1 / 20.0;
  
  float dropRate = 0.004;
  float dropRange = 40;
  color drawColor = color(0, 0, 0);
  float drawWeight = 1;
  float drawAlpha = 50;
  int count = 0;
  int maxCount = 200;
  
  Paint(PVector pos_) {
    pos = pos_.copy();
    ppos = pos_.copy();
    vel = new PVector(0, 0);
    force = new PVector(0, 0);
  }
  
  void update() {
    ppos = pos.copy();
    force.mult(0);
    
    // Add pixels force
    PVector target = new PVector(0, 0);
    float count = 0;
    for (int i = -floor(perception/2) ; i < perception/2 ; i++ ) {
      for (int j = -floor(perception/2) ; j < perception/2 ; j++ ) {
        if (i == 0 && j == 0)
          continue;
        int x = floor(pos.x+i);
        int y = floor(pos.y+j);
        if (x <= img.width - 1 && x >= 0 && y < img.height-1 && y >= 0) {
          float b = brightness(img.get(x, y));
          b = 1 - b/255.0;
          PVector p = new PVector(i, j);
          target.add(p.normalize().copy().mult(b).div(p.mag()));
          count++;
        }
      }
    }
    if (count != 0) {
      if (isDrawBlack)
        force.add(target.div(count));
      else 
        force.add(target.div(count).mult(-1));
    }
    
    // Add noise force
    float n = noise(pos.x/noiseScale, pos.y/noiseScale, z);
    n = map(n, 0, 1, 0, 5*TWO_PI);
    PVector p = PVector.fromAngle(n);
    if(force.mag() < 0.01)
      force.add(p.mult(noiseInfluence * 5));
    else
      force.add(p.mult(noiseInfluence));
    
    // Add bound force
    PVector boundForce = new PVector(0, 0);
    if (pos.x < bound) {
      boundForce.x = (bound-pos.x)/bound;
    } 
    if (pos.x > width - bound) {
      boundForce.x = (pos.x - width)/bound;
    } 
    if (pos.y < bound) {
      boundForce.y = (bound-pos.y)/bound;
    } 
    if (pos.y > height - bound) {
      boundForce.y = (pos.y - height)/bound;
    } 
    force.add(boundForce.mult(boundForceFactor));
    
    
    vel.add(force);
    vel.mult(0.9999);
    if (vel.mag() > maxSpeed) {
      vel.mult(maxSpeed/vel.mag());
    }
    
    pos.add(vel);
    if (pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0) {
      reset();
    }
    
  }
  void reset() {
    count = 0;
    //maxCount = 200;
    boolean hasFound = false;
    while (!hasFound) {
      pos.x = random(1)*width;
      pos.y = random(1)*height;
      if(brightness(img.get(floor(pos.x), floor(pos.y))) < 220 && isDrawBlack)
        hasFound = true;
      if(brightness(img.get(floor(pos.x), floor(pos.y))) >= 220 && !isDrawBlack)
        hasFound = true;
    }
    drawColor = img.get(floor(pos.x), floor(pos.y));
    ppos = pos.copy();
    vel.mult(0);
  }
  void show() {
    count++;
    if (count > maxCount)
      reset();
    stroke(drawColor, drawAlpha);
    strokeWeight(drawWeight);
    if (force.mag() > 0.1 && random(1) < dropRate) {
      //stroke(drawColor, 255);
      float boldWeight = drawWeight+random(5);
      //strokeWeight(boldWeight);
    }
    line(ppos.x, ppos.y, pos.x, pos.y);
    
    
    fadeLineFromImg(ppos.x, ppos.y, pos.x, pos.y);
  }
  
  /* Fade the pixels of the line */
  void fadeLineFromImg(float x1, float y1, float x2, float y2) {
    int xOffset = floor(abs(x1 - x2));
    int yOffset = floor(abs(y1 - y2));
    int step = xOffset < yOffset ? yOffset : xOffset;
    for (int i = 0 ; i < step ; i++) {
      int x = floor(x1 + (x2 - x1) * i / step);
      int y = floor(y1 + (y2 - y1) * i / step);
      color originColor = img.get(x, y);
      float a = brightness(originColor);
      if (isDrawBlack) {
        a = a + 50;
        a = a > 255 ? 255 : a;
        img.set(x, y, color(hue(originColor), saturation(originColor), a));
      } else {
        a = a - 50;
        a = a < 0 ? 0 : a;
        img.set(x, y, color(hue(originColor), saturation(originColor), a));
        
      }
    }
  }
  
}
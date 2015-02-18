
MondeVirtuel monde = new MondeVirtuel(this);

void setup() {
  monde.initialise();
}

void draw() {
 monde.paint();
 //if (frameCount % 10 == 0) println(frameRate);
}

void mouseDragged() {
  monde.onMouseDragged();
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  monde.onMouseWheel(e);
}


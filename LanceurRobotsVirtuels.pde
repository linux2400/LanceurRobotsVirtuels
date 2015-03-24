
MondeVirtuel monde = charger_monde(this,"");

void setup() {
  monde.initialise();
    // on attend que tous les robots soient initialises avant de lancer la simulation
  noLoop();
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


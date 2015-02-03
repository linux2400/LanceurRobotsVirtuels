
MondeVirtuel monde = new MondeVirtuel();
ObstacleMartien caillou = new ObstacleMartien();

import java.io.File;
import java.util.List;
import java.util.LinkedList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

List<String> trouver_robots() {
  // trouver tous les robots dans le repertoire sketch
  File folder = new File(sketchPath);
  File[] listOfFiles = folder.listFiles();
  List<String> robots = new LinkedList<String>();
  Pattern p = Pattern.compile("robot(.+).pde");
  for(int i = 0; i < listOfFiles.length; i++)
  {
    Matcher m = p.matcher(listOfFiles[i].getName());
    if(m.find())
    {
      robots.add(m.group(1));
    }
  }
  return robots;
}

void setup() {
  monde.initialise();
  caillou.initialise(0.0,200.0,5.0);
  monde.ajoute(caillou);
  
  List<String> nom_robots = trouver_robots();
  Iterator<String> it = nom_robots.iterator();
  while(it.hasNext())
  {
    String s = it.next();
    thread("programme" + s);
    println(s);
  }
}

void draw() {
 monde.paint();
 if (frameCount % 10 == 0) println(frameRate);
}

void mouseDragged() {
  monde.onMouseDragged();
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  monde.onMouseWheel(e);
}


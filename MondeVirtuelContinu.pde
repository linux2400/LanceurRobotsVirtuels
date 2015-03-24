import java.util.List;
import java.util.LinkedList;
import java.util.Iterator;

import java.io.File;
import java.util.List;
import java.util.LinkedList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/** contient un objet qui gere le monde virtuel.
*/
class MondeVirtuelContinu extends MondeVirtuel {
  // pas de temps simulation
  float dt;
  float tprec, tactu;
  
  // constructeur
  public MondeVirtuelContinu(PApplet _context) {
    super(_context);  
  }
  
  public PApplet context() {
    return context; 
  }
  
  // chargement du monde 
  void charge_monde() {
    // l'environnement
    environnement = new SolideOBJ();
    environnement.charge("data/mars1.obj",1/100.0); 
   // les obstacles
    //Obstacle caillou = new Obstacle(0.0,0.0,5.0);
    Obstacle caillou = new Obstacle(new Position(0.0,0.0,0.0));
    // les positions de depart possibles des robots
    positions_robots = new ArrayList<Position>();
    positions_robots.add(new Position(-1000,0,0));
    positions_robots.add(new Position(600,-600,3*PI/4));
    positions_robots.add(new Position(-600,600,PI/4));
    positions_robots.add(new Position(600,600,PI/4));
} 
  // fonction qui est appelle a chaque affichage
  void simule() {
    // avance la simu en temps
    Iterator<Robot> iterator = robots.iterator();
   tactu = millis();
   dt = (tactu - tprec)/1000.0;
    while (iterator.hasNext()) {
      // le test de collision se fait maintenant dans la fonction "deplace".   
      iterator.next().deplace(dt);
    }
    tprec = tactu;
  }
};


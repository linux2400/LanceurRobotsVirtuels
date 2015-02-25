// contient un objet qui gere le monde virtuel
import java.util.List;
import java.util.LinkedList;
import java.util.Iterator;

import java.io.File;
import java.util.List;
import java.util.LinkedList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Position {
  float x;
  float y;
  float Rz;
  Position(float _x, float _y, float _Rz) {
    x = _x;
    y = _y;
    Rz = _Rz;
  }  
}

class MondeVirtuel {
  // pas de temps simulation
  float dt;
  float tprec, tactu;
  // nombre d'images par secondes
  int fRate;
  // position camera
  float r_camera, theta_camera, phi_camera;
  float x_camera, y_camera, z_camera;
  Solide environnement;
  //PImage textureSol;
  // l'applet processing dans lequel ce monde est charge
  PApplet context;
  // les robots
  List<RobotMartien> robots;
  // le nombre de robots qui ont ete trouves
  int nombre_de_robots;
  // les obstacles
  List<ObstacleMartien> obstacles;
  // les positions de depart possibles pour les robots
  List<Position> positions_robots;
  boolean robots_ok;
  
  // constructeur
  public MondeVirtuel(PApplet _context) {
    context = _context;
    robots = new LinkedList<RobotMartien>();
    obstacles = new LinkedList<ObstacleMartien>();
    robots_ok = false;  
  }
  
  public PApplet context() {
    return context; 
  }
  
  private List<String> trouver_robots() {
  // trouver tous les robots dans le repertoire sketch
  File folder = new File(sketchPath);
  File[] listOfFiles = folder.listFiles();
  List<String> noms_robots = new LinkedList<String>();
  Pattern p = Pattern.compile("robot(.+).pde");
  for(int i = 0; i < listOfFiles.length; i++)
  {
    Matcher m = p.matcher(listOfFiles[i].getName());
    if(m.find())
    {
      noms_robots.add(m.group(1));
      println(m.group(1));
    }
  }
  return noms_robots;
}

  // initialisation du rendu 3D
  void initialise_3d(){
    size(640, 480, P3D);
    fRate = 30;
    noStroke();    
    // le sol est en Z=0. L'axe Z est dirige vers le haut de l'ecran
    r_camera = 555.0;
    phi_camera = PI/4;
    theta_camera = 1.1;
    x_camera = r_camera*sin(theta_camera)*cos(phi_camera);
    y_camera = r_camera*sin(theta_camera)*sin(phi_camera);
    z_camera = r_camera*cos(theta_camera);
    camera(x_camera, y_camera, z_camera, 0.0, 0.0, 0, 0, 0, -1.0);
    // vitesse affichage
    frameRate(fRate);
  }


  // chargement du monde 
  void charge_monde() {
    // l'environnement
    environnement = new SolideOBJ();
    environnement.charge("data/mars1.obj",1/30.0); 
   // les obstacles
    ObstacleMartien caillou = new ObstacleMartien(0.0,0.0,5.0);
    // les positions de depart possibles des robots
    positions_robots = new ArrayList<Position>();
    positions_robots.add(new Position(300,300,5*PI/4));
    positions_robots.add(new Position(300,-300,3*PI/4));
    positions_robots.add(new Position(-300,300,-PI/4));
    positions_robots.add(new Position(-300,-300,PI/4));
} 
  
  void initialise_robots() {
    List<String> nom_robots = trouver_robots();
    nombre_de_robots = nom_robots.size();
    Iterator<String> it = nom_robots.iterator();
    while(it.hasNext())
    {
      String s = it.next();
      thread("programme" + s);
      delay(10);
      println(s);
    }
  }
 
  void initialise() {
    initialise_3d();
    charge_monde();
    initialise_robots();  
    tprec = millis();
  }
  
  // fonction qui est appelle a chaque affichage
  void paint() {
    if(!robots_ok) return;
    // avance la simu en temps
    Iterator<RobotMartien> iterator = robots.iterator();
   tactu = millis();
   dt = (tactu - tprec)/1000.0;
    while (iterator.hasNext()) {
      // le test de collision se fait maintenant dans la fonction "deplace".   
      iterator.next().deplace(dt);
    }
    tprec = tactu;
    // affiche les objets
    background(0);
    //lights();
    ambientLight(125, 100, 100);
    directionalLight(150, 128, 128, 0, 1, -1);
    afficheSol();
    iterator = robots.iterator();
    while (iterator.hasNext()) {
      iterator.next().affiche();
    }
    Iterator<ObstacleMartien> iterator2 = obstacles.iterator();
    while (iterator2.hasNext()) {
      iterator2.next().affiche();
    }
  }

  boolean testeCollision(PolygoneConvexe test) {
    // test for collisions with obstacles
    Iterator<ObstacleMartien> iterator2 = obstacles.iterator();
    while(iterator2.hasNext())
    {
      ObstacleMartien o = iterator2.next();
      if(test.intersecte(o.enveloppe))
      {
        return true;
      }        
    }
    
    // test for collisions with other robots
    Iterator<RobotMartien> iterator3 = robots.iterator();
    while(iterator3.hasNext())
    {
      RobotMartien o = iterator3.next();
      if(o.enveloppe != test && o.faisceau != test && test.intersecte(o.enveloppe))
      {
        return true;
      }        
    }
    
    
    return false;  
  }
  
  // evenements souris
  void onMouseDragged() {
    float rate = 0.005;
    phi_camera -= (pmouseX-mouseX) * rate;
    phi_camera = phi_camera % (2*PI);    
    theta_camera += (pmouseY-mouseY) * rate;
    theta_camera = constrain(theta_camera, 0.0001, PI/2.0-0.001);
    x_camera = r_camera*sin(theta_camera)*cos(phi_camera);
    y_camera = r_camera*sin(theta_camera)*sin(phi_camera);
    z_camera = r_camera*cos(theta_camera);
    camera(x_camera, y_camera, z_camera, 0.0, 0.0, 0, 0, 0, -1.0);
  }
  void onMouseWheel(float e) {
    float rate = 0.01;
    if(e>0) {
      r_camera = r_camera*(1.0+e*rate);
    } else {
      r_camera = r_camera/(1+abs(e)*rate);
    }
    x_camera = r_camera*sin(theta_camera)*cos(phi_camera);
    y_camera = r_camera*sin(theta_camera)*sin(phi_camera);
    z_camera = r_camera*cos(theta_camera);
    camera(x_camera, y_camera, z_camera, 0.0, 0.0, 0, 0, 0, -1.0);    
  }
  // affichage du sol
  void afficheSol() {
    lights();
    environnement.affiche();
  }
  
  // ajouter un robot
  void ajoute(RobotMartien robot)
  {
    // on verifie si il reste de la place
    if(robots.size() < positions_robots.size())
    {
      Position p = positions_robots.get(robots.size());
      robot.position_initiale(p);
      robots.add(robot);
    }     
    // si tous les robots ont ete charges, ou bien si tous les emplacements ont ete utilises, on lance la simu
    if(robots.size() == nombre_de_robots || robots.size() == positions_robots.size())
    {
      robots_ok = true;
      loop(); 
    }
  }
  
  // ajouter un obstacle
  void ajoute(ObstacleMartien obstacle)
  {
     obstacles.add(obstacle);
  }
};


// contient un objet qui gere le monde virtuel
import java.util.List;
import java.util.LinkedList;
import java.util.Iterator;

public class MondeVirtuel {
  // pas de temps simulation
  float dt;
  float tprec, tactu;
  // nombre d'images par secondes
  int fRate;
  // position camera
  float r_camera, theta_camera, phi_camera;
  float x_camera, y_camera, z_camera;
  // dimension du monde physique
  int size_x, size_y;
  PImage textureSol;
  // les robots
  List<RobotMartien> robots;
  // les obstacles
  List<ObstacleMartien> obstacles;
  
  // constructeur
  MondeVirtuel() {
    robots = new LinkedList<RobotMartien>();
    obstacles = new LinkedList<ObstacleMartien>();  
  }
  
  // initialisation du monde virtuel
  void initialise(){
    // taille du monde
    size_x = 1200;
    size_y = 1200;
    textureSol = loadImage("data/textureSol.jpg");
    textureMode(NORMAL);
    // initialisation 3D, etc...
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
    // pas de temps simulation
    //dt = 1.0 / fRate;
    tprec = millis();
  }
  // fonction qui est appelle a chaque affichage
  void paint() {
    // avance la simu en temps
    Iterator<RobotMartien> iterator = robots.iterator();
    while (iterator.hasNext()) {
      // le test de collision se fait maintenant dans la fonction "deplace".
      tactu = millis();
      dt = (tactu - tprec)/1000.0;      
      iterator.next().deplace(dt);
      tprec = tactu;
    }
    // affiche les objets
    background(0);
    lights();
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

  boolean testeCollision(PolygoneConvexe enveloppe) {
    // test for collisions with obstacles
    Iterator<ObstacleMartien> iterator2 = obstacles.iterator();
    while(iterator2.hasNext())
    {
      ObstacleMartien o = iterator2.next();
      if(enveloppe.intersecte(o.enveloppe))
      {
        return true;
      }        
    }
    
    // test for collisions with other robots
    Iterator<RobotMartien> iterator3 = robots.iterator();
    while(iterator3.hasNext())
    {
      RobotMartien o = iterator3.next();
      if(o.enveloppe != enveloppe && o.faisceau != enveloppe && enveloppe.intersecte(o.enveloppe))
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
    beginShape();
    texture(textureSol);
    fill(255);
    //rect(0, 0, size_x, size_y); // en fait on fait suivant x et z a cause du rotate
    vertex(-size_x/2.0, -size_y/2.0, 0, 0);
    vertex(size_x/2.0, -size_y/2.0, 1, 0);
    vertex(size_x/2.0, size_y/2.0, 1, 1);
    vertex(-size_x/2.0, size_y/2.0, 0, 1);
    endShape(); 
  }
  
  // ajouter un robot
  void ajoute(RobotMartien robot)
  {
    robots.add(robot); 
  }
  
  // ajouter un obstacle
  void ajoute(ObstacleMartien obstacle)
  {
    obstacles.add(obstacle); 
  }
};


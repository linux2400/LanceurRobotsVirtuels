public class RobotBoumBot extends Robot {
  // position et direction
  float x,y,z, Rz;
  // vitesse des roues
  float vitesseG, vitesseD;
  // vitesse max des roues
  float vitesseMax=100; 
  // distance entre les roues
  float dRoues = 120;
  // corps en 3D
  SolideSTL corps3D;
  // capteur de distance
  public PolygoneConvexe faisceau;
  
  // constructeur
  public RobotBoumBot() {
    
  }
 
  public void initialise() {

    // chargement des fichiers
    float facteur = 1.0;   
    corps3D = new SolideSTL();
    corps3D.charge("data/BoumBot.stl", facteur);
  
    // initialisation vitesse et angle des roues
    vitesseG = 0;
    vitesseD = 0;
    
    // calcul du plus petit cube contenant le robot   
    enveloppe = corps3D.enveloppe();
    enveloppe.translate(x,y);
    enveloppe.tourne(x,y,Rz);
    
    // construction du faisceau
    ArrayList<Point> f = new ArrayList<Point>(3);
    f.add(new Point(100,0));
    f.add(new Point(150,-30));
    f.add(new Point(150,30));
    faisceau = new PolygoneConvexe(f);

    super.initialise();
  }
  
  public void position_initiale(Position p)
  {
    super.position_initiale(p);
    faisceau.translate(x, y);
    faisceau.tourne(x, y, Rz);
  }

  
  public void affiche() {
    //fill(200);
    //fill(255,255,50);
    fill(243, 214, 23);
    //fill(255, 255, 5);
    //fill(15, 157, 232);
    //fill(44, 117, 255);
    pushMatrix();
    translate(x, y, z);
    rotate(Rz);
    corps3D.affiche();

    popMatrix();    
    noFill();
    //affichage de l'enveloppe en rouge
    //fill(255,0,0);
    //enveloppe.affiche();
    // affichage du faisceau en vert
      //fill(0,255,0);
      //faisceau.affiche();
      //noFill();

  }
  
  public void avance() {
    vitesseG = vitesseMax;
    vitesseD = vitesseMax;
    monde.pas_de_temps();
  }

  public void recule() {
    vitesseG = -vitesseMax;
    vitesseD = -vitesseMax;
    monde.pas_de_temps();
  }

  public void arrete() {
    vitesseG = 0;
    vitesseD = 0;
  }

  public void tourneDroite() {
    vitesseG = vitesseMax;
    vitesseD = -vitesseMax;
    monde.pas_de_temps();
  }

  public void tourneGauche() {
    vitesseG = -vitesseMax;
    vitesseD = vitesseMax;
    monde.pas_de_temps();
  }

  public void pasADroite() {
    vitesseG = vitesseMax;
    vitesseD = 0;
  }

  public void pasAGauche() {
    vitesseG = 0;
    vitesseD = vitesseMax;
  }

  public void vitesseGauche(int v) {
    vitesseG = constrain(v,-vitesseMax,vitesseMax);
  }

  public void vitesseDroite(int v) {
    vitesseG = constrain(v,-vitesseMax,vitesseMax);
  }

  public boolean obstacle() {
    return (monde.testeCollision(this,faisceau));
}
  
  public void deplace(float dt) {
    // deplace entre t et t+dt
    double vitesse = (vitesseG + vitesseD) / 2.0;
    double dRz = (vitesseG-vitesseD) / dRoues * dt;
    double dx = vitesse*cos(Rz)*dt;
    double dy = vitesse*sin(Rz)*dt; 
    // translation de l'enveloppe
    enveloppe.translate(dx,dy);
    enveloppe.tourne(x+dx,y+dy,dRz);
    if(monde.testeCollision(this,enveloppe))  
    {
      // collision! pas de deplacement
      enveloppe.tourne(x+dx,y+dy,-dRz);
      enveloppe.translate(-dx,-dy);
    } else {
      // pas de collision
      faisceau.translate(dx,dy);
      faisceau.tourne(x+dx,y+dy,dRz);      
      Rz += dRz;
      x += dx;
      y += dy;
    } 
  }
  
  
  
}


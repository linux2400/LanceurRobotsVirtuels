/** Un robot d'exploration martien.
*/
class RobotMartien extends Robot {
  // vitesse et angle des roues avant
  float vitesse, angleRoues;
  // angle du bras bas
  float RBras;
  // angle minimum et maximum du bras
  float RBras_min, RBras_max;
  // angle du bras haut
  float RBrasHaut;
  // position d'attache du bras
  float xBras, yBras, zBras;
  // flags qui indiquent si le bras est en train de se deplier ou replier
  boolean depliement_en_cours;
  boolean repliement_en_cours;
  // vitesse angulaire du bras
  float omega_bras;
  // distance y roues avant
  float xRouesAvant, yRouesAvant;
  // longueur du bras
  float Lbras;
  
  boolean aTouche;

  Solide corps3D;
  Solide roueDroite3D;
  Solide roueGauche3D;
  Solide bras13D;
  Solide bras23D;

  // capteur de distance
  public PolygoneConvexe faisceau;
  // senseur au bout du bras
  public PolygoneConvexe senseur_bras;

  // constructeur
  public RobotMartien() {
  }  

  public void initialise() {
    // chargement des fichiers
    float facteur = 1.0;
    corps3D = new SolideOBJ();
    corps3D.charge("data/modelRobotComplet.obj", facteur);
    //corps3D = new SolideSTL();
    //corps3D.charge("Robot_virtuel_V0_sans_roues.stl", facteur);

    //roueDroite3D = new SolideOBJ();
    //roueDroite3D.charge("data/roue.obj", facteur);
    roueDroite3D = new SolideOBJ();
    roueDroite3D.charge("data/roue.obj", facteur);

    //roueGauche3D = new SolideOBJ();
    //roueGauche3D.charge("data/roue.obj", facteur);
    roueGauche3D = new SolideOBJ();
    roueGauche3D.charge("data/roue.obj", facteur);

    //bras13D = new SolideOBJ();
    //bras13D.charge("data/bras1.obj", facteur);
    bras13D = new SolideSTL();
    bras13D.charge("data/brasBas.stl", facteur);
    
    //bras23D = new SolideOBJ();
    //bras23D.charge("data/bras2.obj", facteur);
    bras23D = new SolideSTL();
    bras23D.charge("data/brasHaut.stl", facteur);

    // initialisation vitesse et angle des roues
    vitesse = 0.;
    angleRoues = 0.0; 
    
    xRouesAvant = 115.0 / facteur;
    yRouesAvant = (125+32.5)/2.0 / facteur;
    
    // pas d'obstacle encore touché par le bras
    aTouche = false;
    
    Lbras = 168.0 / facteur;
    
    xBras = (315/2-23) / facteur; 
    yBras = 62.5 / facteur;
    zBras = (100+5+6.2+76/2) / facteur;
 
    RBrasHaut = 30./180*PI;
    
    RBras = 60.0/180.0*PI;
    RBras_min = RBras;
    RBras_max = 150./180.*PI;
    omega_bras = (RBras_max-RBras_min)/5;
    
    depliement_en_cours = false;
    repliement_en_cours = false;
    // calcul du plus petit cube contenant le robot   
    enveloppe = corps3D.enveloppe().union(roueDroite3D.enveloppe()).union(roueGauche3D.enveloppe());

    // construction du faisceau
    ArrayList<Point> f = new ArrayList<Point>(4);
    f.add(new Point(315.0/2.0, 0));
    f.add(new Point(315.0/2.0, 5));
    f.add(new Point(315.0/2.+110, 30));
    f.add(new Point(315.0/2.+110, 40));
    faisceau = new PolygoneConvexe(f);

    // senseur du bout du bras
    ArrayList<Point> s = new ArrayList<Point>(3);
    s.add(new Point(-15, -5));
    s.add(new Point(-15, -15));
    s.add(new Point(-5, -15));
    s.add(new Point(-5, -5));
    senseur_bras = new PolygoneConvexe(s);
    senseur_bras.translate(xBras-Lbras*cos(RBras)+ Lbras*cos(RBrasHaut), yBras);

    super.initialise();
  }

  public void position_initiale(Position p)
  {
    super.position_initiale(p);
    faisceau.translate(x, y);
    faisceau.tourne(x, y, Rz);
    senseur_bras.translate(x, y);
    senseur_bras.tourne(x, y, Rz);
  }

  public void affiche() {
    fill(220);
    pushMatrix();
    translate(x, y, z);
    rotate(Rz);
    corps3D.affiche();
    pushMatrix();
    translate(xBras, yBras, zBras);
    pushMatrix();
    rotate(RBras, 0, 1, 0);
    bras13D.affiche();
    popMatrix();
    translate(-Lbras*cos(RBras), 0, Lbras*sin(RBras));
    rotate(RBrasHaut, 0, 1, 0);
    bras23D.affiche();
    popMatrix();
//    bras23D.affiche();
    pushMatrix();
    translate(xRouesAvant, yRouesAvant);
    rotate(angleRoues);
    fill(200);
    roueDroite3D.affiche();
    popMatrix();
    pushMatrix();
    translate(xRouesAvant, -yRouesAvant);
    rotate(angleRoues);
    roueGauche3D.affiche();
    popMatrix();
    popMatrix();    
    noFill();
    //affichage de l'enveloppe en rouge
    //fill(255, 0, 0);
    //enveloppe.affiche();
    // affichage du faisceau en vert
    fill(0, 255, 0);
    faisceau.affiche();
    fill(255, 0, 0);
    senseur_bras.affiche();
    noFill();
  }

  public void deplace(float dt) {
    // deplace entre t et t+dt
    double dRz = dt * sin(angleRoues) * vitesse / xRouesAvant;
    float VG = vitesse * sqrt(pow(cos(angleRoues),2) + 0.25*pow(sin(angleRoues),2));
    float beta = atan(1/2*tan(angleRoues));
    double dx = VG*cos(Rz+beta)*dt;
    double dy = VG*sin(Rz+beta)*dt; 
    // translation de l'enveloppe
    enveloppe.translate(dx, dy);
    enveloppe.tourne(x+dx, y+dy, dRz);
    if (monde.testeCollision(this,enveloppe))
    {
      // collision! pas de deplacement
      enveloppe.tourne(x+dx, y+dy, -dRz);
      enveloppe.translate(-dx, -dy);
    } else {
      // pas de collision
      faisceau.translate(dx, dy);
      faisceau.tourne(x+dx, y+dy, dRz);
      senseur_bras.translate(dx, dy);
      senseur_bras.tourne(x+dx, y+dy, dRz);      
      Rz += dRz;
      x += dx;
      y += dy;
    }
    // depliement du bras
    double dRBras = 0;
    if (depliement_en_cours) 
    {
      if (RBras + dt*omega_bras <= RBras_max)
      {
        aTouche = touche();
        dRBras = dt*omega_bras;
      }
      else
      {
       depliement_en_cours = false;
      }
    } else if (repliement_en_cours)
    {
      if (RBras-dt*omega_bras >= RBras_min)
      {
        dRBras = -dt*omega_bras;
      }
      else
      {
       repliement_en_cours = false;
      }
    }
    
    if(dRBras != 0) {
        double X = Lbras*cos(RBras) - Lbras*cos(RBrasHaut);
        senseur_bras.translate(cos(Rz)*X, sin(Rz)*X);
        RBras += dRBras;
        X = -Lbras*cos(RBras) + Lbras*cos(RBrasHaut);
        senseur_bras.translate(cos(Rz)*X, sin(Rz)*X);
    }
    /*
    if(touche())
    {
       println("TOUCHE!"); 
    }
    */
  }

  // METHODES DES BLOCS
  public void avance() {
    tourne(0);
    vitesse = 167;
  }

  public void recule() {
    tourne(0);
    vitesse = -167;
  }

  public void arrete() {
    tourne(0);
    vitesse = 0;
  }
  
  public void avanceDroite()
  {
    vitesse = 167;
    tourne(18);
  }

  void avanceGauche()
  {
    vitesse = 167;
    tourne(-18);  
  }

  public void reculeDroite()
  {
    vitesse = -167;
    tourne(18);
  }

  void reculeGauche()
  {
    vitesse = -167;
    tourne(-18);  
  }

  public void vitesse(int V) {
    vitesse = V;
  }
  public void tourne(int _angle) {
    _angle = constrain(_angle, -18, 18);
    angleRoues = constrain(radians(_angle), -PI/4.0, PI/4.0);
  }
  public boolean obstacle() {
    return (monde.testeCollision(this,faisceau));
  }

  public void deplier_bras()
  {
    depliement_en_cours = true;
    repliement_en_cours = false;
    while(depliement_en_cours) 
    {
      delay(50);
    }
  }

  public void replier_bras()
  {
    aTouche = false;
    depliement_en_cours = false;
    repliement_en_cours = true;
    while(repliement_en_cours) 
    {
      delay(50);
    }
  }

  public boolean brasTouche()
  {
     return aTouche; 
  }

  
  public boolean touche()
  {
     return monde.testeCollision(this,senseur_bras); 
  }
}


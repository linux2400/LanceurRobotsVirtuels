class RobotMartien {
  // position et direction
  float x,y,z, Rz;
  // vitesse et angle des roues
  float vitesse, angleRoues;
  // angle du bras
  float RBras;
  // angle minimum et maximum du bras
  float RBras_min, RBras_max;
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
  
  Solide corps3D;
  Solide roueDroite3D;
  Solide roueGauche3D;
  Solide bras13D;
  Solide bras23D;
  // enveloppe
  public PolygoneConvexe enveloppe;
  // capteur de distance
  public PolygoneConvexe faisceau;
  
  // constructeur
  public RobotMartien() {
    
  }  
  
  public void initialise() {
    // chargement des fichiers
    float facteur = 2.0;
    corps3D = new SolideOBJ();
    corps3D.charge("data/corpsRobotDecentre.obj", facteur);
    roueDroite3D = new SolideOBJ();
    roueDroite3D.charge("data/roue.obj", facteur);
    roueGauche3D = new SolideOBJ();
    roueGauche3D.charge("data/roue.obj", facteur);
    bras13D = new SolideOBJ();
    bras13D.charge("data/bras1.obj", facteur);
    bras23D = new SolideOBJ();
    bras23D.charge("data/bras2.obj", facteur);
    
    // initialisation position, direction
    x = 0;
    y = 0;
    z = 0;
    Rz = 0;   
    // initialisation vitesse et angle des roues
    vitesse = 0.;
    angleRoues = 0.0;
    xRouesAvant = 2.0*80.0 / facteur;
    yRouesAvant = 40.0 / facteur;
    Lbras = 100.0 / facteur;
    xBras = 150 / facteur; 
    yBras = -30 / facteur;
    zBras = 95 / facteur;
    RBras = 10.0/180.0*PI;
    RBras_min = RBras;
    RBras_max = PI-PI/6;
    omega_bras = 1;
    depliement_en_cours = false;
    repliement_en_cours = false;
    // calcul du plus petit cube contenant le robot   
    enveloppe = corps3D.enveloppe().union(roueDroite3D.enveloppe()).union(roueGauche3D.enveloppe());
    
    // construction du faisceau
    ArrayList<Point> f = new ArrayList<Point>(3);
    f.add(new Point(80,0));
    f.add(new Point(200,-80));
    f.add(new Point(200,80));
    faisceau = new PolygoneConvexe(f);
    
    // ajouter le robot au monde
    monde.ajoute(this);
   
    delay(3000);
  }

  public void position_initiale(Position p)
  {
    x = p.x;
    y = p.y;
    Rz = p.Rz;
    enveloppe.translate(x,y);
    enveloppe.tourne(x,y,Rz);
    faisceau.translate(x,y);
    faisceau.tourne(x,y,Rz);
  }
  
  public void affiche() {
    lights();
    fill(200);
    pushMatrix();
    translate(x, y, z);
    rotate(Rz);
    corps3D.affiche();
    pushMatrix();
    translate(xBras,yBras,zBras);
    pushMatrix();
    rotate(RBras,0,1,0);
    bras13D.affiche();
    popMatrix();
    translate(-Lbras*cos(RBras),0,Lbras*sin(RBras));
    bras23D.affiche();
    popMatrix();
    bras23D.affiche();
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
    fill(255,0,0);
    enveloppe.affiche();
    // affichage du faisceau en vert
    fill(0,255,0);
    faisceau.affiche();
    noFill();

  }
  
  public void deplace(float dt) {
    // deplace entre t et t+dt
    double dRz = dt * sin(angleRoues) * vitesse / xRouesAvant;
    double dx = vitesse*cos(Rz)*dt;
    double dy = vitesse*sin(Rz)*dt; 
    // translation de l'enveloppe
    enveloppe.translate(dx,dy);
    enveloppe.tourne(x+dx,y+dy,dRz);
    if(monde.testeCollision(enveloppe))
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
   // depliement du bras
  if(depliement_en_cours) 
  {
    if(RBras + dt*omega_bras <= RBras_max)
    {
       RBras += dt*omega_bras;
    }   
  } else if(repliement_en_cours)
 {
    if(RBras-dt*omega_bras >= RBras_min)
    {
       RBras -= dt*omega_bras;
    }  
 } 
  
  }
  
  // METHODES DES BLOCS
  
  public void vitesse(int V) {
    vitesse = V;
  }
  public void tourne(int _angle) {
    _angle = constrain(_angle,-18,18);
    angleRoues = constrain(radians(_angle), -PI/4.0, PI/4.0);
  }
  public boolean obstacle() {
    return (monde.testeCollision(faisceau));
  }

  public void deplier_bras()
  {
    depliement_en_cours = true;
    repliement_en_cours = false;
  }

  public void replier_bras()
  {
    depliement_en_cours = false;
    repliement_en_cours = true;
  }  
}


class RobotMartien {
  // position et direction
  float x,y,z, Rz;
  // vitesse et angle des roues
  float vitesse, angleRoues;
  // distance y roues avant
  float xRouesAvant, yRouesAvant; 
  Solide corps3D;
  Solide roueDroite3D;
  Solide roueGauche3D;
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
  }
  
  
  
}


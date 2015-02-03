
public class RobotMartien {
  // position et direction
  float x,y,z, Rz;
  // vitesse et angle des roues
  float vitesse, angleRoues;
  // distance y roues avant
  float xRouesAvant, yRouesAvant; 
  solidSTL corps3D;
  solidSTL roueDroite3D;
  solidSTL roueGauche3D;
  // enveloppe
  public PolygoneConvexe enveloppe;
  // capteur de distance
  public PolygoneConvexe faisceau;
  
  // constructeur
  public RobotMartien() {
    
  }
  
  public void initialise(float _x, float _y, float _z, float _Rz) {
  
    // chargement des fichiers
    float facteur = 2.0;   
    corps3D = new solidSTL();
    corps3D.chargeSTL("data/corpsRobotDecentre.stl", facteur);
    roueDroite3D = new solidSTL();
    roueDroite3D.chargeSTL("data/roue.stl", facteur);
    roueGauche3D = new solidSTL();
    roueGauche3D.chargeSTL("data/roue.stl", facteur);
    // initialisation position, direction
    x = _x;
    y = _y;
    z = _z;
    Rz = radians(_Rz);   
    // initialisation vitesse et angle des roues
    vitesse = 0.;
    angleRoues = 0.0;
    xRouesAvant = 2.0*80.0 / facteur;
    yRouesAvant = 40.0 / facteur;
    // calcul du plus petit cube contenant le robot   
    enveloppe = corps3D.enveloppe().union(roueDroite3D.enveloppe()).union(roueGauche3D.enveloppe());
    enveloppe.translate(new Point(x,y));
    
    // construction du faisceau
    ArrayList<Point> f = new ArrayList<Point>(3);
    f.add(new Point(80,0));
    f.add(new Point(200,-80));
    f.add(new Point(200,80));
    faisceau = new PolygoneConvexe(f);
    faisceau.translate(new Point(x,y));
    
    // ajouter le robot au monde
    monde.ajoute(this);
  }    
  public void affiche() {
    fill(200);
    pushMatrix();
    translate(x, y, z);
    rotate(Rz);
    corps3D.affiche();
    pushMatrix();
    translate(xRouesAvant, yRouesAvant);
    rotate(angleRoues);
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
  public void tourne(float _angle) {
    angleRoues = constrain(radians(_angle), -PI/4.0, PI/4.0);
  }
  
  public void deplace(float dt) {
    // deplace entre t et t+dt
    double dRz = dt * sin(angleRoues) * vitesse / xRouesAvant;
    double dx = vitesse*cos(Rz)*dt;
    double dy = vitesse*sin(Rz)*dt; 
    // deplacement de l'enveloppe convexe
    enveloppe.translate(new Point(dx,dy));
    enveloppe.tourne(x,y,dRz);
    // tests de collision
    if(monde.testeCollision(enveloppe))
    {
      // on a une collision : annulation du deplacement
      enveloppe.tourne(x,y,-dRz);
      enveloppe.translate(new Point(-dx,-dy));
    } else {
      // pas de collision
      faisceau.translate(new Point(dx,dy));
      faisceau.tourne(x,y,dRz);          
      Rz +=dRz;
      x += dx;
      y += dy;
    }
  }
}


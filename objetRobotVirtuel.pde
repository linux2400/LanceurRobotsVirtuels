
public class robotVirtuel {
  // position et direction
  float x,y,z, Rz;
  // vitesse et angle des roues
  float vitesse, angleRoues;
  // distance y roues avant
  float xRouesAvant, yRouesAvant; 
  solidSTL corps3D;
  solidSTL roueDroite3D;
  solidSTL roueGauche3D;
  public robotVirtuel() {
  }
  public void initialise(float _x, float _y, float _z, float _Rz) {
    // chargement des fichier 
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
    Rz = _Rz;   
    // initialisation vitesse et angle des roues
    vitesse = 0.;
    angleRoues = 0.0;
    xRouesAvant = 2.0*80.0 / facteur;
    yRouesAvant = 40.0 / facteur; 
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
  }
  public void vitesse(int V) {
    vitesse = V;
  }
  public void tourne(float _angle) {
    angleRoues = constrain(_angle, -PI/4.0, PI/4.0);
  }
  public void deplace(float dt) {
    // deplace entre t et t+dt
    Rz = Rz + dt * sin(angleRoues) * vitesse / xRouesAvant;
    x = x + vitesse*cos(Rz)*dt;
    y = y + vitesse*sin(Rz)*dt;
  }
}


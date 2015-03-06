
public class ObstacleMartien {
  // position
  float x,y,z;
  // geometrie
  Solide obstacle3D;
  // enveloppe
  public PolygoneConvexe enveloppe;
  
  // constructeur
  public ObstacleMartien(float _x, float _y, float _z) {
    // chargement des fichiers
    float facteur = 1.0;   
    obstacle3D = new SolideSTL();
    //obstacle3D.charge("data/obstacle.stl", facteur);
    obstacle3D.charge("data/cube.stl", facteur);
    // initialisation position, direction
    x = _x;
    y = _y;
    z = _z;
    enveloppe = obstacle3D.enveloppe(); 
    enveloppe.translate(x,y);
    
    monde.ajoute(this);
  }    
  
  public void affiche() {
    lights();
    fill(200);
    pushMatrix();
    translate(x, y, z);
    obstacle3D.affiche();
    popMatrix();    
    noFill();
    enveloppe.affiche();
  }
}


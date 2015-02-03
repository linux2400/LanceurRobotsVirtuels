
public class ObstacleMartien {
  // position
  float x,y,z;
  // geometrie
  solidSTL obstacle3D;
  // enveloppe
  public PolygoneConvexe enveloppe;
  
  // constructeur
  public ObstacleMartien() {
    
  }

  public void initialise(float _x, float _y, float _z) {
   
    // chargement des fichiers
    float facteur = 2.0;   
    obstacle3D = new solidSTL();
    obstacle3D.chargeSTL("data/obstacle.stl", facteur);
    // initialisation position, direction
    x = _x;
    y = _y;
    z = _z;
   
    enveloppe = obstacle3D.enveloppe(); 
    enveloppe.translate(new Point(x,y));
  }    
  public void affiche() {
    fill(200);
    pushMatrix();
    translate(x, y, z);
    obstacle3D.affiche();
    popMatrix();    
    noFill();
    enveloppe.affiche();
  }
}


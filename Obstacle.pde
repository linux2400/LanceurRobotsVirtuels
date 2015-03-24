
public class Obstacle {
  // position
  float x,y,z;
  // geometrie
  Solide obstacle3D;
  // enveloppe
  public PolygoneConvexe enveloppe;
  
  // constructeur
  public Obstacle(Position p) {
    // chargement des fichiers
    float facteur = 1.0;   
    obstacle3D = new SolideOBJ();
    //obstacle3D.charge("data/obstacle.stl", facteur);
    obstacle3D.charge("data/cube.obj", facteur);
    // initialisation position, direction
    x = p.x;
    y = p.y;
    z = 0;
    enveloppe = obstacle3D.enveloppe(); 
    enveloppe.translate(x,y);
    
    monde.ajoute(this);
  }    
  
  public void affiche() {
    //lights();
    //fill(200);
    pushMatrix();
    translate(x, y, z);
    obstacle3D.affiche();
    popMatrix();    
    //noFill();
    //enveloppe.affiche();
  }
}


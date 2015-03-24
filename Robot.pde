abstract class Robot {
  // position et direction
  float x, y, z, Rz;
  // enveloppe
  public PolygoneConvexe enveloppe;
  
  // constructeur
  public Robot() {
  }  

  public void initialise() {
    // initialisation position, direction
    x = 0;
    y = 0;
    z = 0;
    Rz = 0;   

    // ajouter le robot au monde
    monde.ajoute(this);

    delay(3000);
  }

  /** Definition de la position initiale du robot.
  */
  public void position_initiale(Position p)
  {
    x = p.x;
    y = p.y;
    Rz = p.Rz;
    enveloppe.translate(x, y);
    enveloppe.tourne(x, y, Rz);
  }

  /** Affichage du robot 
  */
  abstract public void affiche();

  /** Deplacement du robot.
  */
  abstract public void deplace(float dt);
  
}


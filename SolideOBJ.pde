//import objimp.*;
import saito.objloader.*;

public class SolideOBJ implements Solide {
  // scene obj
  OBJModel scene;
  // facteur d'echelle
  float facteur;
  // le constructeur
  public SolideOBJ() {
  }
  public void charge(String fichier, float _facteur) {
    scene = new OBJModel(monde.context(), fichier, "relative", TRIANGLES);
    scene.debug.enabled = false;
    facteur = _facteur;
    scene.scale(1/facteur);
  }
  // chargement du fichier  
  public void charge(String fichier) {
    charge(fichier, 1.0);
  }
    
  // affichage du solide
  public void affiche() {
    //scene.disableMaterial();
    //ambient(200,200,200);
    //emissive(50.0,50.0,50.0);
    //specular(100,100,100);
    //shininess(2.0);
    //lights();
    //directionalLight(126, 126, 126, 0, 0, -1);
    //ambientLight(51, 102, 126);
    scene.draw();
  }
  
  // retourne un cube contenant le solide
  public PolygoneConvexe enveloppe() {  
    List<Point> p = new ArrayList<Point>(scene.getVertexCount());
    for(int i = 0; i < scene.getVertexCount(); i++) 
    {
        PVector v = scene.getVertex(i); 
        p.add(new Point(v.x,v.y));
    }
    return new PolygoneConvexe(p);
  }  
}


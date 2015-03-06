
public class SolideSTL implements Solide {
  // la liste des triangles
  ArrayList<triangleSTL> listeTriangles;
  // facteur d'echelle
  float facteur;
  // le constructeur
  public SolideSTL() {
  }
  
  public void charge(String fichier, float _facteur) {
    // facteur
    facteur = _facteur;
    // charge le fichier
    String lines[] = loadStrings(fichier);
    int nTriangles = (lines.length-2)/7;
    //println("Il y a " + nTriangles + " triangles");
    listeTriangles = new ArrayList<triangleSTL>();
    // pour chaque triange lit, cree et met dans les sommets
    int i0 = 3;
    for(int nT = 0; nT<nTriangles;nT++) {
      // ligne du premier sommet du triangle
      int i = nT*7 + i0;       
      // lit le triangle
      //println("ligne " + i + " " + lines[i]);
      // sommet 1      
      String[] infosS1 = split(trim(lines[i]), ' ');
      //println("n token : ", infosS1.length);
      float s1x = float(infosS1[1]) / facteur;
      float s1y = float(infosS1[2]) / facteur;
      float s1z = float(infosS1[3]) / facteur;
      //println("coord : " + s1x + " " + s1y + " " + s1z);
      // sommet 2
      String[] infosS2 = split(trim(lines[i+1]), ' ');
      float s2x = float(infosS2[1]) / facteur;
      float s2y = float(infosS2[2]) / facteur;
      float s2z = float(infosS2[3]) / facteur;      
      // sommet 3
      String[] infosS3 = split(trim(lines[i+2]), ' ');
      float s3x = float(infosS3[1]) / facteur;
      float s3y = float(infosS3[2]) / facteur;
      float s3z = float(infosS3[3]) / facteur;
            
      // ajoute le triangle    
      listeTriangles.add(new triangleSTL(s1x,-s1y,s1z,s2x,-s2y,s2z,s3x,-s3y,s3z));
    }      
  }
  // chargement du fichier  
  public void charge(String fichier) {
    charge(fichier, 1.0);
  }
    
  // affichage du solide
  public void affiche() {
    ambient(1.0);
    emissive(0.0);
    // pour chaque triangle l'affiche
    for(int i=0; i<listeTriangles.size();i++)
    {
      triangleSTL leTriangle = listeTriangles.get(i);
      //triangle(leTriangle.s1x, leTriangle.s1y, leTriangle.s2x, leTriangle.s2y,  leTriangle.s3x, leTriangle.s3y);
      beginShape();
      for(int j = 0; j < 3; j++)
      {
        vertex(leTriangle.s[j][0], leTriangle.s[j][1], leTriangle.s[j][2]);
      }
      endShape();
    }
  }
  
  // retourne un cube contenant le solide
  public PolygoneConvexe enveloppe() {
    List<Point> p = new ArrayList<Point>(3*listeTriangles.size());
    for(int i = 0; i < listeTriangles.size(); i++)
    {
      triangleSTL t = listeTriangles.get(i);
      for(int d = 0; d < 3; d++)
      {
        p.add(new Point(t.s[d][0],t.s[d][1]));
      }
    }  
    return new PolygoneConvexe(p);
  }  


private class triangleSTL {
  float[][] s;
  public triangleSTL(float _s1x, float _s1y, float _s1z, float _s2x, float _s2y, float _s2z, float _s3x, float _s3y, float _s3z) {
    s = new float[3][3];
    s[0][0] = _s1x;
    s[0][1] = _s1y;
    s[0][2] = _s1z;
    s[1][0] = _s2x;
    s[1][1] = _s2y;
    s[1][2] = _s2z;
    s[2][0] = _s3x;
    s[2][1] = _s3y;
    s[2][2] = _s3z;
  }
}


}


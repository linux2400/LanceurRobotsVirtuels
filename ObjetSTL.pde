
// axis oriented box
public class Box {
  public float[] p0; // lower left corner
  public float[] p1; // upper right corner
  public Box() {
    p0 = new float[3];
    p1 = new float[3];
    for(int i = 0; i < 3; i++)
    {
      p0[i] = 1e10;
      p1[i] = -1e10;
    }
  }
  // translate box by x,y,z
  public void translate(float x, float y, float z)
  {
    p0[0] += x;p0[1] += y; p0[2] += z;
    p1[0] += x;p1[1] += y; p1[2] += z;  
  }
  // compute smallest box containing this box and another box
  public Box union(Box autre)
  {
      Box ret = new Box();
      for(int i = 0; i < 3; i++)
      {
        ret.p0[i] = Math.min(autre.p0[i],p0[i]); 
        ret.p1[i] = Math.max(autre.p1[i],p1[i]);
      }
      return ret;  
  }
  // check for intersection with another box
  public boolean intersecte(Box autre)
  {
    for(int i = 0; i < 3; i++)
    {
     if(autre.p0[i] > p1[i] || autre.p1[i] < p0[i]) { return false; }
    }
     return true;
  }
  
  public String toString() {
   return "(" + p0[0] + "," + p0[1] + "," + p0[2] + ")/(" + p1[0] + "," + p1[1] + "," + p1[2] + ")";
  }
}

public class triangleSTL {
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

public class solidSTL {
  // le nom du solide
  String nom;
  // la liste des triangles
  ArrayList<triangleSTL> listeTriangles;
  // facteur d'echelle
  float facteur;
  // le constructeur
  public solidSTL() {
  }
  public void chargeSTL(String fichier, float _facteur) {
    // facteur
    facteur = _facteur;
    // charge le fichier
    String lines[] = loadStrings(fichier);
    int nTriangles = (lines.length-2)/7;
    println("Il y a " + nTriangles + " triangles");
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
      listeTriangles.add(new triangleSTL(s1x,s1y,s1z,s2x,s2y,s2z,s3x,s3y,s3z));
    }      
  }
  // chargement du fichier  
  public void chargeSTL(String fichier) {
    chargeSTL(fichier, 1.0);
  }
    
  // affichage du solide
  public void affiche() {
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
  public Box boundingBox() {
    Iterator<triangleSTL> it = listeTriangles.iterator();
    Box ret = new Box();
    while(it.hasNext())
    {
      triangleSTL t = it.next();
      for(int i = 0; i < 3; i++)
      {
        for(int j = 0; j < 3; ++j)
        {      
          ret.p0[i] = Math.min(ret.p0[i],t.s[j][i]);
          ret.p1[i] = Math.max(ret.p1[i],t.s[j][i]);
        }
      }
    }  
    return ret;
  }  
}


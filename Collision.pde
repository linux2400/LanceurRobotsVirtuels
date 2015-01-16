import java.util.List;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.lang.Float;

static int D = 2;

public class Point {
  public double[] x;
  Point() {
    x = new double[D];
    x[0] = 0.0;
    x[1] = 0.0;
  }
  Point(double x0, double x1) {
    x = new double[D];
    x[0] = x0;
    x[1] = x1;    
  }
  public String toString() {
    return "(" + x[0] + "," + x[1] + ")";
  }

  public void normaliser() {
    double norme = (double)(Math.sqrt(x[0]*x[0] + x[1]*x[1]));
    x[0] /= norme;
    x[1] /= norme;
  }  
}

boolean rightTurn(Point a, Point b, Point c)
{
        return (b.x[0] - a.x[0])*(c.x[1] - a.x[1]) - (b.x[1] - a.x[1])*(c.x[0] - a.x[0]) > 0;
}

class XCompare implements Comparator<Point>
{
        @Override
        public int compare(Point o1, Point o2)
        {
                if(o1.x[0] < o2.x[0])
                {
                  return -1;
                } else if(o1.x[0] > o2.x[0]) {
                    return 1;
                } else {
                  return 0;
                }
        }
}

public List<Point> enveloppeConvexe(List<Point> points)
{
        List<Point> xSorted = new ArrayList<Point>(points);
        Collections.sort(xSorted, new XCompare());
       
        int n = xSorted.size();
        if(n < 2)
        {
          return points;
        }
        Point[] lUpper = new Point[n];
       
        lUpper[0] = xSorted.get(0);
        lUpper[1] = xSorted.get(1);
       
        int lUpperSize = 2;
       
        for (int i = 2; i < n; i++)
        {
                lUpper[lUpperSize] = xSorted.get(i);
                lUpperSize++;
               
                while (lUpperSize > 2 && !rightTurn(lUpper[lUpperSize - 3], lUpper[lUpperSize - 2], lUpper[lUpperSize - 1]))
                {
                        // Remove the middle point of the three last
                        lUpper[lUpperSize - 2] = lUpper[lUpperSize - 1];
                        lUpperSize--;
                }
        }
       
        Point[] lLower = new Point[n];
       
        lLower[0] = xSorted.get(n - 1);
        lLower[1] = xSorted.get(n - 2);
       
        int lLowerSize = 2;
       
        for (int i = n - 3; i >= 0; i--)
        {
                lLower[lLowerSize] = xSorted.get(i);
                lLowerSize++;
               
                while (lLowerSize > 2 && !rightTurn(lLower[lLowerSize - 3], lLower[lLowerSize - 2], lLower[lLowerSize - 1]))
                {
                        // Remove the middle point of the three last
                        lLower[lLowerSize - 2] = lLower[lLowerSize - 1];
                        lLowerSize--;
                }
        }
       
        ArrayList<Point> resultat = new ArrayList<Point>(lUpperSize + lLowerSize - 2);
       
        for (int i = 0; i < lUpperSize; i++)
        {
                resultat.add(lUpper[i]);
        }
       
        for (int i = 1; i < lLowerSize - 1; i++)
        {
                resultat.add(lLower[i]);
        }
       
        return resultat;
}

// polygon to detect collisions
public class PolygoneConvexe {
  List<Point> sommets;
  
  public PolygoneConvexe(List<Point> v) {
    sommets = enveloppeConvexe(v);
  }
  
  // translate polygon
  public void translate(Point dx)
  {
    Iterator<Point> it = sommets.iterator();
    while(it.hasNext()) {
      Point p = it.next();
      for(int d = 0; d < D; d++)
      {
          p.x[d] += dx.x[d];
      }
    }
  }
  
  // rotation autour du point c0,c1
  public void tourne(double c0, double c1, double alpha)
  {
    Iterator<Point> it = sommets.iterator();
    while(it.hasNext()) {
      Point p = it.next();
      p.x[0] = c0 + (p.x[0]-c0)*Math.cos(alpha) - (p.x[1]-c1)*Math.sin(alpha);
      p.x[1] = c1 + (p.x[0]-c0)*Math.sin(alpha) + (p.x[1]-c1)*Math.cos(alpha);
    }
  }
  
  // compute convex hull of this polygon with another one
  public PolygoneConvexe union(PolygoneConvexe autre)
  {
      List<Point> v = new ArrayList<Point>(sommets);
      v.addAll(autre.sommets);
      return new PolygoneConvexe(v);
  }
  
  // Calculate the projection of a polygon on an axis
  // and returns it as a [min, max] interval
  public Point projection(Point axe) {
      // To project a point on an axis use the dot product
      double dotProduct = sommets.get(0).x[0] * axe.x[0] + sommets.get(0).x[1] * axe.x[1];
      double min = dotProduct;
      double max = dotProduct;
      for (int i = 1; i < sommets.size(); i++) {
          dotProduct = sommets.get(i).x[0] * axe.x[0] + sommets.get(i).x[1] * axe.x[1];
          if (dotProduct < min) {
              min = dotProduct;
          } else {
              if (dotProduct> max) {
                  max = dotProduct;
              }
          }
      }
      return new Point(min,max);
  }

  // Calculate the distance between [minA, maxA] and [minB, maxB]
  // The distance will be negative if the intervals overlap
  public double intervalDistance(Point a, Point b) {
      if (a.x[0] < b.x[0]) {
          return b.x[0] - a.x[1];
      } else {
          return a.x[0] - b.x[1];
      }
  }
  
  // check for intersection with another box
  public boolean intersecte(PolygoneConvexe autre)
  {
    if(sommets.size() == 0 || autre.sommets.size() == 0)
    {
      return false;
    }
    int areteCountA = sommets.size() - 1 ;
    int areteCountB = autre.sommets.size() - 1 ;
    Point arete = new Point();
    // Loop through all the aretes of both polygons
    for (int areteIndex = 0; areteIndex < areteCountA + areteCountB; areteIndex++) {
        if (areteIndex < areteCountA) {
            arete.x[0] = sommets.get(areteIndex+1).x[0] - sommets.get(areteIndex).x[0];
            arete.x[1] = sommets.get(areteIndex+1).x[1] - sommets.get(areteIndex).x[1];
        } else {
            arete.x[0] = autre.sommets.get(areteIndex-areteCountA+1).x[0] - autre.sommets.get(areteIndex-areteCountA).x[0];
            arete.x[1] = autre.sommets.get(areteIndex-areteCountA+1).x[1] - autre.sommets.get(areteIndex-areteCountA).x[1];            
        }
        // ===== 1. Find if the polygons are currently intersecting =====

        // Find the axis perpendicular to the current arete
        Point axe = new Point(-arete.x[1], arete.x[0]);
        axe.normaliser();

        // Find the projection of the polygon on the current axis
        double minA = 0; double minB = 0; double maxA = 0; double maxB = 0;
        Point minmaxA = projection(axe);
        Point minmaxB = autre.projection(axe);

        // Check if the polygon projections are currentlty intersecting
        if (intervalDistance(minmaxA,minmaxB) > 0)
            return false;
    }
    return true;
  }
  
  public String toString() {
    return sommets.toString();
  }

  public void affiche() {
    // affiche l'enveloppe au sol
    beginShape();
    for(int j = 0; j < sommets.size(); j++)
    {
      vertex((float)sommets.get(j).x[0],(float)sommets.get(j).x[1],1.);
    }
    endShape();  
  }
}


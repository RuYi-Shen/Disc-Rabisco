/*import java.util.ArrayList;



public class Trajectory {
  public ArrayList<PVector> currentPos = new ArrayList<PVector>();
  public ArrayList<PVector> previousPos = new ArrayList<PVector>();

  public ArrayList<Integer> quadrants = new ArrayList<Integer>();
  public ArrayList<Integer> modes = new ArrayList<Integer>();
  public int face;
  public int orientation;


  public Trajectory(PVector cPosition, PVector pPosition, int quadrant, int mode, int face) {
    this.currentPos.add(cPosition); 
    this.previousPos.add(pPosition);

    this.quadrants.add(quadrant);
    this.modes.add(mode);
    this.face = face;
  }
  private void update(PVector cPosition, PVector pPosition, int quadrant, int mode) {

    this.currentPos.add(cPosition); 
    this.previousPos.add(pPosition);

    this.quadrants.add(quadrant);
    this.modes.add(mode);
  }
  public void prin() {
    for (int point = 0; point < this.currentPos.size(); point++) {

      println("pos", point, ": ", this.currentPos.get(point));
    }
  }
  public void plot() {
    int cor = 0;
    PVector atual = new PVector(0, 0);
    PVector anterior = new PVector(0, 0);
    float speed;// = dist(previous.x*width, previous.y*height, current.x*width, current.y*height);
    float lineWidth ;//= map(speed, 5, 50, 2, 20);
    //lineWidth = constrain(lineWidth, 0, 100);//magic!!

    for (int point = 0; point < this.currentPos.size(); point++) {
      cor = setColors(quadrants.get(point));
      atual = this.currentPos.get(point);
      anterior = this.previousPos.get(point);
      speed = dist(anterior.x, anterior.y, atual.x, atual.y);
      lineWidth = map(speed, 5, 50, 2, 20);
      lineWidth = constrain(lineWidth, 0, 100);

      noStroke();
      fill(0, 100);
      strokeCap(ROUND);
      stroke(cor, 100, 100);
      strokeWeight(lineWidth);
      //line(Xp*width, Yp*height, X*width, Y*height);


      switch(modes.get(point)) {
      case 1: 
        //rect(anterior.x*width,anterior.y*height,random(80),random(80));
        line(anterior.x, anterior.y, atual.x, atual.y);
        break;
      case 2: 
        point(atual.x, atual.y);
        break;
      case 3: 
        rect(atual.x, atual.y, random(80), random(80));
        break;
      }
    }
  }
}
*/

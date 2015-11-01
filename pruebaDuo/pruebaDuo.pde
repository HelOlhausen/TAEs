import java.awt.Polygon;

boolean dibujar = false; 
boolean mover = false;
PGraphics runa;

Gesture gesto;
final int minMove = 3;     // Distancia minima entre puntos de la runa

void setup(){
  size(displayWidth,displayHeight);
  PImage img;
  img = loadImage("fondo.jpg");
  img.resize(width, height);
  background(img);
  
  gesto = new Gesture(width, height);
  gesto.clear();
}

void draw(){
  renderGesture(gesto, width, height);
}


void dibujarRuna(){
  
}

void mousePressed() {
  gesto.clear();
  gesto.clearPolys();
  gesto.addPoint(mouseX, mouseY);
}


void mouseDragged() {
  if (gesto.distToLast(mouseX, mouseY) > minMove) {
    gesto.addPoint(mouseX, mouseY);
    gesto.smooth();
    gesto.compile();
  }
}

void renderGesture(Gesture gesture, int w, int h) {
  if (gesture.exists) {
    if (gesture.nPolys > 0) {
      Polygon polygons[] = gesture.polygons;
      int crosses[] = gesture.crosses;

      int xpts[];
      int ypts[];
      Polygon p;
      int cr;

      beginShape(QUADS);
      int gnp = gesture.nPolys;
      for (int i=0; i<gnp; i++) {

        p = polygons[i];
        xpts = p.xpoints;
        ypts = p.ypoints;

        vertex(xpts[0], ypts[0]);
        vertex(xpts[1], ypts[1]);
        vertex(xpts[2], ypts[2]);
        vertex(xpts[3], ypts[3]);

        if ((cr = crosses[i]) > 0) {
          if ((cr & 3)>0) {
            vertex(xpts[0]+w, ypts[0]);
            vertex(xpts[1]+w, ypts[1]);
            vertex(xpts[2]+w, ypts[2]);
            vertex(xpts[3]+w, ypts[3]);

            vertex(xpts[0]-w, ypts[0]);
            vertex(xpts[1]-w, ypts[1]);
            vertex(xpts[2]-w, ypts[2]);
            vertex(xpts[3]-w, ypts[3]);
          }
          if ((cr & 12)>0) {
            vertex(xpts[0], ypts[0]+h);
            vertex(xpts[1], ypts[1]+h);
            vertex(xpts[2], ypts[2]+h);
            vertex(xpts[3], ypts[3]+h);

            vertex(xpts[0], ypts[0]-h);
            vertex(xpts[1], ypts[1]-h);
            vertex(xpts[2], ypts[2]-h);
            vertex(xpts[3], ypts[3]-h);
          }

          // I have knowingly retained the small flaw of not
          // completely dealing with the corner conditions
          // (the case in which both of the above are true).
        }
      }
      endShape();
    }
  }
}


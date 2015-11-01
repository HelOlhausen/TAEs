import java.awt.Polygon;


PImage fondo;
boolean dibujar = false; 
boolean mover = false;
PGraphics runa;
int posXRuna = 0;
int posYRuna = 0;
int velocidadMovimiento = 5;

Gesture gesto;
final int minMove = 3;     // Distancia minima entre puntos de la runa

void setup(){
  size(displayWidth,displayHeight);
  fondo = loadImage("fondo.jpg");
  fondo.resize(width, height);
  background(fondo);
  
  gesto = new Gesture(width, height);
  gesto.clear();
  
  runa = createGraphics(width, height);
}

void draw(){
  background(fondo);
  if(dibujar){
    dibujarRuna();
  }
  runa.beginDraw();
  renderGesture(gesto, width, height, runa);
  runa.endDraw();
  image(runa, posXRuna, posYRuna);
  if(mover){
    PVector avance = calcularAvances(width/2, height/2, mouseX, mouseY);
    posXRuna = posXRuna + Math.round(avance.x);
    posYRuna = posYRuna + Math.round(avance.y);
  }
  if((posXRuna < -width) || (posXRuna > width) || (posYRuna > height) || (posYRuna < -height)){
    posXRuna = 0;
    posYRuna = 0;
    gesto.clear();
    runa = createGraphics(width, height);
  }
}


void dibujarRuna(){
  if (gesto.distToLast(mouseX, mouseY) > minMove) {
    gesto.addPoint(mouseX, mouseY);
    gesto.smooth();
    gesto.compile();
  }
}

void mouseClicked(){
  if(dibujar){
    dibujar = false;
    mover = true;
  }
  else{
    // Creo una nueva runa
    dibujar = true;
    mover = false;
    posXRuna = 0;
    posYRuna = 0;
    gesto.clear();
    gesto.clearPolys();
    gesto.addPoint(mouseX, mouseY);
    runa = createGraphics(width, height);      
  }
  
}

//void mousePressed() {
//  if(mover){
//    // Restarteo dibujo
//    mover = false;
//    posXRuna = 0;
//    runa = createGraphics(width, height);
//  }  
//  gesto.clear();
//  gesto.clearPolys();
//  gesto.addPoint(mouseX, mouseY);
//}


//void mouseDragged() {
//  if (gesto.distToLast(mouseX, mouseY) > minMove) {
//    gesto.addPoint(mouseX, mouseY);
//    gesto.smooth();
//    gesto.compile();
//  }
//}

//void mouseReleased(){
//  mover = true;
//}

void renderGesture(Gesture gesture, int w, int h, PGraphics pg) {
  if (gesture.exists) {
    if (gesture.nPolys > 0) {
      Polygon polygons[] = gesture.polygons;
      int crosses[] = gesture.crosses;

      int xpts[];
      int ypts[];
      Polygon p;
      int cr;
      
            
      pg.beginShape(QUADS);
      int gnp = gesture.nPolys;
      for (int i=0; i<gnp; i++) {

        p = polygons[i];
        xpts = p.xpoints;
        ypts = p.ypoints;

        pg.vertex(xpts[0], ypts[0]);
        pg.vertex(xpts[1], ypts[1]);
        pg.vertex(xpts[2], ypts[2]);
        pg.vertex(xpts[3], ypts[3]);

        if ((cr = crosses[i]) > 0) {
          if ((cr & 3)>0) {
            pg.vertex(xpts[0]+w, ypts[0]);
            pg.vertex(xpts[1]+w, ypts[1]);
            pg.vertex(xpts[2]+w, ypts[2]);
            pg.vertex(xpts[3]+w, ypts[3]);

            pg.vertex(xpts[0]-w, ypts[0]);
            pg.vertex(xpts[1]-w, ypts[1]);
            pg.vertex(xpts[2]-w, ypts[2]);
            pg.vertex(xpts[3]-w, ypts[3]);
          }
          if ((cr & 12)>0) {
            pg.vertex(xpts[0], ypts[0]+h);
            pg.vertex(xpts[1], ypts[1]+h);
            pg.vertex(xpts[2], ypts[2]+h);
            pg.vertex(xpts[3], ypts[3]+h);

            pg.vertex(xpts[0], ypts[0]-h);
            pg.vertex(xpts[1], ypts[1]-h);
            pg.vertex(xpts[2], ypts[2]-h);
            pg.vertex(xpts[3], ypts[3]-h);
          }

          // I have knowingly retained the small flaw of not
          // completely dealing with the corner conditions
          // (the case in which both of the above are true).
        }
      }
      pg.endShape();
    }
  }
}

PVector calcularAvances(float centroX, float centroY, float posX, float posY){
  float largoX = posX - centroX;
  float largoY = posY - centroY;
  
  float h = sqrt(sq(largoX) + sq(largoY));
  float m = h;
  if(h > 0){
    m = 1/h;
  }
  PVector avance = new PVector(largoX * m * velocidadMovimiento, 
                                largoY * m * velocidadMovimiento);
  return avance;
    
}


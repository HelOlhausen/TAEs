import java.awt.Polygon;
import SimpleOpenNI.*;
import java.util.ArrayList;
import controlP5.*;

//Parametros kinect
float factorEscala=1.6;

//Parametros para usuarios
SimpleOpenNI  context;
int cantUsuarios = 6;
color[]       userClr = new color[]{ color(255,0,0), color(0,255,0), color(0,0,255),
                                    color(255,255,0), color(255,0,255), color(0,255,255)}; 
PVector com = new PVector();                                   
PVector com2d = new PVector(); 
//Vector para guardar valores del esqueleto
PVector jointPos = new PVector();
PVector jointPos2 = new PVector();
// Puntos del esqueleto a trackear
boolean[] partesDelCuerpo = {false,true,true,true,false,false};
// Opcion de dibujar el esqueleto del usuario trackeado
boolean dibujarEsqueleto = true;


PImage fondo;
//Parametros para las runas
boolean dibujar[] =  new boolean[cantUsuarios];
boolean mover[] = new boolean[cantUsuarios];
PGraphics runa[]= new PGraphics[cantUsuarios];
int posXRuna[] = new int[cantUsuarios];
int posYRuna[] = new int[cantUsuarios];
Gesture gesto[]= new Gesture[cantUsuarios];

int velocidadMovimiento = 5;
final int minMove = 3;     // Distancia minima entre puntos de la runa

void setup(){
  size(1024,768);
  //Inicializamos parametros para las runas de cada usuario
  for(int i=0; i< cantUsuarios; i++){
    dibujar[i]= false;
    mover[i]= false;
    //Se crea las ruans en esta resolucion para trabajar mas facil con el kinect
    runa[i]=createGraphics(640, 480);
    posXRuna[i] = 0;
    posYRuna[i] = 0;
    //Se crean los gestos en esta resolucon para que sean coerentes con las runas
    gesto[i] = new Gesture(640, 480);
    gesto[i].clear();
  }
  
  //Seteamos pantalla
  fondo = loadImage("fondo.jpg");
  fondo.resize(width, height);
  background(fondo);
    
  //Inicializo el contexto
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  // enable depthMap generation 
  context.enableDepth();
  // enable skeleton generation for all joints
  context.enableUser();
}

void draw(){
  background(fondo);
  // update the cam
  context.update();
  PVector posicionManoDerecha= new PVector();
  PVector posicionCodoDerecho= new PVector();
  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for(int i=0; i< min(userList.length, cantUsuarios) ;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
    {        
            
      //Declaro un entorno de dibujo para escalar lo capturado por la kinect
      pushMatrix();
           
      //Escalo la captura del kinect para que coincida con la pantalla de 640x480 a 1024x768
      scale(factorEscala);
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      if(dibujarEsqueleto)
      {
        drawSkeleton(userList[i]);
      }      
      
      posicionManoDerecha = detectarDibujo (userList[i], i);
      posicionCodoDerecho= capturarOrigenMovimiento(userList[i]);
      detectarMusica(userList[i]);
      
      
      if(dibujar[i]){
        dibujarRuna(posicionManoDerecha, i);
      }
      runa[i].beginDraw();
      runa[i].fill(userClr[i] );
      runa[i].stroke(userClr[i]);
      //runa[i].background(192,0,0,100);
      // Escalamos dentro del sticker
      runa[i].scale(factorEscala);
      renderGesture(gesto[i], 640, 480, runa[i]);
      runa[i].endDraw();
      //Finalizo el entorno de dibujo
      popMatrix();
      //Pego Runa en la pantalla      
      image(runa[i], posXRuna[i], posYRuna[i], width, height);
      //En caso de ser necesario movemos la runa
      if(mover[i]){
        PVector avance = calcularAvances(posicionCodoDerecho.x, posicionCodoDerecho.y, 
                                        posicionManoDerecha.x, posicionManoDerecha.y);
        posXRuna[i] = posXRuna[i] + Math.round(avance.x);
        posYRuna[i] = posYRuna[i] + Math.round(avance.y);
      }
      //En caso de ser necesario destruimos la runa
      if((posXRuna[i] < -width/3) || (posXRuna[i] > width/3) || (posYRuna[i] > height) || (posYRuna[i] < -height)){
        posXRuna[i] = 0;
        posYRuna[i] = 0;
        gesto[i].clear();
        runa[i] = createGraphics(width, height);
        mover[i] = false;
      }
    }  
  }    
  
  
}


void dibujarRuna(PVector posicion, int i){
  if (gesto[i].distToLast(posicion.x, posicion.y) > minMove) {
    gesto[i].addPoint(posicion.x, posicion.y);
    gesto[i].smooth();
    gesto[i].compile();
  }
}

//void mouseClicked(){
//  if(dibujar){
//    dibujar = false;
//    mover = true;
//  }
//  else{
//    // Creo una nueva runa
//    dibujar = true;
//    mover = false;
//    posXRuna = 0;
//    posYRuna = 0;
//    gesto.clear();
//    gesto.clearPolys();
//    gesto.addPoint(mouseX, mouseY);
//    runa = createGraphics(width, height);      
//  }
//  
//}

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
// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);
  
  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
  
  
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}

PVector detectarDibujo (int userId, int i) {
  //Detectar pose dibujo
  PVector cabeza = new PVector();
  PVector manoIzquierda = new PVector();
  PVector manoDerecha = new PVector();
  
  //Obtengo las coordenadas de la mano izquierda
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND ,manoIzquierda);
  //Obtengo las coordenadas de la cabeza
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD ,cabeza);
  //Corrijo  los valores
  context.convertRealWorldToProjective(cabeza,cabeza);
  context.convertRealWorldToProjective(manoIzquierda,manoIzquierda);
  //Obtengo las coordenadas de la mano derecha
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND ,manoDerecha);
  //Corrijo  los valores
  context.convertRealWorldToProjective(manoDerecha,manoDerecha);
  
  if (cabeza.y > manoIzquierda.y){
    
    //Seteo que dibuja
    if (!dibujar[i]){
      println("Dibujar runas.");
      dibujar[i]=true;
      mover[i]=false;
      //Indico la posicion inicial del stickerruna
      posXRuna[i] = 0;
      posYRuna[i] = 0;
      //borro el dibujo anterior
      gesto[i].clear();
      //Dibujo
      gesto[i].clearPolys();
      gesto[i].addPoint(manoDerecha.x, manoDerecha.y);
      runa[i] = createGraphics(width, height); 
    }
  } else{
    //println("NO Dibujar.");   
    if(dibujar[i]){ 
      //Seteo que dibuja
      dibujar[i]=false;
      mover[i]=true;
    }
  }
  
  return manoDerecha;
}
void detectarMusica (int userId) {
  //Detectar pose dibujo
  PVector pieD = new PVector();
  PVector rodillaI = new PVector();
  PVector pieI = new PVector();
  
  //Obtengo las coordenadas del pie izquierda
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT,pieI);
  //Obtengo las coordenadas de la rodilla izquierda
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE ,rodillaI);
  //Obtengo las coordenadas del pie derecho
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT,pieD);
  //Corrijo  los valores
  context.convertRealWorldToProjective(pieI,pieI);
  context.convertRealWorldToProjective(rodillaI,rodillaI);
  context.convertRealWorldToProjective(pieD,pieD); 
  if (pieD.y < ((pieI.y+rodillaI.y)/2)){
    //println("Detecto Musica.");
  } else{
    //println("NO Detecto Musica.");    
  }
}
PVector capturarOrigenMovimiento (int userId) {
  //Detectar pose dibujo
  PVector codoDerecho = new PVector();
  //Obtengo las coordenadas de la mano izquierda
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW ,codoDerecho);
  //Corrijo  los valores
  context.convertRealWorldToProjective(codoDerecho,codoDerecho);
  return codoDerecho;
}



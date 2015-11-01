import SimpleOpenNI.*;
import java.awt.Frame;
import controlP5.*;
import java.util.ArrayList;
private ControlP5 cp5;

ControlFrame cf;

//Parametros para usuarios
SimpleOpenNI  context;
color[]       userClr = new color[]{ color(255,0,0), color(0,255,0), color(0,0,255),
                                     color(255,255,0), color(255,0,255), color(0,255,255)}; 
                                     
//Vector para guardar valores del esqueleto
PVector jointPos = new PVector();
PVector jointPos2 = new PVector();
// Puntos del esqueleto a trackear
boolean[] partesDelCuerpo = {false,true,true,true,false,false};
// Opcion de dibujar el esqueleto del usuario trackeado
boolean dibujarEsqueleto = false;


public void setup() {
  //Creo pantalla
  size(1024,768);
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
  
  //Doy color a las lineas
  stroke(0,0,255);
  //Ensancho las lineas
  strokeWeight(3);
  //Dibujo mas suavemente
  smooth();
  //Dejo de dibujar los bordes
  noStroke();
  // cargo controlador
  cp5 = new ControlP5(this);
  cf = addControlFrame("Controladores", 600,600);
}

public void draw() {
  //Fondo blanco
  background(0);
  // update the cam
  context.update();
  scale(1.6);
 
   // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
    {
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      if(dibujarEsqueleto)
      {
        drawSkeleton(userList[i]);
      }
      detectarDibujo (userList[i]);
    } 
  }
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

// -----------------------------------------------------------------
// Deteccion de Baile


//Devuelve si la mano izquierda esta por encima de la cabeza.
void detectarDibujo (int userId) {
  //Detectar pose dibujo
  PVector cabeza = new PVector();
  PVector manoIzquierda = new PVector();
  
  //Obtengo las coordenadas de la mano izquierda
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND ,manoIzquierda);
  //Obtengo las coordenadas de la cabeza
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD ,cabeza);
  //Corrijo  los valores
  context.convertRealWorldToProjective(cabeza,cabeza);
  context.convertRealWorldToProjective(manoIzquierda,manoIzquierda);
  if (cabeza.y > manoIzquierda.y){
    println("Dibujar runas.");
  } else{
    println("NO Dibujar.");    
  }
}

//Devuelve si el pie derecho esta por ensima de la canilla
void detectarPieDerecho (int userId) {
  //Detectar pose dibujo
  PVector pieI = new PVector();
  PVector rodillaI = new PVector();
  PVector pieD = new PVector();
  
  //Obtengo las coordenadas del pie Izquierda
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT ,pieI);
  //Obtengo las coordenadas de la rodilla Izquierda
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE ,rodillaI);
  //Obtengo las coordenadas del pie Derecho
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT ,pieD);
  //Corrijo  los valores
  context.convertRealWorldToProjective(pieI,pieI);
  context.convertRealWorldToProjective(rodillaI,rodillaI);
  context.convertRealWorldToProjective(pieD,pieD);
  if (pieD.y > ( (pieI.y + rodillaI.y)/2) ){
    println("Pie Derecho Levantado hasta: "+ pieD.y);
  } else{
    println("Pie Derecho No levantado.");    
  }
}

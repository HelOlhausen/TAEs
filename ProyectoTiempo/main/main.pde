import SimpleOpenNI.*;
SimpleOpenNI context;

import java.awt.Frame;
import controlP5.*;
ControlP5 cp5;
ControlFrame cf;

// para parar la ejecuccion de draw durante del cambio de las escenas
boolean stopDraw = false;

// para cambiar fluidamente entre las escenas
SceneManager manager;

// Escena 1 -- Viaje en el tiempo
color fondo1 = color(50,0,50);
color sombra1 = color(192,0,192,192);

void setup(){
  size(1024, 768);
  noCursor();
  //setMirror(true);
  cf = addControlFrame("Controladores", 450,700);

  manager = new SceneManager();  
  frameRate(120);

  context = new SimpleOpenNI(this);
 // context.setMirror(true);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  context.enableDepth();
  context.enableUser();

  println("READY TO GO");
}


void draw(){
  if(!stopDraw) manager.actualScene.drawScene(); 
}

void keyPressed(){
  // para cambiar las escenas manualmente
  if (key == '-') manager.activatePrevScene();
  if (key == '=') manager.activateNextScene();

}

// modo pantalla entera
boolean sketchFullScreen() {   return true; }


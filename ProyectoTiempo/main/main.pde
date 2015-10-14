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

// Escena 1 -- Gravedad
// Mundo Fisico
boolean borrarParticulas = false;
// Gravedad
int direccionGravedadX = 0;
int direccionGravedadY = 0;
int particulasPorFrame = 5;
// Puntos del esqueleto a trackear
boolean[] partesDelCuerpo = {false,true,true,true,false,false};
// Opcion de dibujar el esqueleto del usuario trackeado
boolean dibujarRadios = false;
//Parametros de las particulas
float radio = 10;
boolean radioVariable = false;
boolean radioEpileptico = false;
float posibilidadCreacionEspontanea = 25;



// Escena 2 -- Tunel del tiempo
color fondo1 = color(50,0,50);
color sombra1 = color(192,0,192,192);
boolean mover_lineas_hacia_arriba = false;
boolean mover_lineas_hacia_derecha = false;
boolean serPantalla = false;
int velocidad = 6;


// Escena 3 -- Ilusion Optica
int cantidad_lineas_ilusion = 10;
float radio_ilusion = 400;
float intervalo_ilusion = radio_ilusion/cantidad_lineas_ilusion;
float distancia_base_externo = 1;
float distancia_base_interno = intervalo_ilusion;
float velocidad_ilusion = 3;
color fondo3 = color(0,255,0);
color color_lineas_ilusion = color(25,50,0);
int   grosor_lineas_ilusion = 4;
boolean oscurecer = false;


void setup(){
  size(1024, 768);
  noCursor();
  //setMirror(true);
  cf = addControlFrame("Controladores", 950,600);

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
  context.enableRGB();

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


import java.awt.Frame;
import controlP5.*;
import java.util.ArrayList;
private ControlP5 cp5;
import SimpleOpenNI.*;
import java.lang.*;
 

ControlFrame cf;

SimpleOpenNI  context;

PVector com = new PVector();                                   
PVector com2d = new PVector();  

boolean sketchFullScreen() { return true; }
// aca estan los colores de las barras
// definidos en el colorMode RGB -> https://processing.org/reference/colorMode_.html
// color( R, G, B)
color[] color_bars={ 
  color(192,192,192), 
  color(192,192,0), 
  color(0,192,192), 
  color(0,192,0),
  color(192,0,192),
  color(192,0,0),
  color(0,0,192)
};


// Altura de la pantalla
int screen_height;
int screen_width;

// aca se guarda el nro total de los colores definidos
int colorsNr = color_bars.length;

// Modo invertido - por defecto deshabilitado
boolean modoInvertido = false;

// Colorear la barra pixelada
boolean lluviaColorida = false;

// Cantidad de barras adyacentes coloreadas
int cantBarrasAdyacentesColoreadas = colorsNr - 1;

// Luminosidad (color claro) de señal de ruido. Por defecto blanco
int luminosidadRuido = 255;

// Posicion de usuario
float position;

// Opcion espejado (pixela barra contraria)
boolean espejado = false;

// Mapas de profundidades
int[] dMapBase;
int[] dMap;


// esta funcion se ejecuta una vez sola, al principio
void setup(){
  
  context = new SimpleOpenNI(this);
   size(displayWidth, displayHeight);
  scale(1.6);
  screen_width = displayWidth;
  screen_height = displayHeight;
  // por defecto esta cargada la opcion de dibujar un contorno de color negro en las figuras
  // la queremos deshabilitar
  noStroke();
  // cargo controlador
  cp5 = new ControlP5(this);
  cf = addControlFrame("Controladores", 600,600);
  
  if(context.isInit() == false)
  {
   println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
   exit();
   return;  
 }
    
  // mirror is by default enabled
  context.setMirror(false);
  
  // enable depthMap generation 
  context.enableDepth();
 
  // enable skeleton generation for all joints
 context.enableUser();
  
 //Mapa de profundidad 
 dMapBase = context.depthMap();
 
 
 smooth(); 
};

// esta funcion se ejecuta todo el tiempo en un loop constante 
void draw()
{  
  /////////////////////
  // la funcion que creamos para dibujar el fondo ruidoso
  createNoisyBackground(luminosidadRuido);  
  
  // Por defecto la barra a modificar es la de la posicion del mouse
  position = 320;
  
  // update the cam
  context.update();
  
  // Busco un usuario
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    // Obtengo el centro de masa
    if(context.getCoM(userList[i],com)) {
      // Seleccionamos la posicion en el eje horizontal del centro de masa
      // para dibujar la barra noisy
      position = com.x;
    }
  }

  if(!espejado)
  {
    position = screen_width - position;
  }
  
  // Dibujo barras de colores
  drawTv(colorsNr, cantBarrasAdyacentesColoreadas,position);

};

void createNoisyBackground(int luminosidadRuido){
  // una función ya dada que carga los datos de los píxeles de la pantalla de visualización en el pixels [] array 
  // siempre debe ser llamada antes de leer o escribir en pixels [].
  loadPixels();

  // recorremos todos los pixeles
  for (int i = 0; i < pixels.length; i++) {
    // y si el numero que fue "sorteado" en la funcion random(x) es mayor de 50 el pixel va a ser blanco
    if(random(100)>50) pixels[i] = color(luminosidadRuido);
    // en el caso contrario, sera negro
    else{
      if(lluviaColorida)
      {
        int colorR = ((Float) random(255)).intValue();
        int colorG = ((Float) random(255)).intValue();
        int colorB = ((Float) random(255)).intValue();
        pixels[i] = color(colorR, colorG, colorB);
      }
      else
        pixels[i] = color(0);
    } 
  }   
  // una función ya dada que actualiza la ventana de la pantalla con los datos de los pixels [] array
  updatePixels(); 
}


void drawTv( int bars_nr, int cantBarrasAdyacentesColoreadas, float xPosition) {
  // definimos el ancho de las barras 
  // por el tema del redondeo hacemos +1 para cubrir toda la pantalla
  int bar_width = screen_width / bars_nr +1;
  // en funcion de la posicion x del mouse definimos cual de las barras de colores no se dibujara
  int whichBar = (int)(xPosition / bar_width);
  if(whichBar < 0 ) whichBar = 0;
  if(whichBar > bars_nr - 1) whichBar = bars_nr - 1;

  // dibujamos las barras
  for (int i = 0; i < bars_nr; i ++) {
    // coloreamos las adyacentes
    if(abs(i - whichBar) <= cantBarrasAdyacentesColoreadas){
      // dibujamos solo si el mouse no esta parado en esta barra y no esta en modo invertido
      if(((whichBar != i) && !modoInvertido) || ((whichBar == i) && modoInvertido)) {
        // el color de la barra se corresponde a un color definido en el array color_bars[]
        fill(color_bars[i%colorsNr]);
        // dibujamos el rectangulo
        rect(i * bar_width, 0, bar_width, screen_height); 
      }
    }
    else{
      // pintamos la barra de negro
      fill(color(0));
      // dibujamos el rectangulo
      rect(i * bar_width, 0, bar_width, screen_height); 
    }      
  }
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
  println("onVisibleUser - userId: " + userId);
}


void keyPressed()
{
  switch(key)
  {
  case '+':
    println("Funca el +");
    context.setMirror(!context.mirror());
    break;
  }
}  

void multiBarras (int[] dMapBase){
  boolean[] genteEnBarra=  new boolean[colorsNr];
  for (int x=0; x<colorsNr;x=x+1){
    genteEnBarra[x]=false;
  }
  context.update();
  int[]   depthMap = context.depthMap();
  int index;
  for(int x=0;x <context.depthWidth();x+=1)
  {
    for(int y=0;y < context.depthHeight() ;y+=1)
    {
      index = x + y * context.depthWidth();
      int d = abs( dMapBase[index]-depthMap[index]);
      if(d>0){
        genteEnBarra[(int) (x/context.depthWidth()/(colorsNr))]=true;
      }
    }
  }
  for (int x=0; x<colorsNr;x++){
    println("Barra " + x + ": " + genteEnBarra[x]);
  }
}


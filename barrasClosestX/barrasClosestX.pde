import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;
import java.util.ArrayList;
private ControlP5 cp5;

import SimpleOpenNI.*;
import java.lang.*;
 

ControlFrame cf;

SimpleOpenNI  context;

color[]       userClr = new color[]{ color(255,0,0),
                                     color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };
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

// Mapa de profundidad
int[] dMapBase;
int[] dMap;

// Puntos en los que se encuentra al bailarin
ArrayList<Integer> puntos = new ArrayList<Integer>();

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
  
  
  /////////////////////////
  
  context = new SimpleOpenNI(this);
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
 
 //ESCALAR PANTALLA 

//  size(displayWidth,displayHeight);
 
 smooth(); 
 // size define el tamano de nuestro sketch
  
 //ESCALAR PANTALLA 
  //screen_height = context.depthHeight();
  //screen_width = context.depthWidth(); 
 //size(screen_width,screen_height);
 
 // 5 fps
  frameRate(10);

//  // Create the fullscreen object
//  fs = new FullScreen(this); 
//  
//  // enter fullscreen mode
//  fs.enter(); 
 
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

//  int[] userList = new int[0];
//
//  // Si no se detecta ningun usuario, se tiene en cuenta el mapa de profundidad
//  if( userList.length == 0)
//  {  
//    // Cargo el mapa de profundidad
//    dMap = context.depthMap();
//    println("Calculando profundidad...........");
//    // position = obtenerPosicionProfundidadMinima(dMap);
//    position = obtenerPosicionProfundidadMinimaTotal(dMap);
//    println("------------> Posicion es: " + position);
//  }
  
  if(!espejado)
  {
    position = screen_width - position;
  }
  
//   int[] dMap = context.depthMap();
//   for(int pos = 10; pos < context.depthMapSize(); pos = pos + 1) { 
//     if((dMap[pos] != 0) && (dMapBase[pos] != 0) && (Math.abs(dMap[pos] - dMapBase[pos]) > 0)) {
//       println(pos);
//       puntos.add(pos % screen_height);
//     }
//   }
  
  // for(Integer p : puntos){
  //   println(p);
  // }
//println(dMap[5000]);
  
  // Dibujo barras de colores
  drawTv(colorsNr, cantBarrasAdyacentesColoreadas,position);
  
  // Reiniciamos los puntos
  //puntos.clear();
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


////////////////////////////
// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  // to get the 3d joint data
  /*
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
  println(jointPos);
  */
  
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

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


void keyPressed()
{
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());
    break;
  }
}  

/* Esta funcion considera 3 lineas horizontales de la pantalla (a las alturas 
3/6, 4/6 y 5/6 contando desde arriba) y retorna la coordenada x de la posicion 
de minima profundidad en dichas lineas */
float obtenerPosicionProfundidadMinima(int[] dMap)
{
  // Inicializo respuesta
  float respuesta = 0;
  
  // Inicializo el arreglo para almacenar las posiciones de profundidad
  // minima en las 3 filas a considerar
  int[] puntos_candidatos = new int[3]; 

  // Divido el arreglo de profundidad en 6 segmentos
  int intervalo_de_medida = context.depthMapSize() / 6;
  println("Intervalo de medida = " + intervalo_de_medida);

  // Considero unicamente la mitad inferior del arreglo de profundidad
  for(int i = 3; i <= 5; i++)
  {
    // Determino punto inicial de la fila a recorrer
    int inicio = intervalo_de_medida * i;
    // Inicializo variables auxiliares
    int minimo = inicio;
    int valor_minimo = dMap[inicio]; 
    // Recorro una linea horizontal, tomando una medida cada 10 puntos
    for(int j = inicio; j < inicio + screen_width; j = j + 10)
    {
      // Comparo la profundidad en el punto actual con la profundidad minima
      // Me quedo con el menor valor distinto de 0
      if((dMap[j] < valor_minimo) || (valor_minimo == 0))
      {
        valor_minimo = dMap[j];
        minimo = j;
      }
    }
    // Almaceno el minimo de la linea
    puntos_candidatos[i - 3] = minimo;
  }

  // Obtengo la profundidad minima de las 3 medidas
  if(dMap[puntos_candidatos[0]] <= dMap[puntos_candidatos[1]])
  {
    if(dMap[puntos_candidatos[0]] <= dMap[puntos_candidatos[2]])
    {
      respuesta = calcular_x(puntos_candidatos[0], screen_height);      
    }
    else
    {
      respuesta = calcular_x(puntos_candidatos[2], screen_height);
    }      
  }
  else
  {
     if(dMap[puntos_candidatos[1]] <= dMap[puntos_candidatos[2]])
     {
      respuesta = calcular_x(puntos_candidatos[1], screen_height);
     } 
     else
     {
      respuesta = calcular_x(puntos_candidatos[2], screen_height);
     }
  }

  // Retorno posicion x de profundidad minima
  return respuesta;
}

float calcular_x(int pos, int screen_height)
{
  return (pos % screen_height);
}

float obtenerPosicionProfundidadMinimaTotal(int[] dMap)
{
  int closestValue = 8000;
  int closestX = 1;
  // for each row in the depth image
  for(int y = 0; y <context.depthHeight(); y++)
  {
    // look at each pixel in the row
    for(int x = 0; x < context.depthWidth(); x++)
    { 
      // pull out the corresponding value from the depth array
      int i = x + y * context.depthWidth();
      int currentDepthValue = dMap[i];
      // if that pixel is the closest one we've seen so far
      if(currentDepthValue > 0 && currentDepthValue < closestValue)
      {
        // save its value
        closestValue = currentDepthValue;
        // and save its position (X coordinate)
        closestX = x;
      }
    }
  }
  return closestX;
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


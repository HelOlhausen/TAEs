
PVector centro, pos;
float radio;
color color_linea;
int red, green, blue;
int grosor_linea = 20;
int signoY = -1;
float velocidad;

void setup(){
  size(1024,768);  
  background(0);
  centro = new PVector(width/2, height/2);
  radio = height/3;
  float posX = random((centro.x - radio), (radio+centro.x));
  pos = new PVector(posX, obtenerY(posX));
}

void draw(){
  println("X: " + pos.x);
  println("Y: " + pos.y);
  red = (int)(255*mouseX/width);
  blue = (int)(255*mouseY/height);
  float distCentro = sqrt(sq(mouseX - centro.x) + sq(mouseY - centro.y));
  green = (int)(255*distCentro/width);
  color_linea = color(red, green, blue);
  stroke(color_linea);
  fill(color_linea);
  ellipse(pos.x, pos.y, grosor_linea, grosor_linea);
  moverPosicion();
}

float obtenerY(float x){
  return centro.y + signoY*sqrt(sq(radio) - sq(x - centro.x)); 
}

void moverPosicion(){
  calcularVelocidad();
  if(signoY == 1){
    pos.x = pos.x + velocidad;
  }else{
      pos.x = pos.x - velocidad; 
  } 
  
  if(pos.x >= (centro.x + radio)){
     signoY = -1;
     pos.x = centro.x + radio;
  }else{
     if(pos.x <= (centro.x - radio)){
     signoY = 1;
     pos.x = centro.x - radio;
     }
  }  
   pos.y = obtenerY(pos.x); 
}

void calcularVelocidad(){
  velocidad = abs(pos.y - centro.y)/radio;
  if(velocidad == 0){
    velocidad = 0.01;
  }
}




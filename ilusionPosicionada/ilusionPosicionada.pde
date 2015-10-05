int cantidad_lineas = 10;
float radio = 350;
float intervalo = radio/cantidad_lineas;
float distancia_base_externo = 1;
float distancia_base_interno = intervalo;
float velocidad = 1;

void setup(){
  size(displayWidth,displayHeight);
  background(255);
  stroke(0);
  strokeWeight(4);
  
}

void draw(){  
  background(255);  
  // Dibujo circulo externo
  stroke(255,0,0);
  strokeWeight(5);
  fill(255);
  ellipse(mouseX, mouseY, radio*2, radio*2);
  // Dibujo lineas externas
  stroke(0);
  strokeWeight(4);
  dibujarExternos();
  // Dibujo circulo central
  stroke(255,0,0);
  strokeWeight(5);
  fill(255);
  ellipse(mouseX, mouseY, radio, radio);
  // Dibujo lineas internas  
  stroke(0);
  strokeWeight(4);
  dibujarInternos();
}

void dibujarExternos(){
  // Dibujo entre ejes
  for(int i=1; i<=cantidad_lineas; i++)
  {
     float pos_actual = i*intervalo + distancia_base_externo;
     float norte = mouseY - pos_actual;
     float sur = mouseY + pos_actual;
     float este = mouseX + pos_actual;
     float oeste = mouseX - pos_actual;
     line(oeste, mouseY, mouseX, norte);
     line(oeste, mouseY, mouseX, sur);
     line(este, mouseY, mouseX, norte);
     line(este, mouseY, mouseX, sur);
  }
  
  // Dibujo arcos
  stroke(0,0,255);
  float punto_inicial = (cantidad_lineas + 1)*intervalo + distancia_base_externo;
  for(float j = punto_inicial; sqrt((j/2)*(j/2)*2) < radio; j = j + intervalo)
  {
    line(mouseX + j, mouseY, mouseX, mouseY+j);
    line(mouseX + j, mouseY, mouseX, mouseY-j);
    line(mouseX - j, mouseY, mouseX, mouseY+j);
    line(mouseX - j, mouseY, mouseX, mouseY-j);
  }
  
  // Actualizo linea base
  distancia_base_externo = distancia_base_externo + velocidad;
  // Corrijo linea base
  if(distancia_base_externo >= intervalo){
    distancia_base_externo = 1;
  }
}

void dibujarInternos(){
  for(int i=1; i<cantidad_lineas/2; i++)
  {
     float pos_actual = i*intervalo + distancia_base_interno;
     float norte = mouseY - pos_actual;
     float sur = mouseY + pos_actual;
     float este = mouseX + pos_actual;
     float oeste = mouseX - pos_actual;
     line(oeste, mouseY, mouseX, norte);
     line(oeste, mouseY, mouseX, sur);
     line(este, mouseY, mouseX, norte);
     line(este, mouseY, mouseX, sur);
  }
  
  // Dibujo arcos
  stroke(0,255,0);
  float punto_inicial = (cantidad_lineas/2)*intervalo + distancia_base_interno;
  for(float j = punto_inicial; sqrt((j/2)*(j/2)*2) < radio/2; j = j + intervalo)
  {
    line(mouseX + j, mouseY, mouseX, mouseY+j);
    line(mouseX + j, mouseY, mouseX, mouseY-j);
    line(mouseX - j, mouseY, mouseX, mouseY+j);
    line(mouseX - j, mouseY, mouseX, mouseY-j);
  }
  
  // Actualizo linea base
  distancia_base_interno = distancia_base_interno - velocidad;
  // Corrijo linea base
  if(distancia_base_interno <= 0){
    distancia_base_interno = intervalo;
  }
}


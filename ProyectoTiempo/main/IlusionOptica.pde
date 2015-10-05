class IlusionOptica implements Scene
{   
  
  PGraphics pg=createGraphics(width,height);
  
  public IlusionOptica(){};

  void closeScene(){};
  
  void initialScene(){};
  
  void drawScene()
  {    
    // Creo ilusion
    pg.beginDraw();
    crearIlusion();
    pg.endDraw();
    image(pg, 0, 0);
  };
  
  String getSceneName(){return "IlusionOptica";};
  
  void crearIlusion()
  {
    pg.background(255);  
    // Dibujo circulo externo
    pg.stroke(255,0,0);
    pg.strokeWeight(5);
    pg.fill(255);
    pg.ellipse(mouseX, mouseY, radio_ilusion*2, radio_ilusion*2);
    // Dibujo lineas externas
    pg.stroke(0);
    pg.strokeWeight(4);
    dibujarExternos();
    // Dibujo circulo central
    pg.stroke(255,0,0);
    pg.strokeWeight(5);
    pg.fill(255);
    pg.ellipse(mouseX, mouseY, radio_ilusion, radio_ilusion);
    // Dibujo lineas internas  
    pg.stroke(0);
    pg.strokeWeight(4);
    dibujarInternos();
  }
  
  void dibujarExternos(){
    // Dibujo entre ejes
    for(int i=1; i<=cantidad_lineas_ilusion; i++)
    {
       float pos_actual = i*intervalo_ilusion + distancia_base_externo;
       float norte = mouseY - pos_actual;
       float sur = mouseY + pos_actual;
       float este = mouseX + pos_actual;
       float oeste = mouseX - pos_actual;
       pg.line(oeste, mouseY, mouseX, norte);
       pg.line(oeste, mouseY, mouseX, sur);
       pg.line(este, mouseY, mouseX, norte);
       pg.line(este, mouseY, mouseX, sur);
    }
    
    // Dibujo arcos
    pg.stroke(0,0,255);
    float punto_inicial = (cantidad_lineas_ilusion + 1)*intervalo_ilusion + distancia_base_externo;
    for(float j = punto_inicial; sqrt((j/2)*(j/2)*2) < radio_ilusion; j = j + intervalo_ilusion)
    {
      pg.line(mouseX + j, mouseY, mouseX, mouseY+j);
      pg.line(mouseX + j, mouseY, mouseX, mouseY-j);
      pg.line(mouseX - j, mouseY, mouseX, mouseY+j);
      pg.line(mouseX - j, mouseY, mouseX, mouseY-j);
    }
    
    // Actualizo linea base
    distancia_base_externo = distancia_base_externo + velocidad_ilusion;
    // Corrijo linea base
    if(distancia_base_externo >= intervalo_ilusion){
      distancia_base_externo = 1;
    }
  }
  
  void dibujarInternos(){
    for(int i=0; i<=cantidad_lineas_ilusion/2; i++)
    {
       float pos_actual = i*intervalo_ilusion + distancia_base_interno;
       float norte = mouseY - pos_actual;
       float sur = mouseY + pos_actual;
       float este = mouseX + pos_actual;
       float oeste = mouseX - pos_actual;
       pg.line(oeste, mouseY, mouseX, norte);
       pg.line(oeste, mouseY, mouseX, sur);
       pg.line(este, mouseY, mouseX, norte);
       pg.line(este, mouseY, mouseX, sur);
    }
    
    // Dibujo arcos
    pg.stroke(0,255,0);
    float punto_inicial = (cantidad_lineas_ilusion/2)*intervalo_ilusion + distancia_base_interno;
    for(float j = punto_inicial; sqrt((j/2)*(j/2)*2) < radio_ilusion/2; j = j + intervalo_ilusion)
    {
      pg.line(mouseX + j, mouseY, mouseX, mouseY+j);
      pg.line(mouseX + j, mouseY, mouseX, mouseY-j);
      pg.line(mouseX - j, mouseY, mouseX, mouseY+j);
      pg.line(mouseX - j, mouseY, mouseX, mouseY-j);
    }
    
    // Actualizo linea base
    distancia_base_interno = distancia_base_interno - velocidad_ilusion;
    // Corrijo linea base
    if(distancia_base_interno <= 0){
      distancia_base_interno = intervalo_ilusion;
    }
  }

}

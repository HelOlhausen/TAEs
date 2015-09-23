class TunelTiempo implements Scene
{
  PImage bImg; 
  public int cantidad_lineas = 20;
  public float horizonte = 7*height/13;
  public float piso = height;
  public float pos_linea_base = piso;
  public float pos_vertical_base = 0;
  public int velocidad = -6;
  public TunelTiempo(){};
  
  void closeScene(){};
  
  void initialScene(){};
  
  void drawScene(){
    background(fondo1);
    // Dibujo horizonte
    dibujarGradienteHorizontal(8*height/15, height/4, color(255,255,255,200), color(255,255,255,0), false);    
    // Dibujo lineas horizontales
    dibujarLineasHorizontales();
    dibujarLineasVerticales();
    //Bailarin
    bImg = getMeImg();
    image(bImg,0,0);

    
  };
  
  String getSceneName(){return "Tunel del Tiempo";};
  
  // Funciones auxiliares
  void dibujarLineasHorizontales(){
    float altura_linea = pos_linea_base;    
    float centro = height/2;
    
    // Dibujo lineas
    for(int i = 0; i<cantidad_lineas; i++){
      // Calculo alto de sombra            
      int altura_siguiente = (int)(altura_linea - (altura_linea - centro)/7); 
      int h_sombra = (int)((altura_linea - altura_siguiente)/3);
      dibujarLineaHorizontal(altura_linea, h_sombra);
      altura_linea = altura_siguiente;
    }

    if(mover_lineas_hacia_arriba){
      // Actualizo altura base
      pos_linea_base = pos_linea_base - velocidad;  
    }
  
    // Corrijo altura base
    if (velocidad >= 0){
      if(pos_linea_base <= (height - (height/14))){
        pos_linea_base = height;
      }  
    }else{
      if(pos_linea_base >= (height)){
        pos_linea_base = (height - (height/14));
      }
    }
   
  }// dibujarLineasHorizontales
  
  void dibujarLineaHorizontal(float altura, int h_sombra){
    // Dibujo linea blanca
    stroke(255,255,255); 
    line(0, altura, width, altura);
    // Dibujo sombra
    dibujarGradienteHorizontal(altura + 1, h_sombra, sombra1, fondo1, true);
  }//dibujarLineaHorizontal
  
  void dibujarGradienteHorizontal(float y, float h, color c1, color c2, boolean descendente){
    if(descendente){
      for (float i = y; i <= y+h; i++) {
        float inter = map(i, y, y+h, 0, 1);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(0, i, width, i);
      }
    }
    else{
      for (float i = y; i >= y-h; i=i-1) {
        float inter = map(i, y, y-h, 0, 1);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(0, i, width, i);
      }
    }
  } // dibujarGradienteHorizontal
  
  void dibujarLineaVertical(float xHorizonte, float xPiso,int h_sombra){
    // Dibujo linea blanca
    stroke(255,255,255); 
    line(xHorizonte, horizonte, xPiso, piso);
    // Dibujo sombra
    //dibujarGradienteHorizontal(altura + 1, h_sombra, sombra1, fondo1, true);
  } //dibujarLineaVertical
  
  
  void dibujarLineasVerticales(){
    float largo_linea = pos_linea_base;    
    float centro = width/2;
    float pos_linea_actual = pos_vertical_base;
    float intervalo = width/cantidad_lineas;
    
    // Dibujo lineas
    for(int i = 0; i<cantidad_lineas; i++){
      dibujarLineaVertical(pos_linea_actual, pos_linea_actual + 4*(pos_linea_actual - centro), 10);
      pos_linea_actual = pos_linea_actual + intervalo;       
    }
    
    if(mover_lineas_hacia_derecha){
      // Muevo linea base
      pos_vertical_base = pos_vertical_base + velocidad;
    }
    
    // Corrijo linea base
    
    if (velocidad >= 0){
      if(pos_vertical_base >= intervalo){
        pos_vertical_base=0;
      }
    }else{
      if(pos_vertical_base <= 0){
        pos_vertical_base= intervalo;
      }
    }
   
  }// dibujarLineasHorizontales
   
  PImage getMeImg(){
    // para imagen de la kinect
    PImage img = new PImage(context.depthWidth(),context.depthHeight(),ARGB); 
    img.loadPixels();
    // para imagen escalada
    PImage bigImg = new PImage(width,height,ARGB); 
    bigImg.loadPixels();

    context.update();
    int[]   userMap = context.userMap();
    int[]   depthMap = context.depthMap();

    int index;
    for(int x=0;x <context.depthWidth();x+=1)
    {
      for(int y=0;y < context.depthHeight() ;y+=1)
      {
        index = x + y * context.depthWidth();
        int d = depthMap[index];
        // si no hay usuarios
        // ponemos un pixel transparente
        //img.pixels[index] = backPic.pixels[index];
        if(d>0){
          int userNr =userMap[index];
          if( userNr > 0)
          { 
            // si esta un usuario cargamos img con el valor del pixel
            // de la backPic
            img.pixels[index] = color(255,255);
          }
        }
      }
    }
    img.updatePixels(); 
    // escalamos las imagenes
    bigImg.copy(img, 0, 0, 640, 480, 0, 0, width, height);
    return bigImg;
  }//getMeImg

}

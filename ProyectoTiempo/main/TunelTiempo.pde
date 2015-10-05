class TunelTiempo implements Scene
{
  PImage bImg; 
  public int cantidad_lineas = 20;
  public float horizonte = 12*height/23;
  public float piso = height;
  public float pos_linea_base = piso;
  public float pos_vertical_base = 0;
  
 
  public TunelTiempo(){};
  
  
  void closeScene(){};
  
  void initialScene(){};
  
  void drawScene(){
    // Dibujo fondo
    dibujarFondo();
    
    //Cargo un "PEGOTIN" con el Bailarin
    bImg = getMeImg();
    //Dibujo al Bailarin ensima del fondo
    image(bImg,0,0);
   
    //image(img, a x-coordinate of the image, b y-coordinate of the image, 
    //      c width to display the image, d height to display the image)
    
    //PRUEBA dibujo segundo bailarin
    image(bImg, 0          , 0, width/4, height/4);
    image(bImg,  3*width/4 , 0, width/4, height/4);
    image(bImg, 0          , 3 * height/4, width/4, height/4);
    image(bImg,  3*width/4 , 3 * height/4, width/4, height/4);
    
    
    println("SerPantalla: " + serPantalla);
    
  };
  
  String getSceneName(){return "Tunel del Tiempo";};
  
  // Funciones auxiliares
  
  void dibujarFondo(){    
    background(fondo1);
    // Dibujo horizonte
    dibujarGradienteHorizontal(8*height/15, height/4, color(255,255,255,200), color(255,255,255,0), false);    
    // Dibujo lineas y sombras horizontales
    dibujarLineasHorizontales();
    // Dibujo lineas verticales
    dibujarLineasVerticales();
  }
  
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
  
  void dibujarLineaVertical(float xHorizonte, float xPiso){
    // Dibujo linea blanca
    stroke(255,255,255); 
    line(xHorizonte, horizonte, xPiso, piso);
  } //dibujarLineaVertical
  
  
  void dibujarLineasVerticales(){
    float largo_linea = pos_linea_base;    
    float centro = width/2;
    float pos_linea_actual = pos_vertical_base;
    float intervalo = width/cantidad_lineas;
    
    // Dibujo lineas
    for(int i = 0; i<cantidad_lineas; i++){
      dibujarLineaVertical(pos_linea_actual, pos_linea_actual + 4*(pos_linea_actual - centro));
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
   
  }// dibujarLineasVerticales
  

  
  //getMeImg() 
  PImage getMeImg(){
    // para imagen de la kinect
    PImage img = new PImage(context.depthWidth(),context.depthHeight(),ARGB); 
    img.loadPixels();
    // para imagen escalada
    PImage bigImg = new PImage(width,height,ARGB); 
    bigImg.loadPixels();
    //Actualizo el mapa de usuarios y el de profundidad
    context.update();
    int[]   userMap = context.userMap();
    int[]   depthMap = context.depthMap();
    PImage   rgbMap = context.rgbImage();
    //Variable para clacular con que pixel estamos trabajando
    int index;
    //Recorro el largo de la pantalla
    for(int x=0;x <context.depthWidth();x+=1)
    {
      //Recorro la altura de la pantalla
      for(int y=0;y < context.depthHeight() ;y+=1)
      {
        //Calculo en que posicion del array se encuentra el pixel con que quiero trabajar.
        index = x + y * context.depthWidth();
        //Obtengo la profundidad del pixel con el que estoy trabajando
        int d = depthMap[index];
        // Si el usuario Es la pantalla
        if (serPantalla) {
          //Oscuresco la el pixel
          img.pixels[index] = color(0,255);
        } 
        //Si la profundidad del pixel es mayor a 0
        if(d>0){
          //Reviso si el pixel pertenece a un usuario
          int userNr =userMap[index];
          //Si el pixel pertenece a un usuario
          if( userNr > 0)
          { 
            // Si el usuario es la pantalla 
            if (serPantalla) {
              //Dejamos el pixel transparente
              img.pixels[index] = color(0,0);
            } 
            //Si el usario NO es la pantalla
            else{
              //Cambiar por ILUSION OPTICA
              //oscuresemos el pixel
              img.pixels[index] = color(255,255);
              //Guardo la imagen del usuario
              //img.pixels[index] = rgbMap.pixels[index];
            }  
            
          }
        }
      }
    }
    //Updeteamos la imagen a mostrar
    img.updatePixels(); 
    // escalamos las imagenes
    bigImg.copy(img, 0, 0, 640, 480, 0, 0, width, height);
    return bigImg;
  }//getMeImg
  
  
}

class TunelTiempo implements Scene
{
  PImage bImg; 
  public int linea[] = {height /20 * 10, height /20* 11, height /20 * 12, height /20* 13, height /20 * 14,
                        height /20 * 15, height /20* 16, height /20 * 17, height /20* 18, height /20 * 19};
  public float velocidad = 0.065;
  public TunelTiempo(){};
  
  void closeScene(){};
  
  void initialScene(){};
  
  void drawScene(){
    background(fondo1);
    linea = dibujarLineasHorizontales(linea);
    bImg = getMeImg();
    image(bImg,0,0);
  };
  
  String getSceneName(){return "Tunel del Tiempo";};
  
  // Funciones auxiliares
  int [] dibujarLineasHorizontales(int[] linea){
    int altura = height;
    int centro = (int)(height/2);
    int altura_linea = altura;
    
    //GUILLE ESTATICO
    // Dibujo lineas
//    for(int i = 1; i<=20; i++){
//      stroke(255,255,255); 
//      // Calculo posicion de la linea
//      altura_linea = (int)(altura - (altura - centro)/7); 
//      line(0, altura_linea, width, altura_linea);
//      // Calculo alto de sombra
//      int h_sombra = (int)((altura - altura_linea)/3);
//      // Dibujo somba en degrade
//      dibujarGradienteHorizontal(altura_linea + 1, h_sombra, sombra1, fondo1, true);
//      altura = altura_linea;
//    }
    
    //FEDE Y AC DINAMICO
    for(int i =0; i<=9; i++){
      //println("Posicion Original : " +  linea[0] );
      linea[i] = movimientoAlHorizonte(linea[i]);
      //println("Posicion Posterior : " +  linea[0] );
      dibujarGradienteHorizontal(linea[i], 8, sombra1, fondo1, true);
    }    
    // Dibujo horizonte
    //dibujarGradienteHorizontal(altura_linea, height/4, color(255,255,255,50), color(255,255,255,0), false);
    return linea;
  }// dibujarLineasHorizontales
  
  void dibujarGradienteHorizontal(int y, float h, color c1, color c2, boolean descendente){
    if(descendente){
      for (int i = y; i <= y+h; i++) {
        float inter = map(i, y, y+h, 0, 1);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(0, i, width, i);
      }
    }
    else{
      for (int i = y; i >= y-h; i=i-1) {
        float inter = map(i, y, y-h, 0, 1);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(0, i, width, i);
      }
    }
  } // dibujarGradienteHorizontal
  
  int movimientoAlHorizonte(int posicionY){
    // println("El posicion actual es : " + posicionY);
      
    //  println("El velocidad es : " + velocidad);
      if (posicionY <= (int)(height /2)){
        return height;
      } else{
        float distanciaAlHorizonte = abs(posicionY - (height/2));
    //    println("El distanciaAlHorizonte es : " + distanciaAlHorizonte);
        
        float avance = distanciaAlHorizonte * velocidad;
    //    println("El avance es : " +  avance );
        return int (posicionY - avance);
     }
   }//movimientoAlHorizonte
}

 

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
  }

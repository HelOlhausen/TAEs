class IlusionOptica implements Scene
{   
  PImage bImg; 
  PGraphics pg=createGraphics(width,height);
  PVector com = new PVector();
  
  
  public IlusionOptica(){};

  void closeScene(){};
  
  void initialScene(){};
  
  void drawScene()
  {    
     int[] userList = context.getUsers();
    for(int i=0;i<userList.length;i++){
      context.getCoM(userList[i],com); 
      context.convertRealWorldToProjective(com,com);
      com.x=map(com.x, 0,640, 0, width);
      com.y=map(com.y, 0,480, 0, height);
    }  
    // Creo ilusion
    pg.beginDraw();
    crearIlusion();
    pg.endDraw();
    image(pg, 0, 0);
    //Cargo un "PEGOTIN" con el Bailarin
    bImg = getMeImg();
    //Dibujo al Bailarin ensima del fondo
    image(bImg,0,0);
  };
  
  String getSceneName(){return "IlusionOptica";};
  
  void crearIlusion()
  {
    
    pg.background(255);  
    // Dibujo circulo externo
    pg.stroke(255,0,0);
    pg.strokeWeight(5);
    pg.fill(255);
    pg.ellipse(com.x, com.y, radio_ilusion*2, radio_ilusion*2);
    // Dibujo lineas externas
    pg.stroke(0);
    pg.strokeWeight(4);
    dibujarExternos();
    // Dibujo circulo central
    pg.stroke(255,0,0);
    pg.strokeWeight(5);
    pg.fill(255);
    pg.ellipse(com.x, com.y, radio_ilusion, radio_ilusion);
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
       float norte = com.y - pos_actual;
       float sur = com.y + pos_actual;
       float este = com.x + pos_actual;
       float oeste = com.x - pos_actual;
       pg.line(oeste, com.y, com.x, norte);
       pg.line(oeste, com.y, com.x, sur);
       pg.line(este, com.y, com.x, norte);
       pg.line(este, com.y, com.x, sur);
    }
    
    // Dibujo arcos
    pg.stroke(0,0,255);
    float punto_inicial = (cantidad_lineas_ilusion + 1)*intervalo_ilusion + distancia_base_externo;
    for(float j = punto_inicial; sqrt((j/2)*(j/2)*2) < radio_ilusion; j = j + intervalo_ilusion)
    {
      pg.line(com.x + j, com.y, com.x, com.y+j);
      pg.line(com.x + j, com.y, com.x, com.y-j);
      pg.line(com.x - j, com.y, com.x, com.y+j);
      pg.line(com.x - j, com.y, com.x, com.y-j);
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
       float norte = com.y - pos_actual;
       float sur = com.y + pos_actual;
       float este = com.x + pos_actual;
       float oeste = com.x - pos_actual;
       pg.line(oeste, com.y, com.x, norte);
       pg.line(oeste, com.y, com.x, sur);
       pg.line(este, com.y, com.x, norte);
       pg.line(este, com.y, com.x, sur);
    }
    
    // Dibujo arcos
    pg.stroke(0,255,0);
    float punto_inicial = (cantidad_lineas_ilusion/2)*intervalo_ilusion + distancia_base_interno;
    for(float j = punto_inicial; sqrt((j/2)*(j/2)*2) < radio_ilusion/2; j = j + intervalo_ilusion)
    {
      pg.line(com.x + j, com.y, com.x, com.y+j);
      pg.line(com.x + j, com.y, com.x, com.y-j);
      pg.line(com.x - j, com.y, com.x, com.y+j);
      pg.line(com.x - j, com.y, com.x, com.y-j);
    }
    
    // Actualizo linea base
    distancia_base_interno = distancia_base_interno - velocidad_ilusion;
    // Corrijo linea base
    if(distancia_base_interno <= 0){
      distancia_base_interno = intervalo_ilusion;
    }
  }
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

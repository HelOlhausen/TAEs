class TunelTiempo implements Scene
{
  public int cantidad_lineas = 20;
  public float pos_linea_base = height;
  
  public TunelTiempo(){};
  
  void closeScene(){};
  
  void initialScene(){};
  
  void drawScene(){
    background(fondo1);
    // Dibujo horizonte
    dibujarGradienteHorizontal(8*height/15, height/4, color(255,255,255,50), color(255,255,255,0), false);    
    // Dibujo lineas horizontales
    dibujarLineasHorizontales();
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

    // Actualizo altura base
    pos_linea_base = pos_linea_base - 2;  
  
    // Corrijo altura base
    if(pos_linea_base <= (height - (height/14))){
      pos_linea_base = height;
    }  
   
  }// dibujarLineasHorizontales
  
  void dibujarLineaHorizontal(float altura, int h_sombra){
    // Dibujo linea blanca
    stroke(255,255,255); 
    line(0, altura, width, altura);
    // Dibujo sombra
    dibujarGradienteHorizontal(altura + 1, h_sombra, sombra1, fondo1, true);
  }
  
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
}
